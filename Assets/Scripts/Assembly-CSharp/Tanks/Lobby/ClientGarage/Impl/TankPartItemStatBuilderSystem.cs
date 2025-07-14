using System.Collections.Generic;
using Lobby.ClientUserProfile.API;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Kernel.OSGi.ClientCore.API;
using Platform.Library.ClientDataStructures.API;
using Platform.Library.ClientUnityIntegration.API;
using Tanks.Lobby.ClientControls.API;
using Tanks.Lobby.ClientEntrance.API;
using Tanks.Lobby.ClientGarage.API;
using tanks.modules.lobby.ClientGarage.Scripts.Impl.NewModules.System;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class TankPartItemStatBuilderSystem : ECSSystem
	{
		public class ScreenNode : Node
		{
			public NewModulesScreenUIComponent newModulesScreenUi;
		}

		public class SlotNode : Node
		{
			public SlotUserItemInfoComponent slotUserItemInfo;

			public SlotTankPartComponent slotTankPart;
		}

		public class SelectedSlotNode : SlotNode
		{
			public ToggleListSelectedItemComponent toggleListSelectedItem;
		}

		public class ModuleItemNode : Node
		{
			public ModuleTierComponent moduleTier;

			public ModuleItemComponent moduleItem;

			public ModuleTankPartComponent moduleTankPart;
		}

		public class MountedModuleItemNode : ModuleItemNode
		{
			public MountedItemComponent mountedItem;

			public UserItemComponent userItem;

			public ModuleUpgradeLevelComponent moduleUpgradeLevel;
		}

		public class SelectedModuleNode : ModuleItemNode
		{
			public ToggleListSelectedItemComponent toggleListSelectedItem;
		}

		public class ModuleUpgradeConfigNode : Node
		{
			public ModuleUpgradablePowerConfigComponent moduleUpgradablePowerConfig;
		}

		public class MountedWeaponNode : Node
		{
			public WeaponItemComponent weaponItem;

			public MountedItemComponent mountedItem;

			public MarketItemGroupComponent marketItemGroup;
		}

		public class MountedHullNode : Node
		{
			public TankItemComponent tankItem;

			public MountedItemComponent mountedItem;

			public MarketItemGroupComponent marketItemGroup;
		}

		[Inject]
		public static GarageItemsRegistry GarageItemsRegistry { get; set; }

		[OnEventFire]
		public void CalculateWeaponUpgradeCoeff(CalculateTankPartUpgradeCoeffEvent e, SingleNode<WeaponItemComponent> weaponItemComponent, [JoinAll] SingleNode<SelfUserComponent> selfUser, [JoinByUser] ICollection<MountedModuleItemNode> mountedModules, [JoinAll] ICollection<SlotNode> slots, [JoinAll] ModuleUpgradeConfigNode moduleUpgradeConfig)
		{
			e.UpgradeCoeff = TankUpgradeUtils.CalculateUpgradeCoeff(GetTierAndLevelsDictionary(GetMountedModules(mountedModules, TankPartModuleType.WEAPON)), GetSlotsCount(slots, TankPartModuleType.WEAPON), moduleUpgradeConfig.moduleUpgradablePowerConfig);
		}

		[OnEventFire]
		public void CalculateHullUpgradeCoeff(CalculateTankPartUpgradeCoeffEvent e, SingleNode<TankItemComponent> tankItemComponent, [JoinAll] SingleNode<SelfUserComponent> selfUser, [JoinByUser] ICollection<MountedModuleItemNode> mountedModules, [JoinAll] ICollection<SlotNode> slots, [JoinAll] ModuleUpgradeConfigNode moduleUpgradeConfig)
		{
			e.UpgradeCoeff = TankUpgradeUtils.CalculateUpgradeCoeff(GetTierAndLevelsDictionary(GetMountedModules(mountedModules, TankPartModuleType.TANK)), GetSlotsCount(slots, TankPartModuleType.TANK), moduleUpgradeConfig.moduleUpgradablePowerConfig);
		}

		[OnEventFire]
		public void ModuleChanged(ModuleChangedEvent e, Node node, [JoinAll] SingleNode<SelectedHullUIComponent> selectedHullUI, [JoinAll] SingleNode<SelectedTurretUIComponent> selectedTurretUI, [JoinAll] SingleNode<SelectedPresetComponent> selectedPreset, [JoinByUser] ICollection<MountedModuleItemNode> mountedModules, [JoinAll] ICollection<SlotNode> slots, [JoinAll] ModuleUpgradeConfigNode moduleUpgradeConfig)
		{
			float stars = TankUpgradeUtils.CalculateUpgradeCoeff(GetTierAndLevelsDictionary(GetMountedModules(mountedModules, TankPartModuleType.TANK)), GetSlotsCount(slots, TankPartModuleType.TANK), moduleUpgradeConfig.moduleUpgradablePowerConfig);
			selectedHullUI.component.SetStars(stars);
			float stars2 = TankUpgradeUtils.CalculateUpgradeCoeff(GetTierAndLevelsDictionary(GetMountedModules(mountedModules, TankPartModuleType.WEAPON)), GetSlotsCount(slots, TankPartModuleType.WEAPON), moduleUpgradeConfig.moduleUpgradablePowerConfig);
			selectedTurretUI.component.SetStars(stars2);
		}

		[OnEventFire]
		public void SetTurretStars(NodeAddedEvent e, SingleNode<SelectedTurretUIComponent> selectedTurretUI, [Context] SingleNode<SelectedPresetComponent> selectedPreset, [JoinByUser] ICollection<MountedModuleItemNode> mountedModules, [JoinAll] ICollection<SlotNode> slots, [JoinAll] ModuleUpgradeConfigNode moduleUpgradeConfig)
		{
			float stars = TankUpgradeUtils.CalculateUpgradeCoeff(GetTierAndLevelsDictionary(GetMountedModules(mountedModules, TankPartModuleType.WEAPON)), GetSlotsCount(slots, TankPartModuleType.WEAPON), moduleUpgradeConfig.moduleUpgradablePowerConfig);
			selectedTurretUI.component.SetStars(stars);
		}

		[OnEventFire]
		public void SetHullStars(NodeAddedEvent e, SingleNode<SelectedHullUIComponent> selectedHullUI, [Context] SingleNode<SelectedPresetComponent> selectedPreset, [JoinByUser] ICollection<MountedModuleItemNode> mountedModules, [JoinAll] ICollection<SlotNode> slots, [JoinAll] ModuleUpgradeConfigNode moduleUpgradeConfig)
		{
			float stars = TankUpgradeUtils.CalculateUpgradeCoeff(GetTierAndLevelsDictionary(GetMountedModules(mountedModules, TankPartModuleType.TANK)), GetSlotsCount(slots, TankPartModuleType.TANK), moduleUpgradeConfig.moduleUpgradablePowerConfig);
			selectedHullUI.component.SetStars(stars);
		}

		[OnEventFire]
		public void ShowTankPartStatGarage(ButtonClickEvent e, SingleNode<TankPartItemPropertiesButtonComponent> tankPartItemPropertiesButton, [JoinAll] SingleNode<SelectedPresetComponent> selectedPreset, [JoinByUser] ICollection<MountedModuleItemNode> mountedModules, [JoinAll] ICollection<SlotNode> slots, [JoinAll] ModuleUpgradeConfigNode moduleUpgradeConfig, [JoinAll] SingleNode<SelectedHullUIComponent> garageScreen)
		{
			List<ModuleItemNode> list = new List<ModuleItemNode>();
			TankPartModuleType tankPartModuleType = tankPartItemPropertiesButton.component.tankPartModuleType;
			foreach (MountedModuleItemNode mountedModule in mountedModules)
			{
				if (mountedModule.moduleTankPart.TankPart == tankPartModuleType)
				{
					list.Add(mountedModule);
				}
			}
			int slotsCount = GetSlotsCount(slots, tankPartModuleType);
			float num = TankUpgradeUtils.CalculateUpgradeCoeff(GetTierAndLevelsDictionary(list), slotsCount, moduleUpgradeConfig.moduleUpgradablePowerConfig);
			tankPartItemPropertiesButton.component.itemPropertiesUiComponent.Show(null, num, num);
		}

		[OnEventFire]
		public void GetItemStat(GetItemStatEvent e, ModuleItemNode module, [JoinAll] SingleNode<SelectedPresetComponent> selectedPreset, [JoinByUser] MountedHullNode mountedHull, [JoinByUser] MountedWeaponNode mountedWeapon, [JoinByUser] ICollection<MountedModuleItemNode> mountedModules, [JoinByModule] Optional<ModuleItemNode> mountedToSelectedSlotModule, [JoinAll] ICollection<SlotNode> slots, [JoinAll] ModuleUpgradeConfigNode moduleUpgradeConfig, [JoinAll] ScreenNode screen)
		{
			List<ModuleItemNode> tankModules = new List<ModuleItemNode>();
			List<ModuleItemNode> weaponModules = new List<ModuleItemNode>();
			List<ModuleItemNode> list = new List<ModuleItemNode>();
			List<ModuleItemNode> list2 = new List<ModuleItemNode>();
			FilterModules(mountedModules, module, (!mountedToSelectedSlotModule.IsPresent()) ? null : mountedToSelectedSlotModule.Get(), tankModules, weaponModules, list, list2);
			int slotsCount = GetSlotsCount(slots, TankPartModuleType.TANK);
			int slotsCount2 = GetSlotsCount(slots, TankPartModuleType.WEAPON);
			UpgradeCoefs upgradeCoefs = new UpgradeCoefs
			{
				tankCoeffWithSelected = TankUpgradeUtils.CalculateUpgradeCoeff(GetTierAndLevelsDictionary(list), slotsCount, moduleUpgradeConfig.moduleUpgradablePowerConfig),
				weaponCoeffWithSelected = TankUpgradeUtils.CalculateUpgradeCoeff(GetTierAndLevelsDictionary(list2), slotsCount2, moduleUpgradeConfig.moduleUpgradablePowerConfig)
			};
			UpgradeCoefs upgradeCoefs2 = new UpgradeCoefs
			{
				tankCoeffWithSelected = TankUpgradeUtils.CalculateUpgradeCoeff(GetTierAndLevelsDictionaryForNextLevelModule(list, module), slotsCount, moduleUpgradeConfig.moduleUpgradablePowerConfig),
				weaponCoeffWithSelected = TankUpgradeUtils.CalculateUpgradeCoeff(GetTierAndLevelsDictionaryForNextLevelModule(list2, module), slotsCount2, moduleUpgradeConfig.moduleUpgradablePowerConfig)
			};
			float coef = ((module.moduleTankPart.TankPart != TankPartModuleType.TANK) ? upgradeCoefs.weaponCoeffWithSelected : upgradeCoefs.tankCoeffWithSelected);
			float coef2 = ((module.moduleTankPart.TankPart != TankPartModuleType.TANK) ? upgradeCoefs2.weaponCoeffWithSelected : upgradeCoefs2.tankCoeffWithSelected);
			long marketId = ((module.moduleTankPart.TankPart != TankPartModuleType.TANK) ? mountedWeapon.marketItemGroup.Key : mountedHull.marketItemGroup.Key);
			TankPartItem item = GarageItemsRegistry.GetItem<TankPartItem>(marketId);
			VisualProperty visualProperty = item.Properties[0];
			e.moduleUpgradeCharacteristic = new ModuleUpgradeCharacteristic
			{
				Min = visualProperty.GetValue(0f) - visualProperty.GetValue(0f) / 10f,
				Max = visualProperty.GetValue(1f),
				Current = visualProperty.GetValue(coef),
				Next = visualProperty.GetValue(coef2),
				CurrentStr = visualProperty.GetFormatedValue(coef),
				NextStr = visualProperty.GetFormatedValue(coef2),
				Unit = visualProperty.Unit,
				Name = ((module.moduleTankPart.TankPart != TankPartModuleType.TANK) ? screen.newModulesScreenUi.TurretDamage : screen.newModulesScreenUi.HullHealth)
			};
		}

		public UpgradeCoefs GetCoefs(ICollection<MountedModuleItemNode> mountedModules, SelectedModuleNode selectedModule, SelectedSlotNode selectedSlot, ModuleItemNode mountedToSlotModule, ICollection<SlotNode> slots, ModuleUpgradeConfigNode moduleUpgradeConfig)
		{
			List<ModuleItemNode> list = new List<ModuleItemNode>();
			List<ModuleItemNode> list2 = new List<ModuleItemNode>();
			List<ModuleItemNode> list3 = new List<ModuleItemNode>();
			List<ModuleItemNode> list4 = new List<ModuleItemNode>();
			FilterModules(mountedModules, selectedModule, mountedToSlotModule, list, list2, list3, list4);
			int slotsCount = GetSlotsCount(slots, TankPartModuleType.TANK);
			int slotsCount2 = GetSlotsCount(slots, TankPartModuleType.WEAPON);
			return new UpgradeCoefs
			{
				tankCoeff = TankUpgradeUtils.CalculateUpgradeCoeff(GetTierAndLevelsDictionary(list), slotsCount, moduleUpgradeConfig.moduleUpgradablePowerConfig),
				weaponCoeff = TankUpgradeUtils.CalculateUpgradeCoeff(GetTierAndLevelsDictionary(list2), slotsCount2, moduleUpgradeConfig.moduleUpgradablePowerConfig),
				tankCoeffWithSelected = TankUpgradeUtils.CalculateUpgradeCoeff(GetTierAndLevelsDictionary(list3), slotsCount, moduleUpgradeConfig.moduleUpgradablePowerConfig),
				weaponCoeffWithSelected = TankUpgradeUtils.CalculateUpgradeCoeff(GetTierAndLevelsDictionary(list4), slotsCount2, moduleUpgradeConfig.moduleUpgradablePowerConfig)
			};
		}

		private void FilterModules(ICollection<MountedModuleItemNode> mountedModules, ModuleItemNode selectedModule, ModuleItemNode mountedToSlotModule, List<ModuleItemNode> tankModules, List<ModuleItemNode> weaponModules, List<ModuleItemNode> tankModulesWithSelected, List<ModuleItemNode> weaponModulesWithSelected)
		{
			foreach (MountedModuleItemNode mountedModule in mountedModules)
			{
				if (mountedToSlotModule != null && selectedModule != null && mountedToSlotModule.Entity.Equals(mountedModule.Entity) && !mountedToSlotModule.Entity.Equals(selectedModule.Entity))
				{
					continue;
				}
				if (mountedModule.moduleTankPart.TankPart == TankPartModuleType.TANK)
				{
					tankModulesWithSelected.Add(mountedModule);
					if (selectedModule == null || !mountedModule.Entity.Equals(selectedModule.Entity))
					{
						tankModules.Add(mountedModule);
					}
				}
				else
				{
					weaponModulesWithSelected.Add(mountedModule);
					if (selectedModule == null || !mountedModule.Entity.Equals(selectedModule.Entity))
					{
						weaponModules.Add(mountedModule);
					}
				}
			}
			if (selectedModule != null)
			{
				if (selectedModule.moduleTankPart.TankPart == TankPartModuleType.TANK && !ListContainsNodeWithEntity(tankModulesWithSelected, selectedModule.Entity))
				{
					tankModulesWithSelected.Add(selectedModule);
				}
				else if (selectedModule.moduleTankPart.TankPart == TankPartModuleType.WEAPON && !ListContainsNodeWithEntity(weaponModulesWithSelected, selectedModule.Entity))
				{
					weaponModulesWithSelected.Add(selectedModule);
				}
			}
		}

		private bool ListContainsNodeWithEntity(List<ModuleItemNode> nodes, Entity entity)
		{
			foreach (ModuleItemNode node in nodes)
			{
				if (node.Entity.Equals(entity))
				{
					return true;
				}
			}
			return false;
		}

		private int GetSlotsCount(ICollection<SlotNode> slots, TankPartModuleType tankPartType)
		{
			int num = 0;
			foreach (SlotNode slot in slots)
			{
				if (slot.slotTankPart.TankPart == tankPartType)
				{
					num++;
				}
			}
			return num;
		}

		private List<ModuleItemNode> GetMountedModules(ICollection<MountedModuleItemNode> modules, TankPartModuleType tankPartModuleType)
		{
			List<ModuleItemNode> list = new List<ModuleItemNode>();
			foreach (MountedModuleItemNode module in modules)
			{
				if (module.moduleTankPart.TankPart == tankPartModuleType)
				{
					list.Add(module);
				}
			}
			return list;
		}

		private List<int[]> GetTierAndLevelsDictionary(List<ModuleItemNode> modules)
		{
			List<int[]> list = new List<int[]>();
			foreach (ModuleItemNode module in modules)
			{
				list.Add(new int[2]
				{
					module.moduleTier.TierNumber,
					GetModuleLevel(module)
				});
			}
			return list;
		}

		private List<int[]> GetTierAndLevelsDictionaryForNextLevelModule(List<ModuleItemNode> modules, ModuleItemNode nextLevelModule)
		{
			List<int[]> list = new List<int[]>();
			foreach (ModuleItemNode module in modules)
			{
				int num = GetModuleLevel(module);
				if (nextLevelModule.Entity.Equals(module.Entity))
				{
					num++;
				}
				list.Add(new int[2]
				{
					module.moduleTier.TierNumber,
					num
				});
			}
			return list;
		}

		private int GetModuleLevel(ModuleItemNode module)
		{
			return (int)(module.Entity.HasComponent<ModuleUpgradeLevelComponent>() ? module.Entity.GetComponent<ModuleUpgradeLevelComponent>().Level : 0);
		}
	}
}
