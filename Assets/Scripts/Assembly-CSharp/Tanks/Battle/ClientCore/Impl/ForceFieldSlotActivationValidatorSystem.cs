using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientCore.API;
using Tanks.Lobby.ClientEntrance.API;
using Tanks.Lobby.ClientGarage.API;
using UnityEngine;

namespace Tanks.Battle.ClientCore.Impl
{
	public class ForceFieldSlotActivationValidatorSystem : ECSSystem
	{
		public class SlotNode : Node
		{
			public ModuleGroupComponent moduleGroup;

			public SlotUserItemInfoComponent slotUserItemInfo;

			public TankGroupComponent tankGroup;
		}

		public class ForceFieldModuleNode : Node
		{
			public ModuleGroupComponent moduleGroup;

			public ForceFieldModuleComponent forceFieldModule;

			public ModuleEffectsComponent moduleEffects;
		}

		[Not(typeof(ForceFieldModuleComponent))]
		public class ModuleUserItemNode : Node
		{
			public ModuleItemComponent moduleItem;

			public UserItemComponent userItem;

			public MarketItemGroupComponent marketItemGroup;
		}

		public class ForceFieldModuleUpgradeInfoNode : Node
		{
			public MarketItemGroupComponent marketItemGroup;

			public ForceFieldModuleComponent forceFieldModule;
		}

		public class WeaponNode : Node
		{
			public TankGroupComponent tankGroup;

			public WeaponInstanceComponent weaponInstance;

			public SelfComponent self;
		}

		[OnEventFire]
		public void MarkModuleAsForceField(NodeAddedEvent e, ModuleUserItemNode module, [JoinByMarketItem][Context] ForceFieldModuleUpgradeInfoNode info)
		{
			module.Entity.AddComponent<ForceFieldModuleComponent>();
		}

		[OnEventFire]
		public void UpdateActivatePossibility(UpdateEvent e, WeaponNode weaponNode, [JoinByTank][Combine] SlotNode slot, [JoinByModule] ForceFieldModuleNode module)
		{
			Transform transform = weaponNode.weaponInstance.WeaponInstance.transform;
			if (ForceFieldTransformUtil.CanFallToTheGround(transform))
			{
				EnableActivation(slot.Entity);
			}
			else
			{
				DisableActivation(slot.Entity);
			}
		}

		private void EnableActivation(Entity inventory)
		{
			inventory.RemoveComponentIfPresent<InventorySlotTemporaryBlockedByClientComponent>();
		}

		private void DisableActivation(Entity inventory)
		{
			inventory.AddComponentIfAbsent<InventorySlotTemporaryBlockedByClientComponent>();
		}
	}
}
