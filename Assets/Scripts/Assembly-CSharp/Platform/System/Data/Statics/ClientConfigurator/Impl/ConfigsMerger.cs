using System.Collections.Generic;
using Platform.System.Data.Statics.ClientConfigurator.API;
using Platform.System.Data.Statics.ClientYaml.Impl;

namespace Platform.System.Data.Statics.ClientConfigurator.Impl
{
	public class ConfigsMerger
	{
		private struct ConfigData
		{
			public readonly YamlNodeImpl yamlNode;

			public readonly int profileElements;

			public ConfigData(string configName, YamlNodeImpl yamlNode)
			{
				this.yamlNode = yamlNode;
				profileElements = configName.Split('_').Length - 1;
			}
		}

		private class ConfigDataComparer : IComparer<ConfigData>
		{
			public int Compare(ConfigData x, ConfigData y)
			{
				return x.profileElements.CompareTo(y.profileElements);
			}
		}

		private static readonly ConfigDataComparer configDataComparer = new ConfigDataComparer();

		private Dictionary<ConfigTreeNode, List<ConfigData>> configNodeToConfigDataList = new Dictionary<ConfigTreeNode, List<ConfigData>>();

		public void Put(ConfigTreeNode configTreeNode, string configName, YamlNodeImpl yamlNode)
		{
			ConfigData item = new ConfigData(configName, yamlNode);
			List<ConfigData> list;
			if (configNodeToConfigDataList.ContainsKey(configTreeNode))
			{
				list = configNodeToConfigDataList[configTreeNode];
			}
			else
			{
				list = new List<ConfigData>();
				configNodeToConfigDataList[configTreeNode] = list;
			}
			list.Add(item);
		}

		public void Merge()
		{
			foreach (ConfigTreeNode key in configNodeToConfigDataList.Keys)
			{
				List<ConfigData> list = configNodeToConfigDataList[key];
				YamlNodeImpl yamlNode;
				if (list.Count > 1)
				{
					list.Sort(configDataComparer);
					yamlNode = list[0].yamlNode;
					for (int i = 1; i < list.Count; i++)
					{
						yamlNode.Merge(list[i].yamlNode);
					}
				}
				else
				{
					yamlNode = list[0].yamlNode;
				}
				key.SetYaml(yamlNode);
			}
			configNodeToConfigDataList.Clear();
		}
	}
}
