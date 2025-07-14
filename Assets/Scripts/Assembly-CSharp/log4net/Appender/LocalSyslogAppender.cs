using System;
using System.Runtime.InteropServices;
using System.Security.Permissions;
using log4net.Core;
using log4net.Util;

namespace log4net.Appender
{
	public class LocalSyslogAppender : AppenderSkeleton
	{
		public enum SyslogSeverity
		{
			Emergency = 0,
			Alert = 1,
			Critical = 2,
			Error = 3,
			Warning = 4,
			Notice = 5,
			Informational = 6,
			Debug = 7
		}

		public enum SyslogFacility
		{
			Kernel = 0,
			User = 1,
			Mail = 2,
			Daemons = 3,
			Authorization = 4,
			Syslog = 5,
			Printer = 6,
			News = 7,
			Uucp = 8,
			Clock = 9,
			Authorization2 = 10,
			Ftp = 11,
			Ntp = 12,
			Audit = 13,
			Alert = 14,
			Clock2 = 15,
			Local0 = 16,
			Local1 = 17,
			Local2 = 18,
			Local3 = 19,
			Local4 = 20,
			Local5 = 21,
			Local6 = 22,
			Local7 = 23
		}

		public class LevelSeverity : LevelMappingEntry
		{
			private SyslogSeverity m_severity;

			public SyslogSeverity Severity
			{
				get
				{
					return m_severity;
				}
				set
				{
					m_severity = value;
				}
			}
		}

		private SyslogFacility m_facility = SyslogFacility.User;

		private string m_identity;

		private IntPtr m_handleToIdentity = IntPtr.Zero;

		private LevelMapping m_levelMapping = new LevelMapping();

		public string Identity
		{
			get
			{
				return m_identity;
			}
			set
			{
				m_identity = value;
			}
		}

		public SyslogFacility Facility
		{
			get
			{
				return m_facility;
			}
			set
			{
				m_facility = value;
			}
		}

		protected override bool RequiresLayout
		{
			get
			{
				return true;
			}
		}

		public void AddMapping(LevelSeverity mapping)
		{
			m_levelMapping.Add(mapping);
		}

		public override void ActivateOptions()
		{
			base.ActivateOptions();
			m_levelMapping.ActivateOptions();
			string text = m_identity;
			if (text == null)
			{
				text = SystemInfo.ApplicationFriendlyName;
			}
			m_handleToIdentity = Marshal.StringToHGlobalAnsi(text);
			openlog(m_handleToIdentity, 1, m_facility);
		}

		[SecurityPermission(SecurityAction.Demand, UnmanagedCode = true)]
		protected override void Append(LoggingEvent loggingEvent)
		{
			int priority = GeneratePriority(m_facility, GetSeverity(loggingEvent.Level));
			string message = RenderLoggingEvent(loggingEvent);
			syslog(priority, "%s", message);
		}

		protected override void OnClose()
		{
			base.OnClose();
			try
			{
				closelog();
			}
			catch (DllNotFoundException)
			{
			}
			if (m_handleToIdentity != IntPtr.Zero)
			{
				Marshal.FreeHGlobal(m_handleToIdentity);
			}
		}

		protected virtual SyslogSeverity GetSeverity(Level level)
		{
			LevelSeverity levelSeverity = m_levelMapping.Lookup(level) as LevelSeverity;
			if (levelSeverity != null)
			{
				return levelSeverity.Severity;
			}
			if (level >= Level.Alert)
			{
				return SyslogSeverity.Alert;
			}
			if (level >= Level.Critical)
			{
				return SyslogSeverity.Critical;
			}
			if (level >= Level.Error)
			{
				return SyslogSeverity.Error;
			}
			if (level >= Level.Warn)
			{
				return SyslogSeverity.Warning;
			}
			if (level >= Level.Notice)
			{
				return SyslogSeverity.Notice;
			}
			if (level >= Level.Info)
			{
				return SyslogSeverity.Informational;
			}
			return SyslogSeverity.Debug;
		}

		private static int GeneratePriority(SyslogFacility facility, SyslogSeverity severity)
		{
			return (int)((int)facility * 8 + severity);
		}

		[DllImport("libc")]
		private static extern void openlog(IntPtr ident, int option, SyslogFacility facility);

		[DllImport("libc", CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Ansi)]
		private static extern void syslog(int priority, string format, string message);

		[DllImport("libc")]
		private static extern void closelog();
	}
}
