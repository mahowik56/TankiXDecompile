using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientCore.API;

namespace Tanks.Battle.ClientCore.Impl
{
	public class WeaponShotSystem : ECSSystem
	{
		public class WeaponNode : Node
		{
			public WeaponShotComponent weaponShot;

			public MuzzlePointComponent muzzlePoint;

			public ShotIdComponent shotId;

			public WeaponInstanceComponent weaponInstance;
		}

		public class UnblockedWeaponNode : WeaponNode
		{
			public WeaponUnblockedComponent weaponUnblocked;
		}

		public class BlockedWeaponNode : WeaponNode
		{
			public WeaponBlockedComponent weaponBlocked;
		}

		public class UndergroundWeaponNode : WeaponNode
		{
			public WeaponUndergroundComponent weaponUnderground;
		}

		[OnEventFire]
		public void SendShot(SendShotToServerEvent evt, UnblockedWeaponNode weaponNode)
		{
			SelfShotEvent selfShotEvent = new SelfShotEvent();
			if (evt.TargetingData.BestDirection != null)
			{
				selfShotEvent.ShotDirection = evt.TargetingData.BestDirection.Dir;
			}
			else
			{
				selfShotEvent.ShotDirection = new MuzzleLogicAccessor(weaponNode.muzzlePoint, weaponNode.weaponInstance).GetFireDirectionWorld();
			}
			ScheduleEvent(selfShotEvent, weaponNode);
		}

		[OnEventFire]
		public void SendShot(ShotPrepareEvent evt, BlockedWeaponNode weaponNode)
		{
			ScheduleEvent(new SelfShotEvent(new MuzzleLogicAccessor(weaponNode.muzzlePoint, weaponNode.weaponInstance).GetFireDirectionWorld()), weaponNode);
		}

		[OnEventFire]
		public void SendShot(ShotPrepareEvent evt, UndergroundWeaponNode weaponNode)
		{
			ScheduleEvent(new SelfShotEvent(new MuzzleLogicAccessor(weaponNode.muzzlePoint, weaponNode.weaponInstance).GetFireDirectionWorld()), weaponNode);
		}
	}
}
