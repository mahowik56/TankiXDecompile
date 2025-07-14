using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientUnityIntegration.API;
using Tanks.Battle.ClientCore.API;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class WeaponStreamMuzzleFlashSystem : ECSSystem
	{
		public class WeaponStreamMuzzleFlashInitNode : Node
		{
			public WeaponStreamMuzzleFlashComponent weaponStreamMuzzleFlash;

			public MuzzlePointComponent muzzlePoint;
		}

		public class WeaponStreamMuzzleFlashNode : Node
		{
			public WeaponStreamMuzzleFlashReadyComponent weaponStreamMuzzleFlashReady;

			public WeaponStreamMuzzleFlashComponent weaponStreamMuzzleFlash;

			public WeaponStreamShootingComponent weaponStreamShooting;
		}

		[OnEventFire]
		public void Init(NodeAddedEvent evt, WeaponStreamMuzzleFlashInitNode node)
		{
			GameObject gameObject = Object.Instantiate(node.weaponStreamMuzzleFlash.EffectPrefab);
			UnityUtil.InheritAndEmplace(gameObject.transform, node.muzzlePoint.Current);
			node.weaponStreamMuzzleFlash.EffectInstance = gameObject.GetComponent<ParticleSystem>();
			node.weaponStreamMuzzleFlash.LightInstance = gameObject.GetComponent<Light>();
			node.Entity.AddComponent<WeaponStreamMuzzleFlashReadyComponent>();
		}

		[OnEventFire]
		public void StartEffect(NodeAddedEvent evt, WeaponStreamMuzzleFlashNode node)
		{
			node.weaponStreamMuzzleFlash.EffectInstance.Play(true);
			node.weaponStreamMuzzleFlash.LightInstance.enabled = true;
		}

		[OnEventFire]
		public void StopEffect(NodeRemoveEvent evt, WeaponStreamMuzzleFlashNode node)
		{
			node.weaponStreamMuzzleFlash.EffectInstance.Stop(true);
			node.weaponStreamMuzzleFlash.LightInstance.enabled = false;
		}
	}
}
