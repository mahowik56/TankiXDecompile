using TMPro;
using Tanks.Lobby.ClientNavigation.API;
using UnityEngine;

namespace Tanks.Lobby.ClientEntrance.Impl
{
	public class RegistrationScreenLocalizedStringsComponent : LocalizedScreenComponent
	{
		[SerializeField]
		private TextMeshProUGUI finishButtonText;

		[SerializeField]
		private TextMeshProUGUI skipButtonText;

		[SerializeField]
		private TextMeshProUGUI nicknameHintText;

		[SerializeField]
		private TextMeshProUGUI passwordHintText;

		[SerializeField]
		private TextMeshProUGUI repeatPasswordHintText;

		[SerializeField]
		private TextMeshProUGUI iAcceptTermsPart1Text;

		[SerializeField]
		private TextMeshProUGUI iAcceptTermsPart2EULAText;

		[SerializeField]
		private TextMeshProUGUI iAcceptTermsPart4RulesText;

		[SerializeField]
		private TextMeshProUGUI iAcceptTermsPart5PrivacyPolicyText;

		public string Finish
		{
			set
			{
				finishButtonText.text = value;
			}
		}

		public string Skip
		{
			set
			{
				skipButtonText.text = value;
			}
		}

		public string Nickname
		{
			set
			{
				nicknameHintText.text = value;
			}
		}

		public string Password
		{
			set
			{
				passwordHintText.text = value;
			}
		}

		public string RepeatPassword
		{
			set
			{
				repeatPasswordHintText.text = value;
			}
		}

		public string IAcceptTermsPart1
		{
			set
			{
				iAcceptTermsPart1Text.text = value;
			}
		}

		public string IAcceptTermsPart2EULA
		{
			set
			{
				iAcceptTermsPart2EULAText.text = value;
			}
		}

		public string IAcceptTermsPart4Rules
		{
			set
			{
				iAcceptTermsPart4RulesText.text = value;
			}
		}

		public string IAcceptTermsPart5PrivacyPolicy
		{
			set
			{
				iAcceptTermsPart5PrivacyPolicyText.text = value;
			}
		}

		public string LicenseAgreementUrl { get; set; }

		public string GameRulesUrl { get; set; }

		public string PrivacyPolicyUrl { get; set; }
	}
}
