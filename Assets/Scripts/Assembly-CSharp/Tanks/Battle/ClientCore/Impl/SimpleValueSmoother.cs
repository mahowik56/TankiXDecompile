namespace Tanks.Battle.ClientCore.Impl
{
	public class SimpleValueSmoother
	{
		private float targetValue;

		private float smoothingSpeedUp;

		private float smoothingSpeedDown;

		public float CurrentValue { get; private set; }

		public SimpleValueSmoother(float smoothingSpeedUp, float smoothingSpeedDown, float targetValue, float currentValue)
		{
			this.smoothingSpeedUp = smoothingSpeedUp;
			this.smoothingSpeedDown = smoothingSpeedDown;
			this.targetValue = targetValue;
			CurrentValue = currentValue;
		}

		public void Reset(float value)
		{
			CurrentValue = value;
			targetValue = value;
		}

		public float Update(float dt)
		{
			if (CurrentValue < targetValue)
			{
				CurrentValue += smoothingSpeedUp * dt;
				if (CurrentValue > targetValue)
				{
					CurrentValue = targetValue;
				}
			}
			else if (CurrentValue > targetValue)
			{
				CurrentValue -= smoothingSpeedDown * dt;
				if (CurrentValue < targetValue)
				{
					CurrentValue = targetValue;
				}
			}
			return CurrentValue;
		}

		public void SetTargetValue(float value)
		{
			targetValue = value;
		}

		public float GetTargetValue()
		{
			return targetValue;
		}
	}
}
