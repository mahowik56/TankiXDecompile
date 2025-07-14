using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;

namespace Tanks.Lobby.ClientGarage.API
{
	[SerialVersionUID(636353777079800280L)]
	public interface ModuleUpgradeLifestealEffectInfoTemplate : ModuleUpgradeInfoTemplate, Template
	{
		[AutoAdded]
		[PersistentConfig("", false)]
		ModuleLifestealEffectFixedHPPropertyComponent moduleLifestealEffectFixedHPProperty();

		[AutoAdded]
		[PersistentConfig("", false)]
		ModuleLifestealEffectAdditiveHPFactorPropertyComponent moduleLifestealEffectAdditiveHPFactorProperty();
	}
}
