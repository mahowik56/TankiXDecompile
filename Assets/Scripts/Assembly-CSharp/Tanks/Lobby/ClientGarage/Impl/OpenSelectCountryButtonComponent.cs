using Platform.Library.ClientUnityIntegration.API;
using TMPro;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class OpenSelectCountryButtonComponent : BehaviourComponent
	{
		[SerializeField]
		private TextMeshProUGUI buttonTitle;

		[SerializeField]
		private LocalizedField country;

		public string CountryCode
		{
			set
			{
				buttonTitle.text = country.Value + ": " + value;
			}
		}
	}
}
