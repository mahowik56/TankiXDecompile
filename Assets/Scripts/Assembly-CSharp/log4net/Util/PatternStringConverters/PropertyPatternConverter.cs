using System.IO;

namespace log4net.Util.PatternStringConverters
{
	internal sealed class PropertyPatternConverter : PatternConverter
	{
		protected override void Convert(TextWriter writer, object state)
		{
			CompositeProperties compositeProperties = new CompositeProperties();
			PropertiesDictionary propertiesDictionary = ThreadContext.Properties.GetProperties(false);
			if (propertiesDictionary != null)
			{
				compositeProperties.Add(propertiesDictionary);
			}
			compositeProperties.Add(GlobalContext.Properties.GetReadOnlyProperties());
			if (Option != null)
			{
				PatternConverter.WriteObject(writer, null, compositeProperties[Option]);
			}
			else
			{
				PatternConverter.WriteDictionary(writer, null, compositeProperties.Flatten());
			}
		}
	}
}
