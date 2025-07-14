using System;
using System.Collections;
using System.Xml;
using log4net.Appender;
using log4net.Core;
using log4net.Util;

namespace log4net.Repository.Hierarchy
{
	public class Hierarchy : LoggerRepositorySkeleton, IBasicRepositoryConfigurator, IXmlRepositoryConfigurator
	{
		internal class LevelEntry
		{
			private int m_levelValue = -1;

			private string m_levelName;

			private string m_levelDisplayName;

			public int Value
			{
				get
				{
					return m_levelValue;
				}
				set
				{
					m_levelValue = value;
				}
			}

			public string Name
			{
				get
				{
					return m_levelName;
				}
				set
				{
					m_levelName = value;
				}
			}

			public string DisplayName
			{
				get
				{
					return m_levelDisplayName;
				}
				set
				{
					m_levelDisplayName = value;
				}
			}

			public override string ToString()
			{
				return "LevelEntry(Value=" + m_levelValue + ", Name=" + m_levelName + ", DisplayName=" + m_levelDisplayName + ")";
			}
		}

		private ILoggerFactory m_defaultFactory;

		private Hashtable m_ht;

		private Logger m_root;

		private bool m_emittedNoAppenderWarning;

		private static readonly Type declaringType = typeof(Hierarchy);

		public bool EmittedNoAppenderWarning
		{
			get
			{
				return m_emittedNoAppenderWarning;
			}
			set
			{
				m_emittedNoAppenderWarning = value;
			}
		}

		public Logger Root
		{
			get
			{
				if (m_root == null)
				{
					lock (this)
					{
						if (m_root == null)
						{
							Logger logger = m_defaultFactory.CreateLogger(this, null);
							logger.Hierarchy = this;
							m_root = logger;
						}
					}
				}
				return m_root;
			}
		}

		public ILoggerFactory LoggerFactory
		{
			get
			{
				return m_defaultFactory;
			}
			set
			{
				if (value == null)
				{
					throw new ArgumentNullException("value");
				}
				m_defaultFactory = value;
			}
		}

		public event LoggerCreationEventHandler LoggerCreatedEvent
		{
			add
			{
				m_loggerCreatedEvent += value;
			}
			remove
			{
				m_loggerCreatedEvent -= value;
			}
		}

		private event LoggerCreationEventHandler m_loggerCreatedEvent;

		public Hierarchy()
			: this(new DefaultLoggerFactory())
		{
		}

		public Hierarchy(PropertiesDictionary properties)
			: this(properties, new DefaultLoggerFactory())
		{
		}

		public Hierarchy(ILoggerFactory loggerFactory)
			: this(new PropertiesDictionary(), loggerFactory)
		{
		}

		public Hierarchy(PropertiesDictionary properties, ILoggerFactory loggerFactory)
			: base(properties)
		{
			if (loggerFactory == null)
			{
				throw new ArgumentNullException("loggerFactory");
			}
			m_defaultFactory = loggerFactory;
			m_ht = Hashtable.Synchronized(new Hashtable());
		}

		public override ILogger Exists(string name)
		{
			if (name == null)
			{
				throw new ArgumentNullException("name");
			}
			return m_ht[new LoggerKey(name)] as Logger;
		}

		public override ILogger[] GetCurrentLoggers()
		{
			ArrayList arrayList = new ArrayList(m_ht.Count);
			foreach (object value in m_ht.Values)
			{
				if (value is Logger)
				{
					arrayList.Add(value);
				}
			}
			return (Logger[])arrayList.ToArray(typeof(Logger));
		}

		public override ILogger GetLogger(string name)
		{
			if (name == null)
			{
				throw new ArgumentNullException("name");
			}
			return GetLogger(name, m_defaultFactory);
		}

