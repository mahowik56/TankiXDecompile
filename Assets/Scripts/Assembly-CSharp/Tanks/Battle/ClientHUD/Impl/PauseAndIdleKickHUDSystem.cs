using System;
using Lobby.ClientUserProfile.API;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientDataStructures.API;
using Tanks.Battle.ClientCore.API;
using Tanks.Battle.ClientCore.Impl;
using Tanks.Battle.ClientHUD.API;
using Tanks.Lobby.ClientControls.API;

namespace Tanks.Battle.ClientHUD.Impl
{
	public class PauseAndIdleKickHUDSystem : ECSSystem
	{
		public class BattleUserNode : Node
		{
			public BattleUserComponent battleUser;

			public SelfBattleUserComponent selfBattleUser;
		}

		public class PausedBattleUserNode : Node
		{
			public BattleUserComponent battleUser;

			public SelfBattleUserComponent selfBattleUser;

			public PauseComponent pause;
		}

		public class BattleUserCounterNode : Node
		{
			public BattleUserComponent battleUser;

			public SelfBattleUserComponent selfBattleUser;

			public IdleCounterComponent idleCounter;

			public IdleBeginTimeComponent idleBeginTime;

			public IdleKickConfigComponent idleKickConfig;
		}

		public class BattleUserCounterWithWarningNode : Node
		{
			public BattleUserComponent battleUser;

			public SelfBattleUserComponent selfBattleUser;

			public IdleCounterComponent idleCounter;

			public IdleBeginTimeComponent idleBeginTime;

			public IdleKickConfigComponent idleKickConfig;
		}

		public class ActiveRoundNode : Node
		{
			public RoundComponent round;

			public RoundActiveStateComponent roundActiveState;
		}

		public class PauseServiceMessageNode : Node
		{
			public PauseServiceMessageComponent pauseServiceMessage;

			public ServiceMessageESMComponent serviceMessageESM;

			public PauseMessageComponent pauseMessage;

			public ServiceMessageComponent serviceMessage;
		}

		public class AutokickServiceMessageNode : Node
		{
			public AutokickServiceMessageComponent autokickServiceMessage;

			public ServiceMessageESMComponent serviceMessageESM;

			public AutokickMessageComponent autokickMessage;

			public ServiceMessageComponent serviceMessage;
		}

		public class HiddenPauseServiceMessageNode : Node
		{
			public ServiceMessageHiddenStateComponent serviceMessageHiddenState;

			public PauseServiceMessageComponent pauseServiceMessage;

			public TimerComponent timer;
		}

		public class VisiblePauseServiceMessageNode : Node
		{
			public ServiceMessageVisibleStateComponent serviceMessageVisibleState;

			public PauseServiceMessageComponent pauseServiceMessage;

			public TimerComponent timer;
		}

		public class VisibleAutokickServiceMessageNode : Node
		{
			public ServiceMessageVisibleStateComponent serviceMessageVisibleState;

			public AutokickServiceMessageComponent autokickServiceMessage;

			public ServiceMessageESMComponent serviceMessageESM;

			public TimerComponent timer;
		}

		[OnEventFire]
		public void LocalizePauseServiceMessage(NodeAddedEvent e, PauseServiceMessageNode serviceMessage)
		{
			serviceMessage.serviceMessage.MessageText.text = serviceMessage.pauseMessage.Message;
		}

		[OnEventFire]
		public void LocalizeAutokickServiceMessage(NodeAddedEvent e, AutokickServiceMessageNode serviceMessage)
		{
			serviceMessage.serviceMessage.MessageText.text = serviceMessage.autokickMessage.Message;
		}

		[OnEventFire]
		public void ShowPauseServiceMessage(NodeAddedEvent e, PausedBattleUserNode pausedUser, [JoinAll] PauseServiceMessageNode serviceMessage)
		{
			serviceMessage.serviceMessageESM.Esm.ChangeState<ServiceMessageStates.ServiceMessageVisibleState>();
		}

		[OnEventFire]
		public void HidePauseServiceMessage(NodeRemoveEvent e, PausedBattleUserNode pausedUser, [JoinAll] PauseServiceMessageNode serviceMessage)
		{
			serviceMessage.serviceMessageESM.Esm.ChangeState<ServiceMessageStates.ServiceMessageHiddenState>();
		}

		[OnEventFire]
		public void InitCheckTimeLeft(NodeAddedEvent e, BattleUserCounterNode battleUser)
		{
			NewEvent<CheckAutokickTimeEvent>().Attach(battleUser).SchedulePeriodic(1f);
		}

		[OnEventFire]
		public void CheckAutokickTime(CheckAutokickTimeEvent e, BattleUserCounterWithWarningNode battleUser, [JoinAll] AutokickServiceMessageNode autokickServiceMessage, [JoinAll] HiddenPauseServiceMessageNode serviceMessage)
		{
			float num = IdleKickUtils.CalculateTimeLeft(battleUser.idleCounter, battleUser.idleBeginTime, battleUser.idleKickConfig);
			if (num < (float)battleUser.idleKickConfig.IdleWarningTimeSec)
			{
				autokickServiceMessage.serviceMessageESM.Esm.ChangeState<ServiceMessageStates.ServiceMessageVisibleState>();
			}
			else
			{
				autokickServiceMessage.serviceMessageESM.Esm.ChangeState<ServiceMessageStates.ServiceMessageHiddenState>();
			}
		}

		[OnEventFire]
		public void UpdateGUI(UpdateEvent e, BattleUserNode battleUser, [JoinByUser] Optional<BattleUserCounterNode> idleCounter, [JoinBy(typeof(BattleGroupComponent))] ActiveRoundNode activeRound, [JoinAll] VisiblePauseServiceMessageNode serviceMessage)
		{
			bool flag = idleCounter.IsPresent();
			bool flag2 = battleUser.Entity.HasComponent<PauseComponent>();
			int num = 0;
			if (flag)
			{
				float num2 = IdleKickUtils.CalculateTimeLeft(idleCounter.Get().idleCounter, idleCounter.Get().idleBeginTime, idleCounter.Get().idleKickConfig);
				num = (int)Math.Ceiling(num2);
			}
			if (flag2 && flag && idleCounter.Get().idleBeginTime.IdleBeginTime.HasValue)
			{
				serviceMessage.timer.Timer.SecondsLeft = num;
			}
		}

		[OnEventFire]
		public void UpdateGUI(UpdateEvent e, BattleUserCounterWithWarningNode idleCounter, [JoinBy(typeof(BattleGroupComponent))] ActiveRoundNode activeRound, [JoinAll] VisibleAutokickServiceMessageNode serviceMessage)
		{
			float num = IdleKickUtils.CalculateTimeLeft(idleCounter.idleCounter, idleCounter.idleBeginTime, idleCounter.idleKickConfig);
			int num2 = (int)Math.Ceiling(num);
			if (num < (float)idleCounter.idleKickConfig.IdleWarningTimeSec)
			{
				serviceMessage.timer.Timer.SecondsLeft = num2;
			}
		}
	}
}
