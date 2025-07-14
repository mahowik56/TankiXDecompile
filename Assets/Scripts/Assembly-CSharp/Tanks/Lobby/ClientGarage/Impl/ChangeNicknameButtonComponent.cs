using Platform.Library.ClientUnityIntegration.API;
using TMPro;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class ChangeNicknameButtonComponent : BehaviourComponent
	{
		[SerializeField]
		private TextMeshProUGUI price;

		[SerializeField]
		private PaletteColorField notEnoughColor;

		public bool Enough
		{
			set
			{
				if (value)
				{
					price.color = Color.white;
				}
				else
				{
					price.color = notEnoughColor.Color;
				}
			}
		}

		public string XPrice
		{
			set
			{
				price.text = value + "<sprite=9>";
			}
		}
	}
}
