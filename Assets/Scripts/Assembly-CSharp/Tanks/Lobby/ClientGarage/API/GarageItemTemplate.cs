using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;

namespace Tanks.Lobby.ClientGarage.API
{
	[SerialVersionUID(635901897247007499L)]
	public interface GarageItemTemplate : Template
	{
		[AutoAdded]
		GarageItemComponent garageItem();

		[AutoAdded]
		[PersistentConfig("", false)]
		DescriptionItemComponent descriptionItem();

		[AutoAdded]
		[PersistentConfig("order", false)]
		OrderItemComponent OrderItem();

		[AutoAdded]
		[PersistentConfig("default", true)]
		DefaultItemComponent defaultItem();
	}
}
