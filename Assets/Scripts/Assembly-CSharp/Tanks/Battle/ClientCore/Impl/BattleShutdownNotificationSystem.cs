using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientUnityIntegration.API;
using Tanks.Battle.ClientCore.API;
using Tanks.Lobby.ClientEntrance.API;
using Tanks.Lobby.ClientUserProfile.API;

namespace Tanks.Battle.ClientCore.Impl
{
	public class BattleShutdownNotificationSystem : ECSSystem
	{
		public class NotificationNode : Node
		{
			public BattleShutdownNotificationComponent battleShutdownNotification;

			public BattleShutdownTextComponent battleShutdownText;
		}

		public class NotificationMessageNode : Node
		{
			public BattleShutdownNotificationComponent battleShutdownNotification;

			public BattleShutdownTextComponent battleShutdownText;

			public NotificationMessageComponent notificationMessage;
		}

		public class SelfBattleNode : Node
		{
			public BattleComponent battle;

			public SelfComponent self;

			public BattleStartTimeComponent battleStartTime;

			public TimeLimitComponent timeLimit;
		}

		[OnEventFire]
		public void AddNotificationText(NodeAddedEvent e, NotificationNode notification)
		{
			notification.Entity.AddComponent(new NotificationMessageComponent(string.Empty));
		}

		[OnEventFire]
		public void UpdateTimeNotification(UpdateEvent e, NotificationMessageNode notification, [JoinAll] SelfBattleNode battle, [JoinAll][Combine] SingleNode<LocalizedTimerComponent> timer)
		{
			float num = Date.Now - battle.battleStartTime.RoundStartTime;
			float num2 = (float)battle.timeLimit.TimeLimitSec - num;
			if (num2 < 0f)
			{
				num2 = 0f;
			}
			string arg = timer.component.GenerateTimerString(num2);
			notification.notificationMessage.Message = string.Format(notification.battleShutdownText.Text, arg);
		}
	}
}
