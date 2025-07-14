using System;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Kernel.OSGi.ClientCore.API;
using Platform.Library.ClientDataStructures.API;
using Tanks.Battle.ClientCore.API;
using Tanks.Battle.ClientGraphics.API;
using Tanks.Lobby.ClientProfile.API;
using UnityEngine;

namespace Tanks.Battle.ClientCore.Impl
{
	public class ChassisSystem : ECSSystem
	{
		public class ChassisInitNode : Node
		{
			public RigidbodyComponent rigidbody;

			public ChassisConfigComponent chassisConfig;

			public TankCollidersComponent tankColliders;

			public SpeedComponent speed;

			public WeightComponent weight;

			public DampingComponent damping;
		}

		[Not(typeof(TankDeadStateComponent))]
		public class ChassisNode : Node
		{
			public TankGroupComponent tankGroup;

			public RigidbodyComponent rigidbody;

			public ChassisConfigComponent chassisConfig;

			public ChassisComponent chassis;

			public TankCollidersComponent tankColliders;

			public SpeedComponent speed;

			public EffectiveSpeedComponent effectiveSpeed;

			public TrackComponent track;

			public ChassisSmootherComponent chassisSmoother;

			public SpeedConfigComponent speedConfig;

			public CameraVisibleTriggerComponent cameraVisibleTrigger;
		}

		public class TankActiveStateNode : Node
		{
			public TrackComponent track;

			public TankActiveStateComponent tankActiveState;
		}

		private const float SELF_TANK_UPDATE_PERIOD = 0f;

		private const float REMOTE_TANK_UPDATE_PERIOD = 0.05f;

		private const float REMOTE_INVISBILE_TANK_UPDATE_PERIOD = 0.1f;

		private const float REMOTE_RANDOM_TANK_UPDATE_PERIOD = 0.05f;

		private static readonly string RIGHT_AXIS = "MoveRight";

		private static readonly string LEFT_AXIS = "MoveLeft";

		private static readonly string FORWARD_AXIS = "MoveForward";

		private static readonly string BACKWARD_AXIS = "MoveBackward";

		private const float MIN_ACCELERATION = 4f;

		private const float SQRT1_2 = 0.70710677f;

		private const float FULL_FORCE_ANGLE = (float)Math.PI / 4f;

		private const float ZERO_FORCE_ANGLE = (float)Math.PI / 3f;

		private const float FULL_SLOPE_ANGLE = (float)Math.PI / 4f;

		private const float MAX_SLOPE_ANGLE = (float)Math.PI / 3f;

		private static readonly float FULL_SLOPE_COS_ANGLE = Mathf.Cos((float)Math.PI / 4f);

		private static readonly float MAX_SLOPE_COS_ANGLE = Mathf.Cos((float)Math.PI / 3f);

		[Inject]
		public static InputManager InputManager { get; set; }

		[OnEventFire]
		public void InitTankChassis(NodeAddedEvent evt, ChassisInitNode node)
		{
			ChassisComponent chassisComponent = new ChassisComponent();
			CreateTracks(node, chassisComponent);
			node.Entity.AddComponent(chassisComponent);
			node.Entity.AddComponent<EffectiveSpeedComponent>();
			ChassisSmootherComponent chassisSmootherComponent = new ChassisSmootherComponent();
			chassisSmootherComponent.maxSpeedSmoother.Reset(node.speed.Speed);
			chassisSmootherComponent.maxTurnSpeedSmoother.Reset(node.speed.TurnSpeed);
			node.Entity.AddComponent(chassisSmootherComponent);
			Rigidbody rigidbody = node.rigidbody.Rigidbody;
			rigidbody.mass = node.weight.Weight;
		}

		[OnEventFire]
		public void ResetTankChassis(ResetTankSpeedEvent e, SingleNode<ChassisSmootherComponent> smoother, [JoinSelf] SingleNode<SpeedComponent> speed)
		{
			smoother.component.maxSpeedSmoother.Reset(speed.component.Speed);
			smoother.component.maxTurnSpeedSmoother.Reset(speed.component.TurnSpeed);
		}

