using System;
using System.Collections;

namespace log4net.Util
{
	public sealed class LogLog
	{
		public class LogReceivedAdapter : IDisposable
		{
			private readonly IList items;

			private readonly LogReceivedEventHandler handler;

			public IList Items
			{
				get
				{
					return items;
				}
			}

			public LogReceivedAdapter(IList items)
			{
				this.items = items;
				handler = LogLog_LogReceived;
				LogReceived += handler;
			}

			private void LogLog_LogReceived(object source, LogReceivedEventArgs e)
			{
				items.Add(e.LogLog);
			}

			public void Dispose()
			{
				LogReceived -= handler;
			}
		}

		private readonly Type source;

		private readonly DateTime timeStamp;

		private readonly string prefix;

		private readonly string message;

		private readonly Exception exception;

		private static bool s_debugEnabled;

		private static bool s_quietMode;

		private static bool s_emitInternalMessages;

		private const string PREFIX = "log4net: ";

		private const string ERR_PREFIX = "log4net:ERROR ";

		private const string WARN_PREFIX = "log4net:WARN ";

		public Type Source
		{
			get
			{
				return source;
			}
		}

		public DateTime TimeStamp
		{
			get
			{
				return timeStamp;
			}
		}

		public string Prefix
		{
			get
			{
				return prefix;
			}
		}

		public string Message
		{
			get
			{
				return message;
			}
		}

		public Exception Exception
		{
			get
			{
				return exception;
			}
		}

		public static bool InternalDebugging
		{
			get
			{
				return s_debugEnabled;
			}
			set
			{
				s_debugEnabled = value;
			}
		}

		public static bool QuietMode
		{
			get
			{
				return s_quietMode;
			}
			set
			{
				s_quietMode = value;
			}
		}

		public static bool EmitInternalMessages
		{
			get
			{
				return s_emitInternalMessages;
			}
			set
			{
				s_emitInternalMessages = value;
			}
		}

		public static bool IsDebugEnabled
		{
			get
			{
				return s_debugEnabled && !s_quietMode;
			}
		}

		public static bool IsWarnEnabled
		{
			get
			{
				return !s_quietMode;
			}
		}

		public static bool IsErrorEnabled
		{
			get
			{
				return !s_quietMode;
			}
		}

		public static event LogReceivedEventHandler LogReceived;

		public LogLog(Type source, string prefix, string message, Exception exception)
		{
			timeStamp = DateTime.Now;
			this.source = source;
			this.prefix = prefix;
			this.message = message;
			this.exception = exception;
		}

		static LogLog()
		{
			s_emitInternalMessages = true;
		}

		public override string ToString()
		{
			return Prefix + Source.Name + ": " + Message;
		}

		public static void OnLogReceived(Type source, string prefix, string message, Exception exception)
		{
			if (LogLog.LogReceived != null)
			{
				LogLog.LogReceived(null, new LogReceivedEventArgs(new LogLog(source, prefix, message, exception)));
			}
		}

		public static void Debug(Type source, string message)
		{
			if (IsDebugEnabled)
			{
				if (EmitInternalMessages)
				{
					EmitOutLine("log4net: " + message);
				}
				OnLogReceived(source, "log4net: ", message, null);
			}
		}

		public static void Debug(Type source, string message, Exception exception)
		{
			if (!IsDebugEnabled)
			{
				return;
			}
			if (EmitInternalMessages)
			{
				EmitOutLine("log4net: " + message);
				if (exception != null)
				{
					EmitOutLine(exception.ToString());
				}
			}
			OnLogReceived(source, "log4net: ", message, exception);
		}

		public static void Warn(Type source, string message)
		{
			if (IsWarnEnabled)
			{
				if (EmitInternalMessages)
				{
					EmitErrorLine("log4net:WARN " + message);
				}
				OnLogReceived(source, "log4net:WARN ", message, null);
			}
		}

		public static void Warn(Type source, string message, Exception exception)
		{
			if (!IsWarnEnabled)
			{
				return;
			}
			if (EmitInternalMessages)
			{
				EmitErrorLine("log4net:WARN " + message);
				if (exception != null)
				{
					EmitErrorLine(exception.ToString());
				}
			}
			OnLogReceived(source, "log4net:WARN ", message, exception);
		}

		public static void Error(Type source, string message)
		{
			if (IsErrorEnabled)
			{
				if (EmitInternalMessages)
				{
					EmitErrorLine("log4net:ERROR " + message);
				}
				OnLogReceived(source, "log4net:ERROR ", message, null);
			}
		}

		public static void Error(Type source, string message, Exception exception)
		{
			if (!IsErrorEnabled)
			{
				return;
			}
			if (EmitInternalMessages)
			{
				EmitErrorLine("log4net:ERROR " + message);
				if (exception != null)
				{
					EmitErrorLine(exception.ToString());
				}
			}
			OnLogReceived(source, "log4net:ERROR ", message, exception);
		}

		private static void EmitOutLine(string message)
		{
			try
			{
				Console.Out.WriteLine(message);
			}
			catch
			{
			}
		}

		private static void EmitErrorLine(string message)
		{
			try
			{
				Console.Error.WriteLine(message);
			}
			catch
			{
			}
		}
	}
}
