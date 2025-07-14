using System;

namespace WebSocketSharp.Net
{
	public class NetworkCredential
	{
		private string _domain;

		private string _password;

		private string[] _roles;

		private string _userName;

		public string Domain
		{
			get
			{
				return _domain ?? string.Empty;
			}
			internal set
			{
				_domain = value;
			}
		}

		public string Password
		{
			get
			{
				return _password ?? string.Empty;
			}
			internal set
			{
				_password = value;
			}
		}

		public string[] Roles
		{
			get
			{
				return _roles ?? (_roles = new string[0]);
			}
			internal set
			{
				_roles = value;
			}
		}

		public string UserName
		{
			get
			{
				return _userName;
			}
			internal set
			{
				_userName = value;
			}
		}

		public NetworkCredential(string userName, string password)
			: this(userName, password, (string)null, (string[])null)
		{
		}

		public NetworkCredential(string userName, string password, string domain, params string[] roles)
		{
			if (userName == null)
			{
				throw new ArgumentNullException("userName");
			}
			if (userName.Length == 0)
			{
				throw new ArgumentException("An empty string.", "userName");
			}
			_userName = userName;
			_password = password;
			_domain = domain;
			_roles = roles;
		}
	}
}
