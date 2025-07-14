using System.Collections.Generic;
using Platform.Library.ClientUnityIntegration.API;
using UnityEngine;

namespace Tanks.Lobby.ClientBattleSelect.Impl
{
	public class ItemContainerComponent : BehaviourComponent
	{
		[SerializeField]
		private GameObject itemContainer;

		[SerializeField]
		private GameObject itemPrefab;

		protected void InstantiateItems(List<SpecialOfferItem> items)
		{
			foreach (SpecialOfferItem item in items)
			{
				GameObject gameObject = Object.Instantiate(itemPrefab, itemContainer.transform, false);
				SpecialOfferItemUiComponent component = gameObject.GetComponent<SpecialOfferItemUiComponent>();
				component.title.text = item.Title;
				if (item.Quantity == 0)
				{
					component.quantity.enabled = false;
				}
				else
				{
					component.quantity.text = "x" + item.Quantity;
				}
				if (item.RibbonLabel == string.Empty)
				{
					component.ribbon.gameObject.SetActive(false);
				}
				else
				{
					component.ribbon.gameObject.SetActive(true);
					component.ribbonLabel.text = item.RibbonLabel;
				}
				component.imageSkin.SpriteUid = item.SpriteUid;
			}
		}

		protected void ClearItems()
		{
			foreach (Transform item in itemContainer.transform)
			{
				Object.Destroy(item.gameObject);
			}
		}
	}
}
