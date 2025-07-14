using System.Collections.Generic;
using System.Linq;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Lobby.ClientPayment.Impl;
using UnityEngine;
using UnityEngine.UI;

namespace Tanks.Lobby.ClientPaymentGUI.Impl
{
	public class ShopXCrystalsComponent : PurchaseItemComponent
	{
		[SerializeField]
		private XCrystalPackage packPrefab;

		[SerializeField]
		private RectTransform packsRoot;

		private Dictionary<long, XCrystalPackage> packs = new Dictionary<long, XCrystalPackage>();

		private void Awake()
		{
			RectMask2D componentInParent = GetComponentInParent<RectMask2D>();
			if (componentInParent != null)
			{
				componentInParent.enabled = false;
			}
		}

		public void AddPackage(Entity entity, List<string> images)
		{
			if (packs.ContainsKey(entity.Id))
			{
				Object.Destroy(packs[entity.Id].gameObject);
				packs.Remove(entity.Id);
			}
			XCrystalPackage xCrystalPackage = Object.Instantiate(packPrefab);
			xCrystalPackage.transform.SetParent(packsRoot, false);
			xCrystalPackage.GetComponentInChildren<Button>().onClick.AddListener(delegate
			{
				OnPackClick(entity);
			});
			packs.Add(entity.Id, xCrystalPackage);
			xCrystalPackage.Init(entity, images);
			xCrystalPackage.UpdateData();
		}

		private void OnPackClick(Entity entity)
		{
			OnPackClick(entity, true);
		}

		public void Arange()
		{
			List<XCrystalPackage> list = packs.Values.ToList();
			list.Sort(delegate(XCrystalPackage a, XCrystalPackage b)
			{
				if (!a.Entity.HasComponent<XCrystalsPackComponent>())
				{
					return -1;
				}
				return (!b.Entity.HasComponent<XCrystalsPackComponent>()) ? 1 : a.Entity.GetComponent<XCrystalsPackComponent>().Amount.CompareTo(b.Entity.GetComponent<XCrystalsPackComponent>().Amount);
			});
			for (int num = 0; num < list.Count; num++)
			{
				list[num].transform.SetSiblingIndex(num);
			}
		}

		public void Clear()
		{
			foreach (KeyValuePair<long, XCrystalPackage> pack in packs)
			{
				Object.Destroy(pack.Value.gameObject);
			}
			packs.Clear();
			methods.Clear();
		}

		public void UpdatePackage(Entity entity)
		{
			shopDialogs.Cancel();
			if (packs.ContainsKey(entity.Id))
			{
				packs[entity.Id].UpdateData();
			}
		}
	}
}
