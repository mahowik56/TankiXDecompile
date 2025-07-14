using System;
using log4net.Core;

namespace log4net.Filter
{
	public class LoggerMatchFilter : FilterSkeleton
	{
		private bool m_acceptOnMatch = true;

		private string m_loggerToMatch;

		public bool AcceptOnMatch
		{
			get
			{
				return m_acceptOnMatch;
			}
			set
			{
				m_acceptOnMatch = value;
			}
		}

		public string LoggerToMatch
		{
			get
			{
				return m_loggerToMatch;
			}
			set
			{
				m_loggerToMatch = value;
			}
		}

		public override FilterDecision Decide(LoggingEvent loggingEvent)
		{
			if (loggingEvent == null)
			{
				throw new ArgumentNullException("loggingEvent");
			}
			if (m_loggerToMatch != null && m_loggerToMatch.Length != 0 && loggingEvent.LoggerName.StartsWith(m_loggerToMatch))
			{
				if (m_acceptOnMatch)
				{
					return FilterDecision.Accept;
				}
				return FilterDecision.Deny;
			}
			return FilterDecision.Neutral;
		}
	}
}
