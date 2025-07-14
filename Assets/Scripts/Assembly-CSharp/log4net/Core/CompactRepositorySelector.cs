using System;
using System.Collections;
using System.Reflection;
using log4net.Repository;
using log4net.Util;

namespace log4net.Core
{
	public class CompactRepositorySelector : IRepositorySelector
	{
		private const string DefaultRepositoryName = "log4net-default-repository";

		private readonly Hashtable m_name2repositoryMap = new Hashtable();

		private readonly Type m_defaultRepositoryType;

		private static readonly Type declaringType = typeof(CompactRepositorySelector);

		private event LoggerRepositoryCreationEventHandler m_loggerRepositoryCreatedEvent;

		public event LoggerRepositoryCreationEventHandler LoggerRepositoryCreatedEvent
		{
			add
			{
				m_loggerRepositoryCreatedEvent += value;
			}
			remove
			{
				m_loggerRepositoryCreatedEvent -= value;
			}
		}

		public CompactRepositorySelector(Type defaultRepositoryType)
		{
			if (defaultRepositoryType == null)
			{
				throw new ArgumentNullException("defaultRepositoryType");
			}
			if (!typeof(ILoggerRepository).IsAssignableFrom(defaultRepositoryType))
			{
				throw SystemInfo.CreateArgumentOutOfRangeException("defaultRepositoryType", defaultRepositoryType, string.Concat("Parameter: defaultRepositoryType, Value: [", defaultRepositoryType, "] out of range. Argument must implement the ILoggerRepository interface"));
			}
			m_defaultRepositoryType = defaultRepositoryType;
			LogLog.Debug(declaringType, string.Concat("defaultRepositoryType [", m_defaultRepositoryType, "]"));
		}

		public ILoggerRepository GetRepository(Assembly assembly)
		{
			return CreateRepository(assembly, m_defaultRepositoryType);
		}

		public ILoggerRepository GetRepository(string repositoryName)
		{
			if (repositoryName == null)
			{
				throw new ArgumentNullException("repositoryName");
			}
			lock (this)
			{
				ILoggerRepository loggerRepository = m_name2repositoryMap[repositoryName] as ILoggerRepository;
				if (loggerRepository == null)
				{
					throw new LogException("Repository [" + repositoryName + "] is NOT defined.");
				}
				return loggerRepository;
			}
		}

		public ILoggerRepository CreateRepository(Assembly assembly, Type repositoryType)
		{
			if (repositoryType == null)
			{
				repositoryType = m_defaultRepositoryType;
			}
			lock (this)
			{
				ILoggerRepository loggerRepository = m_name2repositoryMap["log4net-default-repository"] as ILoggerRepository;
				if (loggerRepository == null)
				{
					loggerRepository = CreateRepository("log4net-default-repository", repositoryType);
				}
				return loggerRepository;
			}
		}

		public ILoggerRepository CreateRepository(string repositoryName, Type repositoryType)
		{
			if (repositoryName == null)
			{
				throw new ArgumentNullException("repositoryName");
			}
			if (repositoryType == null)
			{
				repositoryType = m_defaultRepositoryType;
			}
			lock (this)
			{
				ILoggerRepository loggerRepository = null;
				loggerRepository = m_name2repositoryMap[repositoryName] as ILoggerRepository;
				if (loggerRepository != null)
				{
					throw new LogException("Repository [" + repositoryName + "] is already defined. Repositories cannot be redefined.");
				}
				LogLog.Debug(declaringType, string.Concat("Creating repository [", repositoryName, "] using type [", repositoryType, "]"));
				loggerRepository = (ILoggerRepository)Activator.CreateInstance(repositoryType);
				loggerRepository.Name = repositoryName;
				m_name2repositoryMap[repositoryName] = loggerRepository;
				OnLoggerRepositoryCreatedEvent(loggerRepository);
				return loggerRepository;
			}
		}

		public bool ExistsRepository(string repositoryName)
		{
			lock (this)
			{
				return m_name2repositoryMap.ContainsKey(repositoryName);
			}
		}

		public ILoggerRepository[] GetAllRepositories()
		{
			lock (this)
			{
				ICollection values = m_name2repositoryMap.Values;
				ILoggerRepository[] array = new ILoggerRepository[values.Count];
				values.CopyTo(array, 0);
				return array;
			}
		}

		protected virtual void OnLoggerRepositoryCreatedEvent(ILoggerRepository repository)
		{
			LoggerRepositoryCreationEventHandler loggerRepositoryCreationEventHandler = this.m_loggerRepositoryCreatedEvent;
			if (loggerRepositoryCreationEventHandler != null)
			{
				loggerRepositoryCreationEventHandler(this, new LoggerRepositoryCreationEventArgs(repository));
			}
		}
	}
}
