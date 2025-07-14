using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;

namespace YamlDotNet.Helpers
{
	internal sealed class GenericDictionaryToNonGenericAdapter : IDictionary, ICollection, IEnumerable
	{
		private class DictionaryEnumerator : IDictionaryEnumerator, IEnumerator
		{
			private readonly IEnumerator enumerator;

			private readonly MethodInfo getKeyMethod;

			private readonly MethodInfo getValueMethod;

			public DictionaryEntry Entry
			{
				get
				{
					return new DictionaryEntry(Key, Value);
				}
			}

			public object Key
			{
				get
				{
					return getKeyMethod.Invoke(enumerator.Current, null);
				}
			}

			public object Value
			{
				get
				{
					return getValueMethod.Invoke(enumerator.Current, null);
				}
			}

			public object Current
			{
				get
				{
					return Entry;
				}
			}

			public DictionaryEnumerator(object genericDictionary, Type genericDictionaryType)
			{
				Type[] genericArguments = genericDictionaryType.GetGenericArguments();
				Type type = typeof(KeyValuePair<, >).MakeGenericType(genericArguments);
				getKeyMethod = type.GetPublicProperty("Key").GetGetMethod();
				getValueMethod = type.GetPublicProperty("Value").GetGetMethod();
				enumerator = ((IEnumerable)genericDictionary).GetEnumerator();
			}

			public bool MoveNext()
			{
				return enumerator.MoveNext();
			}

			public void Reset()
			{
				enumerator.Reset();
			}
		}

		private readonly object genericDictionary;

		private readonly Type genericDictionaryType;

		private readonly MethodInfo indexerSetter;

		public bool IsFixedSize
		{
			get
			{
				throw new NotImplementedException();
			}
		}

		public bool IsReadOnly
		{
			get
			{
				throw new NotImplementedException();
			}
		}

		public ICollection Keys
		{
			get
			{
				throw new NotImplementedException();
			}
		}

		public ICollection Values
		{
			get
			{
				throw new NotImplementedException();
			}
		}

		public object this[object key]
		{
			get
			{
				throw new NotImplementedException();
			}
			set
			{
				indexerSetter.Invoke(genericDictionary, new object[2] { key, value });
			}
		}

		public int Count
		{
			get
			{
				throw new NotImplementedException();
			}
		}

		public bool IsSynchronized
		{
			get
			{
				throw new NotImplementedException();
			}
		}

		public object SyncRoot
		{
			get
			{
				throw new NotImplementedException();
			}
		}

		public GenericDictionaryToNonGenericAdapter(object genericDictionary, Type genericDictionaryType)
		{
			this.genericDictionary = genericDictionary;
			this.genericDictionaryType = genericDictionaryType;
			indexerSetter = genericDictionaryType.GetPublicProperty("Item").GetSetMethod();
		}

		public void Add(object key, object value)
		{
			throw new NotImplementedException();
		}

		public void Clear()
		{
			throw new NotImplementedException();
		}

		public bool Contains(object key)
		{
			throw new NotImplementedException();
		}

		public IDictionaryEnumerator GetEnumerator()
		{
			return new DictionaryEnumerator(genericDictionary, genericDictionaryType);
		}

		public void Remove(object key)
		{
			throw new NotImplementedException();
		}

		public void CopyTo(Array array, int index)
		{
			throw new NotImplementedException();
		}

		IEnumerator IEnumerable.GetEnumerator()
		{
			return ((IEnumerable)genericDictionary).GetEnumerator();
		}
	}
}