		[OnEventFire]
		public void FixedUpdate(FixedUpdateEvent evt, ChassisNode chassisNode, [JoinSelf] Optional<SingleNode<TankSyncComponent>> tankSync, [JoinByTank] Optional<SingleNode<TankJumpComponent>> tankJump, [JoinAll] SingleNode<GameTankSettingsComponent> gameTankSettings, [JoinAll] Optional<SingleNode<BattleActionsStateComponent>> inputState)
		{
			if (tankJump.IsPresent() && tankJump.Get().component.isNearBegin())
			{
				return;
			}
			bool inputEnabled = inputState.IsPresent();
			if (chassisNode.Entity.HasComponent<SelfTankComponent>())
			{
				UpdateSelfInput(chassisNode, inputEnabled, gameTankSettings.component.MovementControlsInverted);
			}
			UpdateInput(chassisNode, inputEnabled);
			ChassisSmootherComponent chassisSmoother = chassisNode.chassisSmoother;
			chassisSmoother.maxSpeedSmoother.SetTargetValue(chassisNode.speed.Speed);
			float num = chassisSmoother.maxSpeedSmoother.Update(evt.DeltaTime);
			chassisNode.effectiveSpeed.MaxSpeed = num;
			Rigidbody rigidbody = chassisNode.rigidbody.Rigidbody;
			if ((bool)rigidbody)
			{
				float x = rigidbody.velocity.x;
				float z = rigidbody.velocity.z;
				float t = ((!tankJump.IsPresent() || !tankJump.Get().component.OnFly) ? 1f : tankJump.Get().component.GetSlowdownLerp());
				if (x * x + z * z > num * num)
				{
					float b = num / (float)Math.Sqrt(x * x + z * z);
					b = Mathf.Lerp(1f, b, t);
					Vector3 velocity = new Vector3(rigidbody.velocity.x * b, rigidbody.velocity.y, rigidbody.velocity.z * b);
					rigidbody.SetVelocitySafe(velocity);
				}
				chassisSmoother.maxTurnSpeedSmoother.SetTargetValue(chassisNode.speed.TurnSpeed);
				chassisNode.effectiveSpeed.MaxTurnSpeed = chassisSmoother.maxTurnSpeedSmoother.Update(evt.DeltaTime);
				AdjustSuspensionSpringCoeff(chassisNode.chassisConfig, chassisNode.chassis, chassisNode.rigidbody.Rigidbody);
				float updatePeriod = 0f;
				if (!tankSync.IsPresent())
				{
					updatePeriod = (chassisNode.cameraVisibleTrigger.IsVisible ? 0.05f : 0.1f);
					updatePeriod += UnityEngine.Random.value * 0.05f;
				}
				if (UpdateSuspensionContacts(chassisNode.track, evt.DeltaTime, updatePeriod) && tankJump.IsPresent())
				{
					TankJumpComponent component = tankJump.Get().component;
					component.FinishAndSlowdown();
				}
				ApplyMovementForces(chassisNode, evt.DeltaTime);
				ApplyStaticFriction(chassisNode.track, chassisNode.rigidbody.Rigidbody);
			}
		}

		private void UpdateInput(ChassisNode tank, bool inputEnabled)
		{
			ChassisComponent chassis = tank.chassis;
			bool flag = tank.Entity.HasComponent<TankMovableComponent>();
			chassis.EffectiveMoveAxis = ((!flag) ? 0f : chassis.MoveAxis);
			chassis.EffectiveTurnAxis = ((!flag) ? 0f : chassis.TurnAxis);
		}

		private void UpdateSelfInput(ChassisNode tank, bool inputEnabled, bool inverse)
		{
			ChassisComponent chassis = tank.chassis;
			float num = ((!inputEnabled) ? 0f : (InputManager.GetUnityAxis(RIGHT_AXIS) - InputManager.GetUnityAxis(LEFT_AXIS)));
			float num2 = ((!inputEnabled) ? 0f : (InputManager.GetUnityAxis(FORWARD_AXIS) - InputManager.GetUnityAxis(BACKWARD_AXIS)));
			if (inverse && num2 < 0f)
			{
				num *= -1f;
			}
			Vector2 vector = new Vector2(chassis.TurnAxis, chassis.MoveAxis);
			Vector2 vector2 = new Vector2(num, num2);
			if (vector2 != vector)
			{
				chassis.TurnAxis = num;
				chassis.MoveAxis = num2;
				bool flag = tank.Entity.HasComponent<TankMovableComponent>();
				chassis.EffectiveMoveAxis = ((!flag) ? 0f : chassis.MoveAxis);
				chassis.EffectiveTurnAxis = ((!flag) ? 0f : chassis.TurnAxis);
				ScheduleEvent<ChassisControlChangedEvent>(tank);
			}
		}

