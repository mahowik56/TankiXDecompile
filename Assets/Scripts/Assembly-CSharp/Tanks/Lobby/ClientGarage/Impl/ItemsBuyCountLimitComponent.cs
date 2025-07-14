using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;

namespace Tanks.Lobby.ClientGarage.Impl
{
	[SerialVersionUID(1495795568363L)]
	public class ItemsBuyCountLimitComponent : Component
	{
		public int Limit { get; set; }
	}
}
