using YamlDotNet.Serialization;

namespace Platform.System.Data.Statics.ClientYaml.Impl
{
	public class CamelToPascalCaseNamingConvention : INamingConvention
	{
		public string Apply(string value)
		{
			return char.ToUpper(value[0]) + value.Substring(1);
		}
	}
}
