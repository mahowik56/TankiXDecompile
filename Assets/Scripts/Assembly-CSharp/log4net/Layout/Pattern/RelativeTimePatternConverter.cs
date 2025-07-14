using System;
using System.Globalization;
using System.IO;
using log4net.Core;

namespace log4net.Layout.Pattern
{
	internal sealed class RelativeTimePatternConverter : PatternLayoutConverter
	{
		protected override void Convert(TextWriter writer, LoggingEvent loggingEvent)
		{
			writer.Write(TimeDifferenceInMillis(LoggingEvent.StartTime, loggingEvent.TimeStamp).ToString(NumberFormatInfo.InvariantInfo));
		}

		private static long TimeDifferenceInMillis(DateTime start, DateTime end)
		{
			return (long)(end.ToUniversalTime() - start.ToUniversalTime()).TotalMilliseconds;
		}
	}
}
