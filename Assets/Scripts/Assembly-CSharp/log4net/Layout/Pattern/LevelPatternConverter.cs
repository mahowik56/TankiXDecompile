using System.IO;
using log4net.Core;

namespace log4net.Layout.Pattern
{
	internal sealed class LevelPatternConverter : PatternLayoutConverter
	{
		protected override void Convert(TextWriter writer, LoggingEvent loggingEvent)
		{
			writer.Write(loggingEvent.Level.DisplayName);
		}
	}
}