		public void ApplyStaticFriction(TrackComponent tracks, Rigidbody rigidbody)
		{
			if (tracks.RightTrack.numContacts >= tracks.RightTrack.rays.Length >> 1 || tracks.LeftTrack.numContacts >= tracks.LeftTrack.rays.Length >> 1)
			{
				Vector3 up = rigidbody.transform.up;
				float num = Vector3.Dot(Physics.gravity, up);
				float num2 = 0.70710677f * Physics.gravity.magnitude;
				if (num < 0f - num2 || num > num2)
				{
					Vector3 force = (up * num - Physics.gravity) * rigidbody.mass;
					rigidbody.AddForceSafe(force);
				}
			}
		}

		private void CreateTracks(ChassisInitNode node, ChassisComponent chassis)
		{
			Entity entity = node.Entity;
			TankCollidersComponent tankColliders = node.tankColliders;
			ChassisConfigComponent chassisConfig = node.chassisConfig;
			Rigidbody rigidbody = node.rigidbody.Rigidbody;
			BoxCollider boundsCollider = tankColliders.BoundsCollider;
			float trackLength = boundsCollider.size.z * 0.8f;
			float num = boundsCollider.size.x - chassisConfig.TrackSeparation;
			Vector3 vector = boundsCollider.center - new Vector3(0f, boundsCollider.size.y / 2f, 0f);
			Vector3 trackCenterPosition = vector + new Vector3(-0.5f * num, chassisConfig.NominalRayLength, 0f);
			Vector3 trackCenterPosition2 = vector + new Vector3(0.5f * num, chassisConfig.NominalRayLength, 0f);
			float damping = node.damping.Damping;
			TrackComponent trackComponent = new TrackComponent();
			trackComponent.LeftTrack = new Track(rigidbody, chassisConfig.NumRaysPerTrack, trackCenterPosition, trackLength, chassisConfig, chassis, -1, damping);
			trackComponent.RightTrack = new Track(rigidbody, chassisConfig.NumRaysPerTrack, trackCenterPosition2, trackLength, chassisConfig, chassis, 1, damping);
			int vISIBLE_FOR_CHASSIS_SEMI_ACTIVE = LayerMasks.VISIBLE_FOR_CHASSIS_SEMI_ACTIVE;
			trackComponent.LeftTrack.SetRayсastLayerMask(vISIBLE_FOR_CHASSIS_SEMI_ACTIVE);
			trackComponent.RightTrack.SetRayсastLayerMask(vISIBLE_FOR_CHASSIS_SEMI_ACTIVE);
			entity.AddComponent(trackComponent);
		}

		[OnEventFire]
		public void SetTankCollisionLayerMask(NodeAddedEvent e, TankActiveStateNode node)
		{
			int vISIBLE_FOR_CHASSIS_ACTIVE = LayerMasks.VISIBLE_FOR_CHASSIS_ACTIVE;
			node.track.LeftTrack.SetRayсastLayerMask(vISIBLE_FOR_CHASSIS_ACTIVE);
			node.track.RightTrack.SetRayсastLayerMask(vISIBLE_FOR_CHASSIS_ACTIVE);
		}

		private void AdjustSuspensionSpringCoeff(ChassisConfigComponent chassisConfig, ChassisComponent chassis, Rigidbody rigidbody)
		{
			float num = Physics.gravity.magnitude * rigidbody.mass;
			chassis.SpringCoeff = num / ((float)(2 * chassisConfig.NumRaysPerTrack) * (chassisConfig.MaxRayLength - chassisConfig.NominalRayLength));
		}

		private bool UpdateSuspensionContacts(TrackComponent trackComponent, float dt, float updatePeriod)
		{
			bool flag = trackComponent.LeftTrack.UpdateSuspensionContacts(dt, updatePeriod);
			bool flag2 = trackComponent.RightTrack.UpdateSuspensionContacts(dt, updatePeriod);
			return flag && flag2;
		}

