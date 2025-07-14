namespace log4net.Util
{
	public sealed class GlobalContextProperties : ContextPropertiesBase
	{
		private volatile ReadOnlyPropertiesDictionary m_readOnlyProperties = new ReadOnlyPropertiesDictionary();

		private readonly object m_syncRoot = new object();

		public override object this[string key]
		{
			get
			{
				return m_readOnlyProperties[key];
			}
			set
			{
				lock (m_syncRoot)
				{
					PropertiesDictionary propertiesDictionary = new PropertiesDictionary(m_readOnlyProperties);
					propertiesDictionary[key] = value;
					m_readOnlyProperties = new ReadOnlyPropertiesDictionary(propertiesDictionary);
				}
			}
		}

		internal GlobalContextProperties()
		{
		}

		public void Remove(string key)
		{
			lock (m_syncRoot)
			{
				if (m_readOnlyProperties.Contains(key))
				{
					PropertiesDictionary propertiesDictionary = new PropertiesDictionary(m_readOnlyProperties);
					propertiesDictionary.Remove(key);
					m_readOnlyProperties = new ReadOnlyPropertiesDictionary(propertiesDictionary);
				}
			}
		}

		public void Clear()
		{
			lock (m_syncRoot)
			{
				m_readOnlyProperties = new ReadOnlyPropertiesDictionary();
			}
		}

		internal ReadOnlyPropertiesDictionary GetReadOnlyProperties()
		{
			return m_readOnlyProperties;
		}
	}
}
