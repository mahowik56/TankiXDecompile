using System.IO;
using log4net.Core;

namespace log4net.Layout.Pattern
{
	internal sealed class UserNamePatternConverter : PatternLayoutConverter
	{
		protected override void Convert(TextWriter writer, LoggingEvent loggingEvent)
		{
			writer.Write(loggingEvent.UserName);
		}
	}
}
