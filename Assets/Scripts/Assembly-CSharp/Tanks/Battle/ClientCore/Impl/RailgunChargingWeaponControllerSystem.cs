using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Kernel.OSGi.ClientCore.API;
using Tanks.Battle.ClientCore.API;

namespace Tanks.Battle.ClientCore.Impl
{
	public class RailgunChargingWeaponControllerSystem : ECSSystem
	{
		public class ReadyRailgunChargingWeaponControllerNode : Node
		{
			public ChargingWeaponControllerComponent chargingWeaponController;

			public DiscreteWeaponEnergyComponent discreteWeaponEnergy;

			public WeaponEnergyComponent weaponEnergy;

			public CooldownTimerComponent cooldownTimer;

			public RailgunChargingWeaponComponent railgunChargingWeapon;

			public ReadyRailgunChargingWeaponComponent readyRailgunChargingWeapon;
		}

		public class CompleteChargingWeaponControllerNode : Node
		{
			public ChargingWeaponControllerComponent chargingWeaponController;

			public RailgunChargingWeaponComponent railgunChargingWeapon;

			public RailgunChargingStateComponent railgunChargingState;
		}

		public class ActiveTankNode : Node
		{
			public TankActiveStateComponent tankActiveState;

			public TankGroupComponent tankGroup;
		}

		[Inject]
		public static InputManager InputManager { get; set; }

		[OnEventFire]
		public void StartShotIfPossible(EarlyUpdateEvent evt, ReadyRailgunChargingWeaponControllerNode chargingWeaponController, [JoinSelf] SingleNode<ShootableComponent> node, [JoinByTank] ActiveTankNode selfActiveTank)
		{
			float unloadEnergyPerShot = chargingWeaponController.discreteWeaponEnergy.UnloadEnergyPerShot;
			float energy = chargingWeaponController.weaponEnergy.Energy;
			CooldownTimerComponent cooldownTimer = chargingWeaponController.cooldownTimer;
			if (!(energy < unloadEnergyPerShot) && !(cooldownTimer.CooldownTimerSec > 0f) && InputManager.CheckAction(ShotActions.SHOT))
			{
				ScheduleEvent<SelfRailgunChargingShotEvent>(chargingWeaponController);
			}
		}

		[OnEventFire]
		public void Reset(NodeAddedEvent evt, ActiveTankNode selfActiveTank, [JoinByTank] CompleteChargingWeaponControllerNode chargingWeaponNode)
		{
			Entity entity = chargingWeaponNode.Entity;
			entity.RemoveComponent<RailgunChargingStateComponent>();
			entity.AddComponent<ReadyRailgunChargingWeaponComponent>();
		}

		[OnEventFire]
		public void SendShotPrepare(RailgunDelayedShotPrepareEvent evt, CompleteChargingWeaponControllerNode chargingWeaponNode, [JoinByTank] ActiveTankNode selfActiveTank)
		{
			Entity entity = chargingWeaponNode.Entity;
			entity.AddComponent<ReadyRailgunChargingWeaponComponent>();
			entity.RemoveComponent<RailgunChargingStateComponent>();
			if (chargingWeaponNode.Entity.HasComponent<ShootableComponent>())
			{
				ScheduleEvent<BeforeShotEvent>(entity);
				ScheduleEvent<ShotPrepareEvent>(entity);
			}
		}

		[OnEventFire]
		public void MakeChargingAndScheduleShot(SelfRailgunChargingShotEvent evt, ReadyRailgunChargingWeaponControllerNode chargingWeaponController)
		{
			Entity entity = chargingWeaponController.Entity;
			entity.RemoveComponent<ReadyRailgunChargingWeaponComponent>();
			entity.AddComponent<RailgunChargingStateComponent>();
			float chargingTime = chargingWeaponController.railgunChargingWeapon.ChargingTime;
			EventBuilder eventBuilder = NewEvent<RailgunDelayedShotPrepareEvent>();
			eventBuilder.Attach(chargingWeaponController);
			eventBuilder.ScheduleDelayed(chargingTime);
		}
	}
}
