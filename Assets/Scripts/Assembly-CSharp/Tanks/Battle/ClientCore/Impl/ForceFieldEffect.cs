using UnityEngine;

namespace Tanks.Battle.ClientCore.Impl
{
	public class ForceFieldEffect : MonoBehaviour
	{
		public float alpha = 1f;

		public MeshCollider outerMeshCollider;

		public MeshCollider innerMeshCollider;

		public MeshRenderer meshRenderer;

		public DomeWaveGenerator waveGenerator;

		public Material enemyMaterial;

		[SerializeField]
		private AudioSource hitSourceAsset;

		[SerializeField]
		private AudioClip[] hitClips;

		private Camera _cachedCamera;

		private Animator _animator;

		public Camera CachedCamera
		{
			get
			{
				if (!_cachedCamera)
				{
					_cachedCamera = Camera.main;
				}
				return _cachedCamera;
			}
		}

		private void Awake()
		{
			_animator = GetComponent<Animator>();
			waveGenerator.Init();
		}

		public void LateUpdate()
		{
			meshRenderer.material.SetFloat("_MainAlpha", alpha);
		}

		public void SetLayer(int layer)
		{
			base.gameObject.layer = layer;
			outerMeshCollider.gameObject.layer = layer;
			innerMeshCollider.gameObject.layer = layer;
		}

		public void SwitchToEnemyView()
		{
			meshRenderer.material = enemyMaterial;
			waveGenerator.Init();
		}

		public void Show()
		{
			meshRenderer.material.SetFloat("_MainAlpha", 0f);
			if (CachedCamera != null)
			{
				meshRenderer.material.shader.maximumLOD = ((CachedCamera.depthTextureMode != DepthTextureMode.None) ? 300 : 150);
			}
			_animator.SetTrigger("show");
			outerMeshCollider.enabled = true;
			innerMeshCollider.enabled = true;
		}

		public void Hide()
		{
			_animator.SetTrigger("hide");
			outerMeshCollider.enabled = false;
			innerMeshCollider.enabled = false;
		}

		public void DrawWave(Vector3 hitPoint, bool playSound)
		{
			waveGenerator.GenerateWave(hitPoint);
			if (playSound)
			{
				InstantiateSound(hitPoint);
			}
		}

		private void InstantiateSound(Vector3 point)
		{
			AudioSource audioSource = Object.Instantiate(hitSourceAsset);
			int num = Random.Range(0, hitClips.Length);
			AudioClip audioClip = (audioSource.clip = hitClips[num]);
			audioSource.transform.position = point;
			audioSource.transform.rotation = Quaternion.identity;
			audioSource.Play();
			Object.DestroyObject(audioSource.gameObject, audioClip.length + 0.3f);
		}

		private void OnEffectHidden()
		{
			Object.DestroyObject(base.gameObject);
		}
	}
}
