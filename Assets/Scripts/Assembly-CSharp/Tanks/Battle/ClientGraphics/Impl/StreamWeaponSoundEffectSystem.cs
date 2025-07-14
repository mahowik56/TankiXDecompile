using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientCore.API;
using Tanks.Battle.ClientCore.Impl;
using Tanks.Battle.ClientGraphics.API;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class StreamWeaponSoundEffectSystem : ECSSystem
	{
		public class WorkingNode : Node
		{
			public StreamWeaponComponent streamWeapon;

			public StreamWeaponWorkingComponent streamWeaponWorking;

			public StreamWeaponSoundEffectComponent streamWeaponSoundEffect;

			public StreamWeaponSoundEffectReadyComponent streamWeaponSoundEffectReady;
		}

		public class StreamWeaponSoundEffectNode : Node
		{
			public AnimationPreparedComponent animationPrepared;

			public StreamWeaponComponent streamWeapon;

			public StreamWeaponSoundEffectComponent streamWeaponSoundEffect;

			public WeaponSoundRootComponent weaponSoundRoot;
		}

		public class ActivaTankNode : Node
		{
			public TankActiveStateComponent tankActiveState;

			public TankGroupComponent tankGroup;
		}

		[OnEventFire]
		public void Build(NodeAddedEvent evt, [Combine] StreamWeaponSoundEffectNode weapon, SingleNode<SoundListenerBattleStateComponent> soundListener)
		{
			GameObject gameObject = Object.Instantiate(weapon.streamWeaponSoundEffect.Asset);
			gameObject.transform.parent = weapon.weaponSoundRoot.gameObject.transform;
			gameObject.transform.localPosition = Vector3.zero;
			weapon.streamWeaponSoundEffect.SoundController = gameObject.GetComponent<SoundController>();
			weapon.Entity.AddComponent<StreamWeaponSoundEffectReadyComponent>();
		}

		[OnEventFire]
		public void StartSoundEffect(NodeAddedEvent evt, WorkingNode weapon)
		{
			weapon.streamWeaponSoundEffect.SoundController.FadeIn();
		}

		[OnEventFire]
		public void StopSoundEffect(NodeRemoveEvent evt, WorkingNode weapon)
		{
			weapon.streamWeaponSoundEffect.SoundController.FadeOut();
		}

		[OnEventFire]
		public void StopSoundEffect(NodeRemoveEvent evt, ActivaTankNode tank, [JoinByTank] WorkingNode weapon)
		{
			weapon.streamWeaponSoundEffect.SoundController.FadeOut();
		}
	}
}
