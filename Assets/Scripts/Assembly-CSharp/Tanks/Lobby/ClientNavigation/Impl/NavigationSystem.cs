using System;
using System.Collections.Generic;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientUnityIntegration.API;
using Tanks.Lobby.ClientNavigation.API;
using UnityEngine;

namespace Tanks.Lobby.ClientNavigation.Impl
{
	public class NavigationSystem : ECSSystem
	{
		public class NavigationRequestNode : Node
		{
			public ScreensRegistryComponent screensRegistry;

			public CurrentScreenComponent currentScreen;

			public HistoryComponent history;

			public RequestShowScreenComponent requestShowScreen;
		}

		public class NavigationNode : Node
		{
			public CurrentScreenComponent currentScreen;

			public HistoryComponent history;

			public ScreensRegistryComponent screensRegistry;
		}

		[Not(typeof(LockedScreenComponent))]
		public class ScreenNode : Node
		{
			public ActiveScreenComponent activeScreen;
		}

		public class GroupScreenNode : Node
		{
			public ScreenComponent screen;

			public ScreenGroupComponent screenGroup;
		}

		[OnEventFire]
		public void CreateGroup(NodeAddedEvent e, SingleNode<ScreenComponent> node)
		{
			node.Entity.CreateGroup<ScreenGroupComponent>();
		}

		[OnEventFire]
		public void CreateDialogsGroup(NodeAddedEvent e, SingleNode<Dialogs60Component> dialogs)
		{
			dialogs.Entity.CreateGroup<ScreenGroupComponent>();
		}

		[OnEventFire]
		public void RegisterScreens(NodeAddedEvent e, SingleNode<ScreensRegistryComponent> navigationNode, [Combine][Context] SingleNode<ScreensBundleComponent> screensBundleNode, SingleNode<ScreensLayerComponent> layerNode)
		{
			foreach (ScreenComponent screen in screensBundleNode.component.Screens)
			{
				base.Log.InfoFormat("RegisterScreens {0}", screen.gameObject.name);
				GameObject gameObject = screen.gameObject;
				if (gameObject.GetComponent<NoScaleScreen>() == null)
				{
				}
				navigationNode.component.screens.Add(gameObject);
				screen.transform.SetParent((gameObject.GetComponent<NoScaleScreen>() != null) ? layerNode.component.screens60Layer : layerNode.component.screensLayer, false);
			}
			if (screensBundleNode.component.Dialogs60 != null)
			{
				screensBundleNode.component.Dialogs60.transform.SetParent(layerNode.component.dialogs60Layer, false);
			}
			UnityEngine.Object.Destroy(screensBundleNode.component.gameObject);
			ScheduleEvent<ScreensLoadedEvent>(navigationNode);
		}

		[OnEventComplete]
		public void TryShowRequestedScreenAfterScreensLoad(ScreensLoadedEvent e, NavigationRequestNode navigationNode)
		{
			TryShowScreen(navigationNode);
		}

		[OnEventFire]
		public void TryShowRequestedScreen(NodeAddedEvent e, NavigationRequestNode navigationNode)
		{
			TryShowScreen(navigationNode);
		}

		[OnEventFire]
		public void RequestShowScreen(ShowScreenEvent e, Node any, [JoinAll] SingleNode<ScreensRegistryComponent> navigationNode)
		{
			base.Log.InfoFormat("RequestShowScreen {0}", e.ShowScreenData.ScreenType.Name);
			RequestShowScreenComponent requestShowScreenComponent = new RequestShowScreenComponent();
			requestShowScreenComponent.Event = e;
			navigationNode.Entity.AddComponent(requestShowScreenComponent);
		}

		[OnEventFire]
		public void GoBack(GoBackRequestEvent e, Node any, [JoinAll] NavigationNode navigationNode, [JoinAll] ScreenNode screen)
		{
			HistoryComponent history = navigationNode.history;
			if (history.screens.Count <= 0)
			{
				return;
			}
			ShowScreenData showScreenData = navigationNode.history.screens.Peek();
			ScreensRegistryComponent screensRegistry = navigationNode.screensRegistry;
			GameObject nonActiveScreen = GetNonActiveScreen(showScreenData.ScreenType, screensRegistry);
			if (nonActiveScreen != null)
			{
				OverrideGoBack component = nonActiveScreen.GetComponent<OverrideGoBack>();
				if (component != null)
				{
					showScreenData = component.ScreenData;
					nonActiveScreen = GetNonActiveScreen(showScreenData.ScreenType, screensRegistry);
				}
				ScheduleEvent<GoBackEvent>(any.Entity);
				navigationNode.history.screens.Pop();
				CurrentScreenComponent currentScreen = navigationNode.currentScreen;
				if (currentScreen.showScreenData.Context != null)
				{
					currentScreen.showScreenData.Context.RemoveComponent<ScreenGroupComponent>();
				}
				GameObject activeScreen = GetActiveScreen(currentScreen.showScreenData.ScreenType, navigationNode.screensRegistry);
				currentScreen.screen.RemoveComponent<ActiveScreenComponent>();
				currentScreen.screen.AddComponent<ScreenHidingComponent>();
				currentScreen.showScreenData.FreeContext();
				ActivateShowingScreen(nonActiveScreen, activeScreen, showScreenData, currentScreen);
				NewEvent<PostGoBackEvent>().Attach(navigationNode).ScheduleDelayed(0f);
			}
		}

