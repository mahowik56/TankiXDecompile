using System;
using System.IO;
using System.Net;
using System.Net.Security;
using System.Net.Sockets;
using System.Text;
using System.Threading;

namespace WebSocketSharp.Net
{
	internal sealed class HttpConnection
	{
		private byte[] _buffer;

		private const int _bufferLength = 8192;

		private HttpListenerContext _context;

		private bool _contextBound;

		private StringBuilder _currentLine;

		private InputState _inputState;

		private RequestStream _inputStream;

		private HttpListener _lastListener;

		private LineState _lineState;

		private EndPointListener _listener;

		private ResponseStream _outputStream;

		private int _position;

		private HttpListenerPrefix _prefix;

		private MemoryStream _requestBuffer;

		private int _reuses;

		private bool _secure;

		private Socket _socket;

		private Stream _stream;

		private object _sync;

		private int _timeout;

		private Timer _timer;

		public bool IsClosed
		{
			get
			{
				return _socket == null;
			}
		}

		public bool IsSecure
		{
			get
			{
				return _secure;
			}
		}

		public IPEndPoint LocalEndPoint
		{
			get
			{
				return (IPEndPoint)_socket.LocalEndPoint;
			}
		}

		public HttpListenerPrefix Prefix
		{
			get
			{
				return _prefix;
			}
			set
			{
				_prefix = value;
			}
		}

		public IPEndPoint RemoteEndPoint
		{
			get
			{
				return (IPEndPoint)_socket.RemoteEndPoint;
			}
		}

		public int Reuses
		{
			get
			{
				return _reuses;
			}
		}

		public Stream Stream
		{
			get
			{
				return _stream;
			}
		}

		internal HttpConnection(Socket socket, EndPointListener listener)
		{
			_socket = socket;
			_listener = listener;
			_secure = listener.IsSecure;
			NetworkStream networkStream = new NetworkStream(socket, false);
			if (_secure)
			{
				ServerSslConfiguration sslConfiguration = listener.SslConfiguration;
				SslStream sslStream = new SslStream(networkStream, false, sslConfiguration.ClientCertificateValidationCallback);
				sslStream.AuthenticateAsServer(sslConfiguration.ServerCertificate, sslConfiguration.ClientCertificateRequired, sslConfiguration.EnabledSslProtocols, sslConfiguration.CheckCertificateRevocation);
				_stream = sslStream;
			}
			else
			{
				_stream = networkStream;
			}
			_sync = new object();
			_timeout = 90000;
			_timer = new Timer(onTimeout, this, -1, -1);
			init();
		}

		private void close()
		{
			lock (_sync)
			{
				if (_socket == null)
				{
					return;
				}
				disposeTimer();
				disposeRequestBuffer();
				disposeStream();
				closeSocket();
			}
			unbind();
			removeConnection();
		}

		private void closeSocket()
		{
			try
			{
				_socket.Shutdown(SocketShutdown.Both);
			}
			catch
			{
			}
			_socket.Close();
			_socket = null;
		}

		private void disposeRequestBuffer()
		{
			if (_requestBuffer != null)
			{
				_requestBuffer.Dispose();
				_requestBuffer = null;
			}
		}

		private void disposeStream()
		{
			if (_stream != null)
			{
				_inputStream = null;
				_outputStream = null;
				_stream.Dispose();
				_stream = null;
			}
		}

		private void disposeTimer()
		{
			if (_timer != null)
			{
				try
				{
					_timer.Change(-1, -1);
				}
				catch
				{
				}
				_timer.Dispose();
				_timer = null;
			}
		}

		private void init()
		{
			_context = new HttpListenerContext(this);
			_inputState = InputState.RequestLine;
			_inputStream = null;
			_lineState = LineState.None;
			_outputStream = null;
			_position = 0;
			_prefix = null;
			_requestBuffer = new MemoryStream();
		}

		private static void onRead(IAsyncResult asyncResult)
		{
			HttpConnection httpConnection = (HttpConnection)asyncResult.AsyncState;
			if (httpConnection._socket == null)
			{
				return;
			}
			lock (httpConnection._sync)
			{
				if (httpConnection._socket == null)
				{
					return;
				}
				int num = -1;
				int num2 = 0;
				try
				{
					httpConnection._timer.Change(-1, -1);
					num = httpConnection._stream.EndRead(asyncResult);
					httpConnection._requestBuffer.Write(httpConnection._buffer, 0, num);
					num2 = (int)httpConnection._requestBuffer.Length;
				}
				catch (Exception ex)
				{
					if (httpConnection._requestBuffer != null && httpConnection._requestBuffer.Length > 0)
					{
						httpConnection.SendError(ex.Message, 400);
					}
					else
					{
						httpConnection.close();
					}
					return;
				}
				if (num <= 0)
				{
					httpConnection.close();
				}
				else if (httpConnection.processInput(httpConnection._requestBuffer.GetBuffer(), num2))
				{
					if (!httpConnection._context.HasError)
					{
						httpConnection._context.Request.FinishInitialization();
					}
					if (httpConnection._context.HasError)
					{
						httpConnection.SendError();
						return;
					}
					if (!httpConnection._listener.BindContext(httpConnection._context))
					{
						httpConnection.SendError("Invalid host", 400);
						return;
					}
					HttpListener listener = httpConnection._context.Listener;
					if (httpConnection._lastListener != listener)
					{
						httpConnection.removeConnection();
						if (!listener.AddConnection(httpConnection))
						{
							httpConnection.close();
							return;
						}
						httpConnection._lastListener = listener;
					}
					if (listener.RegisterContext(httpConnection._context))
					{
						httpConnection._contextBound = true;
					}
				}
				else
				{
					httpConnection._stream.BeginRead(httpConnection._buffer, 0, 8192, onRead, httpConnection);
				}
			}
		}

