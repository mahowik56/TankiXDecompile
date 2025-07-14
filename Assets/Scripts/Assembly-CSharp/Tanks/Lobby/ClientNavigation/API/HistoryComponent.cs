using System.Collections.Generic;
using Platform.Kernel.ECS.ClientEntitySystem.API;

namespace Tanks.Lobby.ClientNavigation.API
{
	public class HistoryComponent : Component
	{
		public Stack<ShowScreenData> screens = new Stack<ShowScreenData>();
	}
}
