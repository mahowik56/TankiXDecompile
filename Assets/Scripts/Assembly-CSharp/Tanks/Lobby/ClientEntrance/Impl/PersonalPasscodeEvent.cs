using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;

namespace Tanks.Lobby.ClientEntrance.Impl
{
	[Shared]
	[SerialVersionUID(1439531278716L)]
	public class PersonalPasscodeEvent : Event
	{
		public string Passcode { get; set; }

		public PersonalPasscodeEvent()
		{
		}

		public PersonalPasscodeEvent(string passcode)
		{
			Passcode = passcode;
		}
	}
}
