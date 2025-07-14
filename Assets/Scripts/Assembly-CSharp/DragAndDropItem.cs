using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

[RequireComponent(typeof(Image))]
public class DragAndDropItem : MonoBehaviour, IBeginDragHandler, IDragHandler, IEndDragHandler, IEventSystemHandler
{
	public delegate void DragEvent(DragAndDropItem item, PointerEventData eventData);

	public static DragAndDropItem draggedItem;

	public static GameObject draggedItemContentCopy;

	public static DragAndDropCell sourceCell;

	private GameObject itemContent;

	public static event DragEvent OnItemDragStartEvent;

	public static event DragEvent OnItemDragEndEvent;

	private void Awake()
	{
		itemContent = base.transform.GetChild(0).gameObject;
	}

	public void OnBeginDrag(PointerEventData eventData)
	{
		if (eventData.button != PointerEventData.InputButton.Right)
		{
			sourceCell = GetComponentInParent<DragAndDropCell>();
			draggedItem = this;
			draggedItemContentCopy = GetCopy(itemContent);
			Canvas componentInParent = sourceCell.transform.parent.GetComponentInParent<Canvas>();
			if (componentInParent != null)
			{
				draggedItemContentCopy.transform.SetParent(componentInParent.transform, false);
				draggedItemContentCopy.transform.SetAsLastSibling();
			}
			MakeVisible(false);
			if (DragAndDropItem.OnItemDragStartEvent != null)
			{
				DragAndDropItem.OnItemDragStartEvent(this, eventData);
			}
		}
	}

	private GameObject GetCopy(GameObject draggedItemContent)
	{
		GameObject gameObject = Object.Instantiate(draggedItemContent);
		gameObject.layer = base.gameObject.layer;
		RectTransform component = gameObject.GetComponent<RectTransform>();
		component.anchorMax = new Vector2(0.5f, 0.5f);
		component.anchorMin = new Vector2(0.5f, 0.5f);
		component.pivot = new Vector2(0.5f, 0.5f);
		component.anchoredPosition = Vector2.zero;
		component.sizeDelta = draggedItemContent.GetComponent<RectTransform>().rect.size;
		gameObject.SetActive(true);
		return gameObject;
	}

	public void OnDrag(PointerEventData data)
	{
		if (data.button != PointerEventData.InputButton.Right && draggedItemContentCopy != null)
		{
			Canvas componentInParent = sourceCell.transform.parent.GetComponentInParent<Canvas>();
			Vector2 localPoint;
			if (RectTransformUtility.ScreenPointToLocalPointInRectangle(componentInParent.GetComponent<RectTransform>(), Input.mousePosition, componentInParent.worldCamera, out localPoint))
			{
				draggedItemContentCopy.GetComponent<RectTransform>().anchoredPosition = localPoint;
			}
		}
	}

	public void OnEndDrag(PointerEventData eventData)
	{
		if (eventData == null || eventData.button != PointerEventData.InputButton.Right)
		{
			if (draggedItemContentCopy != null)
			{
				Object.Destroy(draggedItemContentCopy);
			}
			MakeVisible(true);
			if (DragAndDropItem.OnItemDragEndEvent != null)
			{
				DragAndDropItem.OnItemDragEndEvent(this, eventData);
			}
			draggedItem = null;
			draggedItemContentCopy = null;
			sourceCell = null;
		}
	}

	public void MakeVisible(bool condition)
	{
		itemContent.GetComponent<CanvasGroup>().alpha = (condition ? 1 : 0);
		itemContent.transform.GetChild(1).gameObject.SetActive(condition);
	}
}