		private void ApplyMovementForces(ChassisNode node, float dt)
		{
			TrackComponent track = node.track;
			if (track.LeftTrack.numContacts + track.RightTrack.numContacts <= 0)
			{
				return;
			}
			Rigidbody rigidbody = node.rigidbody.Rigidbody;
			ChassisConfigComponent chassisConfig = node.chassisConfig;
			Vector3 surfaceVelocity;
			Vector3 angularSurfaceVelocity;
			CalculateNetSurfaceVelocities(node, out surfaceVelocity, out angularSurfaceVelocity);
			float num = CalculateSlopeCoefficient(rigidbody.transform.up.y);
			float forwardRelativeSpeed;
			rigidbody.SetVelocitySafe(CalculateRigidBodyVelocity(rigidbody, surfaceVelocity, node.speedConfig.SideAcceleration * num * dt, out forwardRelativeSpeed));
			if (track.LeftTrack.numContacts > 0 || track.RightTrack.numContacts > 0)
			{
				Vector3 vector = CalculateRelativeAngularVelocity(node, dt, num * 1.2f, angularSurfaceVelocity, forwardRelativeSpeed);
				Vector3 normalized = rigidbody.transform.InverseTransformDirection(rigidbody.angularVelocity).normalized;
				if (Mathf.Abs(node.chassis.TurnAxis) > 0f && Mathf.Sign(normalized.y) != Mathf.Sign(node.chassis.TurnAxis))
				{
					float y = Mathf.Lerp(0f, normalized.y, 0.2f * dt * 60f);
					angularSurfaceVelocity -= rigidbody.transform.TransformDirection(new Vector3(0f, y, 0f));
				}
				rigidbody.SetAngularVelocitySafe(angularSurfaceVelocity + vector);
			}
		}

		private float CalculateSlopeCoefficient(float upAxisY)
		{
			float result = 1f;
			if (upAxisY < FULL_SLOPE_COS_ANGLE)
			{
				result = ((!(upAxisY < MAX_SLOPE_COS_ANGLE)) ? (((float)Math.PI / 3f - Mathf.Acos(upAxisY)) / ((float)Math.PI / 12f)) : 0f);
			}
			return result;
		}

		private Vector3 GetContactsMidpoint(ChassisConfigComponent chassisConfig, TrackComponent tracks)
		{
			Vector3 vector = default(Vector3);
			for (int i = 0; i < chassisConfig.NumRaysPerTrack; i++)
			{
				SuspensionRay suspensionRay = tracks.LeftTrack.rays[i];
				if (suspensionRay.hasCollision)
				{
					vector += suspensionRay.rayHit.point;
				}
				suspensionRay = tracks.RightTrack.rays[i];
				if (suspensionRay.hasCollision)
				{
					vector += suspensionRay.rayHit.point;
				}
			}
			int num = tracks.LeftTrack.numContacts + tracks.RightTrack.numContacts;
			return (num != 0) ? (vector / num) : Vector3.zero;
		}

		private void CalculateNetSurfaceVelocities(ChassisNode node, out Vector3 surfaceVelocity, out Vector3 angularSurfaceVelocity)
		{
			ChassisConfigComponent chassisConfig = node.chassisConfig;
			TrackComponent track = node.track;
			Vector3 contactsMidpoint = GetContactsMidpoint(chassisConfig, track);
			surfaceVelocity = Vector3.zero;
			angularSurfaceVelocity = Vector3.zero;
			for (int i = 0; i < chassisConfig.NumRaysPerTrack; i++)
			{
				AddSurfaceVelocitiesFromRay(node, track.LeftTrack.rays[i], contactsMidpoint, ref surfaceVelocity, ref angularSurfaceVelocity);
				AddSurfaceVelocitiesFromRay(node, track.RightTrack.rays[i], contactsMidpoint, ref surfaceVelocity, ref angularSurfaceVelocity);
			}
			float num = track.LeftTrack.numContacts + track.RightTrack.numContacts;
			surfaceVelocity = ((!(num > 0f)) ? surfaceVelocity : (surfaceVelocity / num));
			angularSurfaceVelocity = ((!(num > 0f)) ? angularSurfaceVelocity : (angularSurfaceVelocity / num));
		}

