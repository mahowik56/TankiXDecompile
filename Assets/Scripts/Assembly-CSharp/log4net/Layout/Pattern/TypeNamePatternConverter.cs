using log4net.Core;

namespace log4net.Layout.Pattern
{
	internal sealed class TypeNamePatternConverter : NamedPatternConverter
	{
		protected override string GetFullyQualifiedName(LoggingEvent loggingEvent)
		{
			return loggingEvent.LocationInformation.ClassName;
		}
	}
}
