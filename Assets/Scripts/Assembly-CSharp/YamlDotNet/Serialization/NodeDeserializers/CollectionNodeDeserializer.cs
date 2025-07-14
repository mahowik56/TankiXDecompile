using System;
using System.Collections;
using System.Collections.Generic;
using YamlDotNet.Core;
using YamlDotNet.Core.Events;
using YamlDotNet.Helpers;
using YamlDotNet.Serialization.Utilities;

namespace YamlDotNet.Serialization.NodeDeserializers
{
	public sealed class CollectionNodeDeserializer : INodeDeserializer
	{
		private readonly IObjectFactory _objectFactory;

		public CollectionNodeDeserializer(IObjectFactory objectFactory)
		{
			_objectFactory = objectFactory;
		}

		bool INodeDeserializer.Deserialize(EventReader reader, Type expectedType, Func<EventReader, Type, object> nestedObjectDeserializer, out object value)
		{
			bool canUpdate = true;
			Type implementedGenericInterface = ReflectionUtility.GetImplementedGenericInterface(expectedType, typeof(ICollection<>));
			Type tItem;
			IList list;
			if (implementedGenericInterface != null)
			{
				Type[] genericArguments = implementedGenericInterface.GetGenericArguments();
				tItem = genericArguments[0];
				value = _objectFactory.Create(expectedType);
				list = value as IList;
				if (list == null)
				{
					Type implementedGenericInterface2 = ReflectionUtility.GetImplementedGenericInterface(expectedType, typeof(IList<>));
					canUpdate = implementedGenericInterface2 != null;
					list = new GenericCollectionToNonGenericAdapter(value, implementedGenericInterface, implementedGenericInterface2);
				}
			}
			else
			{
				if (!typeof(IList).IsAssignableFrom(expectedType))
				{
					value = false;
					return false;
				}
				tItem = typeof(object);
				value = _objectFactory.Create(expectedType);
				list = (IList)value;
			}
			DeserializeHelper(tItem, reader, expectedType, nestedObjectDeserializer, list, canUpdate);
			return true;
		}

		internal static void DeserializeHelper(Type tItem, EventReader reader, Type expectedType, Func<EventReader, Type, object> nestedObjectDeserializer, IList result, bool canUpdate)
		{
			reader.Expect<SequenceStart>();
			while (!reader.Accept<SequenceEnd>())
			{
				ParsingEvent current = reader.Parser.Current;
				object obj = nestedObjectDeserializer(reader, tItem);
				IValuePromise valuePromise = obj as IValuePromise;
				if (valuePromise == null)
				{
					result.Add(TypeConverter.ChangeType(obj, tItem));
					continue;
				}
				if (canUpdate)
				{
					int index = result.Add((!tItem.IsValueType()) ? null : Activator.CreateInstance(tItem));
					valuePromise.ValueAvailable += delegate(object v)
					{
						result[index] = TypeConverter.ChangeType(v, tItem);
					};
					continue;
				}
				throw new ForwardAnchorNotSupportedException(current.Start, current.End, "Forward alias references are not allowed because this type does not implement IList<>");
			}
			reader.Expect<SequenceEnd>();
		}
	}
}
