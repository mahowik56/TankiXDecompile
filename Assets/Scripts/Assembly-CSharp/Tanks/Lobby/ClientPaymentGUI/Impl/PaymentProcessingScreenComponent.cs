using Tanks.Lobby.ClientNavigation.API;
using UnityEngine;
using UnityEngine.UI;

namespace Tanks.Lobby.ClientPaymentGUI.Impl
{
	public class PaymentProcessingScreenComponent : LocalizedScreenComponent, PaymentScreen
	{
		[SerializeField]
		private Text info;

		public virtual string Info
		{
			set
			{
				info.text = value;
			}
		}
	}
}
