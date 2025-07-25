using Platform.Library.ClientUnityIntegration.API;
using TMPro;
using Tanks.Lobby.ClientControls.API;

namespace Tanks.Lobby.ClientPaymentGUI.Impl.TankRent
{
	public class NumberOfBattlesLeftUIComponent : BehaviourComponent
	{
		public TextMeshProUGUI text;

		public LocalizedField numberOfBattlesText;

		public void DisplayBattlesLeft(int numberOfBattlesLeft)
		{
			text.text = string.Format("{0} {1}", numberOfBattlesText.Value, numberOfBattlesLeft);
		}
	}
}
