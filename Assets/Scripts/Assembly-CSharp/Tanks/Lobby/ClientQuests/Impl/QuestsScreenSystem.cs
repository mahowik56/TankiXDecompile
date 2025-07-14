using System.Collections.Generic;
using System.Linq;
using Lobby.ClientUserProfile.API;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientDataStructures.API;
using Platform.Library.ClientUnityIntegration.API;
using Tanks.Lobby.ClientEntrance.API;
using Tanks.Lobby.ClientGarage.API;
using Tanks.Lobby.ClientGarage.Impl;
using Tanks.Lobby.ClientNavigation.API;
using Tanks.Lobby.ClientQuests.API;
using UnityEngine;

namespace Tanks.Lobby.ClientQuests.Impl
{
	public class QuestsScreenSystem : ECSSystem
	{
		public class SelfUserNode : Node
		{
			public UserComponent user;

			public SelfComponent self;

			public UserMoneyComponent userMoney;
		}

		public class QuestNode : Node
		{
			public QuestComponent quest;

			public QuestOrderComponent questOrder;

			public QuestProgressComponent questProgress;
		}

		[Not(typeof(QuestItemGUIComponent))]
		public class QuestWithoutGUINode : QuestNode
		{
		}

		[Not(typeof(QuestResultComponent))]
		public class NotResultQuestWithoutGUINode : QuestWithoutGUINode
		{
		}

		public class QuestGUINode : QuestNode
		{
			public QuestItemGUIComponent questItemGUI;
		}

		[Not(typeof(QuestResultComponent))]
		public class NotResultQuestGUINode : QuestNode
		{
			public QuestItemGUIComponent questItemGUI;
		}

		public class QuestResultGUINode : QuestGUINode
		{
			public QuestResultComponent questResult;
		}

		public class AnimatedQuestNode : QuestNode
		{
			public QuestItemGUIComponent questItemGUI;

			public QuestProgressAnimatorComponent questProgressAnimator;
		}

		public class QuestsScreenNode : Node
		{
			public QuestWindowComponent questWindow;
		}

		public class QuestCellNode : Node
		{
			public QuestCellComponent questCell;
		}

		public class QuestsButtonNode : Node
		{
			public QuestsButtonComponent questsButton;

			public ButtonMappingComponent buttonMapping;
		}

		[Not(typeof(QuestResultComponent))]
		public class CompletedRewardedQuestNode : Node
		{
			public QuestComponent quest;

			public QuestOrderComponent questOrder;

			public QuestProgressComponent questProgress;

			public QuestConditionComponent questCondition;

			public QuestRewardComponent questReward;

			public CompleteQuestComponent completeQuest;

			public RewardedQuestComponent rewardedQuest;

			public QuestConditionDescriptionComponent questConditionDescription;
		}

		public class TryShowQuestRewardNotification : Platform.Kernel.ECS.ClientEntitySystem.API.Event
		{
		}

		public class DailyQuestNode : QuestNode
		{
			public BattleCountQuestComponent battleCountQuest;

			public FlagQuestComponent flagQuest;

			public FragQuestComponent fragQuest;

			public ScoreQuestComponent scoreQuest;

			public SupplyQuestComponent supplyQuest;

			public WinQuestComponent winQuest;
		}

		[OnEventFire]
		public void EnableQuests(NodeAddedEvent e, SingleNode<QuestsEnabledComponent> questsEnabled, SingleNode<MainScreenComponent> mainScreen, [JoinAll] ICollection<QuestNode> quest)
		{
			bool active = quest.Count > 0;
			mainScreen.component.QuestsBtn.SetActive(active);
		}

		[OnEventFire]
		public void CreateQuestItemGUIInstances(NodeAddedEvent e, QuestsScreenNode screen, [JoinAll] ICollection<QuestNode> quests)
		{
			if (quests.Count == 0)
			{
				return;
			}
			List<QuestNode> list = new List<QuestNode>();
			foreach (QuestNode quest in quests)
			{
				int num = quests.Count((QuestNode q) => q.questOrder.Index == quest.questOrder.Index);
				bool flag = num == 1;
				bool flag2 = num == 2 && quest.Entity.HasComponent<QuestResultComponent>() && screen.questWindow.ShowProgress;
				bool flag3 = num == 2 && !quest.Entity.HasComponent<QuestResultComponent>() && !screen.questWindow.ShowProgress;
				if (flag || flag2 || flag3)
				{
					list.Add(quest);
				}
			}
			list.Sort((QuestNode a, QuestNode b) => b.questOrder.Index.CompareTo(a.questOrder.Index));
			list.ForEach(delegate(QuestNode questNode)
			{
				SaveAndResetPreviousQuestProgress(questNode, screen.questWindow.ShowProgress);
			});
			list.ForEach(delegate(QuestNode questNode)
			{
				CreateQuestSlotWithItem(screen, questNode.Entity);
			});
			if (list.Count != 0)
			{
				ScheduleEvent<ShowNextQuestAnimationEvent>(list.First());
			}
		}

