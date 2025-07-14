using System;
using System.IO;

namespace log4net.Util.PatternStringConverters
{
	internal class UtcDatePatternConverter : DatePatternConverter
	{
		private static readonly Type declaringType = typeof(UtcDatePatternConverter);

		protected override void Convert(TextWriter writer, object state)
		{
			try
			{
				m_dateFormatter.FormatDate(DateTime.UtcNow, writer);
			}
			catch (Exception exception)
			{
				LogLog.Error(declaringType, "Error occurred while converting date.", exception);
			}
		}
	}
}
