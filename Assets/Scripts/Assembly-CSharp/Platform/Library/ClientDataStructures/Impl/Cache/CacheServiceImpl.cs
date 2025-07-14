using System;
using System.Collections.Generic;
using Platform.Library.ClientDataStructures.API;

namespace Platform.Library.ClientDataStructures.Impl.Cache
{
	public class CacheServiceImpl : CacheService
	{
		private readonly Dictionary<Type, object> caches = new Dictionary<Type, object>();

		public Cache<T> GetCache<T>()
		{
			object value;
			if (caches.TryGetValue(typeof(T), out value))
			{
				return (Cache<T>)value;
			}
			throw new CacheForTypeNotFoundException(typeof(T));
		}

		public Cache<T> GetCache<T>(T o)
		{
			return GetCache<T>();
		}

		public Cache<T> RegisterTypeCache<T>()
		{
			return RegisterTypeCache<T>(null);
		}

		public Cache<T> RegisterTypeCache<T>(Action<T> cleaner)
		{
			Cache<T> cache = new CacheImpl<T>(cleaner, 0);
			caches.Add(typeof(T), cache);
			return cache;
		}

		public void Dispose()
		{
			Dictionary<Type, object>.Enumerator enumerator = caches.GetEnumerator();
			while (enumerator.MoveNext())
			{
				((AbstractCache)enumerator.Current.Value).Dispose();
			}
		}
	}
}
