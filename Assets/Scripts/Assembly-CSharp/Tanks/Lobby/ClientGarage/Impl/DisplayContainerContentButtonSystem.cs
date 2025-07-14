using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientUnityIntegration.API;
using Tanks.Lobby.ClientControls.API;
using Tanks.Lobby.ClientGarage.API;
using Tanks.Lobby.ClientNavigation.API;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class DisplayContainerContentButtonSystem : ECSSystem
	{
		public class ScreenNode : Node
		{
			public ContainersScreenComponent containersScreen;

			public ScreenComponent screen;

			public ActiveScreenComponent activeScreen;
		}

		public class GameplayChestNode : Node
		{
			public ContainerMarkerComponent containerMarker;

			public GameplayChestItemComponent gameplayChestItem;
		}

		public class ItemsContainerNode : Node
		{
			public ContainerMarkerComponent containerMarker;

			public ItemsContainerItemComponent itemsContainerItem;
		}

		[OnEventFire]
		public void ShowButton(ListItemSelectedEvent e, ItemsContainerNode container, [JoinAll] ScreenNode screenNode)
		{
			screenNode.containersScreen.ContentButtonActivity = true;
		}

		[OnEventFire]
		public void HideButton(ListItemSelectedEvent e, GameplayChestNode container, [JoinAll] ScreenNode screenNode)
		{
			screenNode.containersScreen.ContentButtonActivity = false;
		}
	}
}
