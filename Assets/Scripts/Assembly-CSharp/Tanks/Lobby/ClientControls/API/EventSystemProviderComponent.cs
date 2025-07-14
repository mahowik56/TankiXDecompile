using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientUnityIntegration.API;
using UnityEngine.EventSystems;

namespace Tanks.Lobby.ClientControls.API
{
	public class EventSystemProviderComponent : ECSBehaviour, Component, IPointerDownHandler, IBeginDragHandler, IDragHandler, IEndDragHandler, IPointerClickHandler, IEventSystemHandler
	{
		private EntityBehaviour entityBehaviour;

		private void Awake()
		{
			entityBehaviour = GetComponent<EntityBehaviour>();
		}

		public void OnPointerDown(PointerEventData eventData)
		{
			ExecuteInFlow<EventSystemOnPointerDownEvent>(eventData);
		}

		public void OnBeginDrag(PointerEventData eventData)
		{
			ExecuteInFlow<EventSystemOnBeginDragEvent>(eventData);
		}

		public void OnDrag(PointerEventData eventData)
		{
			ExecuteInFlow<EventSystemOnDragEvent>(eventData);
		}

		public void OnEndDrag(PointerEventData eventData)
		{
			ExecuteInFlow<EventSystemOnEndDragEvent>(eventData);
		}

		public void OnPointerClick(PointerEventData eventData)
		{
			ExecuteInFlow<EventSystemOnPointerClickEvent>(eventData);
		}

		private void ExecuteInFlow<T>(PointerEventData eventData) where T : EventSystemPointerEvent, new()
		{
			ScheduleEvent(new T
			{
				PointerEventData = eventData
			}, entityBehaviour.Entity);
		}
	}
}
