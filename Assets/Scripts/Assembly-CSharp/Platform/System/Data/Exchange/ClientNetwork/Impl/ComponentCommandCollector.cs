using System;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Kernel.ECS.ClientEntitySystem.Impl;
using Platform.Kernel.OSGi.ClientCore.API;
using Platform.System.Data.Exchange.ClientNetwork.API;

namespace Platform.System.Data.Exchange.ClientNetwork.Impl
{
	public class ComponentCommandCollector : AbstractCommandCollector, ComponentListener
	{
		private readonly ComponentAndEventRegistrator componentAndEventRegistrator;

		private readonly SharedEntityRegistry entityRegistry;

		[Inject]
		public static NetworkService NetworkService { get; set; }

		public ComponentCommandCollector(CommandCollector commandCollector, ComponentAndEventRegistrator componentAndEventRegistrator, SharedEntityRegistry entityRegistry)
			: base(commandCollector)
		{
			this.componentAndEventRegistrator = componentAndEventRegistrator;
			this.entityRegistry = entityRegistry;
		}

		public void OnComponentAdded(Entity entity, Component component)
		{
			if (Allow(entity, component.GetType()))
			{
				AddCommand(new ComponentAddCommand().Init(entity, component));
			}
		}

		public void OnComponentRemoved(Entity entity, Component component)
		{
			if (Allow(entity, component.GetType()))
			{
				AddCommand(new ComponentRemoveCommand().Init(entity, component.GetType()));
			}
		}

		public void OnComponentChanged(Entity entity, Component component)
		{
			if (!NetworkService.IsDecodeState && Allow(entity, component.GetType()))
			{
				AddCommand(new ComponentChangeCommand().Init(entity, component));
			}
		}

		private bool Allow(Entity entity, Type component)
		{
			return entityRegistry.IsShared(entity.Id) && componentAndEventRegistrator.IsShared(component) && !entity.HasComponent<DeletedEntityComponent>();
		}
	}
}
