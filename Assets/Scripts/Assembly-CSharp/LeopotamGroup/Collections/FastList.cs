using System;
using System.Collections;
using System.Collections.Generic;

namespace LeopotamGroup.Collections
{
	[Serializable]
	public class FastList<T> : IList<T>, ICollection<T>, IEnumerable<T>, IEnumerable
	{
		private const int InitCapacity = 8;

		private readonly bool _isNullable;

		private T[] _items;

		private int _count;

		private int _capacity;

		private readonly EqualityComparer<T> _comparer;

		private bool _useObjectCastComparer;

		public int Count
		{
			get
			{
				return _count;
			}
		}

		public int Capacity
		{
			get
			{
				return _capacity;
			}
		}

		public T this[int index]
		{
			get
			{
				if (index >= _count)
				{
					throw new ArgumentOutOfRangeException();
				}
				return _items[index];
			}
			set
			{
				if (index >= _count)
				{
					throw new ArgumentOutOfRangeException();
				}
				_items[index] = value;
			}
		}

		public bool IsReadOnly
		{
			get
			{
				return false;
			}
		}

		public FastList()
			: this((EqualityComparer<T>)null)
		{
		}

		public FastList(EqualityComparer<T> comparer)
			: this(8, comparer)
		{
		}

		public FastList(int capacity, EqualityComparer<T> comparer = null)
		{
			Type typeFromHandle = typeof(T);
			_isNullable = !typeFromHandle.IsValueType || Nullable.GetUnderlyingType(typeFromHandle) != null;
			_capacity = ((capacity <= 8) ? 8 : capacity);
			_count = 0;
			_comparer = comparer;
			_items = new T[_capacity];
		}

		public void Add(T item)
		{
			if (_count == _capacity)
			{
				if (_capacity > 0)
				{
					_capacity <<= 1;
				}
				else
				{
					_capacity = 8;
				}
				T[] array = new T[_capacity];
				Array.Copy(_items, array, _count);
				_items = array;
			}
			_items[_count] = item;
			_count++;
		}

		public void AddRange(IEnumerable<T> data)
		{
			if (data == null)
			{
				throw new ArgumentNullException("data");
			}
			ICollection<T> collection = data as ICollection<T>;
			if (collection != null)
			{
				int count = collection.Count;
				if (count > 0)
				{
					Reserve(count, false, false);
					collection.CopyTo(_items, _count);
					_count += count;
				}
				return;
			}
			foreach (T datum in data)
			{
				Add(datum);
			}
		}

		public void AssignData(T[] data, int count)
		{
			if (data == null)
			{
				throw new ArgumentNullException("data");
			}
			_items = data;
			_count = ((count >= 0) ? count : 0);
			_capacity = _items.Length;
		}

		public void Clear()
		{
			Clear(false);
		}

		public void Clear(bool forceSetDefaultValues)
		{
			if (_isNullable || forceSetDefaultValues)
			{
				for (int num = _count - 1; num >= 0; num--)
				{
					_items[num] = default(T);
				}
			}
			_count = 0;
		}

		public bool Contains(T item)
		{
			return IndexOf(item) != -1;
		}

		public void CopyTo(T[] array, int arrayIndex)
		{
			Array.Copy(_items, 0, array, arrayIndex, _count);
		}

		public void FillWithEmpty(int amount, bool clearCollection = false, bool forceSetDefaultValues = true)
		{
			if (amount > 0)
			{
				if (clearCollection)
				{
					_count = 0;
				}
				Reserve(amount, clearCollection, forceSetDefaultValues);
				_count += amount;
			}
		}

		public int IndexOf(T item)
		{
			int num;
			if (_useObjectCastComparer && _isNullable)
			{
				num = _count - 1;
				while (num >= 0 && (object)_items[num] != (object)item)
				{
					num--;
				}
			}
			else if (_comparer != null)
			{
				num = _count - 1;
				while (num >= 0 && !_comparer.Equals(_items[num], item))
				{
					num--;
				}
			}
			else
			{
				num = Array.IndexOf(_items, item, 0, _count);
			}
			return num;
		}

		public void Insert(int index, T item)
		{
			if (index < 0 || index > _count)
			{
				throw new ArgumentOutOfRangeException();
			}
			Reserve(1, false, false);
			Array.Copy(_items, index, _items, index + 1, _count - index);
			_items[index] = item;
			_count++;
		}

		public T[] GetData()
		{
			return _items;
		}

		public T[] GetData(out int count)
		{
			count = _count;
			return _items;
		}

		public IEnumerator<T> GetEnumerator()
		{
			throw new NotSupportedException();
		}

		IEnumerator IEnumerable.GetEnumerator()
		{
			throw new NotSupportedException();
		}

		public bool Remove(T item)
		{
			int num = IndexOf(item);
			if (num == -1)
			{
				return false;
			}
			RemoveAt(num);
			return true;
		}

		public void RemoveAt(int id)
		{
			if (id >= 0 && id < _count)
			{
				_count--;
				Array.Copy(_items, id + 1, _items, id, _count - id);
			}
		}

		public bool RemoveLast(bool forceSetDefaultValues = true)
		{
			if (_count <= 0)
			{
				return false;
			}
			_count--;
			if (forceSetDefaultValues)
			{
				_items[_count] = default(T);
			}
			return true;
		}

		public void Reserve(int amount, bool totalAmount = false, bool forceSetDefaultValues = true)
		{
			if (amount <= 0)
			{
				return;
			}
			int num = ((!totalAmount) ? _count : 0);
			int num2 = num + amount;
			if (num2 > _capacity)
			{
				if (_capacity <= 0)
				{
					_capacity = 8;
				}
				while (_capacity < num2)
				{
					_capacity <<= 1;
				}
				T[] array = new T[_capacity];
				Array.Copy(_items, array, _count);
				_items = array;
			}
			if (forceSetDefaultValues)
			{
				for (int i = _count; i < num2; i++)
				{
					_items[i] = default(T);
				}
			}
		}

		public void Reverse()
		{
			if (_count > 0)
			{
				int i = 0;
				for (int num = _count >> 1; i < num; i++)
				{
					T val = _items[i];
					_items[i] = _items[_count - i - 1];
					_items[_count - i - 1] = val;
				}
			}
		}

		public T[] ToArray()
		{
			T[] array = new T[_count];
			if (_count > 0)
			{
				Array.Copy(_items, array, _count);
			}
			return array;
		}

		public void UseCastToObjectComparer(bool state)
		{
			_useObjectCastComparer = state;
		}
	}
}
