using Platform.Library.ClientUnityIntegration.API;
using TMPro;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;
using UnityEngine.UI;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class MountModuleButtonComponent : BehaviourComponent
	{
		[SerializeField]
		private LocalizedField mountButtonLocalizedField;

		[SerializeField]
		private LocalizedField unmountButtonLocalizedField;

		public bool mount = true;

		public bool mountButtonActive
		{
			set
			{
				GetComponent<Button>().interactable = value;
				GetComponent<CanvasGroup>().alpha = ((!value) ? 0.2f : 1f);
			}
		}

		public void SetEquipButtonState(int selectedSlot, bool selectedModuleMounted)
		{
			string text = ((!selectedModuleMounted) ? mountButtonLocalizedField.Value : unmountButtonLocalizedField.Value);
			mount = !selectedModuleMounted;
			GetComponentInChildren<TextMeshProUGUI>().text = text.Replace("{0}", (selectedSlot + 1).ToString());
		}
	}
}
