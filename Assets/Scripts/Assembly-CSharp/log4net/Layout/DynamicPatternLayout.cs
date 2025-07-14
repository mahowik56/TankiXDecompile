using log4net.Util;

namespace log4net.Layout
{
	public class DynamicPatternLayout : PatternLayout
	{
		private PatternString m_headerPatternString = new PatternString(string.Empty);

		private PatternString m_footerPatternString = new PatternString(string.Empty);

		public override string Header
		{
			get
			{
				return m_headerPatternString.Format();
			}
			set
			{
				base.Header = value;
				m_headerPatternString = new PatternString(value);
			}
		}

		public override string Footer
		{
			get
			{
				return m_footerPatternString.Format();
			}
			set
			{
				base.Footer = value;
				m_footerPatternString = new PatternString(value);
			}
		}

		public DynamicPatternLayout()
		{
		}

		public DynamicPatternLayout(string pattern)
			: base(pattern)
		{
		}
	}
}
