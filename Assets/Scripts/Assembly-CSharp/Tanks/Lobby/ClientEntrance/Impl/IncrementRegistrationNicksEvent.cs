using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;

namespace Tanks.Lobby.ClientEntrance.Impl
{
	[Shared]
	[SerialVersionUID(1453881244963L)]
	public class IncrementRegistrationNicksEvent : Event
	{
		public string Nick { get; set; }

		public IncrementRegistrationNicksEvent()
		{
		}

		public IncrementRegistrationNicksEvent(string nick)
		{
			Nick = nick;
		}
	}
}
