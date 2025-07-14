using System.Collections.Generic;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Kernel.OSGi.ClientCore.API;
using Platform.Library.ClientUnityIntegration.API;
using Tanks.Lobby.ClientGarage.API;
using Tanks.Lobby.ClientGarage.Impl;

namespace Tanks.Lobby.ClientBattleSelect.Impl
{
	public class LevelUpUnlockRewardSystem : ECSSystem
	{
		public class ScreenNode : Node
		{
			public BattleResultsAwardsScreenComponent battleResultsAwardsScreen;
		}

		public class LevelUpRewardNode : Node
		{
			public DescriptionItemComponent descriptionItem;

			public LevelUpUnlockRewardConfigComponent levelUpUnlockRewardConfig;
		}

		public class PersonalRewardNode : Node
		{
			public PersonalBattleRewardComponent personalBattleReward;

			public BattleRewardGroupComponent battleRewardGroup;

			public LevelUpUnlockPersonalRewardComponent levelUpUnlockPersonalReward;
		}

		[Inject]
		public static GarageItemsRegistry GarageItemsRegistry { get; set; }

		[OnEventFire]
		public void ShowLevelUpUnlockReward(ShowRewardEvent e, ScreenNode screen, PersonalRewardNode personalReward, [JoinBy(typeof(BattleRewardGroupComponent))] LevelUpRewardNode reward)
		{
			base.Log.DebugFormat("ShowLevelUpUnlockReward: reward={0}", personalReward.Entity.Id);
			List<SpecialOfferItem> items = new List<SpecialOfferItem>();
			personalReward.levelUpUnlockPersonalReward.Unlocked.ForEach(delegate(Entity unlockedItem)
			{
				GarageItem item = GarageItemsRegistry.GetItem<GarageItem>(unlockedItem.Id);
				string spriteUid = item.Preview;
				string title = item.Name;
				if (unlockedItem.HasComponent<SlotItemComponent>())
				{
					ModuleBehaviourType moduleBehaviourType = unlockedItem.GetComponent<SlotUserItemInfoComponent>().ModuleBehaviourType;
					TankPartModuleType tankPart = unlockedItem.GetComponent<SlotTankPartComponent>().TankPart;
					if (moduleBehaviourType == ModuleBehaviourType.ACTIVE)
					{
						spriteUid = reward.levelUpUnlockRewardConfig.ActiveSlotSpriteUid;
						title = ((tankPart != TankPartModuleType.TANK) ? reward.levelUpUnlockRewardConfig.ActiveSlotWeaponText : reward.levelUpUnlockRewardConfig.ActiveSlotHullText);
					}
					else
					{
						spriteUid = reward.levelUpUnlockRewardConfig.PassiveSlotSpriteUid;
						title = ((tankPart != TankPartModuleType.TANK) ? reward.levelUpUnlockRewardConfig.PassiveSlotWeaponText : reward.levelUpUnlockRewardConfig.PassiveSlotHullText);
					}
				}
				SpecialOfferItem item2 = new SpecialOfferItem(0, spriteUid, title);
				items.Add(item2);
			});
			BattleResultSpecialOfferUiComponent specialOfferUI = screen.battleResultsAwardsScreen.specialOfferUI;
			specialOfferUI.ShowContent(reward.descriptionItem.Name, reward.descriptionItem.Description, items);
			specialOfferUI.SetTakeRewardButton();
			specialOfferUI.Appear();
		}

		[OnEventFire]
		public void OnTakeReward(ButtonClickEvent e, SingleNode<SpecialOfferTakeRewardButtonComponent> button, [JoinAll] ScreenNode screen)
		{
			BattleResultSpecialOfferUiComponent specialOfferUI = screen.battleResultsAwardsScreen.specialOfferUI;
			specialOfferUI.DeactivateAllButtons();
		}
	}
}
