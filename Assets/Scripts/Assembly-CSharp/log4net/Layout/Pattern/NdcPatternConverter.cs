using System.IO;
using log4net.Core;
using log4net.Util;

namespace log4net.Layout.Pattern
{
	internal sealed class NdcPatternConverter : PatternLayoutConverter
	{
		protected override void Convert(TextWriter writer, LoggingEvent loggingEvent)
		{
			PatternConverter.WriteObject(writer, loggingEvent.Repository, loggingEvent.LookupProperty("NDC"));
		}
	}
}
