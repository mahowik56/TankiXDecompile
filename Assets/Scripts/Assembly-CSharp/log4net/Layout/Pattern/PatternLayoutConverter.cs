using System;
using System.IO;
using log4net.Core;
using log4net.Util;

namespace log4net.Layout.Pattern
{
	public abstract class PatternLayoutConverter : PatternConverter
	{
		private bool m_ignoresException = true;

		public virtual bool IgnoresException
		{
			get
			{
				return m_ignoresException;
			}
			set
			{
				m_ignoresException = value;
			}
		}

		protected abstract void Convert(TextWriter writer, LoggingEvent loggingEvent);

		protected override void Convert(TextWriter writer, object state)
		{
			LoggingEvent loggingEvent = state as LoggingEvent;
			if (loggingEvent != null)
			{
				Convert(writer, loggingEvent);
				return;
			}
			throw new ArgumentException("state must be of type [" + typeof(LoggingEvent).FullName + "]", "state");
		}
	}
}
