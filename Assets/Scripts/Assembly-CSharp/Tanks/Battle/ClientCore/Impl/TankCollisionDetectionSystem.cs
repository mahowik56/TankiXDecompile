using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientCore.API;
using UnityEngine;

namespace Tanks.Battle.ClientCore.Impl
{
	public class TankCollisionDetectionSystem : ECSSystem
	{
		public class TankNode : Node
		{
			public AssembledTankActivatedStateComponent assembledTankActivatedState;

			public TankSemiActiveStateComponent tankSemiActiveState;

			public TankSyncComponent tankSync;

			public RigidbodyComponent rigidbody;

			public TankCollidersComponent tankColliders;
		}

		public class TankCollisionDetectionNode : Node
		{
			public BattleGroupComponent battleGroup;

			public TankCollisionDetectionComponent tankCollisionDetection;

			public TankStateTimeOutComponent tankStateTimeOut;

			public TankCollidersComponent tankColliders;
		}

		public class TankCollisionDetectionForNRNode : Node
		{
			public BattleGroupComponent battleGroup;

			public TankStateTimeOutComponent tankStateTimeOut;

			public TankCollidersComponent tankColliders;

			public TankSemiActiveStateComponent tankSemiActiveState;
		}

		public class BattleTankCollisionsNode : Node
		{
			public BattleGroupComponent battleGroup;

			public BattleComponent battle;

			public BattleTankCollisionsComponent battleTankCollisions;
		}

		private int DETECTOR_TRUST_UPDATES_COUNT = 4;

		[OnEventFire]
		public void EnableDetector(NodeAddedEvent nodeAdded, TankNode tank)
		{
			BoxCollider boundsCollider = tank.tankColliders.BoundsCollider;
			TankCollisionDetectionComponent tankCollisionDetectionComponent = new TankCollisionDetectionComponent();
			TankCollisionDetector detector = boundsCollider.gameObject.AddComponent<TankCollisionDetector>();
			tankCollisionDetectionComponent.Detector = detector;
			Rigidbody rigidbody = boundsCollider.gameObject.GetComponent<Rigidbody>();
			if (!rigidbody)
			{
				rigidbody = boundsCollider.gameObject.AddComponent<Rigidbody>();
			}
			rigidbody.isKinematic = true;
			boundsCollider.enabled = true;
			boundsCollider.isTrigger = true;
			if (!tank.Entity.HasComponent<TankCollisionDetectionComponent>())
			{
				tank.Entity.AddComponent(tankCollisionDetectionComponent);
			}
		}

		[OnEventFire]
		public void DisableDetector(NodeRemoveEvent nodeRemoveEvent, TankCollisionDetectionForNRNode nr, [JoinSelf] SingleNode<TankCollisionDetectionComponent> tank)
		{
			BoxCollider boundsCollider = nr.tankColliders.BoundsCollider;
			tank.Entity.RemoveComponent<TankCollisionDetectionComponent>();
			Object.DestroyImmediate(tank.component.Detector);
			Object.DestroyImmediate(boundsCollider.gameObject.GetComponent<Rigidbody>());
			boundsCollider.isTrigger = false;
		}

		[OnEventFire]
		public void PrepareAndSendCollisionResult(FixedUpdateEvent e, TankCollisionDetectionNode tank, [JoinByBattle] BattleTankCollisionsNode battle)
		{
			TankCollisionDetectionComponent tankCollisionDetection = tank.tankCollisionDetection;
			if (tankCollisionDetection.Detector.UpdatesCout >= DETECTOR_TRUST_UPDATES_COUNT)
			{
				long semiActiveCollisionsPhase = battle.battleTankCollisions.SemiActiveCollisionsPhase;
				if (tankCollisionDetection.Phase < semiActiveCollisionsPhase && tankCollisionDetection.Detector.CanBeActivated)
				{
					tankCollisionDetection.Phase = semiActiveCollisionsPhase;
					ScheduleEvent(new ActivateTankEvent(semiActiveCollisionsPhase), tank.Entity);
				}
				tankCollisionDetection.Detector.UpdatesCout = 0;
				tankCollisionDetection.Detector.CanBeActivated = true;
			}
		}
	}
}
