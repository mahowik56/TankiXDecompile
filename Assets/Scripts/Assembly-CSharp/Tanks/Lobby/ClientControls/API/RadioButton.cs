using UnityEngine;
using UnityEngine.UI;

namespace Tanks.Lobby.ClientControls.API
{
	public class RadioButton : MonoBehaviour
	{
		[SerializeField]
		private GameObject inactiveHighlight;

		public Selectable Selectable
		{
			get
			{
				return GetComponent<Selectable>();
			}
		}

		public virtual void Activate()
		{
			Selectable.interactable = false;
			inactiveHighlight.SetActive(true);
			foreach (Transform item in base.transform.parent)
			{
				if (!(item == base.transform))
				{
					RadioButton component = item.GetComponent<RadioButton>();
					if (component != null)
					{
						component.Deactivate();
					}
				}
			}
		}

		public virtual void Deactivate()
		{
			Selectable.interactable = true;
			inactiveHighlight.SetActive(false);
			Selectable.OnPointerExit(null);
		}
	}
}
