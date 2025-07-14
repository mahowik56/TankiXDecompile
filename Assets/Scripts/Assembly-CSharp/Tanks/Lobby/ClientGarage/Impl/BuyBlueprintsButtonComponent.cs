using Platform.Library.ClientUnityIntegration.API;
using TMPro;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;
using UnityEngine.UI;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class BuyBlueprintsButtonComponent : BehaviourComponent
	{
		[SerializeField]
		private TextMeshProUGUI titleText;

		[SerializeField]
		private LocalizedField buyBlueprintButtonLocalizedField;

		public bool mountButtonActive
		{
			set
			{
				GetComponent<Button>().interactable = value;
				GetComponent<CanvasGroup>().alpha = ((!value) ? 0.2f : 1f);
			}
		}
	}
}
