using System;
using System.Reflection;
using log4net.Core;
using log4net.Repository;
using log4net.Util;

namespace log4net.Config
{
	[Serializable]
	[AttributeUsage(AttributeTargets.Assembly)]
	public sealed class SecurityContextProviderAttribute : ConfiguratorAttribute
	{
		private Type m_providerType;

		private static readonly Type declaringType = typeof(SecurityContextProviderAttribute);

		public Type ProviderType
		{
			get
			{
				return m_providerType;
			}
			set
			{
				m_providerType = value;
			}
		}

		public SecurityContextProviderAttribute(Type providerType)
			: base(100)
		{
			m_providerType = providerType;
		}

		public override void Configure(Assembly sourceAssembly, ILoggerRepository targetRepository)
		{
			if (m_providerType == null)
			{
				LogLog.Error(declaringType, "Attribute specified on assembly [" + sourceAssembly.FullName + "] with null ProviderType.");
				return;
			}
			LogLog.Debug(declaringType, "Creating provider of type [" + m_providerType.FullName + "]");
			SecurityContextProvider securityContextProvider = Activator.CreateInstance(m_providerType) as SecurityContextProvider;
			if (securityContextProvider == null)
			{
				LogLog.Error(declaringType, "Failed to create SecurityContextProvider instance of type [" + m_providerType.Name + "].");
			}
			else
			{
				SecurityContextProvider.DefaultProvider = securityContextProvider;
			}
		}
	}
}
