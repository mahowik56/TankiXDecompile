using System;
using log4net.Core;

namespace log4net.Util
{
	public sealed class NullSecurityContext : SecurityContext
	{
		public static readonly NullSecurityContext Instance = new NullSecurityContext();

		private NullSecurityContext()
		{
		}

		public override IDisposable Impersonate(object state)
		{
			return null;
		}
	}
}
