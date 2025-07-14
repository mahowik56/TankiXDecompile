using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;
using Tanks.Lobby.ClientPaymentGUI.Impl;

namespace Tanks.Lobby.ClientPayment.API
{
	[SerialVersionUID(1455105039782L)]
	public interface PaymentSectionTemplate : Template
	{
		[AutoAdded]
		[PersistentConfig("", false)]
		ExchangeRateComponent exchangeRate();

		[AutoAdded]
		[PersistentConfig("", false)]
		PacksImagesComponent packsImages();
	}
}