		private void AddSurfaceVelocitiesFromRay(ChassisNode node, SuspensionRay ray, Vector3 contactsMidpoint, ref Vector3 surfaceVelocity, ref Vector3 angularSurfaceVelocity)
		{
			if (ray.hasCollision)
			{
				surfaceVelocity += ray.surfaceVelocity;
				Vector3 lhs = ray.rayHit.point - contactsMidpoint;
				float sqrMagnitude = lhs.sqrMagnitude;
				float num = 0.0001f;
				if (sqrMagnitude > num)
				{
					angularSurfaceVelocity += Vector3.Cross(lhs, ray.surfaceVelocity) / sqrMagnitude;
				}
			}
		}

		private Vector3 CalculateRigidBodyVelocity(Rigidbody rigidbody, Vector3 surfaceVelocity, float sideSpeedDelta, out float forwardRelativeSpeed)
		{
			Vector3 right = rigidbody.transform.right;
			Vector3 forward = rigidbody.transform.forward;
			Vector3 vector = rigidbody.velocity - surfaceVelocity;
			forwardRelativeSpeed = Vector3.Dot(vector, forward);
			float num = CalculateSideVelocityDelta(vector, right, sideSpeedDelta);
			vector += num * right;
			return surfaceVelocity + vector;
		}

		private float CalculateSideVelocityDelta(Vector3 relativeVelocity, Vector3 xAxis, float sideSpeedDelta)
		{
			float num = Vector3.Dot(relativeVelocity, xAxis);
			float num2 = num;
			if (num2 < 0f)
			{
				num2 = ((!(sideSpeedDelta > 0f - num2)) ? (num2 + sideSpeedDelta) : 0f);
			}
			else if (num2 > 0f)
			{
				num2 = ((!(sideSpeedDelta > num2)) ? (num2 - sideSpeedDelta) : 0f);
			}
			return num2 - num;
		}

		private Vector3 CalculateRelativeAngularVelocity(ChassisNode node, float dt, float slopeCoeff, Vector3 surfaceAngularVelocity, float forwardRelativeSpeed)
		{
			ChassisConfigComponent chassisConfig = node.chassisConfig;
			TrackComponent track = node.track;
			Rigidbody rigidbody = node.rigidbody.Rigidbody;
			float maxTurnSpeed = node.effectiveSpeed.MaxTurnSpeed * ((float)Math.PI / 180f);
			Vector3 up = rigidbody.transform.up;
			Vector3 forward = rigidbody.transform.forward;
			Vector3 vector = rigidbody.angularVelocity - surfaceAngularVelocity;
			float relativeTurnSpeed = Vector3.Dot(vector, up);
			float forcePerRay = CalculateForcePerRay(node, dt, forwardRelativeSpeed);
			for (int i = 0; i < chassisConfig.NumRaysPerTrack; i++)
			{
				ApplyForceFromRay(track.LeftTrack.rays[i], rigidbody, forward, forcePerRay);
				ApplyForceFromRay(track.RightTrack.rays[i], rigidbody, forward, forcePerRay);
			}
			float num = Vector3.Dot(vector, up);
			float num2 = RecalculateRelativeTurnSpeed(node, dt, maxTurnSpeed, relativeTurnSpeed, slopeCoeff) - num;
			return vector + num2 * up;
		}

