using Platform.Library.ClientUnityIntegration.API;
using UnityEngine.UI;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class UpgradeTeleportButtonComponent : BehaviourComponent
	{
		private void OnEnable()
		{
			GetComponent<Button>().interactable = true;
		}
	}
}
