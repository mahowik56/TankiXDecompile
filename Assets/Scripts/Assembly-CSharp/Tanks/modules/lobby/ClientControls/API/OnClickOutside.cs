using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.Events;

namespace tanks.modules.lobby.ClientControls.API
{
	public class OnClickOutside : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler, IEventSystemHandler
	{
		[SerializeField]
		private UnityEvent onClick;

		private bool isInside;

		public void OnPointerEnter(PointerEventData eventData)
		{
			isInside = true;
		}

		public void OnPointerExit(PointerEventData eventData)
		{
			isInside = false;
		}

		private void OnDisable()
		{
			isInside = false;
		}

		private void Update()
		{
			if (!isInside && (Input.GetMouseButtonDown(0) || Input.GetMouseButtonDown(1)))
			{
				onClick.Invoke();
			}
		}
	}
}
