using System;
using System.Collections;
using System.Collections.Generic;

namespace SharpCompress
{
	internal class ReadOnlyCollection<T> : ICollection<T>, IEnumerable<T>, IEnumerable
	{
		private ICollection<T> collection;

		public int Count
		{
			get
			{
				return collection.Count;
			}
		}

		public bool IsReadOnly
		{
			get
			{
				return true;
			}
		}

		public ReadOnlyCollection(ICollection<T> collection)
		{
			this.collection = collection;
		}

		public void Add(T item)
		{
			throw new NotImplementedException();
		}

		public void Clear()
		{
			throw new NotImplementedException();
		}

		public bool Contains(T item)
		{
			return collection.Contains(item);
		}

		public void CopyTo(T[] array, int arrayIndex)
		{
			collection.CopyTo(array, arrayIndex);
		}

		public bool Remove(T item)
		{
			throw new NotImplementedException();
		}

		public IEnumerator<T> GetEnumerator()
		{
			return collection.GetEnumerator();
		}

		IEnumerator IEnumerable.GetEnumerator()
		{
			throw new NotImplementedException();
		}
	}
}
