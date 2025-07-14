using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientCore.API;
using Tanks.Battle.ClientCore.Impl;
using Tanks.Battle.ClientGraphics.API;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class MagazineSoundEffectSystem : ECSSystem
	{
		public class InitialMagazineSoundEffectNode : Node
		{
			public AnimationPreparedComponent animationPrepared;

			public MagazineWeaponComponent magazineWeapon;

			public WeaponCooldownComponent weaponCooldown;

			public MagazineStorageComponent magazineStorage;

			public WeaponSoundRootComponent weaponSoundRoot;

			public MagazineLastCartridgeChargeEffectComponent magazineLastCartridgeChargeEffect;

			public MagazineBlowOffEffectComponent magazineBlowOffEffect;

			public MagazineOffsetEffectComponent magazineOffsetEffect;

			public MagazineRollEffectComponent magazineRollEffect;

			public MagazineCartridgeClickEffectComponent magazineCartridgeClickEffect;

			public MagazineShotEffectComponent magazineShotEffect;

			public MagazineBounceEffectComponent magazineBounceEffect;

			public MagazineCooldownEffectComponent magazineCooldownEffect;

			public HammerShotAnimationComponent hammerShotAnimation;

			public HammerShotAnimationReadyComponent hammerShotAnimationReady;

			public TankGroupComponent tankGroup;
		}

		public class ReadyMagazineSoundEffectNode : InitialMagazineSoundEffectNode
		{
			public MagazineSoundEffectReadyComponent magazineSoundEffectReady;
		}

		public class ActiveTankNode : TankNode
		{
			public TankActiveStateComponent tankActiveState;
		}

		public class TankNode : Node
		{
			public TankComponent tank;

			public TankGroupComponent tankGroup;
		}

		public class SelfTankNode : TankNode
		{
			public SelfTankComponent selfTank;
		}

		public class RemoteTankNode : TankNode
		{
			public RemoteTankComponent remoteTank;
		}

		[OnEventFire]
		public void InitMagazineSounds(NodeAddedEvent evt, [Combine] InitialMagazineSoundEffectNode weapon, [Combine][Context][JoinByTank] RemoteTankNode tank, SingleNode<SoundListenerBattleStateComponent> soundListener)
		{
			InitMagazineSound(weapon, false);
		}

		[OnEventFire]
		public void InitMagazineSounds(NodeAddedEvent evt, InitialMagazineSoundEffectNode weapon, [Context][JoinByTank] SelfTankNode tank, SingleNode<SoundListenerBattleStateComponent> soundListener)
		{
			InitMagazineSound(weapon, true);
		}

		private void InitMagazineSound(InitialMagazineSoundEffectNode weapon, bool selfTank)
		{
			Transform transform = weapon.weaponSoundRoot.gameObject.transform;
			PrepareMagazineSoundEffect(weapon.magazineLastCartridgeChargeEffect, transform);
			PrepareMagazineSoundEffect(weapon.magazineBlowOffEffect, transform);
			PrepareMagazineSoundEffect(weapon.magazineOffsetEffect, transform);
			PrepareMagazineSoundEffect(weapon.magazineRollEffect, transform);
			PrepareMagazineSoundEffect(weapon.magazineCartridgeClickEffect, transform);
			PrepareMagazineSoundEffect(weapon.magazineShotEffect, transform);
			PrepareMagazineSoundEffect(weapon.magazineBounceEffect, transform);
			PrepareMagazineSoundEffect(weapon.magazineCooldownEffect, transform);
			MagazineShotEffectAudioGroupBehaviour component = weapon.magazineShotEffect.AudioSource.GetComponent<MagazineShotEffectAudioGroupBehaviour>();
			weapon.magazineShotEffect.AudioSource.outputAudioMixerGroup = ((!selfTank) ? component.RemoteShotGroup : component.SelfShotGroup);
			weapon.Entity.AddComponent<MagazineSoundEffectReadyComponent>();
		}

		[OnEventFire]
		public void StopSoundPlay(NodeRemoveEvent evt, ActiveTankNode tank, [JoinByTank] ReadyMagazineSoundEffectNode weapon)
		{
			StopAllSounds(weapon);
		}

		[OnEventFire]
		public void StopSoundPlay(ExecuteEnergyInjectionEvent evt, ReadyMagazineSoundEffectNode weapon)
		{
			StopAllSounds(weapon);
		}

		private void StopAllSounds(ReadyMagazineSoundEffectNode weapon)
		{
			StopPlaying(weapon.magazineLastCartridgeChargeEffect);
			StopPlaying(weapon.magazineBlowOffEffect);
			StopPlaying(weapon.magazineOffsetEffect);
			StopPlaying(weapon.magazineRollEffect);
			StopPlaying(weapon.magazineCartridgeClickEffect);
			StopPlaying(weapon.magazineShotEffect);
			StopPlaying(weapon.magazineBounceEffect);
			StopPlaying(weapon.magazineCooldownEffect);
		}

		[OnEventFire]
		public void PlayCooldownEffect(HammerCooldownEvent evt, ReadyMagazineSoundEffectNode weapon, [JoinByTank] ActiveTankNode tank)
		{
			PlaySoundEffect(weapon.magazineCooldownEffect);
		}

		[OnEventFire]
		public void PlayShotEffect(HammerMagazineShotEvent evt, ReadyMagazineSoundEffectNode weapon, [JoinByTank] ActiveTankNode tank)
		{
			PlaySoundEffect(weapon.magazineShotEffect);
		}

		[OnEventFire]
		public void PlayBounceEffect(HammerBounceEvent evt, ReadyMagazineSoundEffectNode weapon, [JoinByTank] ActiveTankNode tank)
		{
			PlaySoundEffect(weapon.magazineBounceEffect);
		}

		[OnEventFire]
		public void PlayLastCartridgeChargeEffect(HammerChargeLastCartridgeEvent evt, ReadyMagazineSoundEffectNode weapon, [JoinByTank] ActiveTankNode tank)
		{
			PlaySoundEffect(weapon.magazineLastCartridgeChargeEffect);
		}

		[OnEventFire]
		public void PlayBlowOffEffect(HammerBlowOffEvent evt, ReadyMagazineSoundEffectNode weapon, [JoinByTank] ActiveTankNode tank)
		{
			PlaySoundEffect(weapon.magazineBlowOffEffect);
		}

		[OnEventFire]
		public void PlayOffsetEffect(HammerOffsetEvent evt, ReadyMagazineSoundEffectNode weapon, [JoinByTank] ActiveTankNode tank)
		{
			PlaySoundEffect(weapon.magazineOffsetEffect);
		}

		[OnEventFire]
		public void PlayRollEffect(HammerRollEvent evt, ReadyMagazineSoundEffectNode weapon, [JoinByTank] ActiveTankNode tank)
		{
			PlaySoundEffect(weapon.magazineRollEffect);
		}

		[OnEventFire]
		public void PlayClickEffect(HammerCartridgeClickEvent evt, ReadyMagazineSoundEffectNode weapon, [JoinByTank] ActiveTankNode tank)
		{
			PlaySoundEffect(weapon.magazineCartridgeClickEffect);
		}

		private void PlaySoundEffect(MagazineSoundEffectComponent soundEffect)
		{
			AudioSource audioSource = soundEffect.AudioSource;
			if (audioSource.isPlaying)
			{
				audioSource.Stop();
			}
			audioSource.Play();
		}

		private void StopPlaying(MagazineSoundEffectComponent soundEffect)
		{
			if (soundEffect.AudioSource.isPlaying)
			{
				soundEffect.AudioSource.Stop();
			}
		}

		private void PrepareMagazineSoundEffect(MagazineSoundEffectComponent magazineSoundEffect, Transform root)
		{
			GameObject asset = magazineSoundEffect.Asset;
			AudioSource audioSource = InstantiateAudioEffect(asset, root);
			magazineSoundEffect.AudioSource = audioSource;
		}

		private AudioSource InstantiateAudioEffect(GameObject prefab, Transform root)
		{
			GameObject gameObject = Object.Instantiate(prefab);
			gameObject.transform.parent = root;
			gameObject.transform.localPosition = Vector3.zero;
			return gameObject.GetComponent<AudioSource>();
		}
	}
}
