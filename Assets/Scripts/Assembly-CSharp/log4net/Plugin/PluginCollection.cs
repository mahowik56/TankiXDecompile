using System;
using System.Collections;
using log4net.Util;

namespace log4net.Plugin
{
	public class PluginCollection : ICollection, IList, IEnumerable, ICloneable
	{
		public interface IPluginCollectionEnumerator
		{
			IPlugin Current { get; }

			bool MoveNext();

			void Reset();
		}

		protected internal enum Tag
		{
			Default = 0
		}

		private sealed class Enumerator : IEnumerator, IPluginCollectionEnumerator
		{
			private readonly PluginCollection m_collection;

			private int m_index;

			private int m_version;

			object IEnumerator.Current
			{
				get
				{
					return Current;
				}
			}

			public IPlugin Current
			{
				get
				{
					return m_collection[m_index];
				}
			}

			internal Enumerator(PluginCollection tc)
			{
				m_collection = tc;
				m_index = -1;
				m_version = tc.m_version;
			}

			public bool MoveNext()
			{
				if (m_version != m_collection.m_version)
				{
					throw new InvalidOperationException("Collection was modified; enumeration operation may not execute.");
				}
				m_index++;
				return m_index < m_collection.Count;
			}

			public void Reset()
			{
				m_index = -1;
			}
		}

		private sealed class ReadOnlyPluginCollection : PluginCollection
		{
			private readonly PluginCollection m_collection;

			public override int Count
			{
				get
				{
					return m_collection.Count;
				}
			}

			public override bool IsSynchronized
			{
				get
				{
					return m_collection.IsSynchronized;
				}
			}

			public override object SyncRoot
			{
				get
				{
					return m_collection.SyncRoot;
				}
			}

			public override IPlugin this[int i]
			{
				get
				{
					return m_collection[i];
				}
				set
				{
					throw new NotSupportedException("This is a Read Only Collection and can not be modified");
				}
			}

			public override bool IsFixedSize
			{
				get
				{
					return true;
				}
			}

			public override bool IsReadOnly
			{
				get
				{
					return true;
				}
			}

			public override int Capacity
			{
				get
				{
					return m_collection.Capacity;
				}
				set
				{
					throw new NotSupportedException("This is a Read Only Collection and can not be modified");
				}
			}

			internal ReadOnlyPluginCollection(PluginCollection list)
				: base(Tag.Default)
			{
				m_collection = list;
			}

			public override void CopyTo(IPlugin[] array)
			{
				m_collection.CopyTo(array);
			}

			public override void CopyTo(IPlugin[] array, int start)
			{
				m_collection.CopyTo(array, start);
			}

			public override int Add(IPlugin x)
			{
				throw new NotSupportedException("This is a Read Only Collection and can not be modified");
			}

			public override void Clear()
			{
				throw new NotSupportedException("This is a Read Only Collection and can not be modified");
			}

			public override bool Contains(IPlugin x)
			{
				return m_collection.Contains(x);
			}

			public override int IndexOf(IPlugin x)
			{
				return m_collection.IndexOf(x);
			}

			public override void Insert(int pos, IPlugin x)
			{
				throw new NotSupportedException("This is a Read Only Collection and can not be modified");
			}

			public override void Remove(IPlugin x)
			{
				throw new NotSupportedException("This is a Read Only Collection and can not be modified");
			}

			public override void RemoveAt(int pos)
			{
				throw new NotSupportedException("This is a Read Only Collection and can not be modified");
			}

			public override IPluginCollectionEnumerator GetEnumerator()
			{
				return m_collection.GetEnumerator();
			}

			public override int AddRange(PluginCollection x)
			{
				throw new NotSupportedException("This is a Read Only Collection and can not be modified");
			}

			public override int AddRange(IPlugin[] x)
			{
				throw new NotSupportedException("This is a Read Only Collection and can not be modified");
			}
		}

		private const int DEFAULT_CAPACITY = 16;

		private IPlugin[] m_array;

		private int m_count;

		private int m_version;

		object IList.this[int i]
		{
			get
			{
				return this[i];
			}
			set
			{
				this[i] = (IPlugin)value;
			}
		}

		public virtual int Count
		{
			get
			{
				return m_count;
			}
		}

		public virtual bool IsSynchronized
		{
			get
			{
				return m_array.IsSynchronized;
			}
		}

		public virtual object SyncRoot
		{
			get
			{
				return m_array.SyncRoot;
			}
		}

		public virtual IPlugin this[int index]
		{
			get
			{
				ValidateIndex(index);
				return m_array[index];
			}
			set
			{
				ValidateIndex(index);
				m_version++;
				m_array[index] = value;
			}
		}

		public virtual bool IsFixedSize
		{
			get
			{
				return false;
			}
		}

		public virtual bool IsReadOnly
		{
			get
			{
				return false;
			}
		}

		public virtual int Capacity
		{
			get
			{
				return m_array.Length;
			}
			set
			{
				if (value < m_count)
				{
					value = m_count;
				}
				if (value != m_array.Length)
				{
					if (value > 0)
					{
						IPlugin[] array = new IPlugin[value];
						Array.Copy(m_array, 0, array, 0, m_count);
						m_array = array;
					}
					else
					{
						m_array = new IPlugin[16];
					}
				}
			}
		}

		public PluginCollection()
		{
			m_array = new IPlugin[16];
		}

		public PluginCollection(int capacity)
		{
			m_array = new IPlugin[capacity];
		}

		public PluginCollection(PluginCollection c)
		{
			m_array = new IPlugin[c.Count];
			AddRange(c);
		}

