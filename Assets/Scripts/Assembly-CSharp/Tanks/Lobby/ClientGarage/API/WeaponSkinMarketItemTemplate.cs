using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;

namespace Tanks.Lobby.ClientGarage.API
{
	[SerialVersionUID(1469607574709L)]
	public interface WeaponSkinMarketItemTemplate : WeaponSkinItemTemplate, SkinMarketItemTemplate, Template, SkinItemTemplate, MarketItemTemplate, GarageItemImagedTemplate, GarageItemTemplate, ItemImagedTemplate
	{
	}
}
