using Platform.Kernel.ECS.ClientEntitySystem.API;

namespace Tanks.Battle.ClientCore.API
{
	public class TargetingEvaluateEvent : Event
	{
		public TargetingData TargetingData { get; set; }

		public TargetingEvaluateEvent()
		{
		}

		public TargetingEvaluateEvent(TargetingData targetingData)
		{
			TargetingData = targetingData;
		}

		public TargetingEvaluateEvent Init(TargetingData targetingData)
		{
			TargetingData = targetingData;
			return this;
		}
	}
}
