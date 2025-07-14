using System;
using System.Collections.Generic;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Kernel.OSGi.ClientCore.API;
using Platform.Library.ClientDataStructures.API;

namespace Platform.Kernel.ECS.ClientEntitySystem.Impl
{
	public class EntityStub : EntityInternal, Entity
	{
		private Node node;

		[Inject]
		public static EngineService EngineService { get; set; }

		public long Id
		{
			get
			{
				return -1L;
			}
		}

		public string Name
		{
			get
			{
				return "Stub";
			}
			set
			{
				throw new NotSupportedException();
			}
		}

		public string ConfigPath
		{
			get
			{
				return string.Empty;
			}
		}

		public NodeDescriptionStorage NodeDescriptionStorage
		{
			get
			{
				throw new NotSupportedException();
			}
		}

		public BitSet ComponentsBitId
		{
			get
			{
				throw new NotSupportedException();
			}
		}

		public ICollection<Type> ComponentClasses
		{
			get
			{
				throw new NotSupportedException();
			}
		}

		public ICollection<Component> Components
		{
			get
			{
				throw new NotSupportedException();
			}
		}

		public Optional<TemplateAccessor> TemplateAccessor
		{
			get
			{
				return Optional<Platform.Kernel.ECS.ClientEntitySystem.Impl.TemplateAccessor>.empty();
			}
			set
			{
				throw new NotSupportedException();
			}
		}

		public bool Alive
		{
			get
			{
				return true;
			}
		}

		public EntityStub()
		{
			node = new Node();
			node.Entity = this;
		}

		public void AddComponent(Type componentType)
		{
			throw new NotSupportedException("ComponentType: " + componentType);
		}

		public Component CreateNewComponentInstance(Type componentType)
		{
			throw new NotSupportedException("ComponentType: " + componentType);
		}

		public void AddComponent(Component component)
		{
			throw new NotSupportedException("ComponentType: " + component.GetType());
		}

		public void NotifyComponentChange(Type componentType)
		{
			throw new NotSupportedException();
		}

		public void AddEntityListener(EntityListener entityListener)
		{
			throw new NotSupportedException();
		}

		public void RemoveEntityListener(EntityListener entityListener)
		{
			throw new NotSupportedException();
		}

		public bool Contains(NodeDescription node)
		{
			return node.IsEmpty;
		}

		public string ToStringWithComponentsClasses()
		{
			throw new NotSupportedException();
		}

		public void AddComponentSilent(Component component)
		{
			throw new NotSupportedException();
		}

		public void RemoveComponentSilent(Type componentType)
		{
			throw new NotSupportedException();
		}

		public void Init()
		{
			throw new NotSupportedException();
		}

		public void ChangeComponent(Component component)
		{
			throw new NotSupportedException("ComponentType: " + component.GetType());
		}

		public void OnDelete()
		{
			throw new NotSupportedException();
		}

		public bool IsSameGroup<T>(Entity otherEntity) where T : GroupComponent
		{
			throw new NotImplementedException();
		}

		public void ScheduleEvent<T>() where T : Event, new()
		{
			throw new NotImplementedException();
		}

		public void ScheduleEvent(Event eventInstance)
		{
			throw new NotImplementedException();
		}

		public T SendEvent<T>(T eventInstance) where T : Event
		{
			EngineService.Engine.ScheduleEvent(eventInstance, this);
			return eventInstance;
		}

		public bool CanCast(NodeDescription desc)
		{
			if (desc.IsEmpty)
			{
				return true;
			}
			return false;
		}

		public Node GetNode(NodeClassInstanceDescription instanceDescription)
		{
			if (instanceDescription.NodeDescription.IsEmpty)
			{
				return node;
			}
			throw new NotSupportedException();
		}

		public void AddComponent<T>() where T : Component, new()
		{
			throw new NotSupportedException("ComponentType: " + typeof(T));
		}

		public void AddComponentIfAbsent<T>() where T : Component, new()
		{
			throw new NotSupportedException("ComponentType: " + typeof(T));
		}

		public Component GetComponent(Type componentType)
		{
			throw new NotSupportedException("ComponentType: " + componentType);
		}

		public T GetComponent<T>() where T : Component
		{
			throw new NotSupportedException("ComponentType: " + typeof(T));
		}

		public void RemoveComponent(Type componentType)
		{
			throw new NotSupportedException("ComponentType: " + componentType);
		}

		public void RemoveComponent<T>() where T : Component
		{
			throw new NotSupportedException("ComponentType: " + typeof(T));
		}

		public void RemoveComponentIfPresent<T>() where T : Component
		{
			throw new NotSupportedException("ComponentType: " + typeof(T));
		}

		public bool HasComponent<T>() where T : Component
		{
			return false;
		}

		public bool HasComponent(Type type)
		{
			return false;
		}

		public T CreateGroup<T>() where T : GroupComponent
		{
			throw new NotSupportedException("ComponentType: " + typeof(T));
		}

		public T ToNode<T>() where T : Node, new()
		{
			if (typeof(T) == typeof(Node))
			{
				return (T)node;
			}
			throw new NotSupportedException();
		}

		public T AddComponentAndGetInstance<T>()
		{
			throw new NotSupportedException("ComponentType: " + typeof(T));
		}
	}
}
