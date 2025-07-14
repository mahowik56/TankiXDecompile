using Platform.Kernel.ECS.ClientEntitySystem.API;
using TMPro;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;

namespace Tanks.Lobby.ClientPaymentGUI.Impl
{
	public class PersonalXCrystalBonusUIComponent : LocalizedControl, Platform.Kernel.ECS.ClientEntitySystem.API.Component
	{
		[SerializeField]
		private TextMeshProUGUI description;

		public string Description
		{
			set
			{
				description.text = value;
			}
		}
	}
}
