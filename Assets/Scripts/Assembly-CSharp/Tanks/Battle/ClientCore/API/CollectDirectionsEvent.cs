using Platform.Kernel.ECS.ClientEntitySystem.API;

namespace Tanks.Battle.ClientCore.API
{
	public class CollectDirectionsEvent : Event
	{
		public TargetingData TargetingData { get; set; }

		public CollectDirectionsEvent()
		{
		}

		public CollectDirectionsEvent(TargetingData targetingData)
		{
			TargetingData = targetingData;
		}

		public CollectDirectionsEvent Init(TargetingData targetingData)
		{
			TargetingData = targetingData;
			return this;
		}
	}
}
