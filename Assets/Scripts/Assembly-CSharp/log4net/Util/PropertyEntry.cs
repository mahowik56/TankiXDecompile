namespace log4net.Util
{
	public class PropertyEntry
	{
		private string m_key;

		private object m_value;

		public string Key
		{
			get
			{
				return m_key;
			}
			set
			{
				m_key = value;
			}
		}

		public object Value
		{
			get
			{
				return m_value;
			}
			set
			{
				m_value = value;
			}
		}

		public override string ToString()
		{
			return string.Concat("PropertyEntry(Key=", m_key, ", Value=", m_value, ")");
		}
	}
}
