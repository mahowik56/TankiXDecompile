using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Lobby.ClientGarage.Impl;
using Tanks.Lobby.ClientNotifications.API;
using Tanks.Lobby.ClientUserProfile.API;

namespace Tanks.Lobby.ClientNotifications.Impl
{
	public class UIDChangedNotificationSystem : ECSSystem
	{
		public class NotificationNode : Node
		{
			public UIDChangedNotificationComponent uIDChangedNotification;

			public UIDChangedNotificationTextComponent uIDChangedNotificationText;
		}

		[OnEventFire]
		public void PrepareNotificationText(NodeAddedEvent e, NotificationNode notification, [JoinAll] ChangeUIDSystem.SelfUserNode user)
		{
			string message = string.Format(notification.uIDChangedNotificationText.MessageTemplate, user.userUid.Uid);
			notification.Entity.AddComponent(new NotificationMessageComponent(message));
		}
	}
}
