using System;
using System.Collections;
using System.Reflection;
using log4net.Util;

namespace log4net.Core
{
	[Serializable]
	public class MethodItem
	{
		private readonly string m_name;

		private readonly string[] m_parameters;

		private static readonly Type declaringType = typeof(MethodItem);

		private const string NA = "?";

		public string Name
		{
			get
			{
				return m_name;
			}
		}

		public string[] Parameters
		{
			get
			{
				return m_parameters;
			}
		}

		public MethodItem()
		{
			m_name = "?";
			m_parameters = new string[0];
		}

		public MethodItem(string name)
			: this()
		{
			m_name = name;
		}

		public MethodItem(string name, string[] parameters)
			: this(name)
		{
			m_parameters = parameters;
		}

		public MethodItem(MethodBase methodBase)
			: this(methodBase.Name, GetMethodParameterNames(methodBase))
		{
		}

		private static string[] GetMethodParameterNames(MethodBase methodBase)
		{
			ArrayList arrayList = new ArrayList();
			try
			{
				ParameterInfo[] parameters = methodBase.GetParameters();
				int upperBound = parameters.GetUpperBound(0);
				for (int i = 0; i <= upperBound; i++)
				{
					arrayList.Add(string.Concat(parameters[i].ParameterType, " ", parameters[i].Name));
				}
			}
			catch (Exception exception)
			{
				LogLog.Error(declaringType, "An exception ocurred while retreiving method parameters.", exception);
			}
			return (string[])arrayList.ToArray(typeof(string));
		}
	}
}
