using Tanks.Battle.ClientCore.API;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	[RequireComponent(typeof(ParticleSystem))]
	public class MuzzleFlashAdjustBehaviour : MonoBehaviour
	{
		private const float FAR_FLASH_DISTANCE = 10f;

		[SerializeField]
		private ParticleSystem[] systems;

		private float[] startSizes;

		private float[] startSpeeds;

		private ParticleSystem effect;

		private void Awake()
		{
			effect = GetComponent<ParticleSystem>();
			startSizes = new float[systems.Length];
			for (int i = 0; i < systems.Length; i++)
			{
				startSizes[i] = systems[i].startSize;
			}
			startSpeeds = new float[systems.Length];
			for (int j = 0; j < systems.Length; j++)
			{
				startSpeeds[j] = systems[j].startSpeed;
			}
		}

		private void OnEnable()
		{
			float[] systemsScales = GetSystemsScales();
			for (int i = 0; i < systems.Length; i++)
			{
				UpdateSystem(systems[i], systemsScales[i], startSizes[i], startSpeeds[i]);
			}
			effect.Play(true);
			for (int j = 0; j < systems.Length; j++)
			{
				UpdateParticles(systems[j], systemsScales[j]);
			}
		}

		private void OnDisable()
		{
			effect.Stop(true);
		}

		private float[] GetSystemsScales()
		{
			float num = float.PositiveInfinity;
			Ray ray = new Ray(base.transform.position, base.transform.forward);
			RaycastHit hitInfo;
			if (Physics.Raycast(ray, out hitInfo, 10f, LayerMasks.VISUAL_TARGETING))
			{
				num = hitInfo.distance;
			}
			float[] array = new float[systems.Length];
			for (int i = 0; i < systems.Length; i++)
			{
				ParticleSystem particleSystem = systems[i];
				ParticleSystemRenderer component = particleSystem.GetComponent<ParticleSystemRenderer>();
				float num2 = particleSystem.startSpeed * particleSystem.startLifetime;
				num2 = ((component.renderMode != ParticleSystemRenderMode.Stretch) ? (num2 + particleSystem.startSize * 0.5f) : (num2 + particleSystem.startSize * 0.5f * Mathf.Abs(component.lengthScale)));
				float num3 = Vector3.Distance(base.transform.position, particleSystem.transform.position);
				array[i] = Mathf.Clamp01((num - num3) / num2);
			}
			return array;
		}

		private void UpdateSystem(ParticleSystem system, float scale, float size, float speed)
		{
			system.startSize = size * (1f + scale) / 2f;
			system.startSpeed = speed * scale;
			system.startColor *= new Color(1f, 1f, 1f, scale * scale);
		}

		private void UpdateParticles(ParticleSystem system, float scale)
		{
			ParticleSystem.Particle[] array = new ParticleSystem.Particle[system.particleCount];
			system.GetParticles(array);
			if (system.simulationSpace == ParticleSystemSimulationSpace.Local)
			{
				for (int i = 0; i < array.Length; i++)
				{
					array[i].position = array[i].position * scale;
				}
			}
			else
			{
				for (int j = 0; j < array.Length; j++)
				{
					array[j].position = base.transform.position + (array[j].position - base.transform.position) * scale;
				}
			}
			system.SetParticles(array, array.Length);
		}
	}
}
