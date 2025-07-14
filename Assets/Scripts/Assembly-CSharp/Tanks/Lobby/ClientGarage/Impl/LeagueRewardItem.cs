using TMPro;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class LeagueRewardItem : MonoBehaviour
	{
		[SerializeField]
		private ImageSkin itemIcon;

		[SerializeField]
		private TextMeshProUGUI info;

		public string Text
		{
			set
			{
				info.text = value;
			}
		}

		public string Icon
		{
			set
			{
				itemIcon.SpriteUid = value;
			}
		}
	}
}
