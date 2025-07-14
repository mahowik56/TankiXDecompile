using System;
using System.Collections;
using System.Collections.Generic;

namespace SharpCompress
{
	internal class LazyReadOnlyCollection<T> : ICollection<T>, IEnumerable<T>, IEnumerable
	{
		private class LazyLoader : IEnumerator<T>, IDisposable, IEnumerator
		{
			private readonly LazyReadOnlyCollection<T> lazyReadOnlyCollection;

			private bool disposed;

			private int index = -1;

			object IEnumerator.Current
			{
				get
				{
					return Current;
				}
			}

			public T Current
			{
				get
				{
					return lazyReadOnlyCollection.backing[index];
				}
			}

			internal LazyLoader(LazyReadOnlyCollection<T> lazyReadOnlyCollection)
			{
				this.lazyReadOnlyCollection = lazyReadOnlyCollection;
			}

			public void Dispose()
			{
				if (!disposed)
				{
					disposed = true;
				}
			}

			public bool MoveNext()
			{
				if (index + 1 < lazyReadOnlyCollection.backing.Count)
				{
					index++;
					return true;
				}
				if (!lazyReadOnlyCollection.fullyLoaded && lazyReadOnlyCollection.source.MoveNext())
				{
					lazyReadOnlyCollection.backing.Add(lazyReadOnlyCollection.source.Current);
					index++;
					return true;
				}
				lazyReadOnlyCollection.fullyLoaded = true;
				return false;
			}

			public void Reset()
			{
				throw new NotImplementedException();
			}
		}

		private readonly List<T> backing = new List<T>();

		private readonly IEnumerator<T> source;

		private bool fullyLoaded;

		public int Count
		{
			get
			{
				EnsureFullyLoaded();
				return backing.Count;
			}
		}

		public bool IsReadOnly
		{
			get
			{
				return true;
			}
		}

		public LazyReadOnlyCollection(IEnumerable<T> source)
		{
			this.source = source.GetEnumerator();
		}

		internal void EnsureFullyLoaded()
		{
			if (!fullyLoaded)
			{
				this.ForEach(delegate
				{
				});
				fullyLoaded = true;
			}
		}

		internal IEnumerable<T> GetLoaded()
		{
			return backing;
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
			EnsureFullyLoaded();
			return backing.Contains(item);
		}

		public void CopyTo(T[] array, int arrayIndex)
		{
			EnsureFullyLoaded();
			backing.CopyTo(array, arrayIndex);
		}

		public bool Remove(T item)
		{
			throw new NotImplementedException();
		}

		public IEnumerator<T> GetEnumerator()
		{
			return new LazyLoader(this);
		}

		IEnumerator IEnumerable.GetEnumerator()
		{
			return GetEnumerator();
		}
	}
}
