using System;

namespace log4net.Core
{
	public class ExceptionEvaluator : ITriggeringEventEvaluator
	{
		private Type m_type;

		private bool m_triggerOnSubclass;

		public Type ExceptionType
		{
			get
			{
				return m_type;
			}
			set
			{
				m_type = value;
			}
		}

		public bool TriggerOnSubclass
		{
			get
			{
				return m_triggerOnSubclass;
			}
			set
			{
				m_triggerOnSubclass = value;
			}
		}

		public ExceptionEvaluator()
		{
		}

		public ExceptionEvaluator(Type exType, bool triggerOnSubClass)
		{
			if (exType == null)
			{
				throw new ArgumentNullException("exType");
			}
			m_type = exType;
			m_triggerOnSubclass = triggerOnSubClass;
		}

		public bool IsTriggeringEvent(LoggingEvent loggingEvent)
		{
			if (loggingEvent == null)
			{
				throw new ArgumentNullException("loggingEvent");
			}
			if (m_triggerOnSubclass && loggingEvent.ExceptionObject != null)
			{
				Type type = loggingEvent.ExceptionObject.GetType();
				return type == m_type || type.IsSubclassOf(m_type);
			}
			if (!m_triggerOnSubclass && loggingEvent.ExceptionObject != null)
			{
				return loggingEvent.ExceptionObject.GetType() == m_type;
			}
			return false;
		}
	}
}