		private static void onTimeout(object state)
		{
			HttpConnection httpConnection = (HttpConnection)state;
			httpConnection.close();
		}

		private bool processInput(byte[] data, int length)
		{
			if (_currentLine == null)
			{
				_currentLine = new StringBuilder(64);
			}
			int read = 0;
			try
			{
				string text;
				while ((text = readLineFrom(data, _position, length, out read)) != null)
				{
					_position += read;
					if (text.Length == 0)
					{
						if (_inputState != InputState.RequestLine)
						{
							if (_position > 32768)
							{
								_context.ErrorMessage = "Headers too long";
							}
							_currentLine = null;
							return true;
						}
					}
					else
					{
						if (_inputState == InputState.RequestLine)
						{
							_context.Request.SetRequestLine(text);
							_inputState = InputState.Headers;
						}
						else
						{
							_context.Request.AddHeader(text);
						}
						if (_context.HasError)
						{
							return true;
						}
					}
				}
			}
			catch (Exception ex)
			{
				_context.ErrorMessage = ex.Message;
				return true;
			}
			_position += read;
			if (_position >= 32768)
			{
				_context.ErrorMessage = "Headers too long";
				return true;
			}
			return false;
		}

		private string readLineFrom(byte[] buffer, int offset, int length, out int read)
		{
			read = 0;
			for (int i = offset; i < length; i++)
			{
				if (_lineState == LineState.Lf)
				{
					break;
				}
				read++;
				byte b = buffer[i];
				switch (b)
				{
				case 13:
					_lineState = LineState.Cr;
					break;
				case 10:
					_lineState = LineState.Lf;
					break;
				default:
					_currentLine.Append((char)b);
					break;
				}
			}
			if (_lineState == LineState.Lf)
			{
				_lineState = LineState.None;
				string result = _currentLine.ToString();
				_currentLine.Length = 0;
				return result;
			}
			return null;
		}

		private void removeConnection()
		{
			if (_lastListener != null)
			{
				_lastListener.RemoveConnection(this);
			}
			else
			{
				_listener.RemoveConnection(this);
			}
		}

		private void unbind()
		{
			if (_contextBound)
			{
				_listener.UnbindContext(_context);
				_contextBound = false;
			}
		}

		internal void Close(bool force)
		{
			if (_socket == null)
			{
				return;
			}
			lock (_sync)
			{
				if (_socket == null)
				{
					return;
				}
				if (!force)
				{
					GetResponseStream().Close(false);
					if (!_context.Response.CloseConnection && _context.Request.FlushInput())
					{
						_reuses++;
						disposeRequestBuffer();
						unbind();
						init();
						BeginReadRequest();
						return;
					}
				}
				else if (_outputStream != null)
				{
					_outputStream.Close(true);
				}
				close();
			}
		}

		public void BeginReadRequest()
		{
			if (_buffer == null)
			{
				_buffer = new byte[8192];
			}
			if (_reuses == 1)
			{
				_timeout = 15000;
			}
			try
			{
				_timer.Change(_timeout, -1);
				_stream.BeginRead(_buffer, 0, 8192, onRead, this);
			}
			catch
			{
				close();
			}
		}

		public void Close()
		{
			Close(false);
		}

		public RequestStream GetRequestStream(long contentLength, bool chunked)
		{
			if (_inputStream != null || _socket == null)
			{
				return _inputStream;
			}
			lock (_sync)
			{
				if (_socket == null)
				{
					return _inputStream;
				}
				byte[] buffer = _requestBuffer.GetBuffer();
				int num = (int)_requestBuffer.Length;
				disposeRequestBuffer();
				if (chunked)
				{
					_context.Response.SendChunked = true;
					_inputStream = new ChunkedRequestStream(_stream, buffer, _position, num - _position, _context);
				}
				else
				{
					_inputStream = new RequestStream(_stream, buffer, _position, num - _position, contentLength);
				}
				return _inputStream;
			}
		}

		public ResponseStream GetResponseStream()
		{
			if (_outputStream != null || _socket == null)
			{
				return _outputStream;
			}
			lock (_sync)
			{
				if (_socket == null)
				{
					return _outputStream;
				}
				HttpListener listener = _context.Listener;
				bool ignoreWriteExceptions = listener == null || listener.IgnoreWriteExceptions;
				_outputStream = new ResponseStream(_stream, _context.Response, ignoreWriteExceptions);
				return _outputStream;
			}
		}

		public void SendError()
		{
			SendError(_context.ErrorMessage, _context.ErrorStatus);
		}

		public void SendError(string message, int status)
		{
			if (_socket == null)
			{
				return;
			}
			lock (_sync)
			{
				if (_socket == null)
				{
					return;
				}
				try
				{
					HttpListenerResponse response = _context.Response;
					response.StatusCode = status;
					response.ContentType = "text/html";
					StringBuilder stringBuilder = new StringBuilder(64);
					stringBuilder.AppendFormat("<html><body><h1>{0} {1}", status, response.StatusDescription);
					if (message != null && message.Length > 0)
					{
						stringBuilder.AppendFormat(" ({0})</h1></body></html>", message);
					}
					else
					{
						stringBuilder.Append("</h1></body></html>");
					}
					Encoding uTF = Encoding.UTF8;
					byte[] bytes = uTF.GetBytes(stringBuilder.ToString());
					response.ContentEncoding = uTF;
					response.ContentLength64 = bytes.LongLength;
					response.Close(bytes, true);
				}
				catch
				{
					Close(true);
				}
			}
		}
	}
}