		[OnEventFire]
		public void RemoveQuest(QuestRemovedEvent e, NotResultQuestGUINode questNode)
		{
			DeleteEntity(questNode.Entity);
		}

		[OnEventFire]
		public void ChangeQuest(QuestRemovedEvent e, QuestResultGUINode removedQuestResult, [JoinAll] ICollection<QuestWithoutGUINode> quests, [JoinAll] QuestsScreenNode screen, [JoinAll] ICollection<QuestCellNode> cells)
		{
			QuestWithoutGUINode questWithoutGUINode = quests.ToList().Find((QuestWithoutGUINode q) => q.questOrder.Index == removedQuestResult.questOrder.Index);
			if (questWithoutGUINode != null && !questWithoutGUINode.Entity.Id.Equals(removedQuestResult.Entity.Id))
			{
				CreateQuestItemGUIInstance(questWithoutGUINode, cells, screen);
			}
			DeleteEntity(removedQuestResult.Entity);
		}

		[OnEventFire]
		public void CreateQuestItemGUIInstance(NodeAddedEvent e, QuestNode quest, [JoinAll] QuestsScreenNode screen, [JoinAll] ICollection<QuestCellNode> cells)
		{
			CreateQuestItemGUIInstance(quest, cells, screen);
		}

		private void CreateQuestItemGUIInstance(QuestNode quest, ICollection<QuestCellNode> cells, QuestsScreenNode screen)
		{
			QuestCellNode questCellNode = cells.ToList().Find((QuestCellNode cell) => cell.questCell.Order == quest.questOrder.Index);
			if (questCellNode == null)
			{
				CreateQuestSlotWithItem(screen, quest.Entity);
				return;
			}
			CreateQuestItem(screen, questCellNode.questCell.gameObject, quest.Entity);
			if (!quest.Entity.HasComponent<CompleteQuestComponent>())
			{
				quest.Entity.GetComponent<QuestItemGUIComponent>().AddQuest();
			}
			else
			{
				quest.Entity.GetComponent<QuestItemGUIComponent>().SetQuestCompleted(true);
			}
		}

		[OnEventFire]
		public void RemoveQuestItemGUIInstances(NodeRemoveEvent e, QuestGUINode quest, [JoinAll] QuestsScreenNode screen)
		{
			quest.questItemGUI.RemoveQuest();
		}

		private void CreateQuestSlotWithItem(QuestsScreenNode screen, Entity quest)
		{
			GameObject gameObject = Object.Instantiate(screen.questWindow.QuestCellPrefab);
			gameObject.transform.SetParent(screen.questWindow.QuestsContainer.transform, false);
			gameObject.GetComponent<QuestCellComponent>().Order = quest.GetComponent<QuestOrderComponent>().Index;
			CreateQuestItem(screen, gameObject, quest);
			if (quest.HasComponent<CompleteQuestComponent>() && !quest.HasComponent<QuestResultComponent>())
			{
				quest.GetComponent<QuestItemGUIComponent>().SetQuestCompleted(true);
			}
			else
			{
				quest.GetComponent<QuestItemGUIComponent>().ShowQuest();
			}
		}

		private void CreateQuestItem(QuestsScreenNode screen, GameObject questCellGameObject, Entity quest)
		{
			GameObject gameObject = Object.Instantiate(screen.questWindow.QuestPrefab);
			gameObject.transform.SetParent(questCellGameObject.transform, false);
			EntityBehaviour component = gameObject.GetComponent<EntityBehaviour>();
			component.BuildEntity(quest);
		}

		[OnEventFire]
		public void SetQuestUpdated(QuestProgressUpdatedEvent e, QuestNode quest, [JoinAll] QuestsScreenNode screen)
		{
			SaveAndResetPreviousQuestProgress(quest, screen.questWindow.ShowProgress);
			ScheduleEvent<ShowNextQuestAnimationEvent>(quest);
		}

		private void SaveAndResetPreviousQuestProgress(QuestNode questNode, bool showProgress)
		{
			if (questNode.questProgress.PrevValue.Equals(questNode.questProgress.CurrentValue))
			{
				return;
			}
			if (showProgress)
			{
				if (!questNode.Entity.HasComponent<QuestProgressAnimatorComponent>())
				{
					QuestProgressAnimatorComponent questProgressAnimatorComponent = new QuestProgressAnimatorComponent();
					questProgressAnimatorComponent.ProgressPrevValue = questNode.questProgress.PrevValue;
					questNode.Entity.AddComponent(questProgressAnimatorComponent);
				}
				else
				{
					questNode.Entity.GetComponent<QuestProgressAnimatorComponent>().ProgressPrevValue = questNode.questProgress.PrevValue;
				}
			}
			ScheduleEvent<ResetQuestProgressEvent>(questNode.Entity);
		}

