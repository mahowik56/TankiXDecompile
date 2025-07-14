using System;
using log4net.Core;

namespace log4net.Filter
{
	public class LevelRangeFilter : FilterSkeleton
	{
		private bool m_acceptOnMatch = true;

		private Level m_levelMin;

		private Level m_levelMax;

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

		public Level LevelMin
		{
			get
			{
				return m_levelMin;
			}
			set
			{
				m_levelMin = value;
			}
		}

		public Level LevelMax
		{
			get
			{
				return m_levelMax;
			}
			set
			{
				m_levelMax = value;
			}
		}

		public override FilterDecision Decide(LoggingEvent loggingEvent)
		{
			if (loggingEvent == null)
			{
				throw new ArgumentNullException("loggingEvent");
			}
			if (m_levelMin != null && loggingEvent.Level < m_levelMin)
			{
				return FilterDecision.Deny;
			}
			if (m_levelMax != null && loggingEvent.Level > m_levelMax)
			{
				return FilterDecision.Deny;
			}
			if (m_acceptOnMatch)
			{
				return FilterDecision.Accept;
			}
			return FilterDecision.Neutral;
		}
	}
}
