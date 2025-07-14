using System.IO;
using log4net.Core;
using log4net.Util;

namespace log4net.Layout.Pattern
{
	internal sealed class ExceptionPatternConverter : PatternLayoutConverter
	{
		public ExceptionPatternConverter()
		{
			IgnoresException = false;
		}

		protected override void Convert(TextWriter writer, LoggingEvent loggingEvent)
		{
			if (loggingEvent.ExceptionObject != null && Option != null && Option.Length > 0)
			{
				switch (Option.ToLower())
				{
				case "message":
					PatternConverter.WriteObject(writer, loggingEvent.Repository, loggingEvent.ExceptionObject.Message);
					break;
				case "source":
					PatternConverter.WriteObject(writer, loggingEvent.Repository, loggingEvent.ExceptionObject.Source);
					break;
				case "stacktrace":
					PatternConverter.WriteObject(writer, loggingEvent.Repository, loggingEvent.ExceptionObject.StackTrace);
					break;
				case "targetsite":
					PatternConverter.WriteObject(writer, loggingEvent.Repository, loggingEvent.ExceptionObject.TargetSite);
					break;
				case "helplink":
					PatternConverter.WriteObject(writer, loggingEvent.Repository, loggingEvent.ExceptionObject.HelpLink);
					break;
				}
			}
			else
			{
				string exceptionString = loggingEvent.GetExceptionString();
				if (exceptionString != null && exceptionString.Length > 0)
				{
					writer.WriteLine(exceptionString);
				}
			}
		}
	}
}