		public override void Shutdown()
		{
			LogLog.Debug(declaringType, "Shutdown called on Hierarchy [" + Name + "]");
			Root.CloseNestedAppenders();
			lock (m_ht)
			{
				ILogger[] currentLoggers = GetCurrentLoggers();
				ILogger[] array = currentLoggers;
				for (int i = 0; i < array.Length; i++)
				{
					Logger logger = (Logger)array[i];
					logger.CloseNestedAppenders();
				}
				Root.RemoveAllAppenders();
				ILogger[] array2 = currentLoggers;
				for (int j = 0; j < array2.Length; j++)
				{
					Logger logger2 = (Logger)array2[j];
					logger2.RemoveAllAppenders();
				}
			}
			base.Shutdown();
		}

		public override void ResetConfiguration()
		{
			Root.Level = LevelMap.LookupWithDefault(Level.Debug);
			Threshold = LevelMap.LookupWithDefault(Level.All);
			lock (m_ht)
			{
				Shutdown();
				ILogger[] currentLoggers = GetCurrentLoggers();
				for (int i = 0; i < currentLoggers.Length; i++)
				{
					Logger logger = (Logger)currentLoggers[i];
					logger.Level = null;
					logger.Additivity = true;
				}
			}
			base.ResetConfiguration();
			OnConfigurationChanged(null);
		}

		public override void Log(LoggingEvent logEvent)
		{
			if (logEvent == null)
			{
				throw new ArgumentNullException("logEvent");
			}
			GetLogger(logEvent.LoggerName, m_defaultFactory).Log(logEvent);
		}

		public override IAppender[] GetAppenders()
		{
			ArrayList arrayList = new ArrayList();
			CollectAppenders(arrayList, Root);
			ILogger[] currentLoggers = GetCurrentLoggers();
			for (int i = 0; i < currentLoggers.Length; i++)
			{
				Logger container = (Logger)currentLoggers[i];
				CollectAppenders(arrayList, container);
			}
			return (IAppender[])arrayList.ToArray(typeof(IAppender));
		}

		private static void CollectAppender(ArrayList appenderList, IAppender appender)
		{
			if (!appenderList.Contains(appender))
			{
				appenderList.Add(appender);
				IAppenderAttachable appenderAttachable = appender as IAppenderAttachable;
				if (appenderAttachable != null)
				{
					CollectAppenders(appenderList, appenderAttachable);
				}
			}
		}

