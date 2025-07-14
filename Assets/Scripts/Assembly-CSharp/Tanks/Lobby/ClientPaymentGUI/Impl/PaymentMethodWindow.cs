using System;
using System.Collections.Generic;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using TMPro;
using Tanks.Lobby.ClientGarage.Impl;
using UnityEngine;
using UnityEngine.UI;

namespace Tanks.Lobby.ClientPaymentGUI.Impl
{
	public class PaymentMethodWindow : MonoBehaviour
	{
		[SerializeField]
		private RectTransform methodsRoot;

		[SerializeField]
		private TextMeshProUGUI info;

		[SerializeField]
		private TextMeshProUGUI description;

		[SerializeField]
		private PaymentMethodContent methodPrefab;

		private Action onBack;

		private Action<Entity> onForward;

		private static readonly int CancelHash = Animator.StringToHash("cancel");

		public void Show(Entity item, List<Entity> methods, Action onBack, Action<Entity> onForward, string desc = "")
		{
			MainScreenComponent.Instance.OverrideOnBack(Cancel);
			this.onBack = onBack;
			this.onForward = onForward;
			base.gameObject.SetActive(true);
			info.text = ShopDialogs.FormatItem(item);
			if (!string.IsNullOrEmpty(desc))
			{
				description.text = "\n" + desc;
				description.gameObject.SetActive(true);
			}
			else
			{
				description.text = desc;
				description.gameObject.SetActive(false);
			}
			foreach (Entity method in methods)
			{
				PaymentMethodContent paymentMethodContent = UnityEngine.Object.Instantiate(methodPrefab, methodsRoot, false);
				paymentMethodContent.SetDataProvider(method);
				Entity target = method;
				paymentMethodContent.GetComponent<Button>().onClick.AddListener(delegate
				{
					MainScreenComponent.Instance.ClearOnBackOverride();
					GetComponent<Animator>().SetTrigger(CancelHash);
					onForward(target);
				});
			}
		}

		public void Cancel()
		{
			MainScreenComponent.Instance.ClearOnBackOverride();
			GetComponent<Animator>().SetTrigger(CancelHash);
			onBack();
		}

		private void OnDisable()
		{
			foreach (Transform item in methodsRoot)
			{
				UnityEngine.Object.Destroy(item.gameObject);
			}
		}
	}
}
