using System;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;
using UnityEngine.EventSystems;
using tanks.modules.lobby.ClientGarage.Scripts.API.UI.Items;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class SlotItemView : MonoBehaviour, IPointerClickHandler, IPointerDownHandler, IPointerEnterHandler, IPointerExitHandler, IEventSystemHandler
	{
		public GameObject moduleCard3DPrefab;

		private ModuleCardView moduleCard3D;

		public GameObject itemContent;

		public Action<SlotItemView> onClick;

		public Action<SlotItemView> onDoubleClick;

		public TooltipShowBehaviour tooltip;

		public Animator outline;

		public Color pressedColor;

		public Color highlidhtedColor;

		public Color upgradeColor;

		public float selectionSaturation = 1f;

		public float highlightedSaturation = 0.1f;

		private bool highlightEnable = true;

		private ModuleItem moduleItem;

		private bool selected;

		public bool HighlightEnable
		{
			get
			{
				return highlightEnable;
			}
			set
			{
				highlightEnable = value;
				UpdateHighlight();
			}
		}

		public ModuleItem ModuleItem
		{
			get
			{
				return moduleItem;
			}
		}

		public void Awake()
		{
			GameObject gameObject = UnityEngine.Object.Instantiate(moduleCard3DPrefab);
			gameObject.transform.SetParent(itemContent.transform, false);
			gameObject.transform.position = Vector3.zero;
			moduleCard3D = gameObject.GetComponent<ModuleCardView>();
		}

		private void OnEnable()
		{
			if (moduleItem != null)
			{
				UpdateHighlight();
			}
		}

		public void SetScaleToCard3D(float scale)
		{
			moduleCard3D.transform.localScale = new Vector3(scale, scale, scale);
		}

		public void UpdateView(ModuleItem moduleItem)
		{
			this.moduleItem = moduleItem;
			moduleCard3D.UpdateView(moduleItem.MarketItem.Id, -1L);
			UpdateHighlight();
			tooltip.SetCustomContentData(moduleItem);
		}

		public void UpdateHighlight()
		{
			if (selected)
			{
				HighlightPressed();
			}
			else if (!highlightEnable)
			{
				HideHighlight();
			}
			else if (moduleItem.ImproveAvailable())
			{
				HighlightUpgrade();
			}
			else
			{
				HideHighlight();
			}
		}

		public void OnPointerClick(PointerEventData eventData)
		{
			if (eventData.button != PointerEventData.InputButton.Right)
			{
				if (onClick != null && eventData.clickCount == 1)
				{
					onClick(this);
				}
				if (onDoubleClick != null && eventData.clickCount > 1)
				{
					onDoubleClick(this);
				}
			}
		}

		public void Select()
		{
			selected = true;
			UpdateHighlight();
		}

		public void Deselect()
		{
			selected = false;
			UpdateHighlight();
		}

		public void OnPointerDown(PointerEventData eventData)
		{
			if (eventData.button != PointerEventData.InputButton.Right && !selected && highlightEnable)
			{
				HighlightPressed();
			}
		}

		public void OnPointerEnter(PointerEventData eventData)
		{
			if (!selected && highlightEnable)
			{
				HighlightHighlighted();
			}
		}

		public void OnPointerExit(PointerEventData eventData)
		{
			if (!selected)
			{
				UpdateHighlight();
			}
		}

		private void HighlightUpgrade()
		{
			outline.SetInteger("colorCode", 3);
		}

		private void HighlightPressed()
		{
			outline.SetInteger("colorCode", 1);
		}

		private void HighlightHighlighted()
		{
			outline.SetInteger("colorCode", 2);
		}

		private void HideHighlight()
		{
			outline.SetInteger("colorCode", 0);
		}
	}
}
