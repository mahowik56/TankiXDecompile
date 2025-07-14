using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using YamlDotNet.Helpers;
using YamlDotNet.Serialization.Utilities;

namespace YamlDotNet.Serialization.ObjectGraphTraversalStrategies
{
	public class FullObjectGraphTraversalStrategy : IObjectGraphTraversalStrategy
	{
		protected readonly Serializer serializer;

		private readonly int maxRecursion;

		private readonly ITypeInspector typeDescriptor;

		private readonly ITypeResolver typeResolver;

		private INamingConvention namingConvention;

		public FullObjectGraphTraversalStrategy(Serializer serializer, ITypeInspector typeDescriptor, ITypeResolver typeResolver, int maxRecursion, INamingConvention namingConvention)
		{
			if (maxRecursion <= 0)
			{
				throw new ArgumentOutOfRangeException("maxRecursion", maxRecursion, "maxRecursion must be greater than 1");
			}
			this.serializer = serializer;
			if (typeDescriptor == null)
			{
				throw new ArgumentNullException("typeDescriptor");
			}
			this.typeDescriptor = typeDescriptor;
			if (typeResolver == null)
			{
				throw new ArgumentNullException("typeResolver");
			}
			this.typeResolver = typeResolver;
			this.maxRecursion = maxRecursion;
			this.namingConvention = namingConvention;
		}

		void IObjectGraphTraversalStrategy.Traverse(IObjectDescriptor graph, IObjectGraphVisitor visitor)
		{
			Traverse(graph, visitor, 0);
		}

		protected virtual void Traverse(IObjectDescriptor value, IObjectGraphVisitor visitor, int currentDepth)
		{
			if (++currentDepth > maxRecursion)
			{
				throw new InvalidOperationException("Too much recursion when traversing the object graph");
			}
			if (!visitor.Enter(value))
			{
				return;
			}
			TypeCode typeCode = value.Type.GetTypeCode();
			switch (typeCode)
			{
			case TypeCode.Boolean:
			case TypeCode.Char:
			case TypeCode.SByte:
			case TypeCode.Byte:
			case TypeCode.Int16:
			case TypeCode.UInt16:
			case TypeCode.Int32:
			case TypeCode.UInt32:
			case TypeCode.Int64:
			case TypeCode.UInt64:
			case TypeCode.Single:
			case TypeCode.Double:
			case TypeCode.Decimal:
			case TypeCode.DateTime:
			case TypeCode.String:
				visitor.VisitScalar(value);
				return;
			case TypeCode.DBNull:
				visitor.VisitScalar(new ObjectDescriptor(null, typeof(object), typeof(object)));
				return;
			case TypeCode.Empty:
				throw new NotSupportedException(string.Format(CultureInfo.InvariantCulture, "TypeCode.{0} is not supported.", typeCode));
			}
			if (value.Value == null || value.Type == typeof(TimeSpan))
			{
				visitor.VisitScalar(value);
				return;
			}
			Type underlyingType = Nullable.GetUnderlyingType(value.Type);
			if (underlyingType != null)
			{
				Traverse(new ObjectDescriptor(value.Value, underlyingType, value.Type, value.ScalarStyle), visitor, currentDepth);
			}
			else
			{
				TraverseObject(value, visitor, currentDepth);
			}
		}

		protected virtual void TraverseObject(IObjectDescriptor value, IObjectGraphVisitor visitor, int currentDepth)
		{
			if (typeof(IDictionary).IsAssignableFrom(value.Type))
			{
				TraverseDictionary(value, visitor, currentDepth, typeof(object), typeof(object));
				return;
			}
			Type implementedGenericInterface = ReflectionUtility.GetImplementedGenericInterface(value.Type, typeof(IDictionary<, >));
			if (implementedGenericInterface != null)
			{
				GenericDictionaryToNonGenericAdapter value2 = new GenericDictionaryToNonGenericAdapter(value.Value, implementedGenericInterface);
				Type[] genericArguments = implementedGenericInterface.GetGenericArguments();
				TraverseDictionary(new ObjectDescriptor(value2, value.Type, value.StaticType, value.ScalarStyle), visitor, currentDepth, genericArguments[0], genericArguments[1]);
			}
			else if (typeof(IEnumerable).IsAssignableFrom(value.Type))
			{
				TraverseList(value, visitor, currentDepth);
			}
			else
			{
				TraverseProperties(value, visitor, currentDepth);
			}
		}

		protected virtual void TraverseDictionary(IObjectDescriptor dictionary, IObjectGraphVisitor visitor, int currentDepth, Type keyType, Type valueType)
		{
			visitor.VisitMappingStart(dictionary, keyType, valueType);
			bool flag = dictionary.Type.FullName.Equals("System.Dynamic.ExpandoObject");
			foreach (DictionaryEntry item in (IDictionary)dictionary.Value)
			{
				string value = ((!flag) ? item.Key.ToString() : namingConvention.Apply(item.Key.ToString()));
				IObjectDescriptor objectDescriptor = GetObjectDescriptor(value, keyType);
				IObjectDescriptor objectDescriptor2 = GetObjectDescriptor(item.Value, valueType);
				if (visitor.EnterMapping(objectDescriptor, objectDescriptor2))
				{
					Traverse(objectDescriptor, visitor, currentDepth);
					Traverse(objectDescriptor2, visitor, currentDepth);
				}
			}
			visitor.VisitMappingEnd(dictionary);
		}

		private void TraverseList(IObjectDescriptor value, IObjectGraphVisitor visitor, int currentDepth)
		{
			Type implementedGenericInterface = ReflectionUtility.GetImplementedGenericInterface(value.Type, typeof(IEnumerable<>));
			Type type = ((implementedGenericInterface == null) ? typeof(object) : implementedGenericInterface.GetGenericArguments()[0]);
			visitor.VisitSequenceStart(value, type);
			foreach (object item in (IEnumerable)value.Value)
			{
				Traverse(GetObjectDescriptor(item, type), visitor, currentDepth);
			}
			visitor.VisitSequenceEnd(value);
		}

		protected virtual void TraverseProperties(IObjectDescriptor value, IObjectGraphVisitor visitor, int currentDepth)
		{
			visitor.VisitMappingStart(value, typeof(string), typeof(object));
			foreach (IPropertyDescriptor property in typeDescriptor.GetProperties(value.Type, value.Value))
			{
				IObjectDescriptor value2 = property.Read(value.Value);
				if (visitor.EnterMapping(property, value2))
				{
					Traverse(new ObjectDescriptor(property.Name, typeof(string), typeof(string)), visitor, currentDepth);
					Traverse(value2, visitor, currentDepth);
				}
			}
			visitor.VisitMappingEnd(value);
		}

		private IObjectDescriptor GetObjectDescriptor(object value, Type staticType)
		{
			return new ObjectDescriptor(value, typeResolver.Resolve(staticType, value), staticType);
		}
	}
}
