using TMPro;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;
using UnityEngine.UI;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class PlayerStatInfoUI : MonoBehaviour
	{
		[SerializeField]
		private ImageListSkin imageListSkin;

		[SerializeField]
		private TextMeshProUGUI uid;

		[SerializeField]
		private ImageListSkin league;

		[SerializeField]
		private ImageSkin avatar;

		[SerializeField]
		private Text containerLeftMultiplicator;

		[SerializeField]
		private TextMeshProUGUI hull;

		[SerializeField]
		private TextMeshProUGUI turret;

		[SerializeField]
		private TextMeshProUGUI kills;

		[SerializeField]
		private TextMeshProUGUI score;

		[SerializeField]
		private Button interactionsButton;

		[HideInInspector]
		public long userId;

		[HideInInspector]
		public long battleId;

		[SerializeField]
		private Text containerRightMultiplicator;

		public void Init(int leagueIndex, string uid, int kills, int deaths, int assists, int score, Color uidColor, long hullId, long turretId, long userId, long battleId, string avatarId, bool isSelf, bool isDm, bool isFriend, bool containerLeft, bool containerRight = false)
		{
			this.uid.color = uidColor;
			avatar.SpriteUid = avatarId;
			this.uid.text = uid.Replace("botxz_", string.Empty);
			if (isFriend)
			{
				this.uid.text = "<b>" + this.uid.text + "</b>";
			}
			league.SelectedSpriteIndex = leagueIndex;
			if (isDm)
			{
				this.kills.text = string.Format("{0}/{1}", kills, deaths);
			}
			else
			{
				this.kills.text = string.Format("{0}/{1}/{2}", kills, assists, deaths);
			}
			hull.text = "<sprite name=\"" + hullId + "\">";
			turret.text = "<sprite name=\"" + turretId + "\">";
			this.userId = userId;
			this.battleId = battleId;
			if (this.score != null)
			{
				this.score.text = score.ToStringSeparatedByThousands();
			}
			SetButtonState(isSelf);
		}

		private void SetButtonState(bool isSelf)
		{
			if (interactionsButton != null)
			{
				interactionsButton.interactable = !isSelf;
			}
			else
			{
				Debug.LogError("Button reference wasn't set in " + base.gameObject.name);
			}
		}
	}
}
