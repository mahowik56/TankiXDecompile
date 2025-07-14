using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Kernel.OSGi.ClientCore.API;
using Tanks.Battle.ClientCore.API;
using UnityEngine;

namespace Tanks.Battle.ClientCore.Impl
{
	public class BulletTargetingSystem : AbstractDirectionsCollectorSystem
	{
		public class BulletTargetingNode : Node
		{
			public BulletTargetingComponent bulletTargeting;
		}

		[Inject]
		public new static BattleFlowInstancesCache BattleCache { get; set; }

		[OnEventFire]
		public void PrepareTargeting(TargetingEvent evt, BulletTargetingNode barelTargetingNode)
		{
			TargetingData targetingData = evt.TargetingData;
			BulletTargetingComponent bulletTargeting = barelTargetingNode.bulletTargeting;
			AbstractDirectionsCollectorSystem.CollectDirection(targetingData.Origin, targetingData.Dir, 0f, targetingData);
			Vector3 normalized = Vector3.Cross(targetingData.Dir, Vector3.up).normalized;
			float num = 360f / bulletTargeting.RadialRaysCount;
			for (int i = 0; (float)i < bulletTargeting.RadialRaysCount; i++)
			{
				Vector3 vector = Quaternion.AngleAxis(num * (float)i, targetingData.Dir) * normalized;
				Vector3 origin = targetingData.Origin + vector * bulletTargeting.Radius;
				AbstractDirectionsCollectorSystem.CollectDirection(origin, targetingData.Dir, 0f, targetingData);
			}
			ScheduleEvent(BattleCache.collectTargetsEvent.GetInstance().Init(targetingData), barelTargetingNode);
			ScheduleEvent(BattleCache.targetEvaluateEvent.GetInstance().Init(targetingData), barelTargetingNode);
		}
	}
}