		private float CalculateForcePerRay(ChassisNode node, float dt, float forwardRelativeSpeed)
		{
			ChassisConfigComponent chassisConfig = node.chassisConfig;
			ChassisComponent chassis = node.chassis;
			float maxSpeed = node.effectiveSpeed.MaxSpeed;
			TrackComponent track = node.track;
			Rigidbody rigidbody = node.rigidbody.Rigidbody;
			float num = node.speed.Acceleration;
			float num2 = 0f;
			if (chassis.EffectiveMoveAxis == 0f)
			{
				num2 = (0f - MathUtil.Sign(forwardRelativeSpeed)) * num * dt;
				if (MathUtil.Sign(forwardRelativeSpeed) != MathUtil.Sign(forwardRelativeSpeed + num2))
				{
					num2 = 0f - forwardRelativeSpeed;
				}
			}
			else
			{
				if (IsReversedMove(chassis.EffectiveMoveAxis, forwardRelativeSpeed))
				{
					num = node.speedConfig.ReverseAcceleration;
				}
				num2 = chassis.EffectiveMoveAxis * num * dt;
			}
			float num3 = Mathf.Clamp(forwardRelativeSpeed + num2, 0f - maxSpeed, maxSpeed);
			float num4 = num3 - forwardRelativeSpeed;
			float num5 = 1f;
			float num6 = ((!(maxSpeed > 0f)) ? num5 : Mathf.Clamp01(1f - Mathf.Abs(forwardRelativeSpeed / maxSpeed)));
			if (num6 < num5 && chassis.EffectiveMoveAxis * MathUtil.Sign(forwardRelativeSpeed) > 0f)
			{
				num4 *= num6 / num5;
			}
			float num7 = num4 / dt;
			if (Mathf.Abs(num7) < 4f && Mathf.Abs(num3) > 0.5f * maxSpeed)
			{
				num7 = MathUtil.SignEpsilon(num7, 0.1f) * 4f;
			}
			float num8 = num7 * rigidbody.mass;
			int num9 = track.LeftTrack.numContacts + track.RightTrack.numContacts;
			int num10 = 2 * chassisConfig.NumRaysPerTrack;
			float num11 = num8 * ((float)num9 + 0.42f * (float)(num10 - track.LeftTrack.numContacts)) / (float)num10;
			return (num9 <= 0) ? num11 : (num11 / (float)num9);
		}

		private bool IsReversedTurn(float turnDirection, float relativeTurnSpeed)
		{
			return turnDirection * relativeTurnSpeed < 0f;
		}

		private bool IsReversedMove(float moveDirection, float relativeMovementSpeed)
		{
			return moveDirection * relativeMovementSpeed < 0f;
		}

		private void ApplyForceFromRay(SuspensionRay ray, Rigidbody rigidbody, Vector3 bodyForwardAxis, float forcePerRay)
		{
			if (!ray.hasCollision)
			{
				return;
			}
			float num = Mathf.Abs(Mathf.Acos(ray.rayHit.normal.normalized.y));
			if (num < (float)Math.PI / 3f)
			{
				float num2 = forcePerRay;
				if (num > (float)Math.PI / 3f)
				{
					num2 *= ((float)Math.PI / 3f - num) / ((float)Math.PI / 12f);
				}
				Vector3 force = bodyForwardAxis * num2;
				rigidbody.AddForceAtPositionSafe(force, ray.GetGlobalOrigin());
			}
		}

		private float RecalculateRelativeTurnSpeed(ChassisNode node, float dt, float maxTurnSpeed, float relativeTurnSpeed, float slopeCoeff)
		{
			ChassisComponent chassis = node.chassis;
			ChassisConfigComponent chassisConfig = node.chassisConfig;
			float num = node.speedConfig.TurnAcceleration * ((float)Math.PI / 180f);
			float num2 = CalculateTurnCoefficient(node.track);
			float num3 = 0f;
			if (chassis.EffectiveTurnAxis == 0f)
			{
				num3 = (0f - MathUtil.Sign(relativeTurnSpeed)) * num * slopeCoeff * dt;
				if (MathUtil.Sign(relativeTurnSpeed) != MathUtil.Sign(relativeTurnSpeed + num3))
				{
					num3 = 0f - relativeTurnSpeed;
				}
			}
			else
			{
				if (IsReversedTurn(chassis.EffectiveTurnAxis, relativeTurnSpeed))
				{
					num = node.speedConfig.ReverseTurnAcceleration * ((float)Math.PI / 180f);
				}
				num3 = chassis.EffectiveTurnAxis * num * slopeCoeff * dt;
				if (chassis.EffectiveMoveAxis == -1f && chassisConfig.ReverseBackTurn)
				{
					num3 = 0f - num3;
				}
			}
			return Mathf.Clamp(relativeTurnSpeed + num3, (0f - maxTurnSpeed) * num2, maxTurnSpeed * num2);
		}

		private float CalculateTurnCoefficient(TrackComponent trackComponent)
		{
			float result = 1f;
			if (trackComponent.LeftTrack.numContacts == 0 || trackComponent.RightTrack.numContacts == 0)
			{
				result = 0.5f;
			}
			return result;
		}
	}
}
