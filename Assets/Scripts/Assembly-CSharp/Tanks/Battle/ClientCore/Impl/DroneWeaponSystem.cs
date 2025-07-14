using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Kernel.OSGi.ClientCore.API;
using Platform.Library.ClientUnityIntegration.API;
using Tanks.Battle.ClientCore.API;
using Tanks.Battle.ClientGraphics.Impl;
using Tanks.Lobby.ClientEntrance.API;
using UnityEngine;

namespace Tanks.Battle.ClientCore.Impl
{
	public class DroneWeaponSystem : ECSSystem
	{
		public class DroneLoadedNode : Node
		{
			public DroneEffectComponent droneEffect;

			public UnitMoveComponent unitMove;

			public UnitGroupComponent unitGroup;
		}

		public class DroneNode : DroneLoadedNode
		{
			public new UnitMoveComponent unitMove;

			public RigidbodyComponent rigidbody;
		}

		public class SelfDroneNode : DroneNode
		{
			public SelfComponent self;

			public DroneAnimatorComponent droneAnimator;

			public EffectActiveComponent effectActive;
		}

		public class SelfDroneWithTargetNode : SelfDroneNode
		{
			public UnitTargetComponent unitTarget;
		}

		public class SelfDroneWeapon : Node
		{
			public SelfComponent self;

			public WeaponComponent weapon;

			public DroneWeaponComponent droneWeapon;

			public MuzzlePointComponent muzzlePoint;

			public WeaponInstanceComponent weaponInstance;

			public VerticalTargetingComponent verticalTargeting;

			public CooldownTimerComponent cooldownTimer;

			public WeaponCooldownComponent weaponCooldown;
		}

		public class ShootingDroneWeapon : SelfDroneWeapon
		{
			public StreamHitCheckingComponent streamHitChecking;

			public StreamHitComponent streamHit;
		}

		public static float WEAPON_CONTROL_PERIOD = 1f;

		[Inject]
		public static BattleFlowInstancesCache BattleCache { get; set; }

		[OnEventFire]
		public void InitDroneWeapon(NodeAddedEvent e, [Combine] DroneNode drone, [JoinByUnit] SingleNode<WeaponComponent> weapon, [JoinAll][Context] SingleNode<MapInstanceComponent> map)
		{
			Rigidbody rigidbody = drone.rigidbody.Rigidbody;
			MuzzlePointMarkerComponent componentInChildren = rigidbody.GetComponentInChildren<MuzzlePointMarkerComponent>();
			componentInChildren.gameObject.GetComponent<EntityBehaviour>().BuildEntity(weapon.Entity);
			weapon.Entity.AddComponent(new WeaponInstanceComponent(componentInChildren.gameObject));
			weapon.Entity.AddComponent(new TargetCollectorComponent(new TargetCollector(drone.Entity), new TargetValidator(drone.Entity)));
		}

		[OnEventFire]
		public void InitDroneSelfWeapon(NodeAddedEvent e, [Combine] SelfDroneNode drone, [JoinByUnit] SingleNode<WeaponComponent> weapon, [JoinAll][Context] SingleNode<MapInstanceComponent> map)
		{
			weapon.Entity.AddComponent(new WeaponHitComponent(false, false));
			weapon.Entity.AddComponent<CooldownTimerComponent>();
			StartShooting(weapon.Entity);
			StopShooting(weapon.Entity);
		}

		[OnEventFire]
		public void ControllDroneWeapon(UpdateEvent e, SelfDroneWithTargetNode drone, [JoinByUnit] SelfDroneWeapon droneWeapon)
		{
			if (!(Time.timeSinceLevelLoad - droneWeapon.droneWeapon.lastControlTime < WEAPON_CONTROL_PERIOD))
			{
				droneWeapon.droneWeapon.lastControlTime = Time.timeSinceLevelLoad;
				if (IsTargetVisable(droneWeapon))
				{
					StartShooting(droneWeapon.Entity);
					drone.droneAnimator.StartShoot();
					droneWeapon.droneWeapon.lastTimeTargetSeen = Time.time;
				}
				else
				{
					StopShooting(droneWeapon.Entity);
					drone.droneAnimator.StartIdle();
					drone.Entity.RemoveComponentIfPresent<UnitTargetComponent>();
				}
			}
		}

		[OnEventFire]
		public void ControllDroneWeapon(NodeRemoveEvent e, SelfDroneWithTargetNode drone, [JoinByUnit] SelfDroneWeapon droneWeapon)
		{
			StopShooting(droneWeapon.Entity);
		}

		private bool IsTargetVisable(SelfDroneWeapon droneWeapon)
		{
			TargetingData targetingData = BattleCache.targetingData.GetInstance().Init();
			TargetingEvent eventInstance = BattleCache.targetingEvent.GetInstance().Init(targetingData);
			ScheduleEvent(eventInstance, droneWeapon);
			if (targetingData.HasTargetHit())
			{
				foreach (DirectionData direction in targetingData.Directions)
				{
					if (direction.HasTargetHit() && direction.Targets[0].ValidTarget)
					{
						return true;
					}
				}
			}
			return false;
		}

		private void StartShooting(Entity droneWeapon)
		{
			droneWeapon.AddComponentIfAbsent<WeaponStreamShootingComponent>();
			droneWeapon.AddComponentIfAbsent<StreamHitCheckingComponent>();
		}

		private void StopShooting(Entity droneWeapon)
		{
			droneWeapon.RemoveComponentIfPresent<WeaponStreamShootingComponent>();
			droneWeapon.RemoveComponentIfPresent<StreamHitCheckingComponent>();
		}

		[OnEventFire]
		public void ShootDroneWeapon(UpdateEvent e, SelfDroneWithTargetNode drone, [JoinByUnit] ShootingDroneWeapon droneWeapon)
		{
			if (!(droneWeapon.cooldownTimer.CooldownTimerSec > 0f))
			{
				ScheduleEvent<ShotPrepareEvent>(droneWeapon);
			}
		}
	}
}