		public PluginCollection(IPlugin[] a)
		{
			m_array = new IPlugin[a.Length];
			AddRange(a);
		}

		public PluginCollection(ICollection col)
		{
			m_array = new IPlugin[col.Count];
			AddRange(col);
		}

		protected internal PluginCollection(Tag tag)
		{
			m_array = null;
		}

		public static PluginCollection ReadOnly(PluginCollection list)
		{
			if (list == null)
			{
				throw new ArgumentNullException("list");
			}
			return new ReadOnlyPluginCollection(list);
		}

		public virtual void CopyTo(IPlugin[] array)
		{
			CopyTo(array, 0);
		}

		public virtual void CopyTo(IPlugin[] array, int start)
		{
			if (m_count > array.GetUpperBound(0) + 1 - start)
			{
				throw new ArgumentException("Destination array was not long enough.");
			}
			Array.Copy(m_array, 0, array, start, m_count);
		}

		public virtual int Add(IPlugin item)
		{
			if (m_count == m_array.Length)
			{
				EnsureCapacity(m_count + 1);
			}
			m_array[m_count] = item;
			m_version++;
			return m_count++;
		}

		public virtual void Clear()
		{
			m_version++;
			m_array = new IPlugin[16];
			m_count = 0;
		}

		public virtual object Clone()
		{
			PluginCollection pluginCollection = new PluginCollection(m_count);
			Array.Copy(m_array, 0, pluginCollection.m_array, 0, m_count);
			pluginCollection.m_count = m_count;
			pluginCollection.m_version = m_version;
			return pluginCollection;
		}

		public virtual bool Contains(IPlugin item)
		{
			for (int i = 0; i != m_count; i++)
			{
				if (m_array[i].Equals(item))
				{
					return true;
				}
			}
			return false;
		}

		public virtual int IndexOf(IPlugin item)
		{
			for (int i = 0; i != m_count; i++)
			{
				if (m_array[i].Equals(item))
				{
					return i;
				}
			}
			return -1;
		}

		public virtual void Insert(int index, IPlugin item)
		{
			ValidateIndex(index, true);
			if (m_count == m_array.Length)
			{
				EnsureCapacity(m_count + 1);
			}
			if (index < m_count)
			{
				Array.Copy(m_array, index, m_array, index + 1, m_count - index);
			}
			m_array[index] = item;
			m_count++;
			m_version++;
		}

		public virtual void Remove(IPlugin item)
		{
			int num = IndexOf(item);
			if (num < 0)
			{
				throw new ArgumentException("Cannot remove the specified item because it was not found in the specified Collection.");
			}
			m_version++;
			RemoveAt(num);
		}

		public virtual void RemoveAt(int index)
		{
			ValidateIndex(index);
			m_count--;
			if (index < m_count)
			{
				Array.Copy(m_array, index + 1, m_array, index, m_count - index);
			}
			IPlugin[] sourceArray = new IPlugin[1];
			Array.Copy(sourceArray, 0, m_array, m_count, 1);
			m_version++;
		}

		public virtual IPluginCollectionEnumerator GetEnumerator()
		{
			return new Enumerator(this);
		}

		public virtual int AddRange(PluginCollection x)
		{
			if (m_count + x.Count >= m_array.Length)
			{
				EnsureCapacity(m_count + x.Count);
			}
			Array.Copy(x.m_array, 0, m_array, m_count, x.Count);
			m_count += x.Count;
			m_version++;
			return m_count;
		}

		public virtual int AddRange(IPlugin[] x)
		{
			if (m_count + x.Length >= m_array.Length)
			{
				EnsureCapacity(m_count + x.Length);
			}
			Array.Copy(x, 0, m_array, m_count, x.Length);
			m_count += x.Length;
			m_version++;
			return m_count;
		}

		public virtual int AddRange(ICollection col)
		{
			if (m_count + col.Count >= m_array.Length)
			{
				EnsureCapacity(m_count + col.Count);
			}
			foreach (object item in col)
			{
				Add((IPlugin)item);
			}
			return m_count;
		}

		public virtual void TrimToSize()
		{
			Capacity = m_count;
		}

		private void ValidateIndex(int i)
		{
			ValidateIndex(i, false);
		}

		private void ValidateIndex(int i, bool allowEqualEnd)
		{
			int num = ((!allowEqualEnd) ? (m_count - 1) : m_count);
			if (i < 0 || i > num)
			{
				throw SystemInfo.CreateArgumentOutOfRangeException("i", i, "Index was out of range. Must be non-negative and less than the size of the collection. [" + i + "] Specified argument was out of the range of valid values.");
			}
		}

		private void EnsureCapacity(int min)
		{
			int num = ((m_array.Length != 0) ? (m_array.Length * 2) : 16);
			if (num < min)
			{
				num = min;
			}
			Capacity = num;
		}

		void ICollection.CopyTo(Array array, int start)
		{
			Array.Copy(m_array, 0, array, start, m_count);
		}

		int IList.Add(object x)
		{
			return Add((IPlugin)x);
		}

		bool IList.Contains(object x)
		{
			return Contains((IPlugin)x);
		}

		int IList.IndexOf(object x)
		{
			return IndexOf((IPlugin)x);
		}

		void IList.Insert(int pos, object x)
		{
			Insert(pos, (IPlugin)x);
		}

		void IList.Remove(object x)
		{
			Remove((IPlugin)x);
		}

		void IList.RemoveAt(int pos)
		{
			RemoveAt(pos);
		}

		IEnumerator IEnumerable.GetEnumerator()
		{
			return (IEnumerator)GetEnumerator();
		}
	}
}
