using System;
using System.Collections;
using YamlDotNet.Core;

namespace YamlDotNet.Serialization.NodeDeserializers
{
	public sealed class ArrayNodeDeserializer : INodeDeserializer
	{
		private sealed class ArrayList : IList, ICollection, IEnumerable
		{
			private object[] data;

			private int count;

			public bool IsFixedSize
			{
				get
				{
					return false;
				}
			}

			public bool IsReadOnly
			{
				get
				{
					return false;
				}
			}

			public object this[int index]
			{
				get
				{
					return data[index];
				}
				set
				{
					data[index] = value;
				}
			}

			public int Count
			{
				get
				{
					return count;
				}
			}

			public bool IsSynchronized
			{
				get
				{
					return false;
				}
			}

			public object SyncRoot
			{
				get
				{
					return data;
				}
			}

			public ArrayList()
			{
				Clear();
			}

			public int Add(object value)
			{
				if (count == data.Length)
				{
					Array.Resize(ref data, data.Length * 2);
				}
				data[count] = value;
				return count++;
			}

			public void Clear()
			{
				data = new object[10];
				count = 0;
			}

			public bool Contains(object value)
			{
				throw new NotImplementedException();
			}

			public int IndexOf(object value)
			{
				throw new NotImplementedException();
			}

			public void Insert(int index, object value)
			{
				throw new NotImplementedException();
			}

			public void Remove(object value)
			{
				throw new NotImplementedException();
			}

			public void RemoveAt(int index)
			{
				throw new NotImplementedException();
			}

			public void CopyTo(Array array, int index)
			{
				Array.Copy(data, 0, array, index, count);
			}

			public IEnumerator GetEnumerator()
			{
				for (int i = 0; i < count; i++)
				{
					yield return data[i];
				}
			}
		}

		bool INodeDeserializer.Deserialize(EventReader reader, Type expectedType, Func<EventReader, Type, object> nestedObjectDeserializer, out object value)
		{
			if (!expectedType.IsArray)
			{
				value = false;
				return false;
			}
			Type elementType = expectedType.GetElementType();
			ArrayList arrayList = new ArrayList();
			CollectionNodeDeserializer.DeserializeHelper(elementType, reader, expectedType, nestedObjectDeserializer, arrayList, true);
			Array array = Array.CreateInstance(elementType, arrayList.Count);
			arrayList.CopyTo(array, 0);
			value = array;
			return true;
		}
	}
}
