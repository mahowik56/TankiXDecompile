using System;
using System.IO;
using log4net.Core;
using log4net.Layout;
using log4net.Util;

namespace log4net.Appender
{
	public class TextWriterAppender : AppenderSkeleton
	{
		private QuietTextWriter m_qtw;

		private bool m_immediateFlush = true;

		private static readonly Type declaringType = typeof(TextWriterAppender);

		public bool ImmediateFlush
		{
			get
			{
				return m_immediateFlush;
			}
			set
			{
				m_immediateFlush = value;
			}
		}

		public virtual TextWriter Writer
		{
			get
			{
				return m_qtw;
			}
			set
			{
				lock (this)
				{
					Reset();
					if (value != null)
					{
						m_qtw = new QuietTextWriter(value, ErrorHandler);
						WriteHeader();
					}
				}
			}
		}

		public override IErrorHandler ErrorHandler
		{
			get
			{
				return base.ErrorHandler;
			}
			set
			{
				lock (this)
				{
					if (value == null)
					{
						LogLog.Warn(declaringType, "TextWriterAppender: You have tried to set a null error-handler.");
						return;
					}
					base.ErrorHandler = value;
					if (m_qtw != null)
					{
						m_qtw.ErrorHandler = value;
					}
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

		protected QuietTextWriter QuietWriter
		{
			get
			{
				return m_qtw;
			}
			set
			{
				m_qtw = value;
			}
		}

		public TextWriterAppender()
		{
		}

		[Obsolete("Instead use the default constructor and set the Layout & Writer properties")]
		public TextWriterAppender(ILayout layout, Stream os)
			: this(layout, new StreamWriter(os))
		{
		}

		[Obsolete("Instead use the default constructor and set the Layout & Writer properties")]
		public TextWriterAppender(ILayout layout, TextWriter writer)
		{
			Layout = layout;
			Writer = writer;
		}

		protected override bool PreAppendCheck()
		{
			if (!base.PreAppendCheck())
			{
				return false;
			}
			if (m_qtw == null)
			{
				PrepareWriter();
				if (m_qtw == null)
				{
					ErrorHandler.Error("No output stream or file set for the appender named [" + base.Name + "].");
					return false;
				}
			}
			if (m_qtw.Closed)
			{
				ErrorHandler.Error("Output stream for appender named [" + base.Name + "] has been closed.");
				return false;
			}
			return true;
		}

		protected override void Append(LoggingEvent loggingEvent)
		{
			RenderLoggingEvent(m_qtw, loggingEvent);
			if (m_immediateFlush)
			{
				m_qtw.Flush();
			}
		}

		protected override void Append(LoggingEvent[] loggingEvents)
		{
			foreach (LoggingEvent loggingEvent in loggingEvents)
			{
				RenderLoggingEvent(m_qtw, loggingEvent);
			}
			if (m_immediateFlush)
			{
				m_qtw.Flush();
			}
		}

		protected override void OnClose()
		{
			lock (this)
			{
				Reset();
			}
		}

		protected virtual void WriteFooterAndCloseWriter()
		{
			WriteFooter();
			CloseWriter();
		}

		protected virtual void CloseWriter()
		{
			if (m_qtw != null)
			{
				try
				{
					m_qtw.Close();
				}
				catch (Exception e)
				{
					ErrorHandler.Error(string.Concat("Could not close writer [", m_qtw, "]"), e);
				}
			}
		}

		protected virtual void Reset()
		{
			WriteFooterAndCloseWriter();
			m_qtw = null;
		}

		protected virtual void WriteFooter()
		{
			if (Layout != null && m_qtw != null && !m_qtw.Closed)
			{
				string footer = Layout.Footer;
				if (footer != null)
				{
					m_qtw.Write(footer);
				}
			}
		}

		protected virtual void WriteHeader()
		{
			if (Layout != null && m_qtw != null && !m_qtw.Closed)
			{
				string header = Layout.Header;
				if (header != null)
				{
					m_qtw.Write(header);
				}
			}
		}

		protected virtual void PrepareWriter()
		{
		}
	}
}
