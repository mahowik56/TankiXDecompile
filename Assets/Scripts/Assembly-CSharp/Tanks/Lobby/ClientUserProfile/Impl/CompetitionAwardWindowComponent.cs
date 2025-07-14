using Platform.Library.ClientUnityIntegration.API;
using TMPro;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;

namespace Tanks.Lobby.ClientUserProfile.Impl
{
	public class CompetitionAwardWindowComponent : BehaviourComponent
	{
		[SerializeField]
		private TextMeshProUGUI _fractionNameText;

		[SerializeField]
		private TextMeshProUGUI _fractionRewardDescriptionText;

		[SerializeField]
		private ImageSkin _fractionRewardImage;

		public string FractionName
		{
			set
			{
				_fractionNameText.text = value;
			}
		}

		public Color FractionColor
		{
			set
			{
				_fractionNameText.color = value;
			}
		}

		public string FractionRewardDescription
		{
			set
			{
				_fractionRewardDescriptionText.text = value;
			}
		}

		public string RewardImageUid
		{
			set
			{
				_fractionRewardImage.SpriteUid = value;
			}
		}
	}
}
