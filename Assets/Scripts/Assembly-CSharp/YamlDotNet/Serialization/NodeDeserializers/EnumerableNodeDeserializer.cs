using System;
using System.Collections;
using System.Collections.Generic;
using YamlDotNet.Core;
using YamlDotNet.Serialization.Utilities;

namespace YamlDotNet.Serialization.NodeDeserializers
{
	public sealed class EnumerableNodeDeserializer : INodeDeserializer
	{
		bool INodeDeserializer.Deserialize(EventReader reader, Type expectedType, Func<EventReader, Type, object> nestedObjectDeserializer, out object value)
		{
			Type type;
			if (expectedType == typeof(IEnumerable))
			{
				type = typeof(object);
			}
			else
			{
				Type implementedGenericInterface = ReflectionUtility.GetImplementedGenericInterface(expectedType, typeof(IEnumerable<>));
				if (implementedGenericInterface != expectedType)
				{
					value = null;
					return false;
				}
				type = implementedGenericInterface.GetGenericArguments()[0];
			}
			Type arg = typeof(List<>).MakeGenericType(type);
			value = nestedObjectDeserializer(reader, arg);
			return true;
		}
	}
}
