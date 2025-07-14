using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientUnityIntegration.API;
using Tanks.Battle.ClientCore.API;
using Tanks.Battle.ClientCore.Impl;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class SoleTracerGraphicsSystem : ECSSystem
	{
		public class SoleTracerGraphicsInitNode : Node
		{
			public MuzzlePointComponent muzzlePoint;

			public SoleTracerGraphicsComponent soleTracerGraphics;
		}

		public class SoleTracerGraphicsNode : Node
		{
			public SoleTracerGraphicsReadyComponent soleTracerGraphicsReady;

			public SoleTracerGraphicsComponent soleTracerGraphics;

			public MuzzlePointComponent muzzlePoint;

			public DamageWeakeningByDistanceComponent damageWeakeningByDistance;

			public WeaponUnblockedComponent weaponUnblocked;
		}

		[OnEventFire]
		public void Init(NodeAddedEvent evt, SoleTracerGraphicsInitNode node)
		{
			MuzzlePointComponent muzzlePoint = node.muzzlePoint;
			SoleTracerGraphicsComponent soleTracerGraphics = node.soleTracerGraphics;
			soleTracerGraphics.Tracer = Object.Instantiate(soleTracerGraphics.Tracer);
			UnityUtil.InheritAndEmplace(soleTracerGraphics.Tracer.transform, muzzlePoint.Current);
			node.Entity.AddComponent<SoleTracerGraphicsReadyComponent>();
		}

		[OnEventFire]
		public void InstantiatePellets(BaseShotEvent evt, SoleTracerGraphicsNode weapon)
		{
			SoleTracerGraphicsComponent soleTracerGraphics = weapon.soleTracerGraphics;
			float radiusOfMinDamage = weapon.damageWeakeningByDistance.RadiusOfMinDamage;
			float startLifetime = radiusOfMinDamage / soleTracerGraphics.Tracer.startSpeed;
			ParticleSystem.Particle particle = new ParticleSystem.Particle
			{
				position = soleTracerGraphics.Tracer.transform.position,
				color = soleTracerGraphics.Tracer.startColor,
				size = soleTracerGraphics.Tracer.startSize
			};
			particle.randomSeed = (uint)(Random.value * 4.2949673E+09f);
			particle.velocity = evt.ShotDirection * soleTracerGraphics.Tracer.startSpeed;
			RaycastHit hitInfo;
			if (Physics.Raycast(soleTracerGraphics.Tracer.transform.position, evt.ShotDirection, out hitInfo, radiusOfMinDamage, LayerMasks.GUN_TARGETING_WITH_DEAD_UNITS))
			{
				particle.startLifetime = Vector3.Distance(soleTracerGraphics.Tracer.transform.position, hitInfo.point) / soleTracerGraphics.Tracer.startSpeed;
			}
			else
			{
				particle.startLifetime = startLifetime;
			}
			if (particle.startLifetime > soleTracerGraphics.MaxTime)
			{
				particle.velocity *= particle.startLifetime / soleTracerGraphics.MaxTime;
				particle.startLifetime = soleTracerGraphics.MaxTime;
			}
			particle.remainingLifetime = particle.startLifetime;
			soleTracerGraphics.Tracer.Emit(particle);
		}
	}
}
