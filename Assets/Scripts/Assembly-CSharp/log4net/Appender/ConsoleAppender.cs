using System;
using System.Globalization;
using log4net.Core;
using log4net.Layout;

namespace log4net.Appender
{
	public class ConsoleAppender : AppenderSkeleton
	{
		public const string ConsoleOut = "Console.Out";

		public const string ConsoleError = "Console.Error";

		private bool m_writeToErrorStream;

		public virtual string Target
		{
			get
			{
				return (!m_writeToErrorStream) ? "Console.Out" : "Console.Error";
			}
			set
			{
				string strB = value.Trim();
				if (string.Compare("Console.Error", strB, true, CultureInfo.InvariantCulture) == 0)
				{
					m_writeToErrorStream = true;
				}
				else
				{
					m_writeToErrorStream = false;
				}
			}
		}

		protected override bool RequiresLayout
		{
			get
			{
				return true;
			}
		}

		public ConsoleAppender()
		{
		}

		[Obsolete("Instead use the default constructor and set the Layout property")]
		public ConsoleAppender(ILayout layout)
			: this(layout, false)
		{
		}

		[Obsolete("Instead use the default constructor and set the Layout & Target properties")]
		public ConsoleAppender(ILayout layout, bool writeToErrorStream)
		{
			Layout = layout;
			m_writeToErrorStream = writeToErrorStream;
		}

		protected override void Append(LoggingEvent loggingEvent)
		{
			if (m_writeToErrorStream)
			{
				Console.Error.Write(RenderLoggingEvent(loggingEvent));
			}
			else
			{
				Console.Write(RenderLoggingEvent(loggingEvent));
			}
		}
	}
}
