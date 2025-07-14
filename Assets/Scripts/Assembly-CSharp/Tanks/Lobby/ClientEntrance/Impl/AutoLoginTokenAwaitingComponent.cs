using Platform.Kernel.ECS.ClientEntitySystem.API;

namespace Tanks.Lobby.ClientEntrance.Impl
{
	public class AutoLoginTokenAwaitingComponent : Component
	{
		public byte[] PasswordDigest { get; set; }

		public AutoLoginTokenAwaitingComponent()
		{
		}

		public AutoLoginTokenAwaitingComponent(byte[] passwordDigest)
		{
			PasswordDigest = passwordDigest;
		}
	}
}
