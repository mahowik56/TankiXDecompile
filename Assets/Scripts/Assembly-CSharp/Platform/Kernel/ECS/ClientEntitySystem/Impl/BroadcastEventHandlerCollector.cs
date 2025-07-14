using System;
using System.Collections.Generic;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientDataStructures.API;

namespace Platform.Kernel.ECS.ClientEntitySystem.Impl
{
	public class BroadcastEventHandlerCollector : EntityListener
	{
		private HandlerCollector handlerCollector;

		private Dictionary<Type, BroadcastInvokeDataStorage> handlersByType = new Dictionary<Type, BroadcastInvokeDataStorage>();

		public BroadcastEventHandlerCollector(HandlerCollector handlerCollector)
		{
			this.handlerCollector = handlerCollector;
		}

		public void Register(Type handlerType)
		{
			handlersByType[handlerType] = new BroadcastInvokeDataStorage();
		}

		public void OnNodeAdded(Entity entity, NodeDescription node)
		{
			Collections.Enumerator<KeyValuePair<Type, BroadcastInvokeDataStorage>> enumerator = Collections.GetEnumerator(handlersByType);
			while (enumerator.MoveNext())
			{
				ICollection<Handler> handlers = handlerCollector.GetHandlers(enumerator.Current.Key, node);
				enumerator.Current.Value.Add(entity, handlers);
			}
		}

		public void OnNodeRemoved(Entity entity, NodeDescription node)
		{
			Collections.Enumerator<KeyValuePair<Type, BroadcastInvokeDataStorage>> enumerator = Collections.GetEnumerator(handlersByType);
			while (enumerator.MoveNext())
			{
				ICollection<Handler> handlers = handlerCollector.GetHandlers(enumerator.Current.Key, node);
				enumerator.Current.Value.Remove(entity, handlers);
			}
		}

		public void OnEntityDeleted(Entity entity)
		{
			Collections.Enumerator<BroadcastInvokeDataStorage> enumerator = Collections.GetEnumerator(handlersByType.Values);
			while (enumerator.MoveNext())
			{
				enumerator.Current.Remove(entity);
			}
		}

		public IList<HandlerBroadcastInvokeData> GetHandlers(Type handlerType)
		{
			return handlersByType[handlerType].ContextInvokeDatas;
		}
	}
}
