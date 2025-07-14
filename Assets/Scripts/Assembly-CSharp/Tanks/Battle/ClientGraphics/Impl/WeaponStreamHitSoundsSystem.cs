using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientCore.API;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class WeaponStreamHitSoundsSystem : ECSSystem
	{
		public class WeaponShootingSoundInitNode : Node
		{
			public WeaponShootingSoundEffectComponent weaponShootingSoundEffect;

			public WeaponSoundRootComponent weaponSoundRoot;
		}

		public class WeaponStreamHitSoundNode : Node
		{
			public WeaponStreamHitSoundsEffectComponent weaponStreamHitSoundsEffect;

			public WeaponSoundRootComponent weaponSoundRoot;
		}

		public class WeaponStreamHitSoundReadyNode : WeaponStreamHitSoundNode
		{
			public WeaponStreamHitSoundsEffectReadyComponent weaponStreamHitSoundsEffectReady;
		}

		public class WeaponStreamHitSoundActiveNode : WeaponStreamHitSoundReadyNode
		{
			public StreamHitComponent streamHit;
		}

		public class WeaponShootingSoundReadyNode : WeaponShootingSoundInitNode
		{
			public WeaponShootingSoundEffectReadyComponent weaponShootingSoundEffectReady;
		}

		public class WeaponShootingStateSoundReadyNode : WeaponShootingSoundReadyNode
		{
			public WeaponStreamShootingComponent weaponStreamShooting;
		}

		[OnEventFire]
		public void InitWeaponShootingSound(NodeAddedEvent e, WeaponShootingSoundInitNode weapon)
		{
			InitStreamHitWeaponEffect<WeaponShootingSoundEffectReadyComponent>(weapon.Entity, weapon.weaponShootingSoundEffect, weapon.weaponSoundRoot.transform);
		}

		[OnEventFire]
		public void InitWeaponStreamHitSound(NodeAddedEvent e, WeaponStreamHitSoundNode weapon)
		{
			InitStreamHitWeaponEffect<WeaponStreamHitSoundsEffectReadyComponent>(weapon.Entity, weapon.weaponStreamHitSoundsEffect, weapon.weaponSoundRoot.transform);
		}

		private void InitStreamHitWeaponEffect<T>(Entity weapon, BaseStreamHitWeaponSoundEffect effect, Transform root) where T : Platform.Kernel.ECS.ClientEntitySystem.API.Component, new()
		{
			GameObject effectPrefab = effect.EffectPrefab;
			GameObject gameObject = Object.Instantiate(effectPrefab, root.position, root.rotation, root.transform);
			effect.SoundController = gameObject.GetComponent<SoundController>();
			weapon.AddComponent<T>();
		}

		[OnEventFire]
		public void Play(NodeAddedEvent e, WeaponShootingStateSoundReadyNode weapon)
		{
			weapon.weaponShootingSoundEffect.SoundController.FadeIn();
		}

		[OnEventFire]
		public void Stop(NodeRemoveEvent e, WeaponShootingStateSoundReadyNode weapon)
		{
			weapon.weaponShootingSoundEffect.SoundController.FadeOut();
		}

		[OnEventFire]
		public void StartHitSounds(NodeAddedEvent evt, WeaponStreamHitSoundActiveNode weapon)
		{
			UpdateHitSoundsByForce(weapon.weaponStreamHitSoundsEffect, weapon.streamHit);
			UpdateHitSoundPosition(weapon.weaponStreamHitSoundsEffect, weapon.streamHit);
		}

		[OnEventComplete]
		public void UpdateHitSound(UpdateEvent evt, WeaponStreamHitSoundActiveNode weapon)
		{
			UpdateHitSoundsIfNeeded(weapon.weaponStreamHitSoundsEffect, weapon.streamHit);
			UpdateHitSoundPosition(weapon.weaponStreamHitSoundsEffect, weapon.streamHit);
		}

		[OnEventFire]
		public void StopHitSounds(NodeRemoveEvent evt, WeaponStreamHitSoundActiveNode weapon)
		{
			SoundController soundController = weapon.weaponStreamHitSoundsEffect.SoundController;
			if ((bool)soundController)
			{
				weapon.weaponStreamHitSoundsEffect.SoundController.StopImmediately();
				weapon.weaponStreamHitSoundsEffect.SoundController.gameObject.transform.localPosition = Vector3.zero;
			}
		}

		private void UpdateHitSoundPosition(WeaponStreamHitSoundsEffectComponent effect, StreamHitComponent hit)
		{
			bool flag = hit.StaticHit != null;
			bool flag2 = hit.TankHit != null;
			if (flag)
			{
				effect.SoundController.gameObject.transform.position = hit.StaticHit.Position;
			}
			if (flag2)
			{
				effect.SoundController.gameObject.transform.position = hit.TankHit.TargetPosition;
			}
		}

		private void UpdateHitSoundsIfNeeded(WeaponStreamHitSoundsEffectComponent effect, StreamHitComponent hit)
		{
			bool flag = hit.StaticHit != null;
			if (effect.IsStaticHit != flag)
			{
				UpdateHitSoundsByForce(effect, hit);
			}
		}

		private void UpdateHitSoundsByForce(WeaponStreamHitSoundsEffectComponent effect, StreamHitComponent hit)
		{
			bool flag = (effect.IsStaticHit = hit.StaticHit != null);
			effect.SoundController.StopImmediately();
			if (flag)
			{
				effect.SoundController.Source.clip = effect.StaticHitClip;
			}
			else
			{
				effect.SoundController.Source.clip = effect.TargetHitClip;
			}
			effect.SoundController.SetSoundActive();
		}
	}
}
