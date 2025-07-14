using System;
using System.Collections.Generic;
using System.Linq;
using Lobby.ClientUserProfile.API;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Kernel.OSGi.ClientCore.API;
using Platform.Library.ClientUnityIntegration.API;
using TMPro;
using Tanks.Lobby.ClientControls.API;
using Tanks.Lobby.ClientEntrance.API;
using Tanks.Lobby.ClientGarage.API;
using Tanks.Lobby.ClientNavigation.API;
using Tanks.Lobby.ClientUserProfile.Impl;
using UnityEngine;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class ContainersUI : BehaviourComponent
	{
		public class SelfUserNode : Node
		{
			public SelfUserComponent selfUser;

			public UserUidComponent userUid;
		}

		public class FractionCompetitionNode : Node
		{
			public FractionsCompetitionInfoComponent fractionsCompetitionInfo;
		}

		[SerializeField]
		private Carousel carousel;

		[SerializeField]
		private TextMeshProUGUI title;

		[SerializeField]
		private TextMeshProUGUI openText;

		[SerializeField]
		private TextMeshProUGUI amount;

		[SerializeField]
		private LocalizedField containersAmountSingularText;

		[SerializeField]
		private LocalizedField containersAmountPlural1Text;

		[SerializeField]
		private LocalizedField containersAmountPlural2Text;

		[SerializeField]
		private LocalizedField openContainer;

		[SerializeField]
		private LocalizedField openAllContainers;

		[SerializeField]
		private GameObject openContainerBlock;

		[SerializeField]
		private TextMeshProUGUI openButtonText;

		[SerializeField]
		private BuyContainerButton buyButton;

		[SerializeField]
		private BuyContainerButton[] xBuyButtons;

		[SerializeField]
		private ContainerContentUI containerContent;

		[SerializeField]
		private Animator contentAnimator;

		[SerializeField]
		private GameObject previewButton;

		[SerializeField]
		private float contentCameraOffset;

		[SerializeField]
		private ContainerDescriptionUI containerDescription;

		[SerializeField]
		private bool blueprints;

		private ContainerBoxItem selected;

		public bool previewMode;

		private List<ContainerBoxItem> containers;

		[Inject]
		public static GarageItemsRegistry GarageItemsRegistry { get; set; }

		public bool Blueprints
		{
			get
			{
				return blueprints;
			}
		}

		public List<ContainerBoxItem> GetContainers()
		{
			return containers;
		}

		public void OnEnable()
		{
			UpdateContainerUI();
		}

		public void UpdateContainerUI()
		{
			previewMode = false;
			containerContent.GraffitiRoot.SetActive(false);
			previewButton.SetActive(true);
			SelfUserNode selfUser = ECSBehaviour.EngineService.Engine.SelectAll<SelfUserNode>().FirstOrDefault();
			FractionCompetitionNode fractionCompetition = ECSBehaviour.EngineService.Engine.SelectAll<FractionCompetitionNode>().FirstOrDefault();
			Func<ContainerBoxItem, bool> lockByFraction = delegate(ContainerBoxItem container)
			{
				if (fractionCompetition == null)
				{
					return false;
				}
				if (!container.MarketItem.HasComponent<RestrictionByUserFractionComponent>())
				{
					return false;
				}
				if (container.MarketItem.GetComponent<RestrictionByUserFractionComponent>().FractionId == 0)
				{
					return false;
				}
				return !selfUser.Entity.HasComponent<FractionGroupComponent>() || container.MarketItem.GetComponent<RestrictionByUserFractionComponent>().FractionId != selfUser.Entity.GetComponent<FractionGroupComponent>().Key;
			};
			containers = GarageItemsRegistry.Containers.Where((ContainerBoxItem x) => (x.Count > 0 || x.IsBuyable || x.PackXPrices != null) && blueprints == x.IsBlueprint && !lockByFraction(x)).ToList();
			containers.Sort();
			carousel.AddItems(containers);
			carousel.onItemSelected = ContainerSelected;
			foreach (ContainerBoxItem container in containers)
			{
				if (container.IsSelected)
				{
					selected = container;
					break;
				}
			}
			if (!containers.Contains(selected))
			{
				selected = containers.First();
			}
			if (carousel.IsAnySelected)
			{
				carousel.Selected.Deselect();
			}
			carousel.Select(selected, true);
		}

		private string Pluralize(int amount)
		{
			switch (CasesUtil.GetCase(amount))
			{
			case CaseType.DEFAULT:
				return string.Format(containersAmountPlural1Text.Value, amount);
			case CaseType.ONE:
				return string.Format(containersAmountSingularText.Value, amount);
			case CaseType.TWO:
				return string.Format(containersAmountPlural2Text.Value, amount);
			default:
				throw new Exception("ivnalid case");
			}
		}

		private void ContainerSelected(GarageItemUI item)
		{
			ContainerBoxItem containerBoxItem = item.Item as ContainerBoxItem;
			openText.text = openContainer.Value;
			selected = containerBoxItem;
			amount.text = string.Format(Pluralize(containerBoxItem.Count), containerBoxItem.Count);
			title.text = containerBoxItem.Name;
			bool flag = item.Item.MarketItem.HasComponent<GameplayChestItemComponent>();
			openButtonText.text = ((!flag || containerBoxItem.Count <= 1) ? openContainer.Value : openAllContainers.Value);
			openContainerBlock.GetComponent<Animator>().SetBool("Visible", containerBoxItem.Count > 0);
			if (containerBoxItem.Price > 0)
			{
				buyButton.gameObject.SetActive(true);
				buyButton.Init(1, containerBoxItem.OldPrice, containerBoxItem.Price);
			}
			else
			{
				buyButton.gameObject.SetActive(false);
			}
			int num = 0;
			Dictionary<int, int> packXPrices = containerBoxItem.PackXPrices;
			if (packXPrices != null)
			{
				List<BuyContainerButton> list = new List<BuyContainerButton>();
				foreach (KeyValuePair<int, int> item2 in packXPrices)
				{
					BuyContainerButton buyContainerButton = xBuyButtons[num];
					buyContainerButton.gameObject.SetActive(true);
					buyContainerButton.Init(item2.Key, item2.Key * containerBoxItem.XPrice, item2.Value);
					list.Add(buyContainerButton);
					num++;
				}
				list.Sort((BuyContainerButton a, BuyContainerButton b) => a.Price.CompareTo(b.Price));
				foreach (BuyContainerButton item3 in list)
				{
					item3.transform.SetAsLastSibling();
				}
			}
			for (; num < xBuyButtons.Length; num++)
			{
				xBuyButtons[num].gameObject.SetActive(false);
			}
			bool flag2 = containerBoxItem.Content.Count > 0;
			containerContent.gameObject.SetActive(flag2);
			if (flag2)
			{
				containerContent.Set(carousel.Selected.Item as ContainerBoxItem, false);
				containerDescription.gameObject.SetActive(false);
			}
			else
			{
				containerDescription.gameObject.SetActive(true);
				containerDescription.Title.text = carousel.Selected.Item.MarketItem.GetComponent<DescriptionItemComponent>().Name;
				containerDescription.Description.text = carousel.Selected.Item.MarketItem.GetComponent<DescriptionItemComponent>().Description;
			}
		}

		public void DeleteContainerItem(long marketItem)
		{
			carousel.RemoveItem(marketItem);
		}

		public void OnBuy()
		{
			GarageItem item = carousel.Selected.Item;
			UnityEngine.Object.FindObjectOfType<Dialogs60Component>().Get<BuyConfirmationDialog>().Show(item, delegate
			{
				if (base.gameObject.activeInHierarchy)
				{
					if (carousel.Selected.Item == item)
					{
						ContainerSelected(carousel.Selected);
					}
					else
					{
						carousel.Select(item);
					}
				}
			});
		}

		public void OnXBuy(int buttonIndex)
		{
			BuyContainerButton buyContainerButton = xBuyButtons[buttonIndex];
			GarageItem item = carousel.Selected.Item;
			UnityEngine.Object.FindObjectOfType<Dialogs60Component>().Get<BuyConfirmationDialog>().XShow(item, delegate
			{
				if (base.gameObject.activeInHierarchy)
				{
					if (carousel.Selected.Item == item)
					{
						ContainerSelected(carousel.Selected);
					}
					else
					{
						carousel.Select(item);
					}
				}
			}, buyContainerButton.Price, buyContainerButton.Amount, Pluralize(buyContainerButton.Amount) + " " + item.Name);
		}

		public void OnOpen()
		{
			ContainerBoxItem item = carousel.Selected.Item as ContainerBoxItem;
			openContainerBlock.GetComponent<Animator>().SetBool("Visible", false);
			item.Open(delegate
			{
				openContainerBlock.GetComponent<Animator>().SetBool("Visible", item.Count > 0);
				if (base.gameObject.activeInHierarchy)
				{
					if (carousel.Selected.Item == item)
					{
						ContainerSelected(carousel.Selected);
						if (containerContent.gameObject.activeInHierarchy)
						{
							ContainerContentItemUIContent[] componentsInChildren = containerContent.GetComponentsInChildren<ContainerContentItemUIContent>();
							foreach (ContainerContentItemUIContent containerContentItemUIContent in componentsInChildren)
							{
								containerContentItemUIContent.UpdateOwn();
							}
						}
					}
					else
					{
						carousel.Select(item);
					}
				}
			});
		}

		public void OnItemSelect(ListItem item)
		{
			ShowPreview();
		}

		private void ShowPreview()
		{
			if (!previewMode)
			{
				previewMode = true;
				previewButton.SetActive(false);
				contentAnimator.SetBool("ShowContent", true);
				containerContent.CheckGraffityVisibility();
				Action onBack = MainScreenComponent.Instance.OnBack;
				MainScreenComponent.Instance.OverrideOnBack(delegate
				{
					contentAnimator.SetBool("ShowContent", false);
					OnEnable();
					MainScreenComponent.Instance.OverrideOnBack(onBack);
				});
			}
		}

		public void OnContentPreview()
		{
			ShowPreview();
			containerContent.Set(carousel.Selected.Item as ContainerBoxItem, true);
		}

		public void OnHide()
		{
			containerContent.GraffitiRoot.SetActive(false);
		}
	}
}
