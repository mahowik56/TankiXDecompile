using Platform.Kernel.ECS.ClientEntitySystem.API;

namespace Tanks.Battle.ClientCore.Impl
{
	public class UnitTargetingComponent : Component
	{
		public float Period { get; set; }

		public ScheduledEvent UpdateEvent { get; set; }

		public float LastUpdateTime { get; set; }

		public UnitTargetingComponent()
		{
			Period = 2f;
		}
	}
}