		[OnEventFire]
		public void ShowNextQuestAnimation(ShowNextQuestAnimationEvent e, Node any, [JoinAll] ICollection<AnimatedQuestNode> quests)
		{
			if (quests.Count != 0)
			{
				List<AnimatedQuestNode> list = quests.ToList();
				list.Sort((AnimatedQuestNode a, AnimatedQuestNode b) => b.questOrder.Index.CompareTo(a.questOrder.Index));
				float num = 1f;
				for (int num2 = 0; num2 < list.Count; num2++)
				{
					NewEvent(new ShowQuestGUIAnimationEvent
					{
						ProgressDelay = num
					}).Attach(list[num2]).ScheduleDelayed((float)(num2 + 1) * num);
					NewEvent<TryShowQuestRewardNotification>().Attach(list[num2]).ScheduleDelayed((float)(num2 + 2) * num);
				}
			}
		}

		[OnEventFire]
		public void RemoveQuestAnimator(NodeRemoveEvent e, SingleNode<QuestItemGUIComponent> quest)
		{
			if (quest.Entity.HasComponent<QuestProgressAnimatorComponent>())
			{
				quest.Entity.RemoveComponent<QuestProgressAnimatorComponent>();
			}
		}

		[OnEventFire]
		public void ClearScreen(NodeRemoveEvent e, SingleNode<QuestWindowComponent> screen)
		{
			foreach (Transform item in screen.component.QuestsContainer.transform)
			{
				Object.Destroy(item.gameObject);
			}
		}

		[OnEventFire]
		public void ShowQuests(ButtonClickEvent e, SingleNode<QuestsButtonComponent> questRewardButton, [JoinAll] SingleNode<WindowsSpaceComponent> screens, [JoinAll] SingleNode<Dialogs60Component> dialogs)
		{
			QuestWindowComponent questWindowComponent = dialogs.component.Get<QuestWindowComponent>();
			questWindowComponent.ShowOnMainScreen = true;
			questWindowComponent.ShowProgress = false;
			questWindowComponent.Show(screens.component.Animators);
		}

		[OnEventFire]
		public void OpenQuestDialogs(NodeAddedEvent e, SingleNode<MainScreenComponent> mainScreen, SingleNode<TutorialShowQuestsHandler> showQuestsHandler, [JoinAll] SingleNode<Dialogs60Component> dialogs, [JoinAll] Optional<SingleNode<WindowsSpaceComponent>> screens)
		{
			showQuestsHandler.component.gameObject.SetActive(false);
			QuestWindowComponent questWindowComponent = dialogs.component.Get<QuestWindowComponent>();
			questWindowComponent.ShowOnMainScreen = true;
			questWindowComponent.ShowProgress = false;
			List<Animator> animators = new List<Animator>();
			if (screens.IsPresent())
			{
				animators = screens.Get().component.Animators;
			}
			questWindowComponent.HideDelegate = showQuestsHandler.component.OpenHullModules;
			questWindowComponent.Show(animators);
		}

		[OnEventFire]
		public void Register(NodeAddedEvent e, DailyQuestNode quest)
		{
		}

		[OnEventFire]
		public void CreateQuestResult(NodeAddedEvent e, CompletedRewardedQuestNode questNode)
		{
			if (!questNode.questProgress.PrevValue.Equals(questNode.questProgress.CurrentValue))
			{
				Entity entity = CreateEntity("QuestResult");
				entity.AddComponent<QuestResultComponent>();
				entity.AddComponent<QuestComponent>();
				entity.AddComponent<CompleteQuestComponent>();
				entity.AddComponent<RewardedQuestComponent>();
				entity.AddComponent(new QuestConditionComponent
				{
					Condition = questNode.questCondition.Condition
				});
				entity.AddComponent(new QuestRewardComponent
				{
					Reward = questNode.questReward.Reward
				});
				entity.AddComponent(new QuestOrderComponent
				{
					Index = questNode.questOrder.Index
				});
				QuestProgressComponent questProgress = questNode.questProgress;
				entity.AddComponent(new QuestProgressComponent
				{
					PrevValue = questProgress.PrevValue,
					CurrentValue = questProgress.CurrentValue,
					TargetValue = questProgress.TargetValue,
					PrevComplete = questProgress.PrevComplete,
					CurrentComplete = questProgress.CurrentComplete
				});
				entity.AddComponent(new QuestConditionDescriptionComponent
				{
					condition = questNode.questConditionDescription.condition,
					restrictionFormat = questNode.questConditionDescription.restrictionFormat,
					restrictions = questNode.questConditionDescription.restrictions
				});
			}
		}

		[OnEventFire]
		public void ClearQuestResult(NodeRemoveEvent e, SingleNode<QuestWindowComponent> mainScreen, [JoinAll][Combine] SingleNode<QuestResultComponent> result)
		{
			DeleteEntity(result.Entity);
		}
	}
}
