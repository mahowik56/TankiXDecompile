using System;
using System.Collections;
using log4net.Util;

namespace log4net.Appender
{
	public class AppenderCollection : ICollection, IList, IEnumerable, ICloneable
	{
		public interface IAppenderCollectionEnumerator
		{
			IAppender Current { get; }

			bool MoveNext();

			void Reset();
		}

		protected internal enum Tag
		{
			Default = 0
		}

		private sealed class Enumerator : IEnumerator, IAppenderCollectionEnumerator
		{
			private readonly AppenderCollection m_collection;

			private int m_index;

			private int m_version;

			object IEnumerator.Current
			{
				get
				{
					return Current;
				}
			}

			public IAppender Current
			{
				get
				{
					return m_collection[m_index];
				}
			}

			internal Enumerator(AppenderCollection tc)
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

		private sealed class ReadOnlyAppenderCollection : AppenderCollection, ICollection, IEnumerable
		{
			private readonly AppenderCollection m_collection;

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

			public override IAppender this[int i]
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

			internal ReadOnlyAppenderCollection(AppenderCollection list)
				: base(Tag.Default)
			{
				m_collection = list;
			}

			public override void CopyTo(IAppender[] array)
			{
				m_collection.CopyTo(array);
			}

			public override void CopyTo(IAppender[] array, int start)
			{
				m_collection.CopyTo(array, start);
			}

			void ICollection.CopyTo(Array array, int start)
			{
				((ICollection)m_collection).CopyTo(array, start);
			}

			public override int Add(IAppender x)
			{
				throw new NotSupportedException("This is a Read Only Collection and can not be modified");
			}

			public override void Clear()
			{
				throw new NotSupportedException("This is a Read Only Collection and can not be modified");
			}

			public override bool Contains(IAppender x)
			{
				return m_collection.Contains(x);
			}

			public override int IndexOf(IAppender x)
			{
				return m_collection.IndexOf(x);
			}

			public override void Insert(int pos, IAppender x)
			{
				throw new NotSupportedException("This is a Read Only Collection and can not be modified");
			}

			public override void Remove(IAppender x)
			{
				throw new NotSupportedException("This is a Read Only Collection and can not be modified");
			}

			public override void RemoveAt(int pos)
			{
				throw new NotSupportedException("This is a Read Only Collection and can not be modified");
			}

			public override IAppenderCollectionEnumerator GetEnumerator()
			{
				return m_collection.GetEnumerator();
			}

			public override int AddRange(AppenderCollection x)
			{
				throw new NotSupportedException("This is a Read Only Collection and can not be modified");
			}

			public override int AddRange(IAppender[] x)
			{
				throw new NotSupportedException("This is a Read Only Collection and can not be modified");
			}

			public override IAppender[] ToArray()
			{
				return m_collection.ToArray();
			}

			public override void TrimToSize()
			{
				throw new NotSupportedException("This is a Read Only Collection and can not be modified");
			}
		}

		private const int DEFAULT_CAPACITY = 16;

		private IAppender[] m_array;

		private int m_count;

		private int m_version;

		public static readonly AppenderCollection EmptyCollection = ReadOnly(new AppenderCollection(0));

		object IList.this[int i]
		{
			get
			{
				return this[i];
			}
			set
			{
				this[i] = (IAppender)value;
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

		public virtual IAppender this[int index]
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
						IAppender[] array = new IAppender[value];
						Array.Copy(m_array, 0, array, 0, m_count);
						m_array = array;
					}
					else
					{
						m_array = new IAppender[16];
					}
				}
			}
		}

		public AppenderCollection()
		{
			m_array = new IAppender[16];
		}

		public AppenderCollection(int capacity)
		{
			m_array = new IAppender[capacity];
		}

		public AppenderCollection(AppenderCollection c)
		{
			m_array = new IAppender[c.Count];
			AddRange(c);
		}

		public AppenderCollection(IAppender[] a)
		{
			m_array = new IAppender[a.Length];
			AddRange(a);
		}

		public AppenderCollection(ICollection col)
		{
			m_array = new IAppender[col.Count];
			AddRange(col);
		}

		protected internal AppenderCollection(Tag tag)
		{
			m_array = null;
		}

		public static AppenderCollection ReadOnly(AppenderCollection list)
		{
			if (list == null)
			{
				throw new ArgumentNullException("list");
			}
			return new ReadOnlyAppenderCollection(list);
		}

		public virtual void CopyTo(IAppender[] array)
		{
			CopyTo(array, 0);
		}

		public virtual void CopyTo(IAppender[] array, int start)
		{
			if (m_count > array.GetUpperBound(0) + 1 - start)
			{
				throw new ArgumentException("Destination array was not long enough.");
			}
			Array.Copy(m_array, 0, array, start, m_count);
		}

		public virtual int Add(IAppender item)
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
			m_array = new IAppender[16];
			m_count = 0;
		}

		public virtual object Clone()
		{
			AppenderCollection appenderCollection = new AppenderCollection(m_count);
			Array.Copy(m_array, 0, appenderCollection.m_array, 0, m_count);
			appenderCollection.m_count = m_count;
			appenderCollection.m_version = m_version;
			return appenderCollection;
		}

		public virtual bool Contains(IAppender item)
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

		public virtual int IndexOf(IAppender item)
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

		public virtual void Insert(int index, IAppender item)
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

		public virtual void Remove(IAppender item)
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
			IAppender[] sourceArray = new IAppender[1];
			Array.Copy(sourceArray, 0, m_array, m_count, 1);
			m_version++;
		}

		public virtual IAppenderCollectionEnumerator GetEnumerator()
		{
			return new Enumerator(this);
		}

		public virtual int AddRange(AppenderCollection x)
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

		public virtual int AddRange(IAppender[] x)
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
				Add((IAppender)item);
			}
			return m_count;
		}

		public virtual void TrimToSize()
		{
			Capacity = m_count;
		}

		public virtual IAppender[] ToArray()
		{
			IAppender[] array = new IAppender[m_count];
			if (m_count > 0)
			{
				Array.Copy(m_array, 0, array, 0, m_count);
			}
			return array;
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
			if (m_count > 0)
			{
				Array.Copy(m_array, 0, array, start, m_count);
			}
		}

		int IList.Add(object x)
		{
			return Add((IAppender)x);
		}

		bool IList.Contains(object x)
		{
			return Contains((IAppender)x);
		}

		int IList.IndexOf(object x)
		{
			return IndexOf((IAppender)x);
		}

		void IList.Insert(int pos, object x)
		{
			Insert(pos, (IAppender)x);
		}

		void IList.Remove(object x)
		{
			Remove((IAppender)x);
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
