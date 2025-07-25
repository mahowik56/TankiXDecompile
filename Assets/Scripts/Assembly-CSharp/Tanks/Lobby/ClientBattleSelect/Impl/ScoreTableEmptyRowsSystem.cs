using Lobby.ClientUserProfile.API;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientCore.API;
using Tanks.Lobby.ClientBattleSelect.API;

namespace Tanks.Lobby.ClientBattleSelect.Impl
{
	public class ScoreTableEmptyRowsSystem : ECSSystem
	{
		public class ScoreTableNode : Node
		{
			public ScoreTableEmptyRowIndicatorsComponent scoreTableEmptyRowIndicators;

			public ScoreTableComponent scoreTable;

			public BattleGroupComponent battleGroup;
		}

		public class BattleNode : Node
		{
			public BattleGroupComponent battleGroup;

			public UserLimitComponent userLimit;
		}

		public class DMBattleNode : BattleNode
		{
			public DMComponent dm;
		}

		public class TeamBattleNode : BattleNode
		{
			public TeamBattleComponent teamBattle;
		}

		public class UserRowNode : Node
		{
			public ScoreTableRowComponent scoreTableRow;

			public ScoreTableGroupComponent scoreTableGroup;

			public UserGroupComponent userGroup;
		}

		[OnEventFire]
		public void InitDM(NodeAddedEvent e, [Combine] ScoreTableNode scoreTable, [Context][JoinByBattle] DMBattleNode battle)
		{
			for (int i = 0; i < battle.userLimit.UserLimit; i++)
			{
				ScoreTableRowComponent scoreTableRowComponent = scoreTable.scoreTable.AddRow();
				scoreTable.scoreTableEmptyRowIndicators.emptyRows.Push(scoreTableRowComponent);
				InitRow(scoreTableRowComponent, scoreTable.scoreTableEmptyRowIndicators);
			}
			ScheduleEvent<ScoreTableSetEmptyRowsPositionEvent>(scoreTable);
		}

		[OnEventFire]
		public void InitTeam(NodeAddedEvent e, [Combine] ScoreTableNode scoreTable, [Context][JoinByBattle] TeamBattleNode battle)
		{
			for (int i = 0; i < battle.userLimit.TeamLimit; i++)
			{
				ScoreTableRowComponent scoreTableRowComponent = scoreTable.scoreTable.AddRow();
				scoreTable.scoreTableEmptyRowIndicators.emptyRows.Push(scoreTableRowComponent);
				InitRow(scoreTableRowComponent, scoreTable.scoreTableEmptyRowIndicators);
			}
			ScheduleEvent<ScoreTableSetEmptyRowsPositionEvent>(scoreTable);
		}

		private void InitRow(ScoreTableRowComponent row, ScoreTableEmptyRowIndicatorsComponent scoreTableEmptyRowIndicators)
		{
			row.Color = scoreTableEmptyRowIndicators.emptyRowColor;
			row.Position = 0;
			foreach (ScoreTableRowIndicator indicator in scoreTableEmptyRowIndicators.indicators)
			{
				row.AddIndicator(indicator);
			}
		}

		[OnEventFire]
		public void Destroy(NodeRemoveEvent e, ScoreTableNode scoreTable)
		{
			scoreTable.scoreTableEmptyRowIndicators.emptyRows.Clear();
		}

		[OnEventFire]
		public void RemoveEmptyRow(NodeAddedEvent e, UserRowNode userRow, [JoinByScoreTable] ScoreTableNode scoreTable)
		{
			if (scoreTable.scoreTableEmptyRowIndicators.emptyRows.Count > 0)
			{
				ScoreTableRowComponent row = scoreTable.scoreTableEmptyRowIndicators.emptyRows.Pop();
				scoreTable.scoreTable.RemoveRow(row);
			}
		}

		[OnEventFire]
		public void AddEmptyRow(NodeRemoveEvent e, UserRowNode userRow, [JoinByScoreTable] ScoreTableNode scoreTable)
		{
			if (scoreTable.scoreTable.gameObject.activeInHierarchy)
			{
				ScoreTableRowComponent scoreTableRowComponent = scoreTable.scoreTable.AddRow();
				scoreTable.scoreTableEmptyRowIndicators.emptyRows.Push(scoreTableRowComponent);
				InitRow(scoreTableRowComponent, scoreTable.scoreTableEmptyRowIndicators);
			}
		}
	}
}
