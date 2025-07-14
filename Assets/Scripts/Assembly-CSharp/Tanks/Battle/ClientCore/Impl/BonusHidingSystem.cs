using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientUnityIntegration.API;
using Tanks.Battle.ClientCore.API;
using Tanks.Battle.ClientGraphics.Impl;
using UnityEngine;

namespace Tanks.Battle.ClientCore.Impl
{
	public class BonusHidingSystem : ECSSystem
	{
		public class BonusBoxNode : Node
		{
			public BonusBoxInstanceComponent bonusBoxInstance;

			public BattleGroupComponent battleGroup;
		}

		public class BonusBoxHidingNode : Node
		{
			public LocalDurationComponent localDuration;

			public BonusRoundEndStateComponent bonusRoundEndState;

			public BonusBoxInstanceComponent bonusBoxInstance;
		}

		public const float HIDING_DURATION = 1f;

		[OnEventComplete]
		public void HideParachute(HideBonusEvent e, SingleNode<BonusParachuteInstanceComponent> bonusParachute)
		{
			bonusParachute.component.BonusParachuteInstance.RecycleObject();
			bonusParachute.Entity.RemoveComponent<BonusParachuteInstanceComponent>();
		}

		[OnEventFire]
		public void CreateBonusHidingEffectEntity(HideBonusEvent e, BonusBoxNode bonusBox)
		{
			Entity entity = CreateEntity("BonusHiding");
			entity.AddComponent<BonusRoundEndStateComponent>();
			BonusBoxInstanceComponent bonusBoxInstanceComponent = new BonusBoxInstanceComponent();
			bonusBoxInstanceComponent.BonusBoxInstance = bonusBox.bonusBoxInstance.BonusBoxInstance;
			BonusBoxInstanceComponent component = bonusBoxInstanceComponent;
			entity.AddComponent(component);
			bonusBox.bonusBoxInstance.Removed = true;
			entity.AddComponent(new LocalDurationComponent(1f));
		}

		[OnEventFire]
		public void HidingProcess(UpdateEvent e, BonusBoxHidingNode bonus)
		{
			if ((bool)bonus.bonusBoxInstance.BonusBoxInstance)
			{
				float progress = Date.Now.GetProgress(bonus.localDuration.StartedTime, 1f);
				float num = 1f - progress;
				Vector3 localScale = new Vector3(num, num, num);
				bonus.bonusBoxInstance.BonusBoxInstance.transform.localScale = localScale;
			}
		}

		[OnEventFire]
		public void DestroyBonusBox(LocalDurationExpireEvent e, BonusBoxHidingNode hidingBonus)
		{
			hidingBonus.bonusBoxInstance.BonusBoxInstance.RecycleObject();
			DeleteEntity(hidingBonus.Entity);
		}
	}
}
