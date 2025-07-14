using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;

namespace Tanks.Lobby.ClientEntrance.Impl
{
	[Shared]
	[SerialVersionUID(636071969143771105L)]
	public class ChangeUsernameEvent : Event
	{
		public string Uid { get; set; }

		public ChangeUsernameEvent()
		{
		}

		public ChangeUsernameEvent(string uid)
		{
			Uid = uid;
		}
	}
}
