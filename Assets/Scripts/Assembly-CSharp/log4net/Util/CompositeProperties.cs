using System.Collections;

namespace log4net.Util
{
	public sealed class CompositeProperties
	{
		private PropertiesDictionary m_flattened;

		private ArrayList m_nestedProperties = new ArrayList();

		public object this[string key]
		{
			get
			{
				if (m_flattened != null)
				{
					return m_flattened[key];
				}
				foreach (ReadOnlyPropertiesDictionary nestedProperty in m_nestedProperties)
				{
					if (nestedProperty.Contains(key))
					{
						return nestedProperty[key];
					}
				}
				return null;
			}
		}

		internal CompositeProperties()
		{
		}

		public void Add(ReadOnlyPropertiesDictionary properties)
		{
			m_flattened = null;
			m_nestedProperties.Add(properties);
		}

		public PropertiesDictionary Flatten()
		{
			if (m_flattened == null)
			{
				m_flattened = new PropertiesDictionary();
				int num = m_nestedProperties.Count;
				while (--num >= 0)
				{
					ReadOnlyPropertiesDictionary readOnlyPropertiesDictionary = (ReadOnlyPropertiesDictionary)m_nestedProperties[num];
					foreach (DictionaryEntry item in (IEnumerable)readOnlyPropertiesDictionary)
					{
						m_flattened[(string)item.Key] = item.Value;
					}
				}
			}
			return m_flattened;
		}
	}
}
