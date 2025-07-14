using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientCore.API;
using UnityEngine;

namespace Tanks.Battle.ClientCore.Impl
{
	public class TankFallingSystem : ECSSystem
	{
		public class ActivatedTankNode : Node
		{
			public AssembledTankActivatedStateComponent assembledTankActivatedState;

			public TankMovableComponent tankMovable;

			public TrackComponent track;

			public TankCollisionComponent tankCollision;

			public RigidbodyComponent rigidbody;

			public ChassisConfigComponent chassisConfig;
		}

		public class FallingTankNode : ActivatedTankNode
		{
			public TankFallingComponent tankFalling;
		}

		private const float FLAT_FALLING_ANGLE = 30f;

		private const float VERTICAL_FALLING_ANGLE = 70f;

		private const float DEBUG_RAY_DURATION = 0.5f;

		private const float NRM_LENGTH = 2f;

		[OnEventFire]
		public void InitTankFalling(NodeAddedEvent evt, ActivatedTankNode tank)
		{
			Entity entity = tank.Entity;
			TankFallingComponent tankFallingComponent = new TankFallingComponent();
			TrackComponent track = tank.track;
			TankCollisionComponent tankCollision = tank.tankCollision;
			tankFallingComponent.PreviousCollisionContactsCount = GetCollisionContacts(tankCollision);
			tankFallingComponent.PreviousTrackContactsCount = GetTrackContacts(track);
			tankFallingComponent.IsGrounded = true;
			tankFallingComponent.PreviousVelocity = Vector3.zero;
			entity.AddComponent(tankFallingComponent);
		}

		[OnEventFire]
		public void DisableTankFalling(NodeRemoveEvent evt, ActivatedTankNode tank)
		{
			tank.Entity.RemoveComponentIfPresent<TankFallingComponent>();
		}

		[OnEventComplete]
		public void UpdateTankFalling(FixedUpdateEvent evt, FallingTankNode tank)
		{
			TankFallingComponent tankFalling = tank.tankFalling;
			TrackComponent track = tank.track;
			RigidbodyComponent rigidbody = tank.rigidbody;
			TankCollisionComponent tankCollision = tank.tankCollision;
			ChassisConfigComponent chassisConfig = tank.chassisConfig;
			Entity entity = tank.Entity;
			int previousCollisionContactsCount = tankFalling.PreviousCollisionContactsCount;
			int previousTrackContactsCount = tankFalling.PreviousTrackContactsCount;
			int trackContacts = GetTrackContacts(track);
			int collisionContacts = GetCollisionContacts(tankCollision);
			int num = collisionContacts - previousCollisionContactsCount;
			int num2 = trackContacts - previousTrackContactsCount;
			Vector3 previousVelocity = tankFalling.PreviousVelocity;
			tankFalling.PreviousCollisionContactsCount = collisionContacts;
			tankFalling.PreviousTrackContactsCount = trackContacts;
			tankFalling.PreviousVelocity = rigidbody.Rigidbody.velocity;
			if (num2 > 0)
			{
				ApplyFall(entity, previousVelocity, tankFalling, track, chassisConfig, tankCollision, rigidbody, true);
			}
			else if (num > 0 && trackContacts == 0)
			{
				ApplyFall(entity, previousVelocity, tankFalling, track, chassisConfig, tankCollision, rigidbody, false);
			}
			else
			{
				UpdateGroundedStatus(tankFalling, num2, collisionContacts, trackContacts);
			}
		}

		private void ApplyFall(Entity tankEntity, Vector3 previousVelocity, TankFallingComponent tankFalling, TrackComponent track, ChassisConfigComponent chassisConfig, TankCollisionComponent tankCollision, RigidbodyComponent rigidbody, bool fallingByTrack)
		{
			if (tankFalling != null && !tankFalling.IsGrounded && (bool)rigidbody.Rigidbody)
			{
				bool isFallingOnTank;
				Vector3 fallingNrm = GetFallingNrm(fallingByTrack, track, chassisConfig, tankCollision, out isFallingOnTank);
				Vector3 vector = Vector3.ProjectOnPlane(previousVelocity, fallingNrm);
				float sqrMagnitude = (previousVelocity - vector).sqrMagnitude;
				Vector3 position = rigidbody.Rigidbody.transform.position;
				TankFallingType tankFallingType = DefineFallingCollisionMode(isFallingOnTank, fallingByTrack, fallingNrm);
				TankFallEvent tankFallEvent = new TankFallEvent();
				tankFallEvent.FallingPower = sqrMagnitude;
				tankFallEvent.FallingType = tankFallingType;
				tankFallEvent.Velocity = previousVelocity;
				TankFallEvent tankFallEvent2 = tankFallEvent;
				if (tankFallingType == TankFallingType.SLOPED_STATIC_WITH_COLLISION && CheckTankCollisionNotNull(tankCollision))
				{
					Transform transform = tankCollision.Collision.transform;
					tankFallEvent2.FallingTransform = transform;
				}
				ScheduleEvent(tankFallEvent2, tankEntity);
				tankFalling.IsGrounded = true;
			}
		}

