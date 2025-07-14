using System;
using System.Net;
using System.Net.Sockets;
using System.Security.Principal;
using System.Threading;
using WebSocketSharp.Net;
using WebSocketSharp.Net.WebSockets;

namespace WebSocketSharp.Server
{
	public class WebSocketServer
	{
		private IPAddress _address;

		private WebSocketSharp.Net.AuthenticationSchemes _authSchemes;

		private static readonly string _defaultRealm;

		private bool _dnsStyle;

		private string _hostname;

		private TcpListener _listener;

		private Logger _logger;

		private int _port;

		private string _realm;

		private Thread _receiveThread;

		private bool _reuseAddress;

		private bool _secure;

		private WebSocketServiceManager _services;

		private ServerSslConfiguration _sslConfig;

		private volatile ServerState _state;

		private object _sync;

		private Func<IIdentity, WebSocketSharp.Net.NetworkCredential> _userCredFinder;

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
				return _authSchemes;
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
					_authSchemes = value;
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
				return _realm;
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
					_realm = value;
				}
			}
		}

		public bool ReuseAddress
		{
			get
			{
				return _reuseAddress;
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
					_reuseAddress = value;
				}
			}
		}

		public ServerSslConfiguration SslConfiguration
		{
			get
			{
				return _sslConfig ?? (_sslConfig = new ServerSslConfiguration(null));
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
					_sslConfig = value;
				}
			}
		}

		public Func<IIdentity, WebSocketSharp.Net.NetworkCredential> UserCredentialsFinder
		{
			get
			{
				return _userCredFinder;
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
					_userCredFinder = value;
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

		static WebSocketServer()
		{
			_defaultRealm = "SECRET AREA";
		}

		public WebSocketServer()
		{
			init(null, IPAddress.Any, 80, false);
		}

		public WebSocketServer(int port)
			: this(port, port == 443)
		{
		}

		public WebSocketServer(string url)
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
			init(dnsSafeHost, address, result.Port, result.Scheme == "wss");
		}

		public WebSocketServer(int port, bool secure)
		{
			if (!port.IsPortNumber())
			{
				throw new ArgumentOutOfRangeException("port", "Not between 1 and 65535 inclusive: " + port);
			}
			init(null, IPAddress.Any, port, secure);
		}

		public WebSocketServer(IPAddress address, int port)
			: this(address, port, port == 443)
		{
		}

		public WebSocketServer(IPAddress address, int port, bool secure)
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
			_listener.Stop();
			_services.Stop(new CloseEventArgs(CloseStatusCode.ServerError), true, false);
			_state = ServerState.Stop;
		}

		private string checkIfCertificateExists()
		{
			return (!_secure || (_sslConfig != null && _sslConfig.ServerCertificate != null)) ? null : "The secure connection requires a server certificate.";
		}

		private string getRealm()
		{
			string realm = _realm;
			return (realm == null || realm.Length <= 0) ? _defaultRealm : realm;
		}

		private void init(string hostname, IPAddress address, int port, bool secure)
		{
			_hostname = hostname ?? address.ToString();
			_address = address;
			_port = port;
			_secure = secure;
			_authSchemes = WebSocketSharp.Net.AuthenticationSchemes.Anonymous;
			_dnsStyle = Uri.CheckHostName(hostname) == UriHostNameType.Dns;
			_listener = new TcpListener(address, port);
			_logger = new Logger();
			_services = new WebSocketServiceManager(_logger);
			_sync = new object();
		}

		private void processRequest(TcpListenerWebSocketContext context)
		{
			Uri requestUri = context.RequestUri;
			if (requestUri == null || requestUri.Port != _port)
			{
				context.Close(WebSocketSharp.Net.HttpStatusCode.BadRequest);
				return;
			}
			if (_dnsStyle)
			{
				string dnsSafeHost = requestUri.DnsSafeHost;
				if (Uri.CheckHostName(dnsSafeHost) == UriHostNameType.Dns && dnsSafeHost != _hostname)
				{
					context.Close(WebSocketSharp.Net.HttpStatusCode.NotFound);
					return;
				}
			}
			WebSocketServiceHost host;
			if (!_services.InternalTryGetServiceHost(requestUri.AbsolutePath, out host))
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
					TcpClient cl = _listener.AcceptTcpClient();
					ThreadPool.QueueUserWorkItem(delegate
					{
						try
						{
							TcpListenerWebSocketContext webSocketContext = cl.GetWebSocketContext(null, _secure, _sslConfig, _logger);
							if (webSocketContext.Authenticate(_authSchemes, getRealm(), _userCredFinder))
							{
								processRequest(webSocketContext);
							}
						}
						catch (Exception ex3)
						{
							_logger.Fatal(ex3.ToString());
							cl.Close();
						}
					});
				}
				catch (SocketException ex)
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
			if (_reuseAddress)
			{
				_listener.Server.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.ReuseAddress, true);
			}
			_listener.Start();
			_receiveThread = new Thread(receiveRequest);
			_receiveThread.IsBackground = true;
			_receiveThread.Start();
		}

		private void stopReceiving(int millisecondsTimeout)
		{
			_listener.Stop();
			_receiveThread.Join(millisecondsTimeout);
		}

		private static bool tryCreateUri(string uriString, out Uri result, out string message)
		{
			if (!uriString.TryCreateWebSocketUri(out result, out message))
			{
				return false;
			}
			if (result.PathAndQuery != "/")
			{
				result = null;
				message = "Includes the path or query component: " + uriString;
				return false;
			}
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
			stopReceiving(5000);
			_services.Stop(new CloseEventArgs(), true, true);
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
			stopReceiving(5000);
			if (code == 1005)
			{
				_services.Stop(new CloseEventArgs(), true, true);
			}
			else
			{
				bool flag = !code.IsReserved();
				_services.Stop(new CloseEventArgs(code, reason), flag, flag);
			}
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
			stopReceiving(5000);
			if (code == CloseStatusCode.NoStatus)
			{
				_services.Stop(new CloseEventArgs(), true, true);
			}
			else
			{
				bool flag = !code.IsReserved();
				_services.Stop(new CloseEventArgs(code, reason), flag, flag);
			}
			_state = ServerState.Stop;
		}
	}
}
