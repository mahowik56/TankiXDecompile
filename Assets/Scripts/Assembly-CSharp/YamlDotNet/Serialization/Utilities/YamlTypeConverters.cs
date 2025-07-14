using System.Collections.Generic;
using YamlDotNet.Serialization.Converters;

namespace YamlDotNet.Serialization.Utilities
{
	internal static class YamlTypeConverters
	{
		public static IEnumerable<IYamlTypeConverter> GetBuiltInConverters(bool jsonCompatible)
		{
			yield return new GuidConverter(jsonCompatible);
		}
	}
}
