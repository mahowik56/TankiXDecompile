using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;
using Tanks.Battle.ClientCore.API;

namespace Tanks.Battle.ClientCore.Impl
{
	[SerialVersionUID(2012489519776979402L)]
	public interface TankTemplate : Template
	{
		TankPartComponent tankPart();

		[PersistentConfig("", false)]
		ChassisConfigComponent chassisConfig();

		[PersistentConfig("", false)]
		TankCommonPrefabComponent tankCommonPrefab();

		[PersistentConfig("", false)]
		HealthConfigComponent healthConfig();

		AssembledTankComponent assembledTank();
	}
}
