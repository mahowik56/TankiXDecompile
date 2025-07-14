using System;
using System.Collections;
using log4net.Appender;
using log4net.Core;
using log4net.ObjectRenderer;
using log4net.Plugin;
using log4net.Util;

namespace log4net.Repository
{
	public abstract class LoggerRepositorySkeleton : ILoggerRepository
	{
		private string m_name;

		private RendererMap m_rendererMap;

		private PluginMap m_pluginMap;

		private LevelMap m_levelMap;

		private Level m_threshold;

		private bool m_configured;

		private ICollection m_configurationMessages;

		private PropertiesDictionary m_properties;

		private static readonly Type declaringType = typeof(LoggerRepositorySkeleton);

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

		public virtual Level Threshold
		{
			get
			{
				return m_threshold;
			}
			set
			{
				if (value != null)
				{
					m_threshold = value;
					return;
				}
				LogLog.Warn(declaringType, "LoggerRepositorySkeleton: Threshold cannot be set to null. Setting to ALL");
				m_threshold = Level.All;
			}
		}

		public virtual RendererMap RendererMap
		{
			get
			{
				return m_rendererMap;
			}
		}

		public virtual PluginMap PluginMap
		{
			get
			{
				return m_pluginMap;
			}
		}

		public virtual LevelMap LevelMap
		{
			get
			{
				return m_levelMap;
			}
		}

		public virtual bool Configured
		{
			get
			{
				return m_configured;
			}
			set
			{
				m_configured = value;
			}
		}

		public virtual ICollection ConfigurationMessages
		{
			get
			{
				return m_configurationMessages;
			}
			set
			{
				m_configurationMessages = value;
			}
		}

		public PropertiesDictionary Properties
		{
			get
			{
				return m_properties;
			}
		}

		private event LoggerRepositoryShutdownEventHandler m_shutdownEvent;

		private event LoggerRepositoryConfigurationResetEventHandler m_configurationResetEvent;

		private event LoggerRepositoryConfigurationChangedEventHandler m_configurationChangedEvent;

		public event LoggerRepositoryShutdownEventHandler ShutdownEvent
		{
			add
			{
				m_shutdownEvent += value;
			}
			remove
			{
				m_shutdownEvent -= value;
			}
		}

		public event LoggerRepositoryConfigurationResetEventHandler ConfigurationReset
		{
			add
			{
				m_configurationResetEvent += value;
			}
			remove
			{
				m_configurationResetEvent -= value;
			}
		}

		public event LoggerRepositoryConfigurationChangedEventHandler ConfigurationChanged
		{
			add
			{
				m_configurationChangedEvent += value;
			}
			remove
			{
				m_configurationChangedEvent -= value;
			}
		}

		protected LoggerRepositorySkeleton()
			: this(new PropertiesDictionary())
		{
		}

		protected LoggerRepositorySkeleton(PropertiesDictionary properties)
		{
			m_properties = properties;
			m_rendererMap = new RendererMap();
			m_pluginMap = new PluginMap(this);
			m_levelMap = new LevelMap();
			m_configurationMessages = EmptyCollection.Instance;
			m_configured = false;
			AddBuiltinLevels();
			m_threshold = Level.All;
		}

		public abstract ILogger Exists(string name);

		public abstract ILogger[] GetCurrentLoggers();

		public abstract ILogger GetLogger(string name);

		public virtual void Shutdown()
		{
			PluginCollection.IPluginCollectionEnumerator enumerator = PluginMap.AllPlugins.GetEnumerator();
			try
			{
				while (enumerator.MoveNext())
				{
					IPlugin current = enumerator.Current;
					current.Shutdown();
				}
			}
			finally
			{
				IDisposable disposable;
				if ((disposable = enumerator as IDisposable) != null)
				{
					disposable.Dispose();
				}
			}
			OnShutdown(null);
		}

		public virtual void ResetConfiguration()
		{
			m_rendererMap.Clear();
			m_levelMap.Clear();
			m_configurationMessages = EmptyCollection.Instance;
			AddBuiltinLevels();
			Configured = false;
			OnConfigurationReset(null);
		}

		public abstract void Log(LoggingEvent logEvent);

		public abstract IAppender[] GetAppenders();

		private void AddBuiltinLevels()
		{
			m_levelMap.Add(Level.Off);
			m_levelMap.Add(Level.Emergency);
			m_levelMap.Add(Level.Fatal);
			m_levelMap.Add(Level.Alert);
			m_levelMap.Add(Level.Critical);
			m_levelMap.Add(Level.Severe);
			m_levelMap.Add(Level.Error);
			m_levelMap.Add(Level.Warn);
			m_levelMap.Add(Level.Notice);
			m_levelMap.Add(Level.Info);
			m_levelMap.Add(Level.Debug);
			m_levelMap.Add(Level.Fine);
			m_levelMap.Add(Level.Trace);
			m_levelMap.Add(Level.Finer);
			m_levelMap.Add(Level.Verbose);
			m_levelMap.Add(Level.Finest);
			m_levelMap.Add(Level.All);
		}

		public virtual void AddRenderer(Type typeToRender, IObjectRenderer rendererInstance)
		{
			if (typeToRender == null)
			{
				throw new ArgumentNullException("typeToRender");
			}
			if (rendererInstance == null)
			{
				throw new ArgumentNullException("rendererInstance");
			}
			m_rendererMap.Put(typeToRender, rendererInstance);
		}

		protected virtual void OnShutdown(EventArgs e)
		{
			if (e == null)
			{
				e = EventArgs.Empty;
			}
			LoggerRepositoryShutdownEventHandler loggerRepositoryShutdownEventHandler = this.m_shutdownEvent;
			if (loggerRepositoryShutdownEventHandler != null)
			{
				loggerRepositoryShutdownEventHandler(this, e);
			}
		}

		protected virtual void OnConfigurationReset(EventArgs e)
		{
			if (e == null)
			{
				e = EventArgs.Empty;
			}
			LoggerRepositoryConfigurationResetEventHandler loggerRepositoryConfigurationResetEventHandler = this.m_configurationResetEvent;
			if (loggerRepositoryConfigurationResetEventHandler != null)
			{
				loggerRepositoryConfigurationResetEventHandler(this, e);
			}
		}

		protected virtual void OnConfigurationChanged(EventArgs e)
		{
			if (e == null)
			{
				e = EventArgs.Empty;
			}
			LoggerRepositoryConfigurationChangedEventHandler loggerRepositoryConfigurationChangedEventHandler = this.m_configurationChangedEvent;
			if (loggerRepositoryConfigurationChangedEventHandler != null)
			{
				loggerRepositoryConfigurationChangedEventHandler(this, e);
			}
		}

		public void RaiseConfigurationChanged(EventArgs e)
		{
			OnConfigurationChanged(e);
		}
	}
}
