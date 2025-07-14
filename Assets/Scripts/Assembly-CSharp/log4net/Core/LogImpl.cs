using System;
using System.Globalization;
using log4net.Repository;
using log4net.Util;

namespace log4net.Core
{
	public class LogImpl : LoggerWrapperImpl, ILog, ILoggerWrapper
	{
		private static readonly Type ThisDeclaringType = typeof(LogImpl);

		private Level m_levelDebug;

		private Level m_levelInfo;

		private Level m_levelWarn;

		private Level m_levelError;

		private Level m_levelFatal;

		public virtual bool IsDebugEnabled
		{
			get
			{
				return Logger.IsEnabledFor(m_levelDebug);
			}
		}

		public virtual bool IsInfoEnabled
		{
			get
			{
				return Logger.IsEnabledFor(m_levelInfo);
			}
		}

		public virtual bool IsWarnEnabled
		{
			get
			{
				return Logger.IsEnabledFor(m_levelWarn);
			}
		}

		public virtual bool IsErrorEnabled
		{
			get
			{
				return Logger.IsEnabledFor(m_levelError);
			}
		}

		public virtual bool IsFatalEnabled
		{
			get
			{
				return Logger.IsEnabledFor(m_levelFatal);
			}
		}

		public LogImpl(ILogger logger)
			: base(logger)
		{
			logger.Repository.ConfigurationChanged += LoggerRepositoryConfigurationChanged;
			ReloadLevels(logger.Repository);
		}

		protected virtual void ReloadLevels(ILoggerRepository repository)
		{
			LevelMap levelMap = repository.LevelMap;
			m_levelDebug = levelMap.LookupWithDefault(Level.Debug);
			m_levelInfo = levelMap.LookupWithDefault(Level.Info);
			m_levelWarn = levelMap.LookupWithDefault(Level.Warn);
			m_levelError = levelMap.LookupWithDefault(Level.Error);
			m_levelFatal = levelMap.LookupWithDefault(Level.Fatal);
		}

		public virtual void Debug(object message)
		{
			Logger.Log(ThisDeclaringType, m_levelDebug, message, null);
		}

		public virtual void Debug(object message, Exception exception)
		{
			Logger.Log(ThisDeclaringType, m_levelDebug, message, exception);
		}

		public virtual void DebugFormat(string format, params object[] args)
		{
			if (IsDebugEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelDebug, new SystemStringFormat(CultureInfo.InvariantCulture, format, args), null);
			}
		}