		[OnEventFire]
		public void SetCurrentScreen(NodeAddedEvent e, SingleNode<ScreenComponent> screenNode, [JoinAll] SingleNode<CurrentScreenComponent> currentScreen)
		{
			CurrentScreenComponent component = currentScreen.component;
			component.screen = screenNode.Entity;
			screenNode.Entity.AddComponent<ActiveScreenComponent>();
		}

		[OnEventFire]
		public void JoinContextToScreen(NodeAddedEvent e, GroupScreenNode screenNode, [JoinAll][Mandatory] SingleNode<CurrentScreenComponent> currentScreen)
		{
			ShowScreenData showScreenData = currentScreen.component.showScreenData;
			if (showScreenData != null && showScreenData.Context != null)
			{
				JoinContext(showScreenData.Context, screenNode.Entity);
			}
		}

		private void TryShowScreen(NavigationRequestNode navigationNode)
		{
			ShowScreenData showScreenData = navigationNode.requestShowScreen.Event.ShowScreenData;
			ScreensRegistryComponent screensRegistry = navigationNode.screensRegistry;
			GameObject nonActiveScreen = GetNonActiveScreen(showScreenData.ScreenType, screensRegistry);
			if (nonActiveScreen != null)
			{
				navigationNode.Entity.RemoveComponent<RequestShowScreenComponent>();
				CurrentScreenComponent currentScreen = navigationNode.currentScreen;
				HistoryComponent history = navigationNode.history;
				GameObject gameObject = null;
				if (currentScreen.screen != null)
				{
					gameObject = GetActiveScreen(currentScreen.showScreenData.ScreenType, navigationNode.screensRegistry);
					currentScreen.screen.RemoveComponent<ActiveScreenComponent>();
					currentScreen.screen.AddComponent<ScreenHidingComponent>();
					if (gameObject.GetComponent<ScreenComponent>().LogInHistory)
					{
						ShowScreenData showScreenData2 = currentScreen.showScreenData.InvertAnimationDirection(showScreenData.AnimationDirection);
						Stack<ShowScreenData> screens = history.screens;
						if (screens.Count > 0 && screens.Peek().ScreenType == showScreenData2.ScreenType)
						{
							screens.Pop();
						}
						screens.Push(showScreenData2);
						if (showScreenData2.Context != null)
						{
							showScreenData2.Context.RemoveComponent<ScreenGroupComponent>();
						}
					}
				}
				ActivateShowingScreen(nonActiveScreen, gameObject, showScreenData, currentScreen);
			}
			else if (GetActiveScreen(showScreenData.ScreenType, screensRegistry) != null)
			{
				navigationNode.Entity.RemoveComponent<RequestShowScreenComponent>();
			}
			else
			{
				base.Log.WarnFormat("Skip remove RequestShowScreenComponent {0}", navigationNode.requestShowScreen.Event.ShowScreenData.ScreenType.Name);
			}
		}

		[OnEventFire]
		public void ClearHistory(NodeAddedEvent evt, SingleNode<ScreenComponent> screen, SingleNode<HistoryComponent> navigation)
		{
			ScreenHistoryCleaner component = screen.component.GetComponent<ScreenHistoryCleaner>();
			if (!(component == null))
			{
				component.ClearHistory(navigation.component.screens);
			}
		}

		private void ActivateShowingScreen(GameObject showingScreen, GameObject hidingScreen, ShowScreenData showScreenData, CurrentScreenComponent currentScreenComponent)
		{
			currentScreenComponent.showScreenData = showScreenData;
			showingScreen.GetComponent<EntityBehaviour>().enabled = false;
			showingScreen.SetActive(true);
			showingScreen.GetComponent<EntityBehaviour>().enabled = true;
			PlayAnimation(showingScreen, hidingScreen, showScreenData.AnimationDirection);
		}

		private void JoinContext(Entity context, Entity key)
		{
			if (context.HasComponent<ScreenGroupComponent>())
			{
				context.RemoveComponent<ScreenGroupComponent>();
			}
			context.AddComponent(new ScreenGroupComponent(key));
		}

		private void PlayAnimation(GameObject showingScreen, GameObject hidingScreen, AnimationDirection animationDirection)
		{
			if (hidingScreen != null)
			{
				PlayHideAnimation(hidingScreen.GetComponent<Animator>(), animationDirection);
			}
			PlayShowAnimation(showingScreen.GetComponent<Animator>(), animationDirection);
		}

		private GameObject GetNonActiveScreen(Type screenType, ScreensRegistryComponent screens)
		{
			return GetScreen(screenType, screens, false);
		}

		private GameObject GetActiveScreen(Type screenType, ScreensRegistryComponent screens)
		{
			return GetScreen(screenType, screens, true);
		}

		private GameObject GetScreen(Type screenType, ScreensRegistryComponent screens, bool active)
		{
			foreach (GameObject screen in screens.screens)
			{
				if (screen.GetComponent(screenType) != null && screen.activeSelf == active)
				{
					return screen;
				}
			}
			return null;
		}

		private void PlayShowAnimation(Animator screen, AnimationDirection dir)
		{
			screen.SetInteger("type", (int)dir);
			screen.SetTrigger("show");
		}

		private void PlayHideAnimation(Animator screen, AnimationDirection dir)
		{
			screen.SetInteger("type", (int)dir);
			screen.SetTrigger("hide");
		}
	}
}
