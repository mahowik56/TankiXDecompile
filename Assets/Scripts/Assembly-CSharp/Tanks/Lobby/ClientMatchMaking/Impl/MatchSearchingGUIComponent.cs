using Platform.Library.ClientUnityIntegration.API;
using TMPro;
using Tanks.Lobby.ClientControls.API;

namespace Tanks.Lobby.ClientMatchMaking.Impl
{
	public class MatchSearchingGUIComponent : BehaviourComponent
	{
		public LocalizedField newbieSearchTime;

		public LocalizedField regularSearchTime;

		public TextMeshProUGUI text;

		public void SetWaitingTime(bool newbieMode)
		{
			if (newbieMode)
			{
				text.text = newbieSearchTime.Value;
			}
			else
			{
				text.text = regularSearchTime.Value;
			}
		}
	}
}
