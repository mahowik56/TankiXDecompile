using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;

namespace Tanks.Lobby.ClientUserProfile.Impl
{
	[Shared]
	[SerialVersionUID(1451368548585L)]
	public class RequestLoadUserProfileEvent : Event
	{
		public long UserId { get; set; }

		public RequestLoadUserProfileEvent()
		{
		}

		public RequestLoadUserProfileEvent(long userId)
		{
			UserId = userId;
		}
	}
}
