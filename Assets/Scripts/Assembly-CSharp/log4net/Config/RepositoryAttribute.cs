using System;

namespace log4net.Config
{
	[Serializable]
	[AttributeUsage(AttributeTargets.Assembly)]
	public class RepositoryAttribute : Attribute
	{
		private string m_name;

		private Type m_repositoryType;

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

		public Type RepositoryType
		{
			get
			{
				return m_repositoryType;
			}
			set
			{
				m_repositoryType = value;
			}
		}

		public RepositoryAttribute()
		{
		}

		public RepositoryAttribute(string name)
		{
			m_name = name;
		}
	}
}
