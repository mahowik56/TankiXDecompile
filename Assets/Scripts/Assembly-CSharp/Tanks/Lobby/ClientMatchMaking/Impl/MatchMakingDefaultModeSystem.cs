using System.Collections.Generic;
using System.Linq;
using Lobby.ClientUserProfile.API;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientDataStructures.API;
using Tanks.Lobby.ClientEntrance.API;
using Tanks.Lobby.ClientEntrance.Impl;
using Tanks.Lobby.ClientGarage.API;
using Tanks.Lobby.ClientMatchMaking.API;
using Tanks.Lobby.ClientUserProfile.API;

namespace Tanks.Lobby.ClientMatchMaking.Impl
{
	public class MatchMakingDefaultModeSystem : ECSSystem
	{
		public class SelfUserNode : Node
		{
			public UserComponent user;

			public SelfUserComponent selfUser;

			public UserRankComponent userRank;

			public UserStatisticsComponent userStatistics;

			public RegistrationDateComponent registrationDate;
		}

		public class MatchMakingDefaultModeNode : Node
		{
			public MatchMakingModeComponent matchMakingMode;

			public MatchMakingModeRestrictionsComponent matchMakingModeRestrictions;

			public MatchMakingDefaultModeComponent matchMakingDefaultMode;

			public MatchMakingModeActivationComponent matchMakingModeActivation;

			public OrderItemComponent orderItem;
		}

		[OnEventFire]
		public void SelectDefaultMode(SelectDefaultMatchMakingModeEvent e, Node any, [JoinAll] SelfUserNode selfUser, [JoinAll] ICollection<MatchMakingDefaultModeNode> modes)
		{
			List<MatchMakingDefaultModeNode> list = modes.OrderBy((MatchMakingDefaultModeNode mode) => mode.orderItem.Index).ToList();
			Optional<Entity> defaultMode = Optional<Entity>.empty();
			if (selfUser.registrationDate.RegistrationDate.UnityTime != 0f)
			{
				foreach (MatchMakingDefaultModeNode item in list)
				{
					long value;
					selfUser.userStatistics.Statistics.TryGetValue("ALL_BATTLES_PARTICIPATED", out value);
					if (value < item.matchMakingDefaultMode.MinimalBattles)
					{
						defaultMode = Optional<Entity>.of(item.Entity);
						break;
					}
				}
			}
			if (defaultMode.IsPresent())
			{
				e.DefaultMode = defaultMode;
				return;
			}
			foreach (MatchMakingDefaultModeNode item2 in list)
			{
				if (selfUser.userRank.Rank >= item2.matchMakingModeRestrictions.MinimalRank && selfUser.userRank.Rank <= item2.matchMakingModeRestrictions.MaximalRank)
				{
					defaultMode = Optional<Entity>.of(item2.Entity);
					break;
				}
			}
			e.DefaultMode = defaultMode;
		}

		[OnEventComplete]
		public void EnterToDefaultMode(SelectDefaultMatchMakingModeEvent e, Node any)
		{
			if (e.DefaultMode.IsPresent())
			{
				ScheduleEvent<SaveBattleModeEvent>(e.DefaultMode.Get());
				ScheduleEvent(new UserEnterToMatchMakingEvent(), e.DefaultMode.Get());
			}
		}
	}
}
