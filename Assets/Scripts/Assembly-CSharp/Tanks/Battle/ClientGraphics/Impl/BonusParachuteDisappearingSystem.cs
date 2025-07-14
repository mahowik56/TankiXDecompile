using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientUnityIntegration.API;
using Tanks.Battle.ClientCore.API;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class BonusParachuteDisappearingSystem : ECSSystem
	{
		public class SeparatedParachuteNode : Node
		{
			public SeparateParachuteComponent separateParachute;

			public BonusParachuteInstanceComponent bonusParachuteInstance;

			public ParachuteMaterialComponent parachuteMaterial;

			public LocalDurationComponent localDuration;
		}

		[OnEventFire]
		public void FoldParachute(TimeUpdateEvent e, SeparatedParachuteNode parachute)
		{
			if ((bool)parachute.bonusParachuteInstance.BonusParachuteInstance)
			{
				Date startedTime = parachute.localDuration.StartedTime;
				float progress = Date.Now.GetProgress(startedTime, parachute.localDuration.Duration);
				float num = (1f - parachute.separateParachute.parachuteFoldingScaleByXZ) / parachute.localDuration.Duration;
				float num2 = 1f - progress * num;
				float num3 = (1f - parachute.separateParachute.parachuteFoldingScaleByY) / parachute.localDuration.Duration;
				parachute.bonusParachuteInstance.BonusParachuteInstance.transform.localScale = new Vector3(num2, 1f - progress * num3, num2);
				float alpha = 1f - progress;
				parachute.parachuteMaterial.Material.SetAlpha(alpha);
			}
		}

		[OnEventFire]
		public void RemoveParachute(LocalDurationExpireEvent e, SeparatedParachuteNode bonus)
		{
			bonus.bonusParachuteInstance.BonusParachuteInstance.RecycleObject();
			DeleteEntity(bonus.Entity);
		}
	}
}