		private void UpdateGroundedStatus(TankFallingComponent tankFalling, int deltaTrackContacts, int currentCollisionContactsCount, int currentTrackContactsCount)
		{
			if (tankFalling.IsGrounded)
			{
				if (deltaTrackContacts < 0)
				{
					tankFalling.IsGrounded = false;
				}
				else if (currentCollisionContactsCount == 0 && currentTrackContactsCount == 0)
				{
					tankFalling.IsGrounded = false;
				}
			}
		}

		private TankFallingType DefineFallingCollisionMode(bool isFallingOnTank, bool isFallingByTracks, Vector3 midNrm)
		{
			if (isFallingOnTank)
			{
				return TankFallingType.TANK;
			}
			float num = Mathf.Abs(Vector3.Angle(midNrm, Vector3.up));
			if (num <= 30f)
			{
				return TankFallingType.FLAT_STATIC;
			}
			if (num >= 70f)
			{
				return TankFallingType.VERTICAL_STATIC;
			}
			if (isFallingByTracks)
			{
				return TankFallingType.SLOPED_STATIC_WITH_TRACKS;
			}
			return TankFallingType.SLOPED_STATIC_WITH_COLLISION;
		}

		private Vector3 GetFallingNrm(bool fallingByTrack, TrackComponent track, ChassisConfigComponent chassisConfig, TankCollisionComponent tankCollision, out bool isFallingOnTank)
		{
			Vector3 currentNrm = Vector3.zero;
			isFallingOnTank = false;
			if (fallingByTrack)
			{
				int numRaysPerTrack = chassisConfig.NumRaysPerTrack;
				SuspensionRay[] rays = track.LeftTrack.rays;
				SuspensionRay[] rays2 = track.RightTrack.rays;
				for (int i = 0; i < numRaysPerTrack; i++)
				{
					SuspensionRay suspensionRay = rays[i];
					SuspensionRay suspensionRay2 = rays2[i];
					ApplyTrackRayNormal(ref currentNrm, suspensionRay);
					ApplyTrackRayNormal(ref currentNrm, suspensionRay2);
					if (isFallingOnTank)
					{
						continue;
					}
					if (suspensionRay.hasCollision)
					{
						if (suspensionRay.rayHit.collider == null || suspensionRay.rayHit.collider.gameObject == null)
						{
							return currentNrm.normalized;
						}
						if (ValidateCollider(suspensionRay.rayHit.collider))
						{
							int layer = suspensionRay.rayHit.collider.gameObject.layer;
							isFallingOnTank |= CheckTankLayer(layer);
						}
					}
					if (suspensionRay2.hasCollision)
					{
						if (suspensionRay2.rayHit.collider == null || suspensionRay2.rayHit.collider.gameObject == null)
						{
							return currentNrm.normalized;
						}
						if (ValidateCollider(suspensionRay2.rayHit.collider))
						{
							int layer2 = suspensionRay2.rayHit.collider.gameObject.layer;
							isFallingOnTank |= CheckTankLayer(layer2);
						}
					}
				}
			}
			else
			{
				Collision collision = tankCollision.Collision;
				if (!CheckTankCollisionNotNull(tankCollision))
				{
					return currentNrm.normalized;
				}
				ContactPoint[] contacts = collision.contacts;
				if (contacts == null)
				{
					return currentNrm.normalized;
				}
				int num = contacts.Length;
				for (int j = 0; j < num; j++)
				{
					ContactPoint contactPoint = contacts[j];
					currentNrm += contactPoint.normal;
					if (!isFallingOnTank)
					{
						Collider otherCollider = contactPoint.otherCollider;
						if (ValidateCollider(otherCollider))
						{
							int layer3 = otherCollider.gameObject.layer;
							isFallingOnTank |= CheckTankLayer(layer3);
						}
					}
				}
			}
			return currentNrm.normalized;
		}

		private bool ValidateCollider(Collider collider)
		{
			if (collider == null)
			{
				return false;
			}
			if (collider.gameObject == null)
			{
				return false;
			}
			return true;
		}

		private bool CheckTankLayer(int layer)
		{
			return layer == Layers.TANK_TO_TANK;
		}

		private void ApplyTrackRayNormal(ref Vector3 currentNrm, SuspensionRay ray)
		{
			if (ray.hasCollision)
			{
				currentNrm += ray.rayHit.normal;
			}
		}

		private int GetCollisionContacts(TankCollisionComponent tankCollision)
		{
			Collision collision = tankCollision.Collision;
			if (collision == null)
			{
				return 0;
			}
			if (collision.contacts == null)
			{
				return 0;
			}
			return collision.contacts.Length;
		}

		private int GetTrackContacts(TrackComponent track)
		{
			return track.LeftTrack.numContacts + track.RightTrack.numContacts;
		}

		private bool CheckTankCollisionNotNull(TankCollisionComponent tankCollision)
		{
			return tankCollision.HasCollision && tankCollision.Collision != null && tankCollision.Collision.rigidbody != null;
		}
	}
}
