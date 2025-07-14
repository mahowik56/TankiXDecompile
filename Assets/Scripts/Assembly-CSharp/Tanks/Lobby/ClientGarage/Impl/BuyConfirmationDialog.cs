using System;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Kernel.OSGi.ClientCore.API;
using Platform.Library.ClientUnityIntegration.API;
using TMPro;
using Tanks.Lobby.ClientControls.API;
using Tanks.Lobby.ClientEntrance.API;
using Tanks.Lobby.ClientGarage.API;
using Tanks.Lobby.ClientNavigation.API;
using Tanks.Lobby.ClientPayment.API;
using Tanks.Lobby.ClientProfile.API;
using UnityEngine;
using UnityEngine.UI;
using tanks.modules.lobby.ClientPayment.Scripts.API;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class BuyConfirmationDialog : ECSBehaviour
	{
		[SerializeField]
		private GameObject buyButton;

		[SerializeField]
		private GameObject xBuyButton;

		[SerializeField]
		private TextMeshProUGUI confirmationText;

		[SerializeField]
		private TextMeshProUGUI price;

		[SerializeField]
		private TextMeshProUGUI xPrice;

		[SerializeField]
		private LocalizedField confirmation;

		[SerializeField]
		private GameObject confirmationDialog;

		[SerializeField]
		private GameObject addXCryDialog;

		[SerializeField]
		private GameObject addCryDialog;

		[SerializeField]
		private LocalizedField addXCryText;

		[SerializeField]
		private LocalizedField addCryText;

		[SerializeField]
		private TextMeshProUGUI addXCry;

		[SerializeField]
		private TextMeshProUGUI addCry;

		private Action onBought;

		private Action onCancel;

		private int priceValue;

		private int amount;

		private GarageItem item;

		private bool contextShop;

		[Inject]
		public new static EngineServiceInternal EngineService { get; set; }

		public void Show(GarageItem item, Action boughtAction, string customLabel = null, Action cancelAction = null)
		{
			amount = 1;
			this.item = item;
			base.gameObject.SetActive(true);
			MainScreenComponent.Instance.OverrideOnBack(Cancel);
			long money = SelfUserComponent.SelfUser.GetComponent<UserMoneyComponent>().Money;
			priceValue = item.Price;
			if (money < priceValue)
			{
				addCryDialog.SetActive(true);
				addXCryDialog.SetActive(false);
				confirmationDialog.SetActive(false);
				addCry.text = string.Format(addCryText, item.Price - money);
				return;
			}
			buyButton.GetComponent<Button>().interactable = true;
			addCryDialog.SetActive(false);
			addXCryDialog.SetActive(false);
			confirmationDialog.SetActive(true);
			confirmationText.text = string.Format(confirmation, GetName(item, 1, customLabel));
			buyButton.SetActive(true);
			xBuyButton.SetActive(false);
			onBought = boughtAction;
			onCancel = cancelAction;
			price.text = item.Price.ToStringSeparatedByThousands();
		}

		private string GetName(GarageItem item, int amount, string customLabel)
		{
			return (!string.IsNullOrEmpty(customLabel)) ? customLabel : (((amount <= 1) ? string.Empty : (amount + " ")) + GetName(item));
		}

		private string GetName(GarageItem item)
		{
			VisualItem visualItem = item as VisualItem;
			if (visualItem != null && visualItem.ParentItem != null)
			{
				return MarketItemNameLocalization.GetDetailedName(visualItem.MarketItem);
			}
			return item.Name;
		}

		public void ShowAddCrystals(int price)
		{
			base.gameObject.SetActive(true);
			MainScreenComponent.Instance.OverrideOnBack(Cancel);
			long money = SelfUserComponent.SelfUser.GetComponent<UserMoneyComponent>().Money;
			addCryDialog.SetActive(true);
			addXCryDialog.SetActive(false);
			confirmationDialog.SetActive(false);
			addCry.text = string.Format(addCryText, price - money);
		}

		public void XShow(GarageItem item, Action boughtAction, int price, int amount = 1, string customLabel = null, bool shopContext = false, Action cancelAction = null)
		{
			this.amount = amount;
			this.item = item;
			contextShop = shopContext;
			base.gameObject.SetActive(true);
			MainScreenComponent.Instance.OverrideOnBack(Cancel);
			long money = SelfUserComponent.SelfUser.GetComponent<UserXCrystalsComponent>().Money;
			priceValue = price;
			if (money < priceValue)
			{
				addCryDialog.SetActive(false);
				addXCryDialog.SetActive(true);
				confirmationDialog.SetActive(false);
				addXCry.text = string.Format(addXCryText, priceValue - money);
				return;
			}
			xBuyButton.GetComponent<Button>().interactable = true;
			onBought = boughtAction;
			onCancel = cancelAction;
			addCryDialog.SetActive(false);
			addXCryDialog.SetActive(false);
			confirmationDialog.SetActive(true);
			confirmationText.text = string.Format(confirmation, GetName(item, amount, customLabel));
			buyButton.SetActive(false);
			xBuyButton.SetActive(true);
			xPrice.text = priceValue.ToStringSeparatedByThousands();
		}

		public void Confirm()
		{
			buyButton.GetComponent<Button>().interactable = false;
			GetComponent<Animator>().SetTrigger("buy");
			item.WaitForBuy = true;
			item.Buy(onBought);
			MainScreenComponent.Instance.ClearOnBackOverride();
		}

		public void XConfirm()
		{
			xBuyButton.GetComponent<Button>().interactable = false;
			GetComponent<Animator>().SetTrigger("buy");
			item.WaitForBuy = true;
			item.XBuy(onBought, priceValue, amount);
			MainScreenComponent.Instance.ClearOnBackOverride();
		}

		public void AddXCry()
		{
			if (!contextShop)
			{
				this.SendEvent<GoToXCryShopScreen>(SelfUserComponent.SelfUser);
			}
			else
			{
				UnityEngine.Object.FindObjectOfType<Dialogs60Component>().Get<BuyXCrystalsDialogComponent>().Show();
			}
			Cancel();
		}

		public void AddCry()
		{
			long money = SelfUserComponent.SelfUser.GetComponent<UserMoneyComponent>().Money;
			long exchangingCrystalls = priceValue - money;
			ScheduleEvent(new GoToExchangeCryScreen(exchangingCrystalls), SelfUserComponent.SelfUser);
			Cancel();
		}

		public void Cancel()
		{
			GetComponent<Animator>().SetTrigger("cancel");
			MainScreenComponent.Instance.ClearOnBackOverride();
			if (onCancel != null)
			{
				onCancel();
			}
		}

		public void Hide()
		{
			CheckForTutorialEvent checkForTutorialEvent = new CheckForTutorialEvent();
			ScheduleEvent(checkForTutorialEvent, EngineService.EntityStub);
			if (!checkForTutorialEvent.TutorialIsActive)
			{
				Cancel();
			}
		}
	}
}
