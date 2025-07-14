using System;
using System.Diagnostics;
using System.Globalization;
using System.Reflection;
using log4net.Util;

namespace log4net.Core
{
	[Serializable]
	public class StackFrameItem
	{
		private readonly string m_lineNumber;

		private readonly string m_fileName;

		private readonly string m_className;

		private readonly string m_fullInfo;

		private readonly MethodItem m_method;

		private static readonly Type declaringType = typeof(StackFrameItem);

		private const string NA = "?";

		public string ClassName
		{
			get
			{
				return m_className;
			}
		}

		public string FileName
		{
			get
			{
				return m_fileName;
			}
		}

		public string LineNumber
		{
			get
			{
				return m_lineNumber;
			}
		}

		public MethodItem Method
		{
			get
			{
				return m_method;
			}
		}

		public string FullInfo
		{
			get
			{
				return m_fullInfo;
			}
		}

		public StackFrameItem(StackFrame frame)
		{
			m_lineNumber = "?";
			m_fileName = "?";
			m_method = new MethodItem();
			m_className = "?";
			try
			{
				m_lineNumber = frame.GetFileLineNumber().ToString(NumberFormatInfo.InvariantInfo);
				m_fileName = frame.GetFileName();
				MethodBase method = frame.GetMethod();
				if (method != null)
				{
					if (method.DeclaringType != null)
					{
						m_className = method.DeclaringType.FullName;
					}
					m_method = new MethodItem(method);
				}
			}
			catch (Exception exception)
			{
				LogLog.Error(declaringType, "An exception ocurred while retreiving stack frame information.", exception);
			}
			m_fullInfo = m_className + '.' + m_method.Name + '(' + m_fileName + ':' + m_lineNumber + ')';
		}
	}
}
