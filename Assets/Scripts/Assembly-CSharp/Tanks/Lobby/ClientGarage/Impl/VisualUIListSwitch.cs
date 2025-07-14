using UnityEngine;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class VisualUIListSwitch : MonoBehaviour
	{
		public void Switch()
		{
			GetComponentInParent<VisualUI>().Switch();
		}

		public void Animate()
		{
			if (base.gameObject.activeInHierarchy)
			{
				GetComponent<Animator>().SetTrigger("switch");
			}
		}

		public void OnEnable()
		{
			GetComponent<Animator>().SetTrigger("switch");
		}
	}
}
