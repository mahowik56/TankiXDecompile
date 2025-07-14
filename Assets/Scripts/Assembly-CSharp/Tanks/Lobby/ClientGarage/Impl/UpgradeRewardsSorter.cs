using System.Collections.Generic;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Kernel.ECS.ClientEntitySystem.Impl;
using Tanks.Lobby.ClientControls.API;
using Tanks.Lobby.ClientGarage.API;
using UnityEngine;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class UpgradeRewardsSorter : MonoBehaviour, SimpleHorizontalListItemsSorter, IComparer<ListItem>
	{
		public void Sort(ItemsMap items)
		{
			items.Sort(this);
		}

		public int Compare(ListItem x, ListItem y)
		{
			Entity entity = x.Data as Entity;
			Entity entity2 = y.Data as Entity;
			if (entity == null || entity2 == null)
			{
				return 0;
			}
			AbstractRestrictionComponent restriction = GetRestriction(entity);
			AbstractRestrictionComponent restriction2 = GetRestriction(entity2);
			if (restriction == null && restriction2 == null)
			{
				return 0;
			}
			if (restriction == null)
			{
				return -1;
			}
			if (restriction2 == null)
			{
				return 1;
			}
			return restriction.RestrictionValue.CompareTo(restriction2.RestrictionValue);
		}

		private AbstractRestrictionComponent GetRestriction(Entity entity)
		{
			AbstractRestrictionComponent result = null;
			if (entity.HasComponent<PurchaseUpgradeLevelRestrictionComponent>())
			{
				result = entity.GetComponent<PurchaseUpgradeLevelRestrictionComponent>();
				if (result.RestrictionValue > 0)
				{
					return result;
				}
				result = null;
			}
			if (entity.HasComponent<MountUpgradeLevelRestrictionComponent>())
			{
				result = entity.GetComponent<MountUpgradeLevelRestrictionComponent>();
				if (result.RestrictionValue > 0)
				{
					return result;
				}
				result = null;
			}
			if (entity.HasComponent<UserItemComponent>() && entity.HasComponent<MarketItemGroupComponent>())
			{
				Entity entity2 = Flow.Current.EntityRegistry.GetEntity(entity.GetComponent<MarketItemGroupComponent>().Key);
				result = GetRestriction(entity2);
			}
			if (entity.HasComponent<SlotUserItemInfoComponent>())
			{
				MountUpgradeLevelRestrictionComponent mountUpgradeLevelRestrictionComponent = new MountUpgradeLevelRestrictionComponent();
				mountUpgradeLevelRestrictionComponent.RestrictionValue = entity.GetComponent<SlotUserItemInfoComponent>().UpgradeLevel;
				result = mountUpgradeLevelRestrictionComponent;
				if (result.RestrictionValue > 0)
				{
					return result;
				}
				result = null;
			}
			return result;
		}
	}
}
