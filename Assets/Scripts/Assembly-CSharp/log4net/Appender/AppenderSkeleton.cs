using System;
using System.Collections;
using System.Globalization;
using System.IO;
using log4net.Core;
using log4net.Filter;
using log4net.Layout;
using log4net.Util;

namespace log4net.Appender
{
	public abstract class AppenderSkeleton : IAppender, IBulkAppender, IOptionHandler
	{
		private ILayout m_layout;

		private string m_name;

		private Level m_threshold;

		private IErrorHandler m_errorHandler;

		private IFilter m_headFilter;

		private IFilter m_tailFilter;

		private bool m_closed;

		private bool m_recursiveGuard;

		private ReusableStringWriter m_renderWriter;

		private const int c_renderBufferSize = 256;

		private const int c_renderBufferMaxCapacity = 1024;

		private static readonly Type declaringType = typeof(AppenderSkeleton);

		public Level Threshold
		{
			get
			{
				return m_threshold;
			}
			set
			{
				m_threshold = value;
			}
		}

		public virtual IErrorHandler ErrorHandler
		{
			get
			{
				return m_errorHandler;
			}
			set
			{
				lock (this)
				{
					if (value == null)
					{
						LogLog.Warn(declaringType, "You have tried to set a null error-handler.");
					}
					else
					{
						m_errorHandler = value;
					}
				}
			}
		}

		public virtual IFilter FilterHead
		{
			get
			{
				return m_headFilter;
			}
		}

		public virtual ILayout Layout
		{
			get
			{
				return m_layout;
			}
			set
			{
				m_layout = value;
			}
		}

		public string Name
		{
			get
			{
				return m_name;
			}
			set
			{
				m_name = value;
			}
		}

		protected virtual bool RequiresLayout
		{
			get
			{
				return false;
			}
		}

		protected AppenderSkeleton()
		{
			m_errorHandler = new OnlyOnceErrorHandler(GetType().Name);
		}

		~AppenderSkeleton()
		{
			if (!m_closed)
			{
				LogLog.Debug(declaringType, "Finalizing appender named [" + m_name + "].");
				Close();
			}
		}

		public virtual void ActivateOptions()
		{
		}

		public void Close()
		{
			lock (this)
			{
				if (!m_closed)
				{
					OnClose();
					m_closed = true;
				}
			}
		}

		public void DoAppend(LoggingEvent loggingEvent)
		{
			lock (this)
			{
				if (m_closed)
				{
					ErrorHandler.Error("Attempted to append to closed appender named [" + m_name + "].");
				}
				else
				{
					if (m_recursiveGuard)
					{
						return;
					}
					try
					{
						m_recursiveGuard = true;
						if (FilterEvent(loggingEvent) && PreAppendCheck())
						{
							Append(loggingEvent);
						}
						return;
					}
					catch (Exception e)
					{
						ErrorHandler.Error("Failed in DoAppend", e);
						return;
					}
					finally
					{
						m_recursiveGuard = false;
					}
				}
			}
		}

		public void DoAppend(LoggingEvent[] loggingEvents)
		{
			lock (this)
			{
				if (m_closed)
				{
					ErrorHandler.Error("Attempted to append to closed appender named [" + m_name + "].");
				}
				else
				{
					if (m_recursiveGuard)
					{
						return;
					}
					try
					{
						m_recursiveGuard = true;
						ArrayList arrayList = new ArrayList(loggingEvents.Length);
						foreach (LoggingEvent loggingEvent in loggingEvents)
						{
							if (FilterEvent(loggingEvent))
							{
								arrayList.Add(loggingEvent);
							}
						}
						if (arrayList.Count > 0 && PreAppendCheck())
						{
							Append((LoggingEvent[])arrayList.ToArray(typeof(LoggingEvent)));
						}
						return;
					}
					catch (Exception e)
					{
						ErrorHandler.Error("Failed in Bulk DoAppend", e);
						return;
					}
					finally
					{
						m_recursiveGuard = false;
					}
				}
			}
		}

		protected virtual bool FilterEvent(LoggingEvent loggingEvent)
		{
			if (!IsAsSevereAsThreshold(loggingEvent.Level))
			{
				return false;
			}
			IFilter filter = FilterHead;
			while (filter != null)
			{
				switch (filter.Decide(loggingEvent))
				{
				case FilterDecision.Deny:
					return false;
				case FilterDecision.Accept:
					filter = null;
					break;
				case FilterDecision.Neutral:
					filter = filter.Next;
					break;
				}
			}
			return true;
		}

		public virtual void AddFilter(IFilter filter)
		{
			if (filter == null)
			{
				throw new ArgumentNullException("filter param must not be null");
			}
			if (m_headFilter == null)
			{
				m_headFilter = (m_tailFilter = filter);
				return;
			}
			m_tailFilter.Next = filter;
			m_tailFilter = filter;
		}

		public virtual void ClearFilters()
		{
			m_headFilter = (m_tailFilter = null);
		}

		protected virtual bool IsAsSevereAsThreshold(Level level)
		{
			return m_threshold == null || level >= m_threshold;
		}

		protected virtual void OnClose()
		{
		}

		protected abstract void Append(LoggingEvent loggingEvent);

		protected virtual void Append(LoggingEvent[] loggingEvents)
		{
			foreach (LoggingEvent loggingEvent in loggingEvents)
			{
				Append(loggingEvent);
			}
		}

		protected virtual bool PreAppendCheck()
		{
			if (m_layout == null && RequiresLayout)
			{
				ErrorHandler.Error("AppenderSkeleton: No layout set for the appender named [" + m_name + "].");
				return false;
			}
			return true;
		}

		protected string RenderLoggingEvent(LoggingEvent loggingEvent)
		{
			if (m_renderWriter == null)
			{
				m_renderWriter = new ReusableStringWriter(CultureInfo.InvariantCulture);
			}
			lock (m_renderWriter)
			{
				m_renderWriter.Reset(1024, 256);
				RenderLoggingEvent(m_renderWriter, loggingEvent);
				return m_renderWriter.ToString();
			}
		}

		protected void RenderLoggingEvent(TextWriter writer, LoggingEvent loggingEvent)
		{
			if (m_layout == null)
			{
				throw new InvalidOperationException("A layout must be set");
			}
			if (m_layout.IgnoresException)
			{
				string exceptionString = loggingEvent.GetExceptionString();
				if (exceptionString != null && exceptionString.Length > 0)
				{
					m_layout.Format(writer, loggingEvent);
					writer.WriteLine(exceptionString);
				}
				else
				{
					m_layout.Format(writer, loggingEvent);
				}
			}
			else
			{
				m_layout.Format(writer, loggingEvent);
			}
		}
	}
}
