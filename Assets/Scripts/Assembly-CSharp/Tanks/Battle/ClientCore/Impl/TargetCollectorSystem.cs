using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientCore.API;

namespace Tanks.Battle.ClientCore.Impl
{
	public class TargetCollectorSystem : ECSSystem
	{
		public class TargetCollectorNode : Node
		{
			public TargetCollectorComponent targetCollector;
		}

		[OnEventFire]
		public void CollectTargetsOnDirections(CollectTargetsEvent evt, TargetCollectorNode targetCollectorNode)
		{
			TargetingData targetingData = evt.TargetingData;
			targetCollectorNode.targetCollector.Collect(targetingData);
		}
	}
}
