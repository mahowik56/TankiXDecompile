using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;
using Tanks.Battle.ClientCore.Impl;

namespace Tanks.Battle.ClientCore.API
{
	[SerialVersionUID(1430285569243L)]
	public interface StreamWeaponTemplate : WeaponTemplate, Template
	{
		StreamWeaponControllerComponent streamWeaponController();

		StreamWeaponEnergyComponent streamWeaponEnergy();

		[PersistentConfig("", false)]
		ConicTargetingComponent conicTargeting();

		[AutoAdded]
		EnergyBarComponent energyBar();
	}
}
