using System.Collections.Generic;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientProtocol.API;

namespace Tanks.Lobby.ClientUserProfile.API
{
	[Shared]
	[SerialVersionUID(1458555246853L)]
	public class LoadUsersEvent : Event
	{
		public long RequestEntityId { get; set; }

		public HashSet<long> UsersId { get; set; }

		public LoadUsersEvent(long requestEntityId, HashSet<long> usersId)
		{
			RequestEntityId = requestEntityId;
			UsersId = usersId;
		}

		public LoadUsersEvent(long requestEntityId, params long[] usersIds)
		{
			RequestEntityId = requestEntityId;
			UsersId = new HashSet<long>(usersIds);
		}
	}
}
