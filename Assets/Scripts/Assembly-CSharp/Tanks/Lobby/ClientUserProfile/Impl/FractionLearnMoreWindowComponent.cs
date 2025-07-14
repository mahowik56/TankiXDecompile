using Platform.Library.ClientUnityIntegration.API;
using TMPro;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;

namespace Tanks.Lobby.ClientUserProfile.Impl
{
	public class FractionLearnMoreWindowComponent : BehaviourComponent
	{
		[SerializeField]
		private TextMeshProUGUI _competitionTitle;

		[SerializeField]
		private TextMeshProUGUI _competitionDescription;

		[SerializeField]
		private ImageSkin _competitionLogo;

		public string CompetitionTitle
		{
			set
			{
				_competitionTitle.text = value;
			}
		}

		public string CompetitionDescription
		{
			set
			{
				_competitionDescription.text = value;
			}
		}

		public string CompetitionLogoUid
		{
			set
			{
				_competitionLogo.SpriteUid = value;
			}
		}
	}
}
