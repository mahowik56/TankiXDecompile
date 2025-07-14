using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Kernel.OSGi.ClientCore.API;
using Platform.Library.ClientUnityIntegration.API;
using Tanks.Lobby.ClientControls.API;
using Tanks.Lobby.ClientNavigation.API;
using UnityEngine;
using UnityEngine.EventSystems;

namespace Tanks.Lobby.ClientNavigation.Impl
{
	public class DialogsSystem : ECSSystem
	{
		[Inject]
		public new static EngineServiceInternal EngineService { get; set; }

		[OnEventFire]
		public void CloseDialog(NodeRemoveEvent e, SingleNode<ActiveScreenComponent> screen, [JoinAll] SingleNode<Dialogs60Component> dialogs)
		{
			dialogs.component.CloseAll(string.Empty);
		}

		[OnEventFire]
		public void AddScreenLockClickListener(NodeAddedEvent e, SingleNode<ScreenLockComponent> screenLock)
		{
			screenLock.component.gameObject.AddComponent<DialogsOuterClickListener>().ClickAction = OnClick;
		}

		private void OnClick(PointerEventData eventData)
		{
			EngineService.Engine.ScheduleEvent(new DialogsOuterClickEvent
			{
				EventData = eventData
			}, EngineService.EntityStub);
		}

		[OnEventFire]
		public void SendCancelEventToDialogs(DialogsOuterClickEvent e, Node node, [JoinAll] SingleNode<Dialogs60Component> dialogs)
		{
			foreach (Transform item in dialogs.component.transform)
			{
				ExecuteEvents.Execute(item.gameObject, e.EventData, ExecuteEvents.cancelHandler);
			}
		}

		[OnEventComplete]
		public void MergeDialogs(NodeAddedEvent e, SingleNode<Dialogs60Component> newDialogs, [JoinAll][Combine] SingleNode<Dialogs60Component> dialogs)
		{
			if (newDialogs.Entity != dialogs.Entity)
			{
				while (newDialogs.component.transform.childCount > 0)
				{
					Transform child = newDialogs.component.transform.GetChild(0);
					child.SetParent(dialogs.component.transform, false);
				}
				Object.Destroy(newDialogs.component.gameObject);
			}
		}
	}
}
