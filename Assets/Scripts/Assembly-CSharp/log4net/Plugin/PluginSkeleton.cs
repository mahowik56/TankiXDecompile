using log4net.Repository;

namespace log4net.Plugin
{
	public abstract class PluginSkeleton : IPlugin
	{
		private string m_name;

		private ILoggerRepository m_repository;

		public virtual string Name
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

		protected virtual ILoggerRepository LoggerRepository
		{
			get
			{
				return m_repository;
			}
			set
			{
				m_repository = value;
			}
		}

		protected PluginSkeleton(string name)
		{
			m_name = name;
		}

		public virtual void Attach(ILoggerRepository repository)
		{
			m_repository = repository;
		}

		public virtual void Shutdown()
		{
		}
	}
}
