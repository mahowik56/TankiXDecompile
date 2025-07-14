using System;
using System.IO;
using System.Net;
using System.Security.Principal;
using System.Threading;
using WebSocketSharp.Net;
using WebSocketSharp.Net.WebSockets;

namespace WebSocketSharp.Server
{
	public class HttpServer
	{
		private IPAddress _address;

		private string _hostname;

		private WebSocketSharp.Net.HttpListener _listener;

		private Logger _logger;

		private int _port;

		private Thread _receiveThread;

		private string _rootPath;

		private bool _secure;

		private WebSocketServiceManager _services;

		private volatile ServerState _state;

		private object _sync;

		private bool _windows;

		public IPAddress Address
		{
			get
			{
				return _address;
			}
		}

		public WebSocketSharp.Net.AuthenticationSchemes AuthenticationSchemes
		{
			get
			{
				return _listener.AuthenticationSchemes;
			}
			set
			{
				string text = _state.CheckIfAvailable(true, false, false);
				if (text != null)
				{
					_logger.Error(text);
				}
				else
				{
					_listener.AuthenticationSchemes = value;
				}
			}
		}

		public bool IsListening
		{
			get
			{
				return _state == ServerState.Start;
			}
		}

		public bool IsSecure
		{
			get
			{
				return _secure;
			}
		}

		public bool KeepClean
		{
			get
			{
				return _services.KeepClean;
			}
			set
			{
				string text = _state.CheckIfAvailable(true, false, false);
				if (text != null)
				{
					_logger.Error(text);
				}
				else
				{
					_services.KeepClean = value;
				}
			}
		}

		public Logger Log
		{
			get
			{
				return _logger;
			}
		}

		public int Port
		{
			get
			{
				return _port;
			}
		}

		public string Realm
		{
			get
			{
				return _listener.Realm;
			}
			set
			{
				string text = _state.CheckIfAvailable(true, false, false);
				if (text != null)
				{
					_logger.Error(text);
				}
				else
				{
					_listener.Realm = value;
				}
			}
		}

		public bool ReuseAddress
		{
			get
			{
				return _listener.ReuseAddress;
			}
			set
			{
				string text = _state.CheckIfAvailable(true, false, false);
				if (text != null)
				{
					_logger.Error(text);
				}
				else
				{
					_listener.ReuseAddress = value;
				}
			}
		}

		public string RootPath
		{
			get
			{
				return (_rootPath == null || _rootPath.Length <= 0) ? (_rootPath = "./Public") : _rootPath;
			}
			set
			{
				string text = _state.CheckIfAvailable(true, false, false);
				if (text != null)
				{
					_logger.Error(text);
				}
				else
				{
					_rootPath = value;
				}
			}
		}

		public ServerSslConfiguration SslConfiguration
		{
			get
			{
				return _listener.SslConfiguration;
			}
			set
			{
				string text = _state.CheckIfAvailable(true, false, false);
				if (text != null)
				{
					_logger.Error(text);
				}
				else
				{
					_listener.SslConfiguration = value;
				}
			}
		}

		public Func<IIdentity, WebSocketSharp.Net.NetworkCredential> UserCredentialsFinder
		{
			get
			{
				return _listener.UserCredentialsFinder;
			}
			set
			{
				string text = _state.CheckIfAvailable(true, false, false);
				if (text != null)
				{
					_logger.Error(text);
				}
				else
				{
					_listener.UserCredentialsFinder = value;
				}
			}
		}

		public TimeSpan WaitTime
		{
			get
			{
				return _services.WaitTime;
			}
			set
			{
				string text = _state.CheckIfAvailable(true, false, false) ?? value.CheckIfValidWaitTime();
				if (text != null)
				{
					_logger.Error(text);
				}
				else
				{
					_services.WaitTime = value;
				}
			}
		}

		public WebSocketServiceManager WebSocketServices
		{
			get
			{
				return _services;
			}
		}

		public event EventHandler<HttpRequestEventArgs> OnConnect;

		public event EventHandler<HttpRequestEventArgs> OnDelete;

		public event EventHandler<HttpRequestEventArgs> OnGet;

		public event EventHandler<HttpRequestEventArgs> OnHead;

		public event EventHandler<HttpRequestEventArgs> OnOptions;

		public event EventHandler<HttpRequestEventArgs> OnPatch;

		public event EventHandler<HttpRequestEventArgs> OnPost;

		public event EventHandler<HttpRequestEventArgs> OnPut;

		public event EventHandler<HttpRequestEventArgs> OnTrace;

		public HttpServer()
		{
			init("*", IPAddress.Any, 80, false);
		}

		public HttpServer(int port)
			: this(port, port == 443)
		{
		}

