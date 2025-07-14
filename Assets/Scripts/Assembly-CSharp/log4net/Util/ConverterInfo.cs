using System;

namespace log4net.Util
{
	public sealed class ConverterInfo
	{
		private string m_name;

		private Type m_type;

		private readonly PropertiesDictionary properties = new PropertiesDictionary();

		public string Name
		{
			get
			{
				return m_name;
			}
			set
			{
				m_name = value;
			}
		}

		public Type Type
		{
			get
			{
				return m_type;
			}
			set
			{
				m_type = value;
			}
		}

		public PropertiesDictionary Properties
		{
			get
			{
				return properties;
			}
		}

		public void AddProperty(PropertyEntry entry)
		{
			properties[entry.Key] = entry.Value;
		}
	}
}
