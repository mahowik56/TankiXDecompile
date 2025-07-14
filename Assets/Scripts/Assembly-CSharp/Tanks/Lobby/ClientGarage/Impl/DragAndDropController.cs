using System;
using System.Collections.Generic;
using Tanks.Lobby.ClientGarage.API;
using Tanks.Lobby.ClientGarage.Impl.Tutorial;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using tanks.modules.lobby.ClientGarage.Scripts.API.UI.Items;
using tanks.modules.lobby.ClientGarage.Scripts.Impl.NewModules.UI.New.DragAndDrop;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class DragAndDropController : MonoBehaviour, IDropController
	{
		public TankPartCollectionView turretCollectionView;

		public TankPartCollectionView hullCollectionView;

		public CollectionView collectionView;

		public GameObject background;

		private bool changeSize;

		private DropDescriptor delayedDrop;

		public static float OVER_ITEM_Z_OFFSET = -7f;

		public Action<DropDescriptor, DropDescriptor> onDrop;

		public void Awake()
		{
			turretCollectionView.activeSlot.GetComponent<DragAndDropCell>().dropController = this;
			turretCollectionView.activeSlot2.GetComponent<DragAndDropCell>().dropController = this;
			turretCollectionView.passiveSlot.GetComponent<DragAndDropCell>().dropController = this;
			hullCollectionView.activeSlot.GetComponent<DragAndDropCell>().dropController = this;
			hullCollectionView.activeSlot2.GetComponent<DragAndDropCell>().dropController = this;
			hullCollectionView.passiveSlot.GetComponent<DragAndDropCell>().dropController = this;
			foreach (CollectionSlotView value in CollectionView.slots.Values)
			{
				value.GetComponent<DragAndDropCell>().dropController = this;
			}
		}

		public void OnEnable()
		{
			background.SetActive(false);
			DragAndDropItem.OnItemDragStartEvent += OnAnyItemDragStart;
			DragAndDropItem.OnItemDragEndEvent += OnAnyItemDragEnd;
		}

		public void OnDisable()
		{
			DragAndDropItem.OnItemDragStartEvent -= OnAnyItemDragStart;
			DragAndDropItem.OnItemDragEndEvent -= OnAnyItemDragEnd;
			CorrectFinishDrag();
		}

		private void Update()
		{
			if (changeSize)
			{
				changeSize = false;
				DragAndDropItem.draggedItemContentCopy.GetComponent<Animator>().SetBool("GrowUp", true);
			}
			if (delayedDrop.item != null)
			{
				OnDrop(delayedDrop.sourceCell, delayedDrop.destinationCell, delayedDrop.item);
				delayedDrop.sourceCell = null;
				delayedDrop.destinationCell = null;
				delayedDrop.item = null;
			}
		}

		private void OnAnyItemDragStart(DragAndDropItem item, PointerEventData eventData)
		{
			float oVER_SCREEN_Z_OFFSET = NewModulesScreenUIComponent.OVER_SCREEN_Z_OFFSET;
			if (!ModulesTutorialUtil.TUTORIAL_MODE)
			{
				background.SetActive(true);
				background.transform.SetAsLastSibling();
				Vector3 anchoredPosition3D = background.GetComponent<RectTransform>().anchoredPosition3D;
				anchoredPosition3D.z = oVER_SCREEN_Z_OFFSET * 0.5f - 0.01f;
				background.GetComponent<RectTransform>().anchoredPosition3D = anchoredPosition3D;
			}
			HighlightPossibleSlots();
			MoveDraggingCardInFronfOfAll(oVER_SCREEN_Z_OFFSET + OVER_ITEM_Z_OFFSET);
			DragAndDropItem.draggedItemContentCopy.transform.GetChild(0).GetComponent<Animator>().SetInteger("colorCode", 1);
			if (DragAndDropItem.sourceCell.GetComponent<SlotView>() is CollectionSlotView)
			{
				changeSize = true;
			}
		}

		private void OnAnyItemDragEnd(DragAndDropItem item, PointerEventData eventData)
		{
			background.SetActive(false);
			turretCollectionView.CancelHighlightForDrop();
			hullCollectionView.CancelHighlightForDrop();
			foreach (KeyValuePair<ModuleItem, CollectionSlotView> slot in CollectionView.slots)
			{
				CollectionSlotView value = slot.Value;
				value.GetComponent<DragAndDropCell>().enabled = true;
				value.TurnOffRenderAboveAll();
			}
		}

		private bool DraggedItemWasntDrop(DragAndDropItem item)
		{
			return DragAndDropItem.sourceCell.Equals(item.GetComponentInParent<DragAndDropCell>());
		}

		private void OnApplicationFocus(bool hasFocus)
		{
			CorrectFinishDrag();
		}

		private void CorrectFinishDrag()
		{
			DragAndDropItem draggedItem = DragAndDropItem.draggedItem;
			if (draggedItem != null)
			{
				draggedItem.OnEndDrag(null);
				OnAnyItemDragEnd(draggedItem, null);
			}
		}

		private bool CellIsTankSlot(DragAndDropCell cell)
		{
			return cell.GetComponent<TankSlotView>() != null;
		}

		private void HighlightPossibleSlots()
		{
			ModuleItem moduleItem = DragAndDropItem.draggedItem.GetComponent<SlotItemView>().ModuleItem;
			hullCollectionView.TurnOffSlots();
			turretCollectionView.TurnOffSlots();
			if (moduleItem.TankPartModuleType == TankPartModuleType.WEAPON)
			{
				turretCollectionView.TurnOnSlotsByTypeAndHighlightForDrop(moduleItem.ModuleBehaviourType);
			}
			else
			{
				hullCollectionView.TurnOnSlotsByTypeAndHighlightForDrop(moduleItem.ModuleBehaviourType);
			}
			foreach (KeyValuePair<ModuleItem, CollectionSlotView> slot in CollectionView.slots)
			{
				CollectionSlotView value = slot.Value;
				if (slot.Key == moduleItem)
				{
					value.TurnOnRenderAboveAll();
				}
				else
				{
					value.GetComponent<DragAndDropCell>().enabled = false;
				}
			}
		}

		private void MoveDraggingCardInFronfOfAll(float zOffset)
		{
			Vector3 anchoredPosition3D = DragAndDropItem.draggedItemContentCopy.GetComponent<RectTransform>().anchoredPosition3D;
			anchoredPosition3D.z = zOffset;
			DragAndDropItem.draggedItemContentCopy.GetComponent<RectTransform>().anchoredPosition3D = anchoredPosition3D;
			TurnOnRenderAboveAll(DragAndDropItem.draggedItemContentCopy);
		}

		public void TurnOnRenderAboveAll(GameObject gameObject)
		{
			Canvas canvas = gameObject.AddComponent<Canvas>();
			canvas.renderMode = RenderMode.WorldSpace;
			canvas.overrideSorting = true;
			canvas.sortingOrder = 30;
			gameObject.AddComponent<GraphicRaycaster>();
			CanvasGroup canvasGroup = gameObject.GetComponent<CanvasGroup>() ?? gameObject.AddComponent<CanvasGroup>();
			canvasGroup.blocksRaycasts = true;
			canvasGroup.ignoreParentGroups = true;
			canvasGroup.interactable = false;
		}

		public void OnDrop(DragAndDropCell cellFrom, DragAndDropCell cellTo, DragAndDropItem item)
		{
			if (item == null || cellFrom == cellTo)
			{
				return;
			}
			DropDescriptor arg = new DropDescriptor
			{
				item = item,
				sourceCell = cellFrom,
				destinationCell = cellTo
			};
			if (CellIsTankSlot(cellTo))
			{
				if (CellIsTankSlot(cellFrom))
				{
					DropDescriptor arg2 = new DropDescriptor
					{
						destinationCell = arg.sourceCell,
						item = arg.destinationCell.GetItem(),
						sourceCell = arg.destinationCell
					};
					arg.destinationCell.PlaceItem(arg.item);
					if (arg2.item != null)
					{
						arg.sourceCell.PlaceItem(arg2.item);
					}
					if (onDrop != null)
					{
						onDrop(arg, arg2);
					}
					return;
				}
				DragAndDropItem item2 = arg.destinationCell.GetItem();
				DragAndDropCell destinationCell = null;
				if (item2 != null)
				{
					ModuleItem moduleItem = item2.GetComponent<SlotItemView>().ModuleItem;
					destinationCell = CollectionView.slots[moduleItem].GetComponent<DragAndDropCell>();
				}
				DropDescriptor arg3 = new DropDescriptor
				{
					destinationCell = destinationCell,
					item = item2,
					sourceCell = arg.destinationCell
				};
				arg.destinationCell.PlaceItem(arg.item);
				if (arg3.item != null)
				{
					arg3.destinationCell.PlaceItem(arg3.item);
				}
				if (onDrop != null)
				{
					onDrop(arg, arg3);
				}
			}
			else
			{
				arg.destinationCell.PlaceItem(arg.item);
				if (onDrop != null)
				{
					onDrop(arg, default(DropDescriptor));
				}
			}
		}
	}
}
