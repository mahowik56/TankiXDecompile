using System;
using System.Reflection;
using log4net.Core;
using log4net.Repository;

namespace log4net
{
	public sealed class LogManager
	{
		private static readonly WrapperMap s_wrapperMap = new WrapperMap(WrapperCreationHandler);

		private LogManager()
		{
		}

		public static ILog Exists(string name)
		{
			return Exists(Assembly.GetCallingAssembly(), name);
		}

		public static ILog Exists(string repository, string name)
		{
			return WrapLogger(LoggerManager.Exists(repository, name));
		}

		public static ILog Exists(Assembly repositoryAssembly, string name)
		{
			return WrapLogger(LoggerManager.Exists(repositoryAssembly, name));
		}

		public static ILog[] GetCurrentLoggers()
		{
			return GetCurrentLoggers(Assembly.GetCallingAssembly());
		}

		public static ILog[] GetCurrentLoggers(string repository)
		{
			return WrapLoggers(LoggerManager.GetCurrentLoggers(repository));
		}

		public static ILog[] GetCurrentLoggers(Assembly repositoryAssembly)
		{
			return WrapLoggers(LoggerManager.GetCurrentLoggers(repositoryAssembly));
		}

		public static ILog GetLogger(string name)
		{
			return GetLogger(Assembly.GetCallingAssembly(), name);
		}

		public static ILog GetLogger(string repository, string name)
		{
			return WrapLogger(LoggerManager.GetLogger(repository, name));
		}

		public static ILog GetLogger(Assembly repositoryAssembly, string name)
		{
			return WrapLogger(LoggerManager.GetLogger(repositoryAssembly, name));
		}

		public static ILog GetLogger(Type type)
		{
			return GetLogger(Assembly.GetCallingAssembly(), type.FullName);
		}

		public static ILog GetLogger(string repository, Type type)
		{
			return WrapLogger(LoggerManager.GetLogger(repository, type));
		}

		public static ILog GetLogger(Assembly repositoryAssembly, Type type)
		{
			return WrapLogger(LoggerManager.GetLogger(repositoryAssembly, type));
		}

		public static void Shutdown()
		{
			LoggerManager.Shutdown();
		}

		public static void ShutdownRepository()
		{
			ShutdownRepository(Assembly.GetCallingAssembly());
		}

		public static void ShutdownRepository(string repository)
		{
			LoggerManager.ShutdownRepository(repository);
		}

		public static void ShutdownRepository(Assembly repositoryAssembly)
		{
			LoggerManager.ShutdownRepository(repositoryAssembly);
		}

		public static void ResetConfiguration()
		{
			ResetConfiguration(Assembly.GetCallingAssembly());
		}

		public static void ResetConfiguration(string repository)
		{
			LoggerManager.ResetConfiguration(repository);
		}

		public static void ResetConfiguration(Assembly repositoryAssembly)
		{
			LoggerManager.ResetConfiguration(repositoryAssembly);
		}

		[Obsolete("Use GetRepository instead of GetLoggerRepository")]
		public static ILoggerRepository GetLoggerRepository()
		{
			return GetRepository(Assembly.GetCallingAssembly());
		}

		[Obsolete("Use GetRepository instead of GetLoggerRepository")]
		public static ILoggerRepository GetLoggerRepository(string repository)
		{
			return GetRepository(repository);
		}

		[Obsolete("Use GetRepository instead of GetLoggerRepository")]
		public static ILoggerRepository GetLoggerRepository(Assembly repositoryAssembly)
		{
			return GetRepository(repositoryAssembly);
		}

		public static ILoggerRepository GetRepository()
		{
			return GetRepository(Assembly.GetCallingAssembly());
		}

		public static ILoggerRepository GetRepository(string repository)
		{
			return LoggerManager.GetRepository(repository);
		}

		public static ILoggerRepository GetRepository(Assembly repositoryAssembly)
		{
			return LoggerManager.GetRepository(repositoryAssembly);
		}

		[Obsolete("Use CreateRepository instead of CreateDomain")]
		public static ILoggerRepository CreateDomain(Type repositoryType)
		{
			return CreateRepository(Assembly.GetCallingAssembly(), repositoryType);
		}

		public static ILoggerRepository CreateRepository(Type repositoryType)
		{
			return CreateRepository(Assembly.GetCallingAssembly(), repositoryType);
		}

		[Obsolete("Use CreateRepository instead of CreateDomain")]
		public static ILoggerRepository CreateDomain(string repository)
		{
			return LoggerManager.CreateRepository(repository);
		}

		public static ILoggerRepository CreateRepository(string repository)
		{
			return LoggerManager.CreateRepository(repository);
		}

		[Obsolete("Use CreateRepository instead of CreateDomain")]
		public static ILoggerRepository CreateDomain(string repository, Type repositoryType)
		{
			return LoggerManager.CreateRepository(repository, repositoryType);
		}

		public static ILoggerRepository CreateRepository(string repository, Type repositoryType)
		{
			return LoggerManager.CreateRepository(repository, repositoryType);
		}

		[Obsolete("Use CreateRepository instead of CreateDomain")]
		public static ILoggerRepository CreateDomain(Assembly repositoryAssembly, Type repositoryType)
		{
			return LoggerManager.CreateRepository(repositoryAssembly, repositoryType);
		}

		public static ILoggerRepository CreateRepository(Assembly repositoryAssembly, Type repositoryType)
		{
			return LoggerManager.CreateRepository(repositoryAssembly, repositoryType);
		}

		public static ILoggerRepository[] GetAllRepositories()
		{
			return LoggerManager.GetAllRepositories();
		}

		private static ILog WrapLogger(ILogger logger)
		{
			return (ILog)s_wrapperMap.GetWrapper(logger);
		}

		private static ILog[] WrapLoggers(ILogger[] loggers)
		{
			ILog[] array = new ILog[loggers.Length];
			for (int i = 0; i < loggers.Length; i++)
			{
				array[i] = WrapLogger(loggers[i]);
			}
			return array;
		}

		private static ILoggerWrapper WrapperCreationHandler(ILogger logger)
		{
			return new LogImpl(logger);
		}
	}
}
