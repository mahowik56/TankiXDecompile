using System.Collections.Generic;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;
using UnityEngine.UI;

namespace Tanks.Lobby.ClientPaymentGUI.Impl
{
	public class Receipt : LocalizedControl
	{
		[SerializeField]
		private Text price;

		[SerializeField]
		private Text total;

		private long totalValue;

		[SerializeField]
		private ReceiptItem receiptItemPrefab;

		[SerializeField]
		private RectTransform receiptItemsContainer;

		[SerializeField]
		private Text priceLabel;

		[SerializeField]
		private GameObject totalObject;

		[SerializeField]
		private Text specialOfferText;

		[SerializeField]
		private Text totalLabel;

		public Dictionary<object, object> Lines { get; set; }

		public virtual string PriceLabel
		{
			set
			{
				priceLabel.text = value;
			}
		}

		public virtual string TotalLabel
		{
			set
			{
				totalLabel.text = value;
			}
		}

		public void SetPrice(double price, string currency)
		{
			this.price.text = price.ToStringSeparatedByThousands() + " " + currency;
		}

		public void AddSpecialOfferText(string text)
		{
			specialOfferText.gameObject.SetActive(true);
			specialOfferText.text = text;
		}

		public void AddItem(string name, long amount)
		{
			totalObject.SetActive(true);
			ReceiptItem receiptItem = Object.Instantiate(receiptItemPrefab);
			receiptItem.Init(name, amount);
			receiptItem.transform.SetParent(receiptItemsContainer, false);
			totalValue += amount;
			total.text = totalValue.ToStringSeparatedByThousands();
		}

		private void OnDisable()
		{
			totalValue = 0L;
			foreach (Transform item in receiptItemsContainer)
			{
				if (item != specialOfferText.transform)
				{
					Object.Destroy(item.gameObject);
				}
			}
			totalObject.SetActive(false);
			specialOfferText.gameObject.SetActive(false);
			specialOfferText.text = string.Empty;
		}
	}
}
