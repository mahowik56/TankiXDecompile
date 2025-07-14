using Platform.Library.ClientUnityIntegration.API;
using UnityEngine.UI;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class GetNewTeleportButtonComponent : BehaviourComponent
	{
		private void OnEnable()
		{
			GetComponent<Button>().interactable = true;
		}
	}
}
