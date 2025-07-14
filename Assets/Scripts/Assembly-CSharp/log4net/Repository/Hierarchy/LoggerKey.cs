namespace log4net.Repository.Hierarchy
{
	internal sealed class LoggerKey
	{
		private readonly string m_name;

		private readonly int m_hashCache;

		internal LoggerKey(string name)
		{
			m_name = string.Intern(name);
			m_hashCache = name.GetHashCode();
		}

		public override int GetHashCode()
		{
			return m_hashCache;
		}

		public override bool Equals(object obj)
		{
			if (this == obj)
			{
				return true;
			}
			LoggerKey loggerKey = obj as LoggerKey;
			if (loggerKey != null)
			{
				return (object)m_name == loggerKey.m_name;
			}
			return false;
		}
	}
}
