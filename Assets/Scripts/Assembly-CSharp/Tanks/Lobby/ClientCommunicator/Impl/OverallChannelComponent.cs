using Platform.Kernel.ECS.ClientEntitySystem.API;

namespace Tanks.Lobby.ClientCommunicator.Impl
{
	public class OverallChannelComponent : Component
	{
		public ChatType ChatType
		{
			get
			{
				return ChatType.OVERALL;
			}
		}
	}
}