		private static void CollectAppenders(ArrayList appenderList, IAppenderAttachable container)
		{
			AppenderCollection.IAppenderCollectionEnumerator enumerator = container.Appenders.GetEnumerator();
			try
			{
				while (enumerator.MoveNext())
				{
					IAppender current = enumerator.Current;
					CollectAppender(appenderList, current);
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
		}

		void IBasicRepositoryConfigurator.Configure(IAppender appender)
		{
			BasicRepositoryConfigure(appender);
		}

		void IBasicRepositoryConfigurator.Configure(params IAppender[] appenders)
		{
			BasicRepositoryConfigure(appenders);
		}

		protected void BasicRepositoryConfigure(params IAppender[] appenders)
		{
			ArrayList arrayList = new ArrayList();
			using (new LogLog.LogReceivedAdapter(arrayList))
			{
				foreach (IAppender newAppender in appenders)
				{
					Root.AddAppender(newAppender);
				}
			}
			Configured = true;
			ConfigurationMessages = arrayList;
			OnConfigurationChanged(new ConfigurationChangedEventArgs(arrayList));
		}

		void IXmlRepositoryConfigurator.Configure(XmlElement element)
		{
			XmlRepositoryConfigure(element);
		}

		protected void XmlRepositoryConfigure(XmlElement element)
		{
			ArrayList arrayList = new ArrayList();
			using (new LogLog.LogReceivedAdapter(arrayList))
			{
				XmlHierarchyConfigurator xmlHierarchyConfigurator = new XmlHierarchyConfigurator(this);
				xmlHierarchyConfigurator.Configure(element);
			}
			Configured = true;
			ConfigurationMessages = arrayList;
			OnConfigurationChanged(new ConfigurationChangedEventArgs(arrayList));
		}

		public bool IsDisabled(Level level)
		{
			if ((object)level == null)
			{
				throw new ArgumentNullException("level");
			}
			if (Configured)
			{
				return Threshold > level;
			}
			return true;
		}

		public void Clear()
		{
			m_ht.Clear();
		}

		public Logger GetLogger(string name, ILoggerFactory factory)
		{
			if (name == null)
			{
				throw new ArgumentNullException("name");
			}
			if (factory == null)
			{
				throw new ArgumentNullException("factory");
			}
			LoggerKey key = new LoggerKey(name);
			lock (m_ht)
			{
				Logger logger = null;
				object obj = m_ht[key];
				if (obj == null)
				{
					logger = factory.CreateLogger(this, name);
					logger.Hierarchy = this;
					m_ht[key] = logger;
					UpdateParents(logger);
					OnLoggerCreationEvent(logger);
					return logger;
				}
				Logger logger2 = obj as Logger;
				if (logger2 != null)
				{
					return logger2;
				}
				ProvisionNode provisionNode = obj as ProvisionNode;
				if (provisionNode != null)
				{
					logger = factory.CreateLogger(this, name);
					logger.Hierarchy = this;
					m_ht[key] = logger;
					UpdateChildren(provisionNode, logger);
					UpdateParents(logger);
					OnLoggerCreationEvent(logger);
					return logger;
				}
				return null;
			}
		}

		protected virtual void OnLoggerCreationEvent(Logger logger)
		{
			LoggerCreationEventHandler loggerCreationEventHandler = this.m_loggerCreatedEvent;
			if (loggerCreationEventHandler != null)
			{
				loggerCreationEventHandler(this, new LoggerCreationEventArgs(logger));
			}
		}

		private void UpdateParents(Logger log)
		{
			string name = log.Name;
			int length = name.Length;
			bool flag = false;
			for (int num = name.LastIndexOf('.', length - 1); num >= 0; num = name.LastIndexOf('.', num - 1))
			{
				string name2 = name.Substring(0, num);
				LoggerKey key = new LoggerKey(name2);
				object obj = m_ht[key];
				if (obj == null)
				{
					ProvisionNode value = new ProvisionNode(log);
					m_ht[key] = value;
				}
				else
				{
					Logger logger = obj as Logger;
					if (logger != null)
					{
						flag = true;
						log.Parent = logger;
						break;
					}
					ProvisionNode provisionNode = obj as ProvisionNode;
					if (provisionNode != null)
					{
						provisionNode.Add(log);
					}
					else
					{
						LogLog.Error(declaringType, string.Concat("Unexpected object type [", obj.GetType(), "] in ht."), new LogException());
					}
				}
				if (num == 0)
				{
					break;
				}
			}
			if (!flag)
			{
				log.Parent = Root;
			}
		}

		private static void UpdateChildren(ProvisionNode pn, Logger log)
		{
			for (int i = 0; i < pn.Count; i++)
			{
				Logger logger = (Logger)pn[i];
				if (!logger.Parent.Name.StartsWith(log.Name))
				{
					log.Parent = logger.Parent;
					logger.Parent = log;
				}
			}
		}

		internal void AddLevel(LevelEntry levelEntry)
		{
			if (levelEntry == null)
			{
				throw new ArgumentNullException("levelEntry");
			}
			if (levelEntry.Name == null)
			{
				throw new ArgumentNullException("levelEntry.Name");
			}
			if (levelEntry.Value == -1)
			{
				Level level = LevelMap[levelEntry.Name];
				if (level == null)
				{
					throw new InvalidOperationException("Cannot redefine level [" + levelEntry.Name + "] because it is not defined in the LevelMap. To define the level supply the level value.");
				}
				levelEntry.Value = level.Value;
			}
			LevelMap.Add(levelEntry.Name, levelEntry.Value, levelEntry.DisplayName);
		}

		internal void AddProperty(PropertyEntry propertyEntry)
		{
			if (propertyEntry == null)
			{
				throw new ArgumentNullException("propertyEntry");
			}
			if (propertyEntry.Key == null)
			{
				throw new ArgumentNullException("propertyEntry.Key");
			}
			base.Properties[propertyEntry.Key] = propertyEntry.Value;
		}
	}
}
