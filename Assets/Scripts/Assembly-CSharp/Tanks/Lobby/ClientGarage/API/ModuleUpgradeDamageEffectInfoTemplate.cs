using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;

namespace Tanks.Lobby.ClientGarage.API
{
	[SerialVersionUID(636352879148177794L)]
	public interface ModuleUpgradeDamageEffectInfoTemplate : ModuleUpgradeEffectWithDurationTemplate, ModuleUpgradeInfoTemplate, Template
	{
		[AutoAdded]
		[PersistentConfig("", false)]
		ModuleDamageEffectMinFactorPropertyComponent moduleDamageEffectMinFactorProperty();

		[AutoAdded]
		[PersistentConfig("", false)]
		ModuleDamageEffectMaxFactorPropertyComponent moduleDamageEffectMaxFactorProperty();
	}
}
