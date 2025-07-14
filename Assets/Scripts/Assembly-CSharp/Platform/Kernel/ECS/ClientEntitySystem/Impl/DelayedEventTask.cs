using System.Collections.Generic;
using Platform.Kernel.ECS.ClientEntitySystem.API;

namespace Platform.Kernel.ECS.ClientEntitySystem.Impl
{
	public class DelayedEventTask : ScheduleManager
	{
		private readonly Event e;

		private readonly HashSet<Entity> entities;

		private readonly EngineServiceInternal engine;

		private bool canceled;

		private bool invoked;

		private double timeToExecute;

		public DelayedEventTask(Event e, ICollection<Entity> entities, EngineServiceInternal engine, double timeToExecute)
		{
			this.e = e;
			this.entities = new HashSet<Entity>(entities);
			this.engine = engine;
			this.timeToExecute = timeToExecute;
		}

		public bool Update(double time)
		{
			if (timeToExecute <= time)
			{
				Flow flow = engine.GetFlow();
				RemoveDeletedEntities();
				flow.SendEvent(e, entities);
				invoked = true;
			}
			return invoked;
		}

		public void RemoveDeletedEntities()
		{
			entities.RemoveWhere((Entity entity) => !((EntityImpl)entity).Alive);
		}

		public bool Cancel()
		{
			canceled = true;
			return invoked;
		}

		public bool IsCanceled()
		{
			return canceled;
		}
	}
}
