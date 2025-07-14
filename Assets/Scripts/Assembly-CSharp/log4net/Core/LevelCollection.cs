using System;
using System.Collections;
using log4net.Util;

namespace log4net.Core
{
	public class LevelCollection : ICollection, IList, IEnumerable, ICloneable
	{
		public interface ILevelCollectionEnumerator
		{
			Level Current { get; }

			bool MoveNext();

			void Reset();
		}

		protected internal enum Tag
		{
			Default = 0
		}

		private sealed class Enumerator : IEnumerator, ILevelCollectionEnumerator
		{
			private readonly LevelCollection m_collection;

			private int m_index;

			private int m_version;

			object IEnumerator.Current
			{
				get
				{
					return Current;
				}
			}

			public Level Current
			{
				get
				{
					return m_collection[m_index];
				}
			}

			internal Enumerator(LevelCollection tc)
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

		private sealed class ReadOnlyLevelCollection : LevelCollection
		{
			private readonly LevelCollection m_collection;

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

			public override Level this[int i]
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

			internal ReadOnlyLevelCollection(LevelCollection list)
				: base(Tag.Default)
			{
				m_collection = list;
			}

			public override void CopyTo(Level[] array)
			{
				m_collection.CopyTo(array);
			}

			public override void CopyTo(Level[] array, int start)
			{
				m_collection.CopyTo(array, start);
			}

			public override int Add(Level x)
			{
				throw new NotSupportedException("This is a Read Only Collection and can not be modified");
			}

			public override void Clear()
			{
				throw new NotSupportedException("This is a Read Only Collection and can not be modified");
			}

			public override bool Contains(Level x)
			{
				return m_collection.Contains(x);
			}

			public override int IndexOf(Level x)
			{
				return m_collection.IndexOf(x);
			}

			public override void Insert(int pos, Level x)
			{
				throw new NotSupportedException("This is a Read Only Collection and can not be modified");
			}

			public override void Remove(Level x)
			{
				throw new NotSupportedException("This is a Read Only Collection and can not be modified");
			}

			public override void RemoveAt(int pos)
			{
				throw new NotSupportedException("This is a Read Only Collection and can not be modified");
			}

			public override ILevelCollectionEnumerator GetEnumerator()
			{
				return m_collection.GetEnumerator();
			}

			public override int AddRange(LevelCollection x)
			{
				throw new NotSupportedException("This is a Read Only Collection and can not be modified");
			}

			public override int AddRange(Level[] x)
			{
				throw new NotSupportedException("This is a Read Only Collection and can not be modified");
			}
		}

		private const int DEFAULT_CAPACITY = 16;

		private Level[] m_array;

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
				this[i] = (Level)value;
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

		public virtual Level this[int index]
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
						Level[] array = new Level[value];
						Array.Copy(m_array, 0, array, 0, m_count);
						m_array = array;
					}
					else
					{
						m_array = new Level[16];
					}
				}
			}
		}

		public LevelCollection()
		{
			m_array = new Level[16];
		}

		public LevelCollection(int capacity)
		{
			m_array = new Level[capacity];
		}

		public LevelCollection(LevelCollection c)
		{
			m_array = new Level[c.Count];
			AddRange(c);
		}

		public LevelCollection(Level[] a)
		{
			m_array = new Level[a.Length];
			AddRange(a);
		}

		public LevelCollection(ICollection col)
		{
			m_array = new Level[col.Count];
			AddRange(col);
		}

		protected internal LevelCollection(Tag tag)
		{
			m_array = null;
		}

		public static LevelCollection ReadOnly(LevelCollection list)
		{
			if (list == null)
			{
				throw new ArgumentNullException("list");
			}
			return new ReadOnlyLevelCollection(list);
		}

		public virtual void CopyTo(Level[] array)
		{
			CopyTo(array, 0);
		}

		public virtual void CopyTo(Level[] array, int start)
		{
			if (m_count > array.GetUpperBound(0) + 1 - start)
			{
				throw new ArgumentException("Destination array was not long enough.");
			}
			Array.Copy(m_array, 0, array, start, m_count);
		}

		public virtual int Add(Level item)
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
			m_array = new Level[16];
			m_count = 0;
		}

		public virtual object Clone()
		{
			LevelCollection levelCollection = new LevelCollection(m_count);
			Array.Copy(m_array, 0, levelCollection.m_array, 0, m_count);
			levelCollection.m_count = m_count;
			levelCollection.m_version = m_version;
			return levelCollection;
		}

		public virtual bool Contains(Level item)
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

		public virtual int IndexOf(Level item)
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

		public virtual void Insert(int index, Level item)
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

		public virtual void Remove(Level item)
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
			Level[] sourceArray = new Level[1];
			Array.Copy(sourceArray, 0, m_array, m_count, 1);
			m_version++;
		}

		public virtual ILevelCollectionEnumerator GetEnumerator()
		{
			return new Enumerator(this);
		}

		public virtual int AddRange(LevelCollection x)
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

		public virtual int AddRange(Level[] x)
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
				Add((Level)item);
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
			return Add((Level)x);
		}

		bool IList.Contains(object x)
		{
			return Contains((Level)x);
		}

		int IList.IndexOf(object x)
		{
			return IndexOf((Level)x);
		}

		void IList.Insert(int pos, object x)
		{
			Insert(pos, (Level)x);
		}

		void IList.Remove(object x)
		{
			Remove((Level)x);
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
