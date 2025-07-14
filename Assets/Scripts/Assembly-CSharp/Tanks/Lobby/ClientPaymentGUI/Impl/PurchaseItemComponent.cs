using System;
using System.Collections.Generic;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientUnityIntegration.API;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;

namespace Tanks.Lobby.ClientPaymentGUI.Impl
{
	public class PurchaseItemComponent : BehaviourComponent
	{
		[NonSerialized]
		public ShopDialogs shopDialogs;

		private bool steamComponentIsPresent;

		protected readonly HashSet<Entity> methods = new HashSet<Entity>();

		[SerializeField]
		private LocalizedField specialOfferDesc;

		private string steamOfflineDescUid = "b4eafa32-5752-4cd8-b1ae-c9aa9a702bac";

		public bool SteamComponentIsPresent
		{
			get
			{
				return steamComponentIsPresent;
			}
			set
			{
				steamComponentIsPresent = value;
			}
		}

		public void ShowPurchaseDialog(ShopDialogs shopDialogs, Entity entity, bool xCry = false)
		{
			this.shopDialogs = shopDialogs;
			OnPackClick(entity, xCry);
		}

		protected void OnPackClick(Entity entity, bool xCry = false)
		{
			shopDialogs.Show(entity, methods, xCry, specialOfferDesc.Value);
		}

		public void AddMethod(Entity entity)
		{
		}

		public void HandleSuccessMobile(string transactionId)
		{
			if (!(shopDialogs == null) && shopDialogs.gameObject.activeInHierarchy)
			{
				shopDialogs.ShowCheckout(transactionId);
			}
		}

		public void HandleQiwiError()
		{
			if (!(shopDialogs == null) && shopDialogs.gameObject.activeInHierarchy)
			{
				shopDialogs.ShowQiwiError();
			}
		}

		public void HandleError()
		{
			if (!(shopDialogs == null))
			{
				shopDialogs.ShowError();
			}
		}

		public void HandleGoToLink()
		{
			CloseDialogs();
		}

		public void HandleSuccess()
		{
			CloseDialogs();
		}

		private void CloseDialogs()
		{
			if (!(shopDialogs == null) && shopDialogs.gameObject.activeInHierarchy)
			{
				shopDialogs.CloseAll();
			}
		}
	}
}
