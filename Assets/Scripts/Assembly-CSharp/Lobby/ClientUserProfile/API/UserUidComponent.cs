using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;

namespace Lobby.ClientUserProfile.API
{
	[Shared]
	[SerialVersionUID(-5477085396086342998L)]
	public class UserUidComponent : Component
	{
		public string Uid { get; set; }

		public UserUidComponent()
		{
		}

		public UserUidComponent(string uid)
		{
			Uid = uid;
		}
	}
}
