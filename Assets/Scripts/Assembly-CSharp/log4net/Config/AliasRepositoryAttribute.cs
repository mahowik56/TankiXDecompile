using System;

namespace log4net.Config
{
	[Serializable]
	[AttributeUsage(AttributeTargets.Assembly, AllowMultiple = true)]
	public class AliasRepositoryAttribute : Attribute
	{
		private string m_name;

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

		public AliasRepositoryAttribute(string name)
		{
			Name = name;
		}
	}
}
