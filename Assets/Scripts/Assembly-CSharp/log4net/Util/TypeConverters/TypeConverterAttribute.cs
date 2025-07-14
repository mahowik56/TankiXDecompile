using System;

namespace log4net.Util.TypeConverters
{
	[AttributeUsage(AttributeTargets.Class | AttributeTargets.Enum | AttributeTargets.Interface)]
	public sealed class TypeConverterAttribute : Attribute
	{
		private string m_typeName;

		public string ConverterTypeName
		{
			get
			{
				return m_typeName;
			}
			set
			{
				m_typeName = value;
			}
		}

		public TypeConverterAttribute()
		{
		}

		public TypeConverterAttribute(string typeName)
		{
			m_typeName = typeName;
		}

		public TypeConverterAttribute(Type converterType)
		{
			m_typeName = SystemInfo.AssemblyQualifiedName(converterType);
		}
	}
}
