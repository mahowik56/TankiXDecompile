using System;

namespace log4net.Core
{
	public class TimeEvaluator : ITriggeringEventEvaluator
	{
		private int m_interval;

		private DateTime m_lasttime;

		private const int DEFAULT_INTERVAL = 0;

		public int Interval
		{
			get
			{
				return m_interval;
			}
			set
			{
				m_interval = value;
			}
		}

		public TimeEvaluator()
			: this(0)
		{
		}

		public TimeEvaluator(int interval)
		{
			m_interval = interval;
			m_lasttime = DateTime.Now;
		}

		public bool IsTriggeringEvent(LoggingEvent loggingEvent)
		{
			if (loggingEvent == null)
			{
				throw new ArgumentNullException("loggingEvent");
			}
			if (m_interval == 0)
			{
				return false;
			}
			lock (this)
			{
				if (DateTime.Now.Subtract(m_lasttime).TotalSeconds > (double)m_interval)
				{
					m_lasttime = DateTime.Now;
					return true;
				}
				return false;
			}
		}
	}
}