		public HttpServer(string url)
		{
			if (url == null)
			{
				throw new ArgumentNullException("url");
			}
			if (url.Length == 0)
			{
				throw new ArgumentException("An empty string.", "url");
			}
			Uri result;
			string message;
			if (!tryCreateUri(url, out result, out message))
			{
				throw new ArgumentException(message, "url");
			}
			string dnsSafeHost = result.DnsSafeHost;
			IPAddress address = dnsSafeHost.ToIPAddress();
			if (!address.IsLocal())
			{
				throw new ArgumentException("The host part isn't a local host name: " + url, "url");
			}
			init(dnsSafeHost, address, result.Port, result.Scheme == "https");
		}

		public HttpServer(int port, bool secure)
		{
			if (!port.IsPortNumber())
			{
				throw new ArgumentOutOfRangeException("port", "Not between 1 and 65535 inclusive: " + port);
			}
			init("*", IPAddress.Any, port, secure);
		}

		public HttpServer(IPAddress address, int port)
			: this(address, port, port == 443)
		{
		}

		public HttpServer(IPAddress address, int port, bool secure)
		{
			if (address == null)
			{
				throw new ArgumentNullException("address");
			}
			if (!address.IsLocal())
			{
				throw new ArgumentException("Not a local IP address: " + address, "address");
			}
			if (!port.IsPortNumber())
			{
				throw new ArgumentOutOfRangeException("port", "Not between 1 and 65535 inclusive: " + port);
			}
			init(null, address, port, secure);
		}

		private void abort()
		{
			lock (_sync)
			{
				if (!IsListening)
				{
					return;
				}
				_state = ServerState.ShuttingDown;
			}
			_services.Stop(new CloseEventArgs(CloseStatusCode.ServerError), true, false);
			_listener.Abort();
			_state = ServerState.Stop;
		}

		private string checkIfCertificateExists()
		{
			if (!_secure)
			{
				return null;
			}
			bool flag = _listener.SslConfiguration.ServerCertificate != null;
			bool flag2 = EndPointListener.CertificateExists(_port, _listener.CertificateFolderPath);
			if (flag && flag2)
			{
				_logger.Warn("The server certificate associated with the port number already exists.");
				return null;
			}
			return (flag || flag2) ? null : "The secure connection requires a server certificate.";
		}

		private void init(string hostname, IPAddress address, int port, bool secure)
		{
			_hostname = hostname ?? address.ToString();
			_address = address;
			_port = port;
			_secure = secure;
			_listener = new WebSocketSharp.Net.HttpListener();
			_listener.Prefixes.Add(string.Format("http{0}://{1}:{2}/", (!secure) ? string.Empty : "s", _hostname, port));
			_logger = _listener.Log;
			_services = new WebSocketServiceManager(_logger);
			_sync = new object();
			OperatingSystem oSVersion = Environment.OSVersion;
			_windows = oSVersion.Platform != PlatformID.Unix && oSVersion.Platform != PlatformID.MacOSX;
		}

		private void processRequest(WebSocketSharp.Net.HttpListenerContext context)
		{
			object obj;
			switch (context.Request.HttpMethod)
			{
			case "GET":
				obj = this.OnGet;
				break;
			case "HEAD":
				obj = this.OnHead;
				break;
			case "POST":
				obj = this.OnPost;
				break;
			case "PUT":
				obj = this.OnPut;
				break;
			case "DELETE":
				obj = this.OnDelete;
				break;
			case "OPTIONS":
				obj = this.OnOptions;
				break;
			case "TRACE":
				obj = this.OnTrace;
				break;
			case "CONNECT":
				obj = this.OnConnect;
				break;
			case "PATCH":
				obj = this.OnPatch;
				break;
			default:
				obj = null;
				break;
			}
			EventHandler<HttpRequestEventArgs> eventHandler = (EventHandler<HttpRequestEventArgs>)obj;
			if (eventHandler != null)
			{
				eventHandler(this, new HttpRequestEventArgs(context));
			}
			else
			{
				context.Response.StatusCode = 501;
			}
			context.Response.Close();
		}

		private void processRequest(HttpListenerWebSocketContext context)
		{
			WebSocketServiceHost host;
			if (!_services.InternalTryGetServiceHost(context.RequestUri.AbsolutePath, out host))
			{
				context.Close(WebSocketSharp.Net.HttpStatusCode.NotImplemented);
			}
			else
			{
				host.StartSession(context);
			}
		}

		private void receiveRequest()
		{
			while (true)
			{
				try
				{
					WebSocketSharp.Net.HttpListenerContext ctx = _listener.GetContext();
					ThreadPool.QueueUserWorkItem(delegate
					{
						try
						{
							if (ctx.Request.IsUpgradeTo("websocket"))
							{
								processRequest(ctx.AcceptWebSocket(null));
							}
							else
							{
								processRequest(ctx);
							}
						}
						catch (Exception ex3)
						{
							_logger.Fatal(ex3.ToString());
							ctx.Connection.Close(true);
						}
					});
				}
				catch (WebSocketSharp.Net.HttpListenerException ex)
				{
					_logger.Warn("Receiving has been stopped.\n  reason: " + ex.Message);
					break;
				}
				catch (Exception ex2)
				{
					_logger.Fatal(ex2.ToString());
					break;
				}
			}
			if (IsListening)
			{
				abort();
			}
		}

