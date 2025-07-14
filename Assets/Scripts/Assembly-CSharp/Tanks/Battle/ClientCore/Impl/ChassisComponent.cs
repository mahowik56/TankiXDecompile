using Platform.Kernel.ECS.ClientEntitySystem.API;

namespace Tanks.Battle.ClientCore.Impl
{
	public class ChassisComponent : Component
	{
		public float MoveAxis { get; set; }

		public float TurnAxis { get; set; }

		public float EffectiveMoveAxis { get; set; }

		public float EffectiveTurnAxis { get; set; }

		public float SpringCoeff { get; set; }

		public void Reset()
		{
			MoveAxis = 0f;
			TurnAxis = 0f;
			EffectiveMoveAxis = 0f;
			SpringCoeff = 0f;
		}
	}
}
