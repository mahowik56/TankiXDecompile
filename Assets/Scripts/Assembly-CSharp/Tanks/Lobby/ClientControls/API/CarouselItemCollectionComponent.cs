using System.Collections.Generic;
using Platform.Kernel.ECS.ClientEntitySystem.API;

namespace Tanks.Lobby.ClientControls.API
{
	public class CarouselItemCollectionComponent : Component
	{
		public List<Entity> Items { get; set; }
	}
}
