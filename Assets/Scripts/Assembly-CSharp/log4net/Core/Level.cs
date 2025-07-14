using System;

namespace log4net.Core
{
	[Serializable]
	public sealed class Level : IComparable
	{
		public static readonly Level Off = new Level(int.MaxValue, "OFF");

		public static readonly Level Log4Net_Debug = new Level(120000, "log4net:DEBUG");

		public static readonly Level Emergency = new Level(120000, "EMERGENCY");

		public static readonly Level Fatal = new Level(110000, "FATAL");

		public static readonly Level Alert = new Level(100000, "ALERT");

		public static readonly Level Critical = new Level(90000, "CRITICAL");

		public static readonly Level Severe = new Level(80000, "SEVERE");

		public static readonly Level Error = new Level(70000, "ERROR");

		public static readonly Level Warn = new Level(60000, "WARN");

		public static readonly Level Notice = new Level(50000, "NOTICE");

		public static readonly Level Info = new Level(40000, "INFO");

		public static readonly Level Debug = new Level(30000, "DEBUG");

		public static readonly Level Fine = new Level(30000, "FINE");

		public static readonly Level Trace = new Level(20000, "TRACE");

		public static readonly Level Finer = new Level(20000, "FINER");

		public static readonly Level Verbose = new Level(10000, "VERBOSE");

		public static readonly Level Finest = new Level(10000, "FINEST");

		public static readonly Level All = new Level(int.MinValue, "ALL");

		private readonly int m_levelValue;

		private readonly string m_levelName;

		private readonly string m_levelDisplayName;

		public string Name
		{
			get
			{
				return m_levelName;
			}
		}

		public int Value
		{
			get
			{
				return m_levelValue;
			}
		}

		public string DisplayName
		{
			get
			{
				return m_levelDisplayName;
			}
		}

		public Level(int level, string levelName, string displayName)
		{
			if (levelName == null)
			{
				throw new ArgumentNullException("levelName");
			}
			if (displayName == null)
			{
				throw new ArgumentNullException("displayName");
			}
			m_levelValue = level;
			m_levelName = string.Intern(levelName);
			m_levelDisplayName = displayName;
		}

		public Level(int level, string levelName)
			: this(level, levelName, levelName)
		{
		}

		public override string ToString()
		{
			return m_levelName;
		}

		public override bool Equals(object o)
		{
			Level level = o as Level;
			if (level != null)
			{
				return m_levelValue == level.m_levelValue;
			}
			return base.Equals(o);
		}

		public override int GetHashCode()
		{
			return m_levelValue;
		}

		public int CompareTo(object r)
		{
			Level level = r as Level;
			if (level != null)
			{
				return Compare(this, level);
			}
			throw new ArgumentException(string.Concat("Parameter: r, Value: [", r, "] is not an instance of Level"));
		}

		public static bool operator >(Level l, Level r)
		{
			return l.m_levelValue > r.m_levelValue;
		}

		public static bool operator <(Level l, Level r)
		{
			return l.m_levelValue < r.m_levelValue;
		}

		public static bool operator >=(Level l, Level r)
		{
			return l.m_levelValue >= r.m_levelValue;
		}

		public static bool operator <=(Level l, Level r)
		{
			return l.m_levelValue <= r.m_levelValue;
		}

		public static bool operator ==(Level l, Level r)
		{
			if ((object)l != null && (object)r != null)
			{
				return l.m_levelValue == r.m_levelValue;
			}
			return (object)l == r;
		}

		public static bool operator !=(Level l, Level r)
		{
			return !(l == r);
		}

		public static int Compare(Level l, Level r)
		{
			if ((object)l == r)
			{
				return 0;
			}
			if (l == null && r == null)
			{
				return 0;
			}
			if (l == null)
			{
				return -1;
			}
			if (r == null)
			{
				return 1;
			}
			return l.m_levelValue.CompareTo(r.m_levelValue);
		}
	}
}
