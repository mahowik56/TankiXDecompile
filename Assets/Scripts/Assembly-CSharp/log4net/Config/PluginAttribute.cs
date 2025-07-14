using System;
using log4net.Core;
using log4net.Plugin;
using log4net.Util;

namespace log4net.Config
{
	[Serializable]
	[AttributeUsage(AttributeTargets.Assembly, AllowMultiple = true)]
	public sealed class PluginAttribute : Attribute, IPluginFactory
	{
		private string m_typeName;

		private Type m_type;

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

		public string TypeName
		{
			get
			{
				return m_typeName;
			}
			set
			{
				m_typeName = value;
			}
		}

		public PluginAttribute(string typeName)
		{
			m_typeName = typeName;
		}

		public PluginAttribute(Type type)
		{
			m_type = type;
		}

		public IPlugin CreatePlugin()
		{
			Type type = m_type;
			if (m_type == null)
			{
				type = SystemInfo.GetTypeFromString(m_typeName, true, true);
			}
			if (!typeof(IPlugin).IsAssignableFrom(type))
			{
				throw new LogException("Plugin type [" + type.FullName + "] does not implement the log4net.IPlugin interface");
			}
			return (IPlugin)Activator.CreateInstance(type);
		}

		public override string ToString()
		{
			if (m_type != null)
			{
				return "PluginAttribute[Type=" + m_type.FullName + "]";
			}
			return "PluginAttribute[Type=" + m_typeName + "]";
		}
	}
}