		public virtual void DebugFormat(string format, object arg0)
		{
			if (IsDebugEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelDebug, new SystemStringFormat(CultureInfo.InvariantCulture, format, arg0), null);
			}
		}

		public virtual void DebugFormat(string format, object arg0, object arg1)
		{
			if (IsDebugEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelDebug, new SystemStringFormat(CultureInfo.InvariantCulture, format, arg0, arg1), null);
			}
		}

		public virtual void DebugFormat(string format, object arg0, object arg1, object arg2)
		{
			if (IsDebugEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelDebug, new SystemStringFormat(CultureInfo.InvariantCulture, format, arg0, arg1, arg2), null);
			}
		}

		public virtual void DebugFormat(IFormatProvider provider, string format, params object[] args)
		{
			if (IsDebugEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelDebug, new SystemStringFormat(provider, format, args), null);
			}
		}

		public virtual void Info(object message)
		{
			Logger.Log(ThisDeclaringType, m_levelInfo, message, null);
		}

		public virtual void Info(object message, Exception exception)
		{
			Logger.Log(ThisDeclaringType, m_levelInfo, message, exception);
		}

		public virtual void InfoFormat(string format, params object[] args)
		{
			if (IsInfoEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelInfo, new SystemStringFormat(CultureInfo.InvariantCulture, format, args), null);
			}
		}

		public virtual void InfoFormat(string format, object arg0)
		{
			if (IsInfoEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelInfo, new SystemStringFormat(CultureInfo.InvariantCulture, format, arg0), null);
			}
		}

		public virtual void InfoFormat(string format, object arg0, object arg1)
		{
			if (IsInfoEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelInfo, new SystemStringFormat(CultureInfo.InvariantCulture, format, arg0, arg1), null);
			}
		}

		public virtual void InfoFormat(string format, object arg0, object arg1, object arg2)
		{
			if (IsInfoEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelInfo, new SystemStringFormat(CultureInfo.InvariantCulture, format, arg0, arg1, arg2), null);
			}
		}

		public virtual void InfoFormat(IFormatProvider provider, string format, params object[] args)
		{
			if (IsInfoEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelInfo, new SystemStringFormat(provider, format, args), null);
			}
		}

		public virtual void Warn(object message)
		{
			Logger.Log(ThisDeclaringType, m_levelWarn, message, null);
		}

		public virtual void Warn(object message, Exception exception)
		{
			Logger.Log(ThisDeclaringType, m_levelWarn, message, exception);
		}

		public virtual void WarnFormat(string format, params object[] args)
		{
			if (IsWarnEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelWarn, new SystemStringFormat(CultureInfo.InvariantCulture, format, args), null);
			}
		}

		public virtual void WarnFormat(string format, object arg0)
		{
			if (IsWarnEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelWarn, new SystemStringFormat(CultureInfo.InvariantCulture, format, arg0), null);
			}
		}

		public virtual void WarnFormat(string format, object arg0, object arg1)
		{
			if (IsWarnEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelWarn, new SystemStringFormat(CultureInfo.InvariantCulture, format, arg0, arg1), null);
			}
		}

		public virtual void WarnFormat(string format, object arg0, object arg1, object arg2)
		{
			if (IsWarnEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelWarn, new SystemStringFormat(CultureInfo.InvariantCulture, format, arg0, arg1, arg2), null);
			}
		}

		public virtual void WarnFormat(IFormatProvider provider, string format, params object[] args)
		{
			if (IsWarnEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelWarn, new SystemStringFormat(provider, format, args), null);
			}
		}

		public virtual void Error(object message)
		{
			Logger.Log(ThisDeclaringType, m_levelError, message, null);
		}

		public virtual void Error(object message, Exception exception)
		{
			Logger.Log(ThisDeclaringType, m_levelError, message, exception);
		}

		public virtual void ErrorFormat(string format, params object[] args)
		{
			if (IsErrorEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelError, new SystemStringFormat(CultureInfo.InvariantCulture, format, args), null);
			}
		}

		public virtual void ErrorFormat(string format, object arg0)
		{
			if (IsErrorEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelError, new SystemStringFormat(CultureInfo.InvariantCulture, format, arg0), null);
			}
		}

		public virtual void ErrorFormat(string format, object arg0, object arg1)
		{
			if (IsErrorEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelError, new SystemStringFormat(CultureInfo.InvariantCulture, format, arg0, arg1), null);
			}
		}

		public virtual void ErrorFormat(string format, object arg0, object arg1, object arg2)
		{
			if (IsErrorEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelError, new SystemStringFormat(CultureInfo.InvariantCulture, format, arg0, arg1, arg2), null);
			}
		}

		public virtual void ErrorFormat(IFormatProvider provider, string format, params object[] args)
		{
			if (IsErrorEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelError, new SystemStringFormat(provider, format, args), null);
			}
		}

		public virtual void Fatal(object message)
		{
			Logger.Log(ThisDeclaringType, m_levelFatal, message, null);
		}

		public virtual void Fatal(object message, Exception exception)
		{
			Logger.Log(ThisDeclaringType, m_levelFatal, message, exception);
		}

		public virtual void FatalFormat(string format, params object[] args)
		{
			if (IsFatalEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelFatal, new SystemStringFormat(CultureInfo.InvariantCulture, format, args), null);
			}
		}

		public virtual void FatalFormat(string format, object arg0)
		{
			if (IsFatalEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelFatal, new SystemStringFormat(CultureInfo.InvariantCulture, format, arg0), null);
			}
		}

		public virtual void FatalFormat(string format, object arg0, object arg1)
		{
			if (IsFatalEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelFatal, new SystemStringFormat(CultureInfo.InvariantCulture, format, arg0, arg1), null);
			}
		}

		public virtual void FatalFormat(string format, object arg0, object arg1, object arg2)
		{
			if (IsFatalEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelFatal, new SystemStringFormat(CultureInfo.InvariantCulture, format, arg0, arg1, arg2), null);
			}
		}

		public virtual void FatalFormat(IFormatProvider provider, string format, params object[] args)
		{
			if (IsFatalEnabled)
			{
				Logger.Log(ThisDeclaringType, m_levelFatal, new SystemStringFormat(provider, format, args), null);
			}
		}

		private void LoggerRepositoryConfigurationChanged(object sender, EventArgs e)
		{
			ILoggerRepository loggerRepository = sender as ILoggerRepository;
			if (loggerRepository != null)
			{
				ReloadLevels(loggerRepository);
			}
		}
	}
}
