using System;
using log4net.Core;

namespace log4net.Util
{
	public class OnlyOnceErrorHandler : IErrorHandler
	{
		private DateTime m_enabledDate;

		private bool m_firstTime = true;

		private string m_message;

		private Exception m_exception;

		private ErrorCode m_errorCode;

		private readonly string m_prefix;

		private static readonly Type declaringType = typeof(OnlyOnceErrorHandler);

		public bool IsEnabled
		{
			get
			{
				return m_firstTime;
			}
		}

		public DateTime EnabledDate
		{
			get
			{
				return m_enabledDate;
			}
		}

		public string ErrorMessage
		{
			get
			{
				return m_message;
			}
		}

		public Exception Exception
		{
			get
			{
				return m_exception;
			}
		}

		public ErrorCode ErrorCode
		{
			get
			{
				return m_errorCode;
			}
		}

		public OnlyOnceErrorHandler()
		{
			m_prefix = string.Empty;
		}

		public OnlyOnceErrorHandler(string prefix)
		{
			m_prefix = prefix;
		}

		public void Reset()
		{
			m_enabledDate = DateTime.MinValue;
			m_errorCode = ErrorCode.GenericFailure;
			m_exception = null;
			m_message = null;
			m_firstTime = true;
		}

		public void Error(string message, Exception e, ErrorCode errorCode)
		{
			if (m_firstTime)
			{
				FirstError(message, e, errorCode);
			}
		}

		public virtual void FirstError(string message, Exception e, ErrorCode errorCode)
		{
			m_enabledDate = DateTime.Now;
			m_errorCode = errorCode;
			m_exception = e;
			m_message = message;
			m_firstTime = false;
			if (LogLog.InternalDebugging && !LogLog.QuietMode)
			{
				LogLog.Error(declaringType, "[" + m_prefix + "] ErrorCode: " + errorCode.ToString() + ". " + message, e);
			}
		}

		public void Error(string message, Exception e)
		{
			Error(message, e, ErrorCode.GenericFailure);
		}

		public void Error(string message)
		{
			Error(message, null, ErrorCode.GenericFailure);
		}
	}
}
