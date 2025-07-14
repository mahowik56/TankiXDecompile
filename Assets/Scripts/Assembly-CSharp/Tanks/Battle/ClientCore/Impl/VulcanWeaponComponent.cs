using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;

namespace Tanks.Battle.ClientCore.Impl
{
	[Shared]
	[SerialVersionUID(4207390770640273134L)]
	public class VulcanWeaponComponent : Component
	{
		public float SpeedUpTime { get; set; }

		public float SlowDownTime { get; set; }

		public float TemperatureIncreasePerSec { get; set; }

		public float TemperatureLimit { get; set; }

		public float TemperatureHittingTime { get; set; }

		public float WeaponTurnDecelerationCoeff { get; set; }

		public float TargetHeatingMult { get; set; }
	}
}
