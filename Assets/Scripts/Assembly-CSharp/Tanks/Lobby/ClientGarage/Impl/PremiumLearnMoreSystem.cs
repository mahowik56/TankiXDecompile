using System.Collections.Generic;
using System.Linq;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientUnityIntegration.API;
using Tanks.Lobby.ClientNavigation.API;
using Tanks.Lobby.ClientPayment.API;
using Tanks.Lobby.ClientPayment.Impl;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class PremiumLearnMoreSystem : ECSSystem
	{
		public class GoodsNode : Node
		{
			public PremiumOfferComponent premiumOffer;

			public CountableItemsPackComponent countableItemsPack;

			public SpecialOfferContentLocalizationComponent specialOfferContentLocalization;

			public OrderItemComponent orderItem;
		}

		private class PremiumGoodsNodeComparer : IComparer<GoodsNode>
		{
			public int Compare(GoodsNode a, GoodsNode b)
			{
				return a.orderItem.Index.CompareTo(b.orderItem.Index);
			}
		}

		[OnEventFire]
		public void ShowInfoDialog(ButtonClickEvent e, SingleNode<PremiumLearnMoreButtonComponent> button, [JoinAll] SingleNode<Dialogs60Component> dialogs60)
		{
			PremiumLearnMoreComponent premiumLearnMoreComponent = dialogs60.component.Get<PremiumLearnMoreComponent>();
			premiumLearnMoreComponent.tabManager.index = button.component.idx;
			premiumLearnMoreComponent.Show();
		}

		[OnEventFire]
		public void FillInfoElements(NodeAddedEvent e, SingleNode<PremiumLearnMoreComponent> infoUi, [JoinAll] ICollection<GoodsNode> goods, [JoinAll] PremiumUiShopSystem.BaseUserNode selfUser)
		{
			List<GoodsNode> list = new List<GoodsNode>();
			SelectGoods(goods, selfUser, list);
			list.Sort(new PremiumGoodsNodeComparer());
			FillElements(list, infoUi);
		}

		private void FillElements(List<GoodsNode> sortedGoods, SingleNode<PremiumLearnMoreComponent> infoUi)
		{
			for (int i = 0; i < sortedGoods.Count; i++)
			{
				FillUiElement(sortedGoods.ElementAt(i), infoUi.component.uiElements[i]);
			}
		}

		private void FillUiElement(GoodsNode sortedGoods, PremiumInfoUiElement infoUi)
		{
			string text = sortedGoods.countableItemsPack.Pack.First().Value.ToString();
			string description = sortedGoods.specialOfferContentLocalization.Description;
			bool flag = sortedGoods.countableItemsPack.Pack.ContainsKey(-180272377L);
			string text2 = ((!flag) ? string.Empty : "+");
			infoUi.daysText.text = text + " " + description + " " + text2;
			infoUi.crystalObject.SetActive(flag);
			infoUi.tabCrystalObject.SetActive(flag);
		}

		private static void SelectGoods(ICollection<GoodsNode> goods, PremiumUiShopSystem.BaseUserNode selfUser, List<GoodsNode> sortedGoods)
		{
			int rank = selfUser.userRank.Rank;
			foreach (GoodsNode good in goods)
			{
				int minRank = good.premiumOffer.MinRank;
				int maxRank = good.premiumOffer.MaxRank;
				if (rank >= minRank && rank < maxRank)
				{
					sortedGoods.Add(good);
				}
			}
		}
	}
}
