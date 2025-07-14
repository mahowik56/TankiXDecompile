using TMPro;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class CantUseAllEnergyBonusDialog : ConfirmWindowComponent
	{
		[SerializeField]
		private TextMeshProUGUI question;

		[SerializeField]
		private LocalizedField questionText;

		public void SetEnergyCount(long energy)
		{
			question.text = string.Format(questionText.Value, energy);
		}
	}
}
