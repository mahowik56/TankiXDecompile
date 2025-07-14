using System;

namespace log4net.Util
{
	public class LogReceivedEventArgs : EventArgs
	{
		private readonly LogLog loglog;

		public LogLog LogLog
		{
			get
			{
				return loglog;
			}
		}

		public LogReceivedEventArgs(LogLog loglog)
		{
			this.loglog = loglog;
		}
	}
}
