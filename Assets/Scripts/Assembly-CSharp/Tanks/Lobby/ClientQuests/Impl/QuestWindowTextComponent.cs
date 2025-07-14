using TMPro;
using Tanks.Lobby.ClientNavigation.API;
using UnityEngine;

namespace Tanks.Lobby.ClientQuests.Impl
{
	public class QuestWindowTextComponent : LocalizedScreenComponent
	{
		[SerializeField]
		private TextMeshProUGUI closeButton;

		public string CloseButton
		{
			set
			{
				closeButton.text = value;
			}
		}
	}
}
