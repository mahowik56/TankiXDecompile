using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientDataStructures.API;
using Tanks.Lobby.ClientEntrance.API;
using UnityEngine;

namespace Tanks.Battle.ClientCore.Impl
{
	public class UnitMoveSystem : ECSSystem
	{
		public class UnitMoveSyncComponent : Platform.Kernel.ECS.ClientEntitySystem.API.Component
		{
			public float LastSendMoveTime { get; set; }

			public Vector3 LastSendVelocity { get; set; }
		}

		public class UnitMoveNode : Node
		{
			public UnitComponent unit;

			public UnitMoveComponent unitMove;

			public RigidbodyComponent rigidBody;
		}

		public class UnitMoveInitSelfNode : UnitMoveNode
		{
			public SelfComponent self;
		}

		public class UnitMoveSyncNode : UnitMoveNode
		{
			public UnitMoveSyncComponent unitMoveSync;
		}

		public static float SEND_MOVE_PERIOD = 1f;

		public static float MAX_VELOCITY_DELTA = 5f;

		[OnEventFire]
		public void Init(NodeAddedEvent evt, UnitMoveNode unit)
		{
			UpdateRigidbody(unit.unitMove.Movement, unit.rigidBody);
			unit.Entity.AddComponent<UnitReadyComponent>();
		}

		[OnEventFire]
		public void InitSelf(NodeAddedEvent evt, UnitMoveInitSelfNode unit)
		{
			unit.Entity.AddComponent<UnitMoveSyncComponent>();
		}

		[OnEventFire]
		public void SendMoveToServer(FixedUpdateEvent evt, [Combine] UnitMoveSyncNode unit)
		{
			Movement moveFromRigidbody = GetMoveFromRigidbody(unit.rigidBody.Rigidbody);
			if (IsNeedSendToServer(moveFromRigidbody, unit.unitMoveSync))
			{
				ScheduleEvent(new UnitMoveSelfEvent(moveFromRigidbody), unit);
			}
		}

		[OnEventFire]
		public void RecieveMoveFromServer(UnitMoveRemoteEvent evt, UnitMoveNode unit, [JoinSelf] Optional<SingleNode<UnitMoveSmootherComponent>> smoother)
		{
			Movement unitMove = evt.UnitMove;
			unit.unitMove.Movement = unitMove;
			if (smoother.IsPresent())
			{
				smoother.Get().component.BeforeSetMovement();
				UpdateRigidbody(unitMove, unit.rigidBody);
				smoother.Get().component.AfterSetMovement();
			}
			else
			{
				UpdateRigidbody(unitMove, unit.rigidBody);
			}
		}

		private Movement GetMoveFromRigidbody(Rigidbody rigidbody)
		{
			return new Movement
			{
				Position = rigidbody.position,
				Orientation = rigidbody.rotation,
				Velocity = rigidbody.velocity,
				AngularVelocity = rigidbody.angularVelocity
			};
		}

		private void UpdateRigidbody(Movement move, RigidbodyComponent rigidbody)
		{
			if ((bool)rigidbody.Rigidbody)
			{
				rigidbody.RigidbodyTransform.SetPositionSafe(move.Position);
				rigidbody.RigidbodyTransform.SetRotationSafe(move.Orientation);
				rigidbody.Rigidbody.SetVelocitySafe(move.Velocity);
				rigidbody.Rigidbody.SetAngularVelocitySafe(move.AngularVelocity);
			}
		}

		private bool IsNeedSendToServer(Movement move, UnitMoveSyncComponent unitMoveSync)
		{
			bool flag = false;
			float num = (float)PreciseTime.Time;
			flag = num > unitMoveSync.LastSendMoveTime + SEND_MOVE_PERIOD || (unitMoveSync.LastSendVelocity - move.Velocity).sqrMagnitude > MAX_VELOCITY_DELTA * MAX_VELOCITY_DELTA;
			if (flag)
			{
				unitMoveSync.LastSendMoveTime = num;
				unitMoveSync.LastSendVelocity = move.Velocity;
			}
			return flag;
		}
	}
}
