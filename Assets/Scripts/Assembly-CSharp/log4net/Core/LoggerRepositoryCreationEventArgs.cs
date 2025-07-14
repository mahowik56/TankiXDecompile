using System;
using log4net.Repository;

namespace log4net.Core
{
	public class LoggerRepositoryCreationEventArgs : EventArgs
	{
		private ILoggerRepository m_repository;

		public ILoggerRepository LoggerRepository
		{
			get
			{
				return m_repository;
			}
		}

		public LoggerRepositoryCreationEventArgs(ILoggerRepository repository)
		{
			m_repository = repository;
		}
	}
}
