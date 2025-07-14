using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;

namespace Tanks.Lobby.ClientGarage.API
{
	[SerialVersionUID(1436443339132L)]
	public interface TankPaintMarketItemTemplate : TankPaintItemTemplate, MarketItemTemplate, PaintItemTemplate, GarageItemImagedTemplate, GarageItemTemplate, ItemImagedTemplate, Template
	{
		[AutoAdded]
		[PersistentConfig("", false)]
		PurchaseUpgradeLevelRestrictionComponent purchaseUpgradeLevelRestriction();

		[AutoAdded]
		[PersistentConfig("", false)]
		PurchaseUserRankRestrictionComponent purchaseUserRankRestriction();
	}
}
