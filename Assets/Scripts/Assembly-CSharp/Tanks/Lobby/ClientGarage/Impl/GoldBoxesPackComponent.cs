using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientUnityIntegration.API;
using TMPro;
using Tanks.Lobby.ClientControls.API;
using Tanks.Lobby.ClientPaymentGUI.Impl;
using UnityEngine;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class GoldBoxesPackComponent : BehaviourComponent
	{
		[SerializeField]
		private TextMeshProUGUI _cardNameText;

		[SerializeField]
		private TextMeshProUGUI _boxCountText;

		[SerializeField]
		private ImageSkin _imageSkin;

		[SerializeField]
		private TextMeshProUGUI _priceText;

		[SerializeField]
		private GameObject _hitMarkObject;

		[SerializeField]
		private GameObject _discountMarkObject;

		[SerializeField]
		private TextMeshProUGUI _discountMarkText;

		[SerializeField]
		private PurchaseButtonComponent _purchaseButton;

		public string CardName
		{
			set
			{
				_cardNameText.text = value;
			}
		}

		public long BoxCount
		{
			set
			{
				_boxCountText.text = "x" + value;
			}
		}

		public string SpriteUid
		{
			set
			{
				_imageSkin.SpriteUid = value;
			}
		}

		public string Price
		{
			set
			{
				_priceText.text = value;
			}
		}

		public bool HitMarkEnabled
		{
			set
			{
				_hitMarkObject.SetActive(value);
			}
		}

		public int Discount
		{
			set
			{
				if (value > 0)
				{
					_discountMarkObject.SetActive(true);
					_discountMarkText.text = "-" + value + "%";
				}
				else
				{
					_discountMarkObject.SetActive(false);
				}
			}
		}

		public Entity GoodsEntity
		{
			set
			{
				_purchaseButton.GoodsEntity = value;
			}
		}
	}
}
