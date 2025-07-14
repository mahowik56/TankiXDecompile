using System.IO;
using Platform.Tool.ClientUnityLogger.Impl;
using log4net.Core;
using log4net.Layout.Pattern;

namespace Platform.Tool.ClientUnityLogger.API
{
	public class ExceptionEscapeConverter : PatternLayoutConverter
	{
		public const string KEY = "escapedException";

		protected override void Convert(TextWriter writer, LoggingEvent loggingEvent)
		{
			string exceptionString = loggingEvent.GetExceptionString();
			if (!string.IsNullOrEmpty(exceptionString))
			{
				writer.WriteLine(JsonUtil.ToJSONString(exceptionString));
			}
		}
	}
}
