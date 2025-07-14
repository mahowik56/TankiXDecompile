using System.Collections.Generic;
using System.Linq;
using Platform.Kernel.OSGi.ClientCore.API;
using Tanks.Lobby.ClientGarage.API;
using UnityEngine;
using UnityEngine.UI;
using tanks.modules.lobby.ClientGarage.Scripts.API.UI.Items;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class CollectionView : MonoBehaviour
	{
		public GameObject tierActiveCollectionViewPrefab;

		public GameObject tierPassiveCollectionViewPrefab;

		public GameObject collectionSlotPrefab;

		public SubCollectionView turretCollectionView;

		public SubCollectionView hullCollectionView;

		public Toggle turretToggle;

		public Toggle hullToggle;

		public static Dictionary<ModuleItem, CollectionSlotView> slots;

		[Inject]
		public static GarageItemsRegistry GarageItemsRegistry { get; set; }

		private void AddTierCollectionViewToList(GameObject targetTierCollectionList, GameObject tierCollectionPrefab)
		{
			GameObject gameObject = Object.Instantiate(tierCollectionPrefab);
			gameObject.transform.SetParent(targetTierCollectionList.transform, false);
		}

		public void UpdateView()
		{
			if (slots == null)
			{
				CreateSlots();
			}
			foreach (CollectionSlotView value in slots.Values)
			{
				value.UpdateView();
			}
		}

		private void CreateSlots()
		{
			slots = new Dictionary<ModuleItem, CollectionSlotView>();
			List<ModuleItem> list = GarageItemsRegistry.Modules.Where((ModuleItem mi) => mi.IsMutable()).ToList();
			list.Sort();
			for (int num = 0; num < list.Count; num++)
			{
				AddSlot(list[num]);
			}
		}

		public void AddSlot(ModuleItem moduleItem)
		{
			SubCollectionView subCollectionView = ((moduleItem.TankPartModuleType != TankPartModuleType.WEAPON) ? hullCollectionView : turretCollectionView);
			GameObject gameObject;
			GameObject tierCollectionPrefab;
			if (moduleItem.ModuleBehaviourType == ModuleBehaviourType.ACTIVE)
			{
				gameObject = subCollectionView.activeTierCollectionList;
				tierCollectionPrefab = tierActiveCollectionViewPrefab;
			}
			else
			{
				gameObject = subCollectionView.passiveTierCollectionList;
				tierCollectionPrefab = tierPassiveCollectionViewPrefab;
			}
			for (int i = gameObject.transform.childCount; i <= moduleItem.TierNumber; i++)
			{
				AddTierCollectionViewToList(gameObject, tierCollectionPrefab);
			}
			Transform child = gameObject.transform.GetChild(moduleItem.TierNumber);
			TierCollectionView component = child.GetComponent<TierCollectionView>();
			GameObject gameObject2 = Object.Instantiate(collectionSlotPrefab);
			gameObject2.transform.SetParent(component.slotList.transform, false);
			CollectionSlotView componentInChildren = gameObject2.GetComponentInChildren<CollectionSlotView>();
			componentInChildren.Init(moduleItem);
			slots.Add(moduleItem, componentInChildren);
		}

		public void AddSlotItem(ModuleItem moduleItem, SlotItemView slotItemView)
		{
			CollectionSlotView collectionSlotView = slots[moduleItem];
			collectionSlotView.SetItem(slotItemView);
		}

		public void SwitchMode(TankPartModuleType mode)
		{
			if (mode == TankPartModuleType.WEAPON)
			{
				turretCollectionView.gameObject.SetActive(true);
				turretToggle.isOn = true;
				turretToggle.interactable = false;
				hullCollectionView.gameObject.SetActive(false);
				hullToggle.isOn = false;
				hullToggle.interactable = true;
			}
			else
			{
				hullCollectionView.gameObject.SetActive(true);
				hullToggle.isOn = true;
				hullToggle.interactable = false;
				turretCollectionView.gameObject.SetActive(false);
				turretToggle.isOn = false;
				turretToggle.interactable = true;
			}
		}
	}
}
