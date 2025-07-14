using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientUnityIntegration.API;
using Tanks.Battle.ClientCore.API;
using Tanks.Battle.ClientCore.Impl;
using Tanks.Lobby.ClientBattleSelect.API;
using Tanks.Lobby.ClientControls.API;

namespace Tanks.Lobby.ClientBattleSelect.Impl
{
	public class BattleTimeIndicatorSystem : ECSSystem
	{
		public class BattleTimeNode : Node
		{
			public TimeLimitComponent timeLimit;

			public BattleGroupComponent battleGroup;
		}

		public class BattleTimeIndicatorNode : Node
		{
			public BattleGroupComponent battleGroup;

			public BattleTimeIndicatorComponent battleTimeIndicator;
		}

		public class RoundNode : Node
		{
			public BattleGroupComponent battleGroup;

			public RoundComponent round;
		}

		[OnEventFire]
		public void UpdateTime(UpdateEvent e, BattleTimeIndicatorNode battleTimeIndicator, [JoinByBattle] BattleTimeNode battleTime, [JoinByBattle] RoundNode round)
		{
			float num = 0f;
			long timeLimitSec = battleTime.timeLimit.TimeLimitSec;
			float num2 = timeLimitSec;
			float num3 = 0f;
			if (battleTime.Entity.HasComponent<BattleStartTimeComponent>() && !round.Entity.HasComponent<RoundWarmingUpStateComponent>())
			{
				Date roundStartTime = battleTime.Entity.GetComponent<BattleStartTimeComponent>().RoundStartTime;
				num3 = Date.Now - roundStartTime;
				num2 -= num3;
				Date endDate = roundStartTime + timeLimitSec;
				num = Date.Now.GetProgress(roundStartTime, endDate);
			}
			string timerText = TimerUtils.GetTimerText(num2);
			battleTimeIndicator.battleTimeIndicator.Progress = 1f - num;
			battleTimeIndicator.battleTimeIndicator.Time = timerText;
		}
	}
}
