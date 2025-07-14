using System;
using System.Collections;
using log4net.Core;
using log4net.Util;

namespace log4net.Appender
{
	public abstract class BufferingAppenderSkeleton : AppenderSkeleton
	{
		private const int DEFAULT_BUFFER_SIZE = 512;

		private int m_bufferSize = 512;

		private CyclicBuffer m_cb;

		private ITriggeringEventEvaluator m_evaluator;

		private bool m_lossy;

		private ITriggeringEventEvaluator m_lossyEvaluator;

		private FixFlags m_fixFlags = FixFlags.All;

		private readonly bool m_eventMustBeFixed;

		public bool Lossy
		{
			get
			{
				return m_lossy;
			}
			set
			{
				m_lossy = value;
			}
		}

		public int BufferSize
		{
			get
			{
				return m_bufferSize;
			}
			set
			{
				m_bufferSize = value;
			}
		}

		public ITriggeringEventEvaluator Evaluator
		{
			get
			{
				return m_evaluator;
			}
			set
			{
				m_evaluator = value;
			}
		}

		public ITriggeringEventEvaluator LossyEvaluator
		{
			get
			{
				return m_lossyEvaluator;
			}
			set
			{
				m_lossyEvaluator = value;
			}
		}

		[Obsolete("Use Fix property")]
		public virtual bool OnlyFixPartialEventData
		{
			get
			{
				return Fix == FixFlags.Partial;
			}
			set
			{
				if (value)
				{
					Fix = FixFlags.Partial;
				}
				else
				{
					Fix = FixFlags.All;
				}
			}
		}

		public virtual FixFlags Fix
		{
			get
			{
				return m_fixFlags;
			}
			set
			{
				m_fixFlags = value;
			}
		}

		protected BufferingAppenderSkeleton()
			: this(true)
		{
		}

		protected BufferingAppenderSkeleton(bool eventMustBeFixed)
		{
			m_eventMustBeFixed = eventMustBeFixed;
		}

		public virtual void Flush()
		{
			Flush(false);
		}

		public virtual void Flush(bool flushLossyBuffer)
		{
			lock (this)
			{
				if (m_cb == null || m_cb.Length <= 0)
				{
					return;
				}
				if (m_lossy)
				{
					if (!flushLossyBuffer)
					{
						return;
					}
					if (m_lossyEvaluator != null)
					{
						LoggingEvent[] array = m_cb.PopAll();
						ArrayList arrayList = new ArrayList(array.Length);
						LoggingEvent[] array2 = array;
						foreach (LoggingEvent loggingEvent in array2)
						{
							if (m_lossyEvaluator.IsTriggeringEvent(loggingEvent))
							{
								arrayList.Add(loggingEvent);
							}
						}
						if (arrayList.Count > 0)
						{
							SendBuffer((LoggingEvent[])arrayList.ToArray(typeof(LoggingEvent)));
						}
					}
					else
					{
						m_cb.Clear();
					}
				}
				else
				{
					SendFromBuffer(null, m_cb);
				}
			}
		}

		public override void ActivateOptions()
		{
			base.ActivateOptions();
			if (m_lossy && m_evaluator == null)
			{
				ErrorHandler.Error("Appender [" + base.Name + "] is Lossy but has no Evaluator. The buffer will never be sent!");
			}
			if (m_bufferSize > 1)
			{
				m_cb = new CyclicBuffer(m_bufferSize);
			}
			else
			{
				m_cb = null;
			}
		}

		protected override void OnClose()
		{
			Flush(true);
		}

		protected override void Append(LoggingEvent loggingEvent)
		{
			if (m_cb == null || m_bufferSize <= 1)
			{
				if (!m_lossy || (m_evaluator != null && m_evaluator.IsTriggeringEvent(loggingEvent)) || (m_lossyEvaluator != null && m_lossyEvaluator.IsTriggeringEvent(loggingEvent)))
				{
					if (m_eventMustBeFixed)
					{
						loggingEvent.Fix = Fix;
					}
					SendBuffer(new LoggingEvent[1] { loggingEvent });
				}
				return;
			}
			loggingEvent.Fix = Fix;
			LoggingEvent loggingEvent2 = m_cb.Append(loggingEvent);
			if (loggingEvent2 != null)
			{
				if (!m_lossy)
				{
					SendFromBuffer(loggingEvent2, m_cb);
					return;
				}
				if (m_lossyEvaluator == null || !m_lossyEvaluator.IsTriggeringEvent(loggingEvent2))
				{
					loggingEvent2 = null;
				}
				if (m_evaluator != null && m_evaluator.IsTriggeringEvent(loggingEvent))
				{
					SendFromBuffer(loggingEvent2, m_cb);
				}
				else if (loggingEvent2 != null)
				{
					SendBuffer(new LoggingEvent[1] { loggingEvent2 });
				}
			}
			else if (m_evaluator != null && m_evaluator.IsTriggeringEvent(loggingEvent))
			{
				SendFromBuffer(null, m_cb);
			}
		}

		protected virtual void SendFromBuffer(LoggingEvent firstLoggingEvent, CyclicBuffer buffer)
		{
			LoggingEvent[] array = buffer.PopAll();
			if (firstLoggingEvent == null)
			{
				SendBuffer(array);
				return;
			}
			if (array.Length == 0)
			{
				SendBuffer(new LoggingEvent[1] { firstLoggingEvent });
				return;
			}
			LoggingEvent[] array2 = new LoggingEvent[array.Length + 1];
			Array.Copy(array, 0, array2, 1, array.Length);
			array2[0] = firstLoggingEvent;
			SendBuffer(array2);
		}

		protected abstract void SendBuffer(LoggingEvent[] events);
	}
}
