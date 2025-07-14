using System;
using System.Linq;
using Platform.Kernel.OSGi.ClientCore.API;
using Tanks.Lobby.ClientControls.API;
using Tanks.Lobby.ClientGarage.API;
using Tanks.Lobby.ClientUserProfile.API;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class MapViewBonusElement : MonoBehaviour, IPointerEnterHandler, IEventSystemHandler
	{
		[SerializeField]
		private GameObject inaccesible;

		[SerializeField]
		private Toggle accesible;

		[SerializeField]
		private Toggle epicAccesible;

		[SerializeField]
		private GameObject taken;

		[SerializeField]
		private GameObject epicTaken;

		[SerializeField]
		private LocalizedField crystalText;

		[SerializeField]
		private LocalizedField xCrystalText;

		[SerializeField]
		private LocalizedField chargesText;

		[SerializeField]
		private LocalizedField hiddenText;

		public DailyBonusData dailyBonusData;

		private Toggle toggle;

		private BonusElementState elementState;

		[Inject]
		public static GarageItemsRegistry GarageItemsRegistry { get; set; }

		public int ZoneIndex { get; set; }

		public Toggle Toggle
		{
			get
			{
				return toggle;
			}
		}

		public bool Interactable
		{
			set
			{
				if (toggle != null)
				{
					toggle.interactable = value;
				}
			}
		}

		public void UpdateView(DailyBonusData dailyBonusData, BonusElementState elementState)
		{
			this.dailyBonusData = dailyBonusData;
			this.elementState = elementState;
			inaccesible.SetActive(false);
			accesible.gameObject.SetActive(false);
			epicAccesible.gameObject.SetActive(false);
			taken.SetActive(false);
			epicTaken.SetActive(false);
			switch (elementState)
			{
			case BonusElementState.INACCESSIBLE:
				inaccesible.SetActive(true);
				break;
			case BonusElementState.ACCESSIBLE:
				toggle = ((!dailyBonusData.IsEpic()) ? accesible : epicAccesible);
				toggle.gameObject.SetActive(true);
				toggle.isOn = false;
				break;
			case BonusElementState.TAKEN:
				if (dailyBonusData.IsEpic())
				{
					epicTaken.SetActive(true);
				}
				else
				{
					taken.SetActive(true);
				}
				break;
			}
			GetComponent<TooltipShowBehaviour>().TipText = GetTooltipText(dailyBonusData, elementState);
		}

		private string GetTooltipText(DailyBonusData dailyBonusData, BonusElementState elementState)
		{
			if (elementState == BonusElementState.INACCESSIBLE)
			{
				return hiddenText;
			}
			switch (dailyBonusData.DailyBonusType)
			{
			case DailyBonusType.CONTAINER:
			{
				GarageItem item2 = GarageItemsRegistry.GetItem<GarageItem>(dailyBonusData.ContainerReward.MarketItemId);
				return FirstCharToUpper(item2.Name);
			}
			case DailyBonusType.DETAIL:
			{
				DetailItem item = GarageItemsRegistry.GetItem<DetailItem>(dailyBonusData.DetailReward.MarketItemId);
				return item.Name;
			}
			case DailyBonusType.CRY:
				return FirstCharToUpper(crystalText.Value) + " x" + dailyBonusData.CryAmount;
			case DailyBonusType.XCRY:
				return FirstCharToUpper(xCrystalText.Value) + " x" + dailyBonusData.XcryAmount;
			case DailyBonusType.ENERGY:
				return FirstCharToUpper(chargesText.Value) + " x" + dailyBonusData.EnergyAmount;
			default:
				return string.Empty;
			}
		}

		public static string FirstCharToUpper(string input)
		{
			return input.First().ToString().ToUpper() + input.Substring(1).ToLower();
		}

		public void OnValueChanged(Action<MapViewBonusElement, bool> onBonusElementClick)
		{
			accesible.onValueChanged.AddListener(delegate(bool isChecked)
			{
				onBonusElementClick(this, isChecked);
			});
			epicAccesible.onValueChanged.AddListener(delegate(bool isChecked)
			{
				onBonusElementClick(this, isChecked);
			});
		}

		public void SetToggleGroup(ToggleGroup toggleGroup)
		{
			toggleGroup.RegisterToggle(accesible);
			toggleGroup.RegisterToggle(epicAccesible);
		}

		public void OnPointerEnter(PointerEventData eventData)
		{
			if (elementState == BonusElementState.ACCESSIBLE)
			{
				UISoundEffectController.UITransformRoot.GetComponent<DailyBonusScreenSoundsRoot>().dailyBonusSoundsBehaviour.PlayHover();
			}
		}
	}
}
