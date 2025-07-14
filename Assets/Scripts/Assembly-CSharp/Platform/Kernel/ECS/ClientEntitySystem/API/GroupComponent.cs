using System.Collections.Generic;
using Platform.Kernel.ECS.ClientEntitySystem.Impl;
using Platform.Library.ClientDataStructures.API;

namespace Platform.Kernel.ECS.ClientEntitySystem.API
{
	[SkipAutoRemove]
	public class GroupComponent : Component, AttachToEntityListener, DetachFromEntityListener, EntityListener
	{
		private readonly NodeCollector nodeCollector;

		private HashSet<Entity> members;

		public long Key { get; private set; }

		public GroupComponent(Entity keyEntity)
			: this(keyEntity.Id)
		{
		}

		public GroupComponent(long key)
		{
			Key = key;
			nodeCollector = new GroupNodeCollectorImpl();
			members = new HashSet<Entity>();
		}

		public GroupComponent Attach(Entity entity)
		{
			entity.AddComponent(this);
			return this;
		}

		public void Detach(Entity entity)
		{
			entity.RemoveComponent(GetType());
		}

		public ICollection<Entity> GetGroupMembers()
		{
			return members;
		}

		public ICollection<Entity> GetGroupMembers(NodeDescription nodeDescription)
		{
			ICollection<Entity> entities = nodeCollector.GetEntities(nodeDescription);
			return entities ?? Collections.EmptyList<Entity>();
		}

		public override string ToString()
		{
			return GetType().Name + "[key=" + Key + ']';
		}

		public void AttachedToEntity(Entity entity)
		{
			EntityInternal entityInternal = (EntityInternal)entity;
			members.Add(entityInternal);
			entityInternal.AddEntityListener(this);
			Collections.Enumerator<NodeDescription> enumerator = Collections.GetEnumerator(entityInternal.NodeDescriptionStorage.GetNodeDescriptions());
			while (enumerator.MoveNext())
			{
				nodeCollector.Attach(entityInternal, enumerator.Current);
			}
		}

		public void DetachedFromEntity(Entity entity)
		{
			EntityInternal entityInternal = (EntityInternal)entity;
			OnRemoveMemberWithoutRemovingListener(entityInternal);
			entityInternal.RemoveEntityListener(this);
		}

		private void OnRemoveMemberWithoutRemovingListener(EntityInternal member)
		{
			Collections.Enumerator<NodeDescription> enumerator = Collections.GetEnumerator(member.NodeDescriptionStorage.GetNodeDescriptions());
			while (enumerator.MoveNext())
			{
				nodeCollector.Detach(member, enumerator.Current);
			}
			members.Remove(member);
		}

		public void OnNodeAdded(Entity entity, NodeDescription nodeDescription)
		{
			nodeCollector.Attach(entity, nodeDescription);
		}

		public void OnNodeRemoved(Entity entity, NodeDescription nodeDescription)
		{
			nodeCollector.Detach(entity, nodeDescription);
		}

		public void OnEntityDeleted(Entity entity)
		{
			OnRemoveMemberWithoutRemovingListener((EntityInternal)entity);
		}
	}
}
