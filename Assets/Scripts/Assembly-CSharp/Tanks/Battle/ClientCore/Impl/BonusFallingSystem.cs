using System;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientUnityIntegration.API;
using Tanks.Battle.ClientCore.API;
using UnityEngine;

namespace Tanks.Battle.ClientCore.Impl
{
	public class BonusFallingSystem : ECSSystem
	{
		public class BonusFallingNode : Node
		{
			public BonusComponent bonus;

			public BonusDropTimeComponent bonusDropTime;

			public BonusFallingStateComponent bonusFallingState;

			public BonusDataComponent bonusData;

			public BonusBoxInstanceComponent bonusBoxInstance;

			public BonusParachuteInstanceComponent bonusParachuteInstance;

			public BonusConfigComponent bonusConfig;

			public PositionComponent position;

			public RotationComponent rotation;
		}

		[OnEventFire]
		public void PrepareFalling(NodeAddedEvent e, BonusFallingNode bonus)
		{
			UpdateBonusPosition(bonus);
		}

		[OnEventComplete]
		public void UpdateBonusPosition(UpdateEvent e, BonusFallingNode bonus)
		{
			UpdateBonusPosition(bonus);
		}

		private void UpdateBonusPosition(BonusFallingNode bonus)
		{
			GameObject bonusBoxInstance = bonus.bonusBoxInstance.BonusBoxInstance;
			if ((bool)bonusBoxInstance)
			{
				BonusConfigComponent bonusConfig = bonus.bonusConfig;
				BonusDataComponent bonusData = bonus.bonusData;
				float num = Mathf.Clamp(Date.Now - bonus.bonusDropTime.DropTime, 0f, bonusData.FallDuration);
				Vector3 euler = new Vector3(bonusConfig.SwingAngle * Mathf.Sin(bonusConfig.SwingFreq * (bonusData.FallDuration - num)), bonus.rotation.RotationEuler.y + bonusConfig.AngularSpeed * num, bonusBoxInstance.transform.eulerAngles.z);
				bonusBoxInstance.transform.rotation = Quaternion.Euler(euler);
				Vector3 vector = MathUtil.SetRotationMatrix(bonusBoxInstance.transform.eulerAngles * ((float)Math.PI / 180f)).MultiplyPoint3x4(Vector3.down);
				bonusBoxInstance.transform.position = new Vector3(bonus.position.Position.x + bonusData.SwingPivotY * vector.x, bonus.position.Position.y - bonusConfig.FallSpeed * num, bonus.position.Position.z + bonusData.SwingPivotY * vector.z);
				if (num.Equals(bonusData.FallDuration))
				{
					ToAlignmentToGroundState(bonus.Entity);
				}
			}
		}

		private void ToAlignmentToGroundState(Entity entity)
		{
			entity.RemoveComponent<BonusFallingStateComponent>();
			entity.AddComponent<BonusAlignmentToGroundStateComponent>();
			entity.AddComponent<BonusGroundedStateComponent>();
		}
	}
}
