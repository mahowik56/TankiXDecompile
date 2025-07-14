using Platform.Library.ClientUnityIntegration.API;
using UnityEngine.UI;

namespace Tanks.Lobby.ClientBattleSelect.API
{
	public class BattleLevelsIndicatorComponent : BehaviourComponent
	{
		public void ShowText(string text)
		{
			base.gameObject.SetActive(true);
			GetComponent<Text>().text = text;
		}

		public void Hide()
		{
			base.gameObject.SetActive(false);
		}
	}
}
