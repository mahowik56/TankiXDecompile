using Platform.Kernel.ECS.ClientEntitySystem.API;
using TMPro;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class PlayScreenSeasonGUIComponent : TextTimerComponent, Platform.Kernel.ECS.ClientEntitySystem.API.Component
	{
		[SerializeField]
		private LocalizedField seasonNumberTextLocalization;

		[SerializeField]
		private TextMeshProUGUI seasonNumberText;

		public void SetSeasonNameFromNumber(long number)
		{
			seasonNumberText.text = string.Format(seasonNumberTextLocalization.Value, number);
		}

		public void SetSeasonName(string seasonName)
		{
			seasonNumberText.text = seasonName;
		}
	}
}
