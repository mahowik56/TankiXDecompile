using System;
using log4net.Core;

namespace log4net.Filter
{
	public class LevelMatchFilter : FilterSkeleton
	{
		private bool m_acceptOnMatch = true;

		private Level m_levelToMatch;

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

		public Level LevelToMatch
		{
			get
			{
				return m_levelToMatch;
			}
			set
			{
				m_levelToMatch = value;
			}
		}

		public override FilterDecision Decide(LoggingEvent loggingEvent)
		{
			if (loggingEvent == null)
			{
				throw new ArgumentNullException("loggingEvent");
			}
			if (m_levelToMatch != null && m_levelToMatch == loggingEvent.Level)
			{
				return m_acceptOnMatch ? FilterDecision.Accept : FilterDecision.Deny;
			}
			return FilterDecision.Neutral;
		}
	}
}
