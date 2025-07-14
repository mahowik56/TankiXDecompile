using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientUnityIntegration.API;
using Tanks.Battle.ClientCore.API;
using Tanks.Battle.ClientCore.Impl;
using Tanks.Battle.ClientGraphics.API;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class PelletThrowingGraphicsSystem : ECSSystem
	{
		public class PelletThrowingGraphicsInitNode : Node
		{
			public MuzzlePointComponent muzzlePoint;

			public PelletThrowingGraphicsComponent pelletThrowingGraphics;
		}

		public class PelletThrowingGraphicsNode : Node
		{
			public PelletThrowingGraphicsReadyComponent pelletThrowingGraphicsReady;

			public PelletThrowingGraphicsComponent pelletThrowingGraphics;

			public HammerPelletConeComponent hammerPelletCone;

			public MuzzlePointComponent muzzlePoint;

			public DamageWeakeningByDistanceComponent damageWeakeningByDistance;

			public WeaponUnblockedComponent weaponUnblocked;
		}

		[OnEventFire]
		public void Init(NodeAddedEvent evt, PelletThrowingGraphicsInitNode node)
		{
			MuzzlePointComponent muzzlePoint = node.muzzlePoint;
			PelletThrowingGraphicsComponent pelletThrowingGraphics = node.pelletThrowingGraphics;
			pelletThrowingGraphics.Trails = InstantiateAndInherit(muzzlePoint, pelletThrowingGraphics.Trails);
			pelletThrowingGraphics.Hits = InstantiateAndInherit(muzzlePoint, pelletThrowingGraphics.Hits);
			CustomRenderQueue.SetQueue(pelletThrowingGraphics.gameObject, 3150);
			node.Entity.AddComponent<PelletThrowingGraphicsReadyComponent>();
		}

		[OnEventFire]
		public void InstantiatePellets(SelfHammerShotEvent evt, PelletThrowingGraphicsNode weapon)
		{
			InstantiatePelletsByBaseEvent(evt.ShotDirection, weapon);
		}

		[OnEventFire]
		public void InstantiatePellets(RemoteHammerShotEvent evt, PelletThrowingGraphicsNode weapon)
		{
			weapon.hammerPelletCone.ShotSeed = evt.RandomSeed;
			InstantiatePelletsByBaseEvent(evt.ShotDirection, weapon);
		}

		private static void InstantiatePelletsByBaseEvent(Vector3 shotDirection, PelletThrowingGraphicsNode weapon)
		{
			MuzzlePointComponent muzzlePoint = weapon.muzzlePoint;
			PelletThrowingGraphicsComponent pelletThrowingGraphics = weapon.pelletThrowingGraphics;
			float radiusOfMinDamage = weapon.damageWeakeningByDistance.RadiusOfMinDamage;
			float constant = pelletThrowingGraphics.Trails.main.startSpeed.constant;
			float startLifetime = radiusOfMinDamage / constant;
			ParticleSystem.EmitParams emitParams = new ParticleSystem.EmitParams
			{
				position = pelletThrowingGraphics.Trails.transform.position,
				startColor = pelletThrowingGraphics.Trails.main.startColor.color,
				startSize = pelletThrowingGraphics.Trails.main.startSizeMultiplier
			};
			ParticleSystem.EmitParams emitParams2 = new ParticleSystem.EmitParams
			{
				startColor = pelletThrowingGraphics.Hits.main.startColor.color,
				startSize = pelletThrowingGraphics.Hits.main.startSizeMultiplier
			};
			Vector3 localDirection = muzzlePoint.Current.InverseTransformVector(shotDirection);
			Vector3[] randomDirections = PelletDirectionsCalculator.GetRandomDirections(weapon.hammerPelletCone, muzzlePoint.Current.rotation, localDirection);
			Vector3[] array = randomDirections;
			foreach (Vector3 vector in array)
			{
				if (pelletThrowingGraphics.Trails.main.startColor.mode == ParticleSystemGradientMode.RandomColor)
				{
					emitParams.startColor = pelletThrowingGraphics.Trails.main.startColor.Evaluate(Random.Range(0f, 1f));
				}
				emitParams.randomSeed = (uint)(Random.value * 4.2949673E+09f);
				emitParams.velocity = vector * constant;
				RaycastHit hitInfo;
				if (Physics.Raycast(pelletThrowingGraphics.Trails.transform.position, vector, out hitInfo, radiusOfMinDamage, LayerMasks.GUN_TARGETING_WITH_DEAD_UNITS))
				{
					emitParams.startLifetime = Vector3.Distance(pelletThrowingGraphics.Trails.transform.position, hitInfo.point) / constant;
					emitParams2.startLifetime = Random.Range(pelletThrowingGraphics.SparklesMinLifetime, pelletThrowingGraphics.SparklesMaxLifetime);
					emitParams2.randomSeed = (uint)(Random.value * 4.2949673E+09f);
					emitParams2.position = hitInfo.point;
					emitParams2.velocity = Random.onUnitSphere;
					emitParams2.velocity *= Mathf.Sign(Vector3.Dot(emitParams2.velocity, hitInfo.normal)) * pelletThrowingGraphics.HitReflectVeolcity;
					pelletThrowingGraphics.Hits.Emit(emitParams2, 1);
				}
				else
				{
					emitParams.startLifetime = startLifetime;
				}
				pelletThrowingGraphics.Trails.Emit(emitParams, 1);
			}
		}

		private static ParticleSystem InstantiateAndInherit(MuzzlePointComponent muzzlePoint, ParticleSystem prefab)
		{
			ParticleSystem particleSystem = Object.Instantiate(prefab);
			UnityUtil.InheritAndEmplace(particleSystem.transform, muzzlePoint.Current);
			return particleSystem;
		}
	}
}
