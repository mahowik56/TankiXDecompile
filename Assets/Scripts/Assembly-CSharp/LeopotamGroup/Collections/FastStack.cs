using System;
using System.Collections.Generic;

namespace LeopotamGroup.Collections
{
	public class FastStack<T>
	{
		private const int InitCapacity = 8;

		private T[] _items;

		private int _capacity;

		private int _count;

		private readonly bool _isNullable;

		private readonly EqualityComparer<T> _comparer;

		private bool _useObjectCastComparer;

		public int Count
		{
			get
			{
				return _count;
			}
		}

		public FastStack()
			: this((EqualityComparer<T>)null)
		{
		}

		public FastStack(EqualityComparer<T> comparer)
			: this(8, comparer)
		{
		}

		public FastStack(int capacity, EqualityComparer<T> comparer = null)
		{
			Type typeFromHandle = typeof(T);
			_isNullable = !typeFromHandle.IsValueType || Nullable.GetUnderlyingType(typeFromHandle) != null;
			_capacity = ((capacity <= 8) ? 8 : capacity);
			_count = 0;
			_comparer = comparer;
			_items = new T[_capacity];
		}

		public void Clear()
		{
			if (_isNullable)
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
			return num != -1;
		}

		public void CopyTo(T[] array, int arrayIndex)
		{
			Array.Copy(_items, 0, array, arrayIndex, _count);
		}

		public T Peek()
		{
			if (_count == 0)
			{
				throw new IndexOutOfRangeException();
			}
			return _items[_count - 1];
		}

		public T Pop()
		{
			if (_count == 0)
			{
				throw new IndexOutOfRangeException();
			}
			_count--;
			T result = _items[_count];
			if (_isNullable)
			{
				_items[_count] = default(T);
			}
			return result;
		}

		public void Push(T item)
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

		public T[] ToArray()
		{
			T[] array = new T[_count];
			if (_count > 0)
			{
				Array.Copy(_items, array, _count);
			}
			return array;
		}

		public void TrimExcess()
		{
			throw new NotSupportedException();
		}

		public void UseCastToObjectComparer(bool state)
		{
			_useObjectCastComparer = state;
		}
	}
}
