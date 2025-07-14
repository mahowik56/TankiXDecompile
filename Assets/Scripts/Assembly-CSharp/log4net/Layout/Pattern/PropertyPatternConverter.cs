using System.IO;
using log4net.Core;
using log4net.Util;

namespace log4net.Layout.Pattern
{
	internal sealed class PropertyPatternConverter : PatternLayoutConverter
	{
		protected override void Convert(TextWriter writer, LoggingEvent loggingEvent)
		{
			if (Option != null)
			{
				PatternConverter.WriteObject(writer, loggingEvent.Repository, loggingEvent.LookupProperty(Option));
			}
			else
			{
				PatternConverter.WriteDictionary(writer, loggingEvent.Repository, loggingEvent.GetProperties());
			}
		}
	}
}
