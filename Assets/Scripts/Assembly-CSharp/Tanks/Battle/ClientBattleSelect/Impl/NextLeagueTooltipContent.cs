using TMPro;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;

namespace Tanks.Battle.ClientBattleSelect.Impl
{
	public class NextLeagueTooltipContent : MonoBehaviour, ITooltipContent
	{
		[SerializeField]
		private TextMeshProUGUI text;

		[SerializeField]
		private ImageSkin leagueIcon;

		[SerializeField]
		private TextMeshProUGUI leagueName;

		[SerializeField]
		private LocalizedField leaguePointsText;

		[SerializeField]
		private LocalizedField leagueNameText;

		public void Init(object data)
		{
			NextLeagueTooltipData nextLeagueTooltipData = data as NextLeagueTooltipData;
			if (!string.IsNullOrEmpty(nextLeagueTooltipData.unfairMM))
			{
				text.text = nextLeagueTooltipData.unfairMM + "\n";
			}
			text.text += string.Format(leaguePointsText, nextLeagueTooltipData.points);
			leagueIcon.SpriteUid = nextLeagueTooltipData.icon;
			leagueName.text = string.Format(leagueNameText, nextLeagueTooltipData.name);
		}
	}
}
