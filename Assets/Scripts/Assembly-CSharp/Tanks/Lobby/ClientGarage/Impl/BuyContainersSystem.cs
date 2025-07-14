using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Lobby.ClientControls.API;
using Tanks.Lobby.ClientEntrance.API;
using Tanks.Lobby.ClientGarage.API;
using Tanks.Lobby.ClientNavigation.API;
using Tanks.Lobby.ClientProfile.API;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class BuyContainersSystem : ECSSystem
	{
		public class SelfUserNode : Node
		{
			public UserXCrystalsComponent userXCrystals;

			public UserMoneyComponent userMoney;

			public SelfUserComponent selfUser;
		}

		public class ButtonNode : Node
		{
			public PriceButtonComponent priceButton;

			public UniversalPriceButtonComponent universalPriceButton;

			public BuyContainerButtonComponent buyContainerButton;

			public ItemPackButtonComponent itemPackButton;
		}

		public class ContainerItemNode : Node
		{
			public ContainerMarkerComponent containerMarker;

			public MarketItemGroupComponent marketItemGroup;
		}

		public class ContainerUserItemNode : ContainerItemNode
		{
			public UserItemComponent userItem;
		}

		public class ContainerMarketItemNode : ContainerItemNode
		{
			public MarketItemComponent marketItem;
		}

		public class BuySelectedContainerItemEvent : Event
		{
		}

		[OnEventFire]
		public void BuyContainers(ConfirmButtonClickYesEvent e, ButtonNode buyButton, [JoinByScreen] SingleNode<SelectedItemComponent> selectedItem)
		{
			NewEvent<BuySelectedContainerItemEvent>().AttachAll(selectedItem.component.SelectedItem, buyButton.Entity).Schedule();
		}

		[OnEventFire]
		public void BuyContainers(BuySelectedContainerItemEvent evt, ButtonNode buyButton, ContainerUserItemNode containerUserItem, [JoinByMarketItem] ContainerMarketItemNode containerMarketItem, [JoinAll] SelfUserNode userNode)
		{
			if (buyButton.universalPriceButton.XPriceActivity)
			{
				NewEvent(new XBuyMarketItemEvent
				{
					Amount = buyButton.itemPackButton.Count,
					Price = (int)buyButton.priceButton.Price
				}).AttachAll(containerMarketItem.Entity, userNode.Entity).Schedule();
			}
			else if (buyButton.universalPriceButton.PriceActivity)
			{
				NewEvent(new BuyMarketItemEvent
				{
					Amount = buyButton.itemPackButton.Count,
					Price = (int)buyButton.priceButton.Price
				}).AttachAll(containerMarketItem.Entity, userNode.Entity).Schedule();
			}
		}
	}
}
