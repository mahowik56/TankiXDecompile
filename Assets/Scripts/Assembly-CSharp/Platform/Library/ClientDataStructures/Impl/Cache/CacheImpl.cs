using System;
using System.Collections.Generic;
using Platform.Library.ClientDataStructures.API;

namespace Platform.Library.ClientDataStructures.Impl.Cache
{
	public class CacheImpl<T> : Cache<T>, AbstractCache
	{
		private static readonly int DEFAULT_MAX_SIZE = 100;

		private readonly Stack<T> cache = new Stack<T>();

		private readonly IList<T> inuse = new List<T>();

		private readonly Action<T> cleaner;

		private readonly int elementsCount;

		private int maxSize = DEFAULT_MAX_SIZE;

		public int InstanceCount { get; private set; }

		public int UseCount { get; private set; }

		public int FreeCount { get; private set; }

		public int OverflowCount { get; private set; }

		public int Capacity
		{
			get
			{
				return cache.Count;
			}
		}

		public CacheImpl()
		{
		}

		public CacheImpl(Action<T> cleaner)
		{
			this.cleaner = cleaner;
		}

		public CacheImpl(Action<T> cleaner, int elementsCount)
		{
			this.cleaner = cleaner;
			this.elementsCount = elementsCount;
		}

		public T GetInstance()
		{
			UseCount++;
			T val = ((cache.Count == 0) ? NewInstance() : cache.Pop());
			if (inuse.Count <= maxSize)
			{
				inuse.Add(val);
			}
			else
			{
				OverflowCount++;
			}
			return val;
		}

		protected T NewInstance()
		{
			Type typeFromHandle = typeof(T);
			object obj;
			if (typeFromHandle.IsArray)
			{
				Type elementType = typeFromHandle.GetElementType();
				obj = Array.CreateInstance(elementType, elementsCount);
			}
			else
			{
				obj = Activator.CreateInstance<T>();
			}
			InstanceCount++;
			return (T)obj;
		}

		public void Free(T o)
		{
			if (cleaner != null)
			{
				cleaner(o);
			}
			if (!ReturnToCache(o))
			{
				OverflowCount++;
			}
			FreeCount++;
		}

		public void SetMaxSize(int maxSize)
		{
			this.maxSize = maxSize;
		}

		private bool ReturnToCache(T o)
		{
			if (cache.Count > maxSize)
			{
				return false;
			}
			cache.Push(o);
			return true;
		}

		public void FreeAll()
		{
			int count = inuse.Count;
			for (int i = 0; i < count; i++)
			{
				Free(inuse[i]);
			}
			inuse.Clear();
		}

		public void Dispose()
		{
			cache.Clear();
		}
	}
}
