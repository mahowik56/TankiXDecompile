using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Kernel.OSGi.ClientCore.API;
using Tanks.Battle.ClientCore.API;
using Tanks.Battle.ClientCore.Impl;
using Tanks.Battle.ClientGraphics.API;
using Tanks.Lobby.ClientSettings.API;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class WeaponEnergyFeedbackSoundSystem : ECSSystem
	{
		public class TankNode : Node
		{
			public ShootingEnergyFeedbackSoundComponent shootingEnergyFeedbackSound;

			public AssembledTankActivatedStateComponent assembledTankActivatedState;

			public TankActiveStateComponent tankActiveState;

			public SelfTankComponent selfTank;

			public TankGroupComponent tankGroup;
		}

		public class WeaponNode : Node
		{
			public WeaponComponent weapon;

			public TankGroupComponent tankGroup;
		}

		public class WeaponEnergyNode : WeaponNode
		{
			public WeaponEnergyComponent weaponEnergy;
		}

		[Not(typeof(TwinsComponent))]
		public class SimpleDiscreteWeaponEnergyNode : WeaponEnergyNode
		{
			public DiscreteWeaponEnergyComponent discreteWeaponEnergy;
		}

		public class StreamEnergyNode : WeaponEnergyNode
		{
			public StreamWeaponComponent streamWeapon;
		}

		public class VulcanWeaponNode : Node
		{
			public VulcanWeaponComponent vulcanWeapon;

			public VulcanWeaponStateComponent vulcanWeaponState;

			public TankGroupComponent tankGroup;

			public CooldownTimerComponent cooldownTimer;
		}

		public class VulcanWeaponSlowDownNode : VulcanWeaponNode
		{
			public VulcanSlowDownComponent vulcanSlowDown;
		}

		public class VulcanWeaponIdleNode : VulcanWeaponNode
		{
			public VulcanIdleComponent vulcanIdle;
		}

		public class HammerEnergyNode : Node
		{
			public WeaponComponent weapon;

			public HammerComponent hammer;

			public MagazineWeaponComponent magazineWeapon;

			public MagazineStorageComponent magazineStorage;

			public TankGroupComponent tankGroup;

			public HammerEnergyBarComponent hammerEnergyBar;

			public CooldownTimerComponent cooldownTimer;
		}

		public class ShaftEnergyNode : Node
		{
			public ShaftEnergyComponent shaftEnergy;

			public WeaponEnergyComponent weaponEnergy;

			public TankGroupComponent tankGroup;

			public CooldownTimerComponent cooldownTimer;
		}

		public class SoundListenerNode : Node
		{
			public SoundListenerComponent soundListener;

			public SoundListenerBattleStateComponent soundListenerBattleState;

			public SoundListenerReadyForHitFeedbackComponent soundListenerReadyForHitFeedback;
		}

		[Inject]
		public static InputManager InputManager { get; set; }

		[OnEventFire]
		public void StopLowEnergyOnHitFeedback(HitFeedbackEvent e, TankNode tank, [JoinAll] SoundListenerNode listener)
		{
			StopSound(tank);
		}

		[OnEventFire]
		public void PlayLowEnergyForSimpleDiscreteEnergyWeapon(TimeUpdateEvent e, SimpleDiscreteWeaponEnergyNode weapon, [JoinByTank] TankNode tank, [JoinAll] SoundListenerNode listener)
		{
			if (InputManager.GetActionKeyDown(ShotActions.SHOT))
			{
				if (!weapon.Entity.HasComponent<ShootableComponent>())
				{
					PlayLowEnergyFeedback(tank);
				}
				else if (weapon.weaponEnergy.Energy < weapon.discreteWeaponEnergy.UnloadEnergyPerShot)
				{
					PlayLowEnergyFeedback(tank);
				}
			}
		}

		[OnEventFire]
		public void PlayLowEnergyForStreamEnergyWeapon(TimeUpdateEvent e, StreamEnergyNode weapon, [JoinByTank] TankNode tank, [JoinAll] SoundListenerNode listener)
		{
			if (InputManager.GetActionKeyDown(ShotActions.SHOT) && !weapon.Entity.HasComponent<ShootableComponent>())
			{
				PlayLowEnergyFeedback(tank);
			}
		}

		[OnEventFire]
		public void PlayLowEnergyForVulcanSlowDownWeapon(TimeUpdateEvent e, VulcanWeaponSlowDownNode weapon, [JoinByTank] TankNode tank, [JoinAll] SoundListenerNode listener)
		{
			if (InputManager.GetActionKeyDown(ShotActions.SHOT))
			{
				PlayLowEnergyFeedback(tank);
			}
		}

		[OnEventFire]
		public void PlayLowEnergyForVulcanIdleWeapon(TimeUpdateEvent e, VulcanWeaponIdleNode weapon, [JoinByTank] TankNode tank, [JoinAll] SoundListenerNode listener)
		{
			if (InputManager.GetActionKeyDown(ShotActions.SHOT) && !weapon.Entity.HasComponent<ShootableComponent>())
			{
				PlayLowEnergyFeedback(tank);
			}
		}

		[OnEventFire]
		public void PlayLowEnergyForHammerWeapon(TimeUpdateEvent e, HammerEnergyNode weapon, [JoinByTank] TankNode tank, [JoinAll] SoundListenerNode listener)
		{
			if (InputManager.GetActionKeyDown(ShotActions.SHOT) && (weapon.cooldownTimer.CooldownTimerSec > 0f || weapon.Entity.HasComponent<MagazineReloadStateComponent>() || !weapon.Entity.HasComponent<ShootableComponent>()))
			{
				PlayLowEnergyFeedback(tank);
			}
		}

		[OnEventFire]
		public void PlayLowEnergyForShaft(TimeUpdateEvent e, ShaftEnergyNode weapon, [JoinByTank] TankNode tank, [JoinAll] SoundListenerNode listener)
		{
			if (InputManager.GetActionKeyDown(ShotActions.SHOT))
			{
				float unloadEnergyPerQuickShot = weapon.shaftEnergy.UnloadEnergyPerQuickShot;
				float energy = weapon.weaponEnergy.Energy;
				CooldownTimerComponent cooldownTimer = weapon.cooldownTimer;
				if (energy < unloadEnergyPerQuickShot || cooldownTimer.CooldownTimerSec > 0f || !weapon.Entity.HasComponent<ShootableComponent>())
				{
					PlayLowEnergyFeedback(tank);
				}
			}
		}

		private void PlayLowEnergyFeedback(TankNode tank)
		{
			StopSound(tank);
			WeaponFeedbackSoundBehaviour weaponFeedbackSoundBehaviour = Object.Instantiate(tank.shootingEnergyFeedbackSound.LowEnergyFeedbackSoundAsset);
			tank.shootingEnergyFeedbackSound.Instance = weaponFeedbackSoundBehaviour;
			weaponFeedbackSoundBehaviour.Play(-1f, 1f, true);
		}

		private void StopSound(TankNode tank)
		{
			WeaponFeedbackSoundBehaviour instance = tank.shootingEnergyFeedbackSound.Instance;
			if ((bool)instance)
			{
				instance.GetComponent<WeaponEnergyFeedbackFadeBehaviour>().enabled = true;
			}
		}
	}
}
