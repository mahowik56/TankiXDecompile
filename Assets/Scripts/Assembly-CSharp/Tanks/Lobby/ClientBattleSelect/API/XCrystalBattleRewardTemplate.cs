using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;
using Tanks.Lobby.ClientBattleSelect.Impl;

namespace Tanks.Lobby.ClientBattleSelect.API
{
	[SerialVersionUID(1513245612798L)]
	public interface XCrystalBattleRewardTemplate : BattleResultRewardTemplate, Template
	{
		[AutoAdded]
		[PersistentConfig("", false)]
		XCrystalRewardTextConfigComponent xCrystalRewardTextConfig();

		[AutoAdded]
		[PersistentConfig("", false)]
		XCrystalRewardItemsConfigComponent itemsConfig();
	}
}
