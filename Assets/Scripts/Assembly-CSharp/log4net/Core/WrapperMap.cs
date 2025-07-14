using System;
using System.Collections;
using log4net.Repository;

namespace log4net.Core
{
	public class WrapperMap
	{
		private readonly Hashtable m_repositories = new Hashtable();

		private readonly WrapperCreationHandler m_createWrapperHandler;

		private readonly LoggerRepositoryShutdownEventHandler m_shutdownHandler;

		protected Hashtable Repositories
		{
			get
			{
				return m_repositories;
			}
		}

		public WrapperMap(WrapperCreationHandler createWrapperHandler)
		{
			m_createWrapperHandler = createWrapperHandler;
			m_shutdownHandler = ILoggerRepository_Shutdown;
		}

		public virtual ILoggerWrapper GetWrapper(ILogger logger)
		{
			if (logger == null)
			{
				return null;
			}
			lock (this)
			{
				Hashtable hashtable = (Hashtable)m_repositories[logger.Repository];
				if (hashtable == null)
				{
					hashtable = new Hashtable();
					m_repositories[logger.Repository] = hashtable;
					logger.Repository.ShutdownEvent += m_shutdownHandler;
				}
				ILoggerWrapper loggerWrapper = hashtable[logger] as ILoggerWrapper;
				if (loggerWrapper == null)
				{
					loggerWrapper = (ILoggerWrapper)(hashtable[logger] = CreateNewWrapperObject(logger));
				}
				return loggerWrapper;
			}
		}

		protected virtual ILoggerWrapper CreateNewWrapperObject(ILogger logger)
		{
			if (m_createWrapperHandler != null)
			{
				return m_createWrapperHandler(logger);
			}
			return null;
		}

		protected virtual void RepositoryShutdown(ILoggerRepository repository)
		{
			lock (this)
			{
				m_repositories.Remove(repository);
				repository.ShutdownEvent -= m_shutdownHandler;
			}
		}

		private void ILoggerRepository_Shutdown(object sender, EventArgs e)
		{
			ILoggerRepository loggerRepository = sender as ILoggerRepository;
			if (loggerRepository != null)
			{
				RepositoryShutdown(loggerRepository);
			}
		}
	}
}
