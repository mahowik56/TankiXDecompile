using UnityEngine;
using UnityEngine.EventSystems;

namespace Tanks.Lobby.ClientControls.Impl
{
	public class ButtonSmoke : UIBehaviour
	{
		[SerializeField]
		private ParticleSystem smoke;

		public void Play()
		{
			if (!(smoke == null))
			{
				smoke.Play();
			}
		}

		protected override void Start()
		{
			if (QualitySettings.GetQualityLevel() < 3)
			{
				GetComponent<Animator>().SetLayerWeight(1, 0f);
			}
			OnRectTransformDimensionsChange();
		}

		public void Stop()
		{
			if (!(smoke == null))
			{
				smoke.Stop();
			}
		}

		protected override void OnRectTransformDimensionsChange()
		{
			if (!(smoke == null))
			{
				smoke.transform.localScale = new Vector3(((RectTransform)base.transform).rect.width / 2f, 1f, 1f);
			}
		}
	}
}
