using System;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Kernel.OSGi.ClientCore.API;
using Platform.Library.ClientResources.API;
using Tanks.Lobby.ClientControls.API;
using Tanks.Lobby.ClientEntrance.API;
using Tanks.Lobby.ClientGarage.API;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class GarageItem : IComparable<GarageItem>, IComparable
	{
		private Entity userItem;

		private Action onBought;

		private Action onMount;

		[Inject]
		public static EngineService EngineService { get; set; }

		public virtual Entity MarketItem { get; set; }

		public string ConfigPath { get; set; }

		public Entity UserItem
		{
			get
			{
				return userItem;
			}
			set
			{
				userItem = value;
				if (onBought != null)
				{
					onBought();
					onBought = null;
				}
			}
		}

		public string Preview { get; set; }

		public bool WaitForBuy { get; set; }

		public int PersonalSalePercent { get; set; }

		public int AdditionalPrice { get; set; }

		public string Name
		{
			get
			{
				return (MarketItem != null) ? MarketItem.GetComponent<DescriptionItemComponent>().Name : string.Empty;
			}
		}

		public string Description
		{
			get
			{
				return (MarketItem != null) ? MarketItem.GetComponent<DescriptionItemComponent>().Description : string.Empty;
			}
		}

		public ItemRarityType Rarity
		{
			get
			{
				if (MarketItem == null)
				{
					return ItemRarityType.COMMON;
				}
				return MarketItem.HasComponent<ItemRarityComponent>() ? MarketItem.GetComponent<ItemRarityComponent>().RarityType : ItemRarityType.COMMON;
			}
		}

		public bool IsRestricted
		{
			get
			{
				return (UserItem != null && UserItem.HasComponent<RestrictedByUpgradeLevelComponent>()) || (UserItem == null && RestrictionLevel > 0);
			}
		}

		public int RestrictionLevel
		{
			get
			{
				return MarketItem.HasComponent<MountUpgradeLevelRestrictionComponent>() ? MarketItem.GetComponent<MountUpgradeLevelRestrictionComponent>().RestrictionValue : 0;
			}
		}

		public bool IsSelected
		{
			get
			{
				return MarketItem.HasComponent<HangarItemPreviewComponent>() || (UserItem != null && UserItem.HasComponent<HangarItemPreviewComponent>());
			}
		}

		public bool IsBuyable
		{
			get
			{
				return Price > 0 || XPrice > 0;
			}
		}

		public int Price
		{
			get
			{
				return CalcPrice(MarketItem.GetComponent<PriceItemComponent>().Price);
			}
		}

		public int XPrice
		{
			get
			{
				return CalcPrice(MarketItem.GetComponent<XPriceItemComponent>().Price);
			}
		}

		public int OldPrice
		{
			get
			{
				PriceItemComponent component = MarketItem.GetComponent<PriceItemComponent>();
				return (component.OldPrice == 0) ? component.Price : component.OldPrice;
			}
		}

		public int OldXPrice
		{
			get
			{
				XPriceItemComponent component = MarketItem.GetComponent<XPriceItemComponent>();
				return (component.OldPrice == 0) ? component.Price : component.OldPrice;
			}
		}

		public bool IsContainerItem
		{
			get
			{
				return MarketItem.HasComponent<ContainerContentItemGroupComponent>();
			}
		}

		public bool IsMounted
		{
			get
			{
				return UserItem != null && UserItem.HasComponent<MountedItemComponent>();
			}
		}

		public bool IsVisualItem
		{
			get
			{
				if (MarketItem != null && (MarketItem.HasComponent<ShellItemComponent>() || MarketItem.HasComponent<SkinItemComponent>() || MarketItem.HasComponent<GraffitiItemComponent>() || MarketItem.HasComponent<WeaponPaintItemComponent>() || MarketItem.HasComponent<AvatarItemComponent>() || MarketItem.HasComponent<TankPaintItemComponent>()))
				{
					return true;
				}
				return false;
			}
		}

		public string AssertGuid
		{
			get
			{
				if (MarketItem != null)
				{
					return MarketItem.GetComponent<AssetReferenceComponent>().Reference.AssetGuid;
				}
				AssetReferenceComponent assetReferenceComponent = AssetReferenceComponent.createFromConfig(ConfigPath);
				return assetReferenceComponent.Reference.AssetGuid;
			}
		}

		private bool UserHasItem
		{
			get
			{
				if (UserItem != null)
				{
					return !UserItem.HasComponent<UserItemCounterComponent>() || UserItem.GetComponent<UserItemCounterComponent>().Count > 0;
				}
				return false;
			}
		}

		private bool IsSortItem
		{
			get
			{
				return MarketItem.HasComponent<GraffitiItemComponent>() || MarketItem.HasComponent<PaintItemComponent>() || MarketItem.HasComponent<SkinItemComponent>() || MarketItem.HasComponent<ShellItemComponent>() || MarketItem.HasComponent<AvatarItemComponent>() || (MarketItem.HasComponent<ContainerMarkerComponent>() && !MarketItem.HasComponent<GameplayChestItemComponent>());
			}
		}

		public void Mounted()
		{
			if (onMount != null)
			{
				onMount();
				onMount = null;
			}
		}

		private int CalcPrice(int price)
		{
			price += AdditionalPrice;
			if (PersonalSalePercent > 0)
			{
				return (int)((float)price / 100f * (float)(100 - PersonalSalePercent));
			}
			return price;
		}

		public void Buy(Action onBought)
		{
			this.onBought = onBought;
			BuyMarketItemEvent buyMarketItemEvent = new BuyMarketItemEvent();
			buyMarketItemEvent.Price = Price;
			buyMarketItemEvent.Amount = 1;
			BuyMarketItemEvent eventInstance = buyMarketItemEvent;
			EngineService.Engine.NewEvent(eventInstance).Attach(SelfUserComponent.SelfUser).Attach(MarketItem)
				.Schedule();
		}

		public void XBuy(Action onBought, int price, int amount)
		{
			this.onBought = onBought;
			XBuyMarketItemEvent xBuyMarketItemEvent = new XBuyMarketItemEvent();
			xBuyMarketItemEvent.Price = price;
			xBuyMarketItemEvent.Amount = amount;
			XBuyMarketItemEvent eventInstance = xBuyMarketItemEvent;
			EngineService.Engine.NewEvent(eventInstance).Attach(SelfUserComponent.SelfUser).Attach(MarketItem)
				.Schedule();
		}

		public void Mount(Action onMount = null)
		{
			if (!IsMounted)
			{
				EngineService.Engine.ScheduleEvent<MountItemEvent>(UserItem);
			}
		}

		public void Select()
		{
			EngineService.Engine.ScheduleEvent<ListItemSelectedEvent>(UserItem ?? MarketItem);
		}

		public int CompareTo(GarageItem other)
		{
			if (this == other)
			{
				return 0;
			}
			if (!MarketItem.HasComponent<GameplayChestItemComponent>() && UserHasItem && !other.UserHasItem)
			{
				return -1;
			}
			if (!MarketItem.HasComponent<GameplayChestItemComponent>() && !UserHasItem && other.UserHasItem)
			{
				return 1;
			}
			if (UserHasItem && other.UserHasItem && IsSortItem && other.IsSortItem)
			{
				if (UserItem.GetComponent<DefaultItemComponent>().Default)
				{
					return -1;
				}
				if (other.UserItem.GetComponent<DefaultItemComponent>().Default)
				{
					return 1;
				}
				if (!IsRestricted && other.IsRestricted)
				{
					return -1;
				}
				if (IsRestricted && !other.IsRestricted)
				{
					return 1;
				}
				return string.Compare(Name, other.Name, StringComparison.Ordinal);
			}
			if (IsSortItem && other.IsSortItem)
			{
				return string.Compare(Name, other.Name, StringComparison.Ordinal);
			}
			if (!MarketItem.HasComponent<OrderItemComponent>())
			{
				return -1;
			}
			if (!other.MarketItem.HasComponent<OrderItemComponent>())
			{
				return 1;
			}
			return MarketItem.GetComponent<OrderItemComponent>().Index.CompareTo(other.MarketItem.GetComponent<OrderItemComponent>().Index);
		}

		public int CompareByType(GarageItem other)
		{
			if (this == other)
			{
				return 0;
			}
			if (MarketItem.HasComponent<AvatarItemComponent>())
			{
				return -1;
			}
			if (other.MarketItem.HasComponent<AvatarItemComponent>())
			{
				return 1;
			}
			if (MarketItem.HasComponent<GraffitiItemComponent>())
			{
				return -1;
			}
			if (other.MarketItem.HasComponent<GraffitiItemComponent>())
			{
				return 1;
			}
			if (MarketItem.HasComponent<ShellItemComponent>())
			{
				return -1;
			}
			if (other.MarketItem.HasComponent<ShellItemComponent>())
			{
				return 1;
			}
			if (MarketItem.HasComponent<PaintItemComponent>())
			{
				return -1;
			}
			if (other.MarketItem.HasComponent<PaintItemComponent>())
			{
				return 1;
			}
			return CompareTo(other);
		}

		public int CompareTo(object obj)
		{
			if (!(obj is GarageItem))
			{
				return -1;
			}
			return CompareTo((GarageItem)obj);
		}
	}
}
