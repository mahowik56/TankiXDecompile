using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientCore.API;
using UnityEngine;

namespace Tanks.Battle.ClientCore.Impl
{
	public class RicochetBulletSystem : AbstractBulletSystem
	{
		public class TankNode : Node
		{
			public AssembledTankComponent assembledTank;

			public RigidbodyComponent rigidbody;
		}

		public class WeaponNode : Node
		{
			public TankGroupComponent tankGroup;

			public RicochetComponent ricochet;

			public MuzzlePointComponent muzzlePoint;

			public WeaponBulletShotComponent weaponBulletShot;

			public ShotIdComponent shotId;
		}

		public class BulletNode : Node
		{
			public TankGroupComponent tankGroup;

			public BulletComponent bullet;

			public ReadyBulletComponent readyBullet;

			public BulletConfigComponent bulletConfig;

			public RicochetBulletComponent ricochetBullet;

			public TargetCollectorComponent targetCollector;
		}

		[OnEventFire]
		public void Build(BulletBuildEvent e, WeaponNode weaponNode, [JoinByTank] TankNode tankNode)
		{
			Entity entity = CreateEntity<RicochetBulletTemplate>("battle/weapon/ricochet/bullet");
			BulletComponent bulletComponent = new BulletComponent();
			WeaponBulletShotComponent weaponBulletShot = weaponNode.weaponBulletShot;
			float radius = (bulletComponent.Radius = weaponBulletShot.BulletRadius);
			bulletComponent.Speed = weaponBulletShot.BulletSpeed;
			MuzzleVisualAccessor muzzleVisualAccessor = new MuzzleVisualAccessor(weaponNode.muzzlePoint);
			BulletConfigComponent bulletConfigComponent = entity.AddComponentAndGetInstance<BulletConfigComponent>();
			BulletTargetingComponent bulletTargetingComponent = entity.AddComponentAndGetInstance<BulletTargetingComponent>();
			bulletTargetingComponent.RadialRaysCount = bulletConfigComponent.RadialRaysCount;
			bulletTargetingComponent.Radius = radius;
			Vector3 worldPosition = muzzleVisualAccessor.GetWorldPosition();
			Rigidbody rigidbody = tankNode.rigidbody.Rigidbody;
			bulletComponent.ShotId = weaponNode.shotId.ShotId;
			InitBullet(bulletComponent, worldPosition, e.Direction, bulletComponent.Radius, rigidbody);
			entity.AddComponent(bulletComponent);
			entity.AddComponent(new TankGroupComponent(weaponNode.tankGroup.Key));
			entity.AddComponent<RicochetBulletComponent>();
			TargetCollectorComponent component = new TargetCollectorComponent(new TargetCollector(tankNode.Entity), new TargetValidator(tankNode.Entity));
			entity.AddComponent(component);
			entity.AddComponent<ReadyBulletComponent>();
		}

		[OnEventComplete]
		public void HandleFrame(UpdateBulletEvent e, BulletNode bulletNode)
		{
			BulletComponent bullet = bulletNode.bullet;
			BulletConfigComponent bulletConfig = bulletNode.bulletConfig;
			DirectionData directionData = e.TargetingData.Directions[0];
			if (directionData.StaticHit != null)
			{
				Vector3 position = directionData.StaticHit.Position;
				ScheduleEvent(new RicochetBulletBounceEvent(position), bulletNode);
				bullet.Distance += (bullet.Position - directionData.StaticHit.Position).magnitude;
				ProcessRicochet(bullet, directionData.StaticHit);
			}
			else
			{
				if (DestroyOnAnyTargetHit(bulletNode.Entity, bullet, bulletConfig, e.TargetingData))
				{
					return;
				}
				MoveBullet(bulletNode.Entity, bullet);
			}
			if (bullet.Distance > bulletConfig.FullDistance)
			{
				DestroyBullet(bulletNode.Entity);
			}
		}

		private void ProcessRicochet(BulletComponent bullet, StaticHit staticHit)
		{
			bullet.Position = staticHit.Position - bullet.Direction * bullet.Radius;
			Vector3 direction = bullet.Direction;
			bullet.Direction = (direction - 2f * Vector3.Dot(direction, staticHit.Normal) * staticHit.Normal).normalized;
		}
	}
}
