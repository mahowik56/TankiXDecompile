using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;

namespace Tanks.Lobby.ClientEntrance.Impl
{
	[Shared]
	[SerialVersionUID(1478774431678L)]
	public class ClientLaunchEvent : Event
	{
		public string WebId { get; set; }

		public ClientLaunchEvent(string webId)
		{
			WebId = webId;
		}
	}
}
