using System;
using System.Collections;
using System.Runtime.Serialization;
using System.Security.Permissions;
using System.Xml;

namespace log4net.Util
{
	[Serializable]
	public class ReadOnlyPropertiesDictionary : ISerializable, IDictionary, ICollection, IEnumerable
	{
		private Hashtable m_hashtable = new Hashtable();

		bool IDictionary.IsReadOnly
		{
			get
			{
				return true;
			}
		}

		object IDictionary.this[object key]
		{
			get
			{
				if (!(key is string))
				{
					throw new ArgumentException("key must be a string");
				}
				return InnerHashtable[key];
			}
			set
			{
				throw new NotSupportedException("This is a Read Only Dictionary and can not be modified");
			}
		}

		ICollection IDictionary.Values
		{
			get
			{
				return InnerHashtable.Values;
			}
		}

		ICollection IDictionary.Keys
		{
			get
			{
				return InnerHashtable.Keys;
			}
		}

		bool IDictionary.IsFixedSize
		{
			get
			{
				return InnerHashtable.IsFixedSize;
			}
		}

		bool ICollection.IsSynchronized
		{
			get
			{
				return InnerHashtable.IsSynchronized;
			}
		}

		object ICollection.SyncRoot
		{
			get
			{
				return InnerHashtable.SyncRoot;
			}
		}

		public virtual object this[string key]
		{
			get
			{
				return InnerHashtable[key];
			}
			set
			{
				throw new NotSupportedException("This is a Read Only Dictionary and can not be modified");
			}
		}

		protected Hashtable InnerHashtable
		{
			get
			{
				return m_hashtable;
			}
		}

		public int Count
		{
			get
			{
				return InnerHashtable.Count;
			}
		}

		public ReadOnlyPropertiesDictionary()
		{
		}

		public ReadOnlyPropertiesDictionary(ReadOnlyPropertiesDictionary propertiesDictionary)
		{
			foreach (DictionaryEntry item in (IEnumerable)propertiesDictionary)
			{
				InnerHashtable.Add(item.Key, item.Value);
			}
		}

		protected ReadOnlyPropertiesDictionary(SerializationInfo info, StreamingContext context)
		{
			SerializationInfoEnumerator enumerator = info.GetEnumerator();
			while (enumerator.MoveNext())
			{
				SerializationEntry current = enumerator.Current;
				InnerHashtable[XmlConvert.DecodeName(current.Name)] = current.Value;
			}
		}

		public string[] GetKeys()
		{
			string[] array = new string[InnerHashtable.Count];
			InnerHashtable.Keys.CopyTo(array, 0);
			return array;
		}

		public bool Contains(string key)
		{
			return InnerHashtable.Contains(key);
		}

		[SecurityPermission(SecurityAction.Demand, SerializationFormatter = true)]
		public virtual void GetObjectData(SerializationInfo info, StreamingContext context)
		{
			foreach (DictionaryEntry item in InnerHashtable)
			{
				string text = item.Key as string;
				object value = item.Value;
				if (text != null && value != null && value.GetType().IsSerializable)
				{
					info.AddValue(XmlConvert.EncodeLocalName(text), value);
				}
			}
		}

		IDictionaryEnumerator IDictionary.GetEnumerator()
		{
			return InnerHashtable.GetEnumerator();
		}

		void IDictionary.Remove(object key)
		{
			throw new NotSupportedException("This is a Read Only Dictionary and can not be modified");
		}

		bool IDictionary.Contains(object key)
		{
			return InnerHashtable.Contains(key);
		}

		public virtual void Clear()
		{
			throw new NotSupportedException("This is a Read Only Dictionary and can not be modified");
		}

		void IDictionary.Add(object key, object value)
		{
			throw new NotSupportedException("This is a Read Only Dictionary and can not be modified");
		}

		void ICollection.CopyTo(Array array, int index)
		{
			InnerHashtable.CopyTo(array, index);
		}

		IEnumerator IEnumerable.GetEnumerator()
		{
			return ((IEnumerable)InnerHashtable).GetEnumerator();
		}
	}
}
