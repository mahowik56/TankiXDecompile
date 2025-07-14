using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;
using Tanks.Lobby.ClientControls.API;

namespace Tanks.Lobby.ClientBattleSelect.API
{
	[Shared]
	[SerialVersionUID(1462084282857L)]
	public class BattleLevelRangeComponent : Component
	{
		public IndexRange Range { get; set; }
	}
}
