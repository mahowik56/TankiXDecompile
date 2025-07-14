using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientCore.API;

namespace Tanks.Battle.ClientCore.Impl
{
	public class UpdateBulletEvent : Event
	{
		public TargetingData TargetingData { get; set; }

		public UpdateBulletEvent()
		{
		}

		public UpdateBulletEvent(TargetingData targetingData)
		{
			TargetingData = targetingData;
		}

		public UpdateBulletEvent Init(TargetingData targetingData)
		{
			TargetingData = targetingData;
			return this;
		}
	}
}