		private void startReceiving()
		{
			_listener.Start();
			_receiveThread = new Thread(receiveRequest);
			_receiveThread.IsBackground = true;
			_receiveThread.Start();
		}

		private void stopReceiving(int millisecondsTimeout)
		{
			_listener.Close();
			_receiveThread.Join(millisecondsTimeout);
		}

		private static bool tryCreateUri(string uriString, out Uri result, out string message)
		{
			result = null;
			Uri uri = uriString.ToUri();
			if (uri == null)
			{
				message = "An invalid URI string: " + uriString;
				return false;
			}
			if (!uri.IsAbsoluteUri)
			{
				message = "Not an absolute URI: " + uriString;
				return false;
			}
			string scheme = uri.Scheme;
			if (!(scheme == "http") && !(scheme == "https"))
			{
				message = "The scheme part isn't 'http' or 'https': " + uriString;
				return false;
			}
			if (uri.PathAndQuery != "/")
			{
				message = "Includes the path or query component: " + uriString;
				return false;
			}
			if (uri.Fragment.Length > 0)
			{
				message = "Includes the fragment component: " + uriString;
				return false;
			}
			if (uri.Port == 0)
			{
				message = "The port part is zero: " + uriString;
				return false;
			}
			result = uri;
			message = string.Empty;
			return true;
		}

		public void AddWebSocketService<TBehavior>(string path, Func<TBehavior> initializer) where TBehavior : WebSocketBehavior
		{
			string text = path.CheckIfValidServicePath() ?? ((initializer != null) ? null : "'initializer' is null.");
			if (text != null)
			{
				_logger.Error(text);
			}
			else
			{
				_services.Add(path, initializer);
			}
		}

		public void AddWebSocketService<TBehaviorWithNew>(string path) where TBehaviorWithNew : WebSocketBehavior, new()
		{
			AddWebSocketService(path, () => new TBehaviorWithNew());
		}

		public byte[] GetFile(string path)
		{
			path = RootPath + path;
			if (_windows)
			{
				path = path.Replace("/", "\\");
			}
			return (!File.Exists(path)) ? null : File.ReadAllBytes(path);
		}

		public bool RemoveWebSocketService(string path)
		{
			string text = path.CheckIfValidServicePath();
			if (text != null)
			{
				_logger.Error(text);
				return false;
			}
			return _services.Remove(path);
		}

		public void Start()
		{
			lock (_sync)
			{
				string text = _state.CheckIfAvailable(true, false, false) ?? checkIfCertificateExists();
				if (text != null)
				{
					_logger.Error(text);
					return;
				}
				_services.Start();
				startReceiving();
				_state = ServerState.Start;
			}
		}

		public void Stop()
		{
			lock (_sync)
			{
				string text = _state.CheckIfAvailable(false, true, false);
				if (text != null)
				{
					_logger.Error(text);
					return;
				}
				_state = ServerState.ShuttingDown;
			}
			_services.Stop(new CloseEventArgs(), true, true);
			stopReceiving(5000);
			_state = ServerState.Stop;
		}

		public void Stop(ushort code, string reason)
		{
			lock (_sync)
			{
				string text = _state.CheckIfAvailable(false, true, false) ?? WebSocket.CheckCloseParameters(code, reason, false);
				if (text != null)
				{
					_logger.Error(text);
					return;
				}
				_state = ServerState.ShuttingDown;
			}
			if (code == 1005)
			{
				_services.Stop(new CloseEventArgs(), true, true);
			}
			else
			{
				bool flag = !code.IsReserved();
				_services.Stop(new CloseEventArgs(code, reason), flag, flag);
			}
			stopReceiving(5000);
			_state = ServerState.Stop;
		}

		public void Stop(CloseStatusCode code, string reason)
		{
			lock (_sync)
			{
				string text = _state.CheckIfAvailable(false, true, false) ?? WebSocket.CheckCloseParameters(code, reason, false);
				if (text != null)
				{
					_logger.Error(text);
					return;
				}
				_state = ServerState.ShuttingDown;
			}
			if (code == CloseStatusCode.NoStatus)
			{
				_services.Stop(new CloseEventArgs(), true, true);
			}
			else
			{
				bool flag = !code.IsReserved();
				_services.Stop(new CloseEventArgs(code, reason), flag, flag);
			}
			stopReceiving(5000);
			_state = ServerState.Stop;
		}
	}
}
