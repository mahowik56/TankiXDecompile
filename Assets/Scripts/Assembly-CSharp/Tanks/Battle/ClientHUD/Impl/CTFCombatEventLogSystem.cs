using System;
using Lobby.ClientUserProfile.API;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientDataStructures.API;
using Tanks.Battle.ClientCore.API;
using Tanks.Battle.ClientCore.Impl;
using Tanks.Battle.ClientHUD.API;
using Tanks.Lobby.ClientEntrance.API;
using UnityEngine;

namespace Tanks.Battle.ClientHUD.Impl
{
	public class CTFCombatEventLogSystem : ECSSystem
	{
		public class CTFBattleNode : Node
		{
			public BattleComponent battle;

			public CTFComponent ctf;
		}

		public class BattleUserNode : Node
		{
			public SelfComponent self;

			public BattleUserComponent battleUser;

			public UserInBattleAsTankComponent userInBattleAsTank;

			public UserGroupComponent userGroup;

			public BattleGroupComponent battleGroup;
		}

		public class FlagNode : Node
		{
			public FlagComponent flag;

			public TeamGroupComponent teamGroup;
		}

		[Not(typeof(TankGroupComponent))]
		public class NotCarriedFlagNode : FlagNode
		{
		}

		public class TankNode : Node
		{
			public TankComponent tank;

			public TeamGroupComponent teamGroup;

			public TankGroupComponent tankGroup;
		}

		public class TeamNode : Node
		{
			public TeamComponent team;

			public TeamGroupComponent teamGroup;

			public ColorInBattleComponent colorInBattle;
		}

		public class UserNode : Node
		{
			public UserGroupComponent userGroup;

			public UserComponent user;

			public UserUidComponent userUid;

			public UserRankComponent userRank;
		}

		public class CombatLogNode : Node
		{
			public CombatLogCTFMessagesComponent combatLogCTFMessages;

			public CombatEventLogComponent combatEventLog;

			public ActiveCombatLogComponent activeCombatLog;

			public UILogComponent uiLog;
		}

		[OnEventFire]
		public void CTFStartMessage(NodeAddedEvent e, BattleUserNode selfTank, [JoinByBattle] CTFBattleNode ctfBattle, [Context][JoinAll] CombatLogNode combatEventLog)
		{
			string battleStartMessage = combatEventLog.combatLogCTFMessages.BattleStartMessage;
			combatEventLog.uiLog.UILog.AddMessage(battleStartMessage);
		}

		[OnEventFire]
		public void AddMessageLog(FlagEvent e, FlagNode flag, [JoinByTank] TankNode tank2Team, [JoinByTeam] TeamNode tankTeam, FlagNode flag2User, [JoinByTank] TankNode tank2User, [JoinByUser] UserNode user, FlagNode flag2Team, [JoinByTeam] TeamNode flagTeam, [JoinAll] SingleNode<SelfBattleUserComponent> selfUser, [JoinByTeam] Optional<TeamNode> selfTeam, [JoinAll] CombatLogNode combatLog)
		{
			CombatLogCTFMessagesComponent combatLogCTFMessages = combatLog.combatLogCTFMessages;
			string ownFlag = GetOwnFlag(selfTeam, flagTeam, combatLogCTFMessages);
			string message = GetMessage(e, flag.Entity, combatLogCTFMessages).Replace(CombatLogCTFMessagesComponent.OWN, ownFlag);
			Color teamColor = CombatEventLogUtil.GetTeamColor(tankTeam.colorInBattle.TeamColor, combatLog.combatEventLog);
			message = CombatEventLogUtil.ApplyPlaceholder(message, "{user}", user.userRank.Rank, user.userUid.Uid, teamColor);
			combatLog.uiLog.UILog.AddMessage(message);
		}

		[OnEventFire]
		public void AddFlagNotCountedMessageLog(FlagNotCountedDeliveryEvent e, CTFBattleNode battle, [JoinAll] CombatLogNode combatLog)
		{
			combatLog.uiLog.UILog.AddMessage(combatLog.combatLogCTFMessages.DeliveryNotCounted);
		}

		[OnEventFire]
		public void AddMessageAutoReturnedFlag(FlagReturnEvent e, NotCarriedFlagNode flag, [JoinByTeam] TeamNode flagTeam, [JoinAll] SingleNode<SelfBattleUserComponent> selfUser, [JoinByTeam] Optional<TeamNode> selfTeam, [JoinAll] CombatLogNode combatEventLog)
		{
			CombatLogCTFMessagesComponent combatLogCTFMessages = combatEventLog.combatLogCTFMessages;
			string ownFlag = GetOwnFlag(selfTeam, flagTeam, combatLogCTFMessages);
			string messageText = combatLogCTFMessages.AutoReturned.Replace(CombatLogCTFMessagesComponent.OWN, ownFlag);
			combatEventLog.uiLog.UILog.AddMessage(messageText);
		}

		private static string GetOwnFlag(Optional<TeamNode> selfTeam, TeamNode flagTeam, CombatLogCTFMessagesComponent logCtfMessages)
		{
			if (selfTeam.IsPresent())
			{
				if (flagTeam.teamGroup.Key == selfTeam.Get().teamGroup.Key)
				{
					return logCtfMessages.OurFlag;
				}
				return logCtfMessages.EnemyFlag;
			}
			if (flagTeam.colorInBattle.TeamColor == TeamColor.BLUE)
			{
				return logCtfMessages.BlueFlag;
			}
			return logCtfMessages.RedFlag;
		}

		private static string GetMessage(FlagEvent e, Entity flag, CombatLogCTFMessagesComponent logCtfMessages)
		{
			Type type = e.GetType();
			if (type == typeof(FlagPickupEvent))
			{
				if (flag.HasComponent<FlagHomeStateComponent>())
				{
					return logCtfMessages.Took;
				}
				return logCtfMessages.PickedUp;
			}
			if (type == typeof(FlagDropEvent))
			{
				if (((FlagDropEvent)e).IsUserAction)
				{
					return logCtfMessages.Dropped;
				}
				return logCtfMessages.Lost;
			}
			if (type == typeof(FlagDeliveryEvent))
			{
				return logCtfMessages.Delivered;
			}
			if (type == typeof(FlagReturnEvent))
			{
				return logCtfMessages.Returned;
			}
			throw new ArgumentException();
		}

		[OnEventFire]
		public void FlagHomeStateComponent(NodeAddedEvent e, SingleNode<FlagHomeStateComponent> n)
		{
		}
	}
}
