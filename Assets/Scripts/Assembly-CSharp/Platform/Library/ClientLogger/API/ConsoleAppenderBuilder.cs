using Platform.Library.ClientLogger.Impl;
using log4net.Appender;

namespace Platform.Library.ClientLogger.API
{
	public class ConsoleAppenderBuilder : AppenderBuilder
	{
		public ConsoleAppenderBuilder()
		{
			Init(new ConsoleAppender());
		}
	}
}
