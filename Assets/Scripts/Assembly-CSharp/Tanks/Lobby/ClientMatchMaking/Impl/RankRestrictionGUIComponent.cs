using Platform.Library.ClientUnityIntegration.API;
using TMPro;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;

namespace Tanks.Lobby.ClientMatchMaking.Impl
{
	public class RankRestrictionGUIComponent : BehaviourComponent
	{
		[SerializeField]
		private TextMeshProUGUI rankName;

		[SerializeField]
		private ImageListSkin imageListSkin;

		public string RankName
		{
			set
			{
				rankName.text = value;
			}
		}

		public void SetRank(int rank)
		{
			imageListSkin.SelectSprite(rank.ToString());
		}
	}
}
