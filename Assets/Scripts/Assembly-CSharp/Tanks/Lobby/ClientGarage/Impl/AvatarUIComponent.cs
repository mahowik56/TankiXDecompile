using System;
using System.Collections.Generic;
using System.Linq;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Kernel.ECS.ClientEntitySystem.Impl;
using Platform.Kernel.OSGi.ClientCore.API;
using Platform.Library.ClientUnityIntegration.API;
using TMPro;
using Tanks.Lobby.ClientControls.API;
using Tanks.Lobby.ClientGarage.API;
using Tanks.Lobby.ClientHangar.Impl;
using Tanks.Lobby.ClientNavigation.API;
using UnityEngine;
using UnityEngine.UI;

namespace Tanks.Lobby.ClientGarage.Impl
{
	public class AvatarUIComponent : BehaviourComponent
	{
		[SerializeField]
		private AvatarButton avatarButtonPrefab;

		[SerializeField]
		private Transform grid;

		[SerializeField]
		private GaragePrice xPrice;

		[SerializeField]
		private GaragePrice price;

		[SerializeField]
		private Button xBuyButton;

		[SerializeField]
		private Button buyButton;

		[SerializeField]
		private Button equipButton;

		[SerializeField]
		private Button cancelButton;

		[SerializeField]
		private Button closeButton;

		[SerializeField]
		private Button toContainerButton;

		[SerializeField]
		private TMP_Text restriction;

		[SerializeField]
		private LocalizedField restrictionLocalization;

		[SerializeField]
		private LocalizedField avatarTypeLocalization;

		[SerializeField]
		private LocalizedField _commonString;

		[SerializeField]
		private LocalizedField _rareString;

		[SerializeField]
		private LocalizedField _epicString;

		[SerializeField]
		private LocalizedField _legendaryString;

		private readonly Dictionary<long, Avatar> _avatars = new Dictionary<long, Avatar>();

		private readonly Dictionary<long, AvatarButton> _avatarButtons = new Dictionary<long, AvatarButton>();

		[Inject]
		public static GarageItemsRegistry GarageItemsRegistry { get; set; }

		private long Equipped { get; set; }

		private long Selected { get; set; }

		private void Awake()
		{
			toContainerButton.onClick.AddListener(delegate
			{
				GoToContainer(Selected);
			});
			equipButton.onClick.AddListener(delegate
			{
				ECSBehaviour.EngineService.Engine.ScheduleEvent<MountItemEvent>(_avatars[Selected].UserItem);
			});
			cancelButton.onClick.AddListener(Cancel);
			closeButton.onClick.AddListener(Close);
			xBuyButton.onClick.AddListener(delegate
			{
				XBuy(Selected);
			});
			buyButton.onClick.AddListener(delegate
			{
				Buy(Selected);
			});
		}

		private void OnEnable()
		{
			SortAvatars();
			if (_avatars.ContainsKey(Equipped))
			{
				_avatars[Equipped].SetEquipped(true);
			}
		}

		private void OnDisable()
		{
			OnSelect(Equipped);
			grid.DestroyChildren();
			_avatars.Clear();
			_avatarButtons.Clear();
		}

		private void GoToContainer(long key)
		{
			Entity entity = null;
			try
			{
				entity = Select<SingleNode<ContainerMarkerComponent>>(Select<SingleNode<ContainerContentItemComponent>>(_avatars[key].MarketItem, typeof(ContainerContentItemGroupComponent)).First().Entity, typeof(ContainerGroupComponent)).First().Entity;
			}
			catch (Exception)
			{
				Debug.LogError("No such container");
			}
			if (entity != null)
			{
				this.SendEvent(new ShowGarageCategoryEvent
				{
					Category = GarageCategory.CONTAINERS,
					SelectedItem = entity
				});
			}
		}

		private void Cancel()
		{
		}

		private void Close()
		{
		}

		public void OnDoubleClick(long key)
		{
			if (_avatars[key].Unlocked)
			{
				if (_avatars[key].UserItem != null)
				{
					ECSBehaviour.EngineService.Engine.ScheduleEvent<MountItemEvent>(_avatars[key].UserItem);
				}
				else if (_avatars[key].XPrice > 0)
				{
					XBuy(key);
				}
				else if (_avatars[key].Price > 0)
				{
					Buy(key);
				}
				else if (_avatars[key].IsContainerItem)
				{
					GoToContainer(key);
				}
			}
		}

		private string GetName(string itemName)
		{
			return string.Format(avatarTypeLocalization, itemName);
		}

		private void Buy(long key)
		{
			GarageItem item = GarageItemsRegistry.GetItem<GarageItem>(key);
			UnityEngine.Object.FindObjectOfType<Dialogs60Component>().Get<BuyConfirmationDialog>().Show(item, SendOpenAvatarsEvent, GetName(item.Name), SendOpenAvatarsEvent);
			GetComponent<AvatarDialogComponent>().Hide();
		}

		private void XBuy(long key)
		{
			GarageItem item = GarageItemsRegistry.GetItem<GarageItem>(key);
			int num = _avatars[key].XPrice;
			UnityEngine.Object.FindObjectOfType<Dialogs60Component>().Get<BuyConfirmationDialog>().XShow(item, SendOpenAvatarsEvent, num, 1, GetName(item.Name), true, SendOpenAvatarsEvent);
			GetComponent<AvatarDialogComponent>().Hide();
		}

		private void SendOpenAvatarsEvent()
		{
			ECSBehaviour.EngineService.Engine.NewEvent(new AvatarMenuSystem.ShowMenuEvent()).Attach(new EntityStub()).Schedule();
		}

		public void AddMarketItem(IEnumerable<long> avatarIds, int currentUserRank)
		{
			foreach (long avatarId in avatarIds)
			{
				if (!_avatars.ContainsKey(avatarId))
				{
					Avatar item = GarageItemsRegistry.GetItem<Avatar>(avatarId);
					if (item.UserItem != null || item.IsBuyable || item.IsContainerItem)
					{
						CreateAvatarButton(item, currentUserRank);
					}
					_avatars.Add(item.MarketItem.Id, item);
				}
			}
			UpdateButtons();
		}

		public void SortAvatars()
		{
			List<Avatar> list = _avatars.Values.ToList();
			list.Sort((Avatar a1, Avatar a2) => a1.CompareTo(a2));
			for (int num = 0; num < list.Count; num++)
			{
				list[num].Index = num;
			}
			List<AvatarButton> list2 = grid.GetComponentsInChildren<AvatarButton>().ToList();
			list2.Sort((AvatarButton x, AvatarButton y) => x.GetIndex() - y.GetIndex());
			foreach (AvatarButton item in list2)
			{
				item.transform.SetAsLastSibling();
			}
		}

		public void UpdateAvatars()
		{
			List<long> list = (from x in _avatars
				where x.Value.MarketItem == null
				select x.Key).ToList();
			list.ForEach(Remove);
		}

		public void Remove(long key)
		{
			if (!_avatars.ContainsKey(key))
			{
				return;
			}
			Avatar avatar = _avatars[key];
			if (avatar.UserItem == null)
			{
				if (Selected == key && _avatars.ContainsKey(Equipped))
				{
					Selected = Equipped;
					_avatars[Equipped].SetSelected(true);
					UpdatePrice(key);
					UpdateButtons();
				}
				if (avatar.Remove != null)
				{
					avatar.Remove();
				}
				_avatars.Remove(key);
			}
		}

		public void AddUserItem(long key, int currentUserRank)
		{
			if (_avatarButtons.ContainsKey(key))
			{
				UpdateButtons();
			}
			else
			{
				CreateAvatarButton(_avatars[key], currentUserRank);
			}
			_avatars[key].OnBought();
		}

		private void CreateAvatarButton(Avatar avatar, int currentUserRank)
		{
			long id = avatar.MarketItem.Id;
			AvatarButton button = AddAvatar(avatar.IconUid, avatar.RarityName, avatar);
			button.GetIndex = () => avatar.Index;
			button.OnPress = delegate
			{
				OnSelect(id);
			};
			button.OnDoubleClick = delegate
			{
				OnDoubleClick(id);
			};
			avatar.Unlocked = avatar.UserItem != null || avatar.MinRank <= currentUserRank;
			avatar.Remove = delegate
			{
				UnityEngine.Object.Destroy(button);
			};
			button.GetComponent<TooltipShowBehaviour>().TipText = MarketItemNameLocalization.GetFullItemDescription(avatar, false, _commonString, _rareString, _epicString, _legendaryString);
			_avatarButtons.Add(id, button);
		}

		private AvatarButton AddAvatar(string iconUid, string rarity, IAvatarStateChanger changer)
		{
			AvatarButton avatarButton = UnityEngine.Object.Instantiate(avatarButtonPrefab);
			avatarButton.Init(iconUid, rarity, changer);
			avatarButton.transform.SetParent(grid, false);
			return avatarButton;
		}

		public void OnEquip(long avatarKey)
		{
			if (Equipped != avatarKey)
			{
				if (Equipped != 0)
				{
					_avatars[Equipped].SetEquipped(false);
				}
				Equipped = avatarKey;
				_avatars[Equipped].SetEquipped(true);
				if (Selected == 0)
				{
					Selected = Equipped;
					_avatars[Equipped].SetSelected(true);
				}
				UpdateButtons();
			}
		}

		public void OnSelect(long key)
		{
			if (Selected != key)
			{
				if (Selected != 0)
				{
					_avatars[Selected].SetSelected(false);
				}
				Selected = key;
				_avatars[Selected].SetSelected(true);
				Entity entity = _avatars[Selected].UserItem ?? _avatars[Selected].MarketItem;
				ECSBehaviour.EngineService.Engine.NewEvent(new ItemPreviewBaseSystem.PrewievEvent()).Attach(entity).Schedule();
				UpdatePrice(key);
				UpdateButtons();
			}
		}

		public void UpdatePrice(long key)
		{
			if (key == Selected && _avatars[Selected].UserItem == null)
			{
				xPrice.SetPrice(_avatars[Selected].OldXPrice, _avatars[Selected].XPrice);
				price.SetPrice(_avatars[Selected].OldPrice, _avatars[Selected].Price);
			}
		}

		public void UpdateRank(int rank)
		{
			foreach (Avatar value in _avatars.Values)
			{
				value.Unlocked = value.UserItem != null || value.MinRank <= rank;
			}
			UpdateButtons();
		}

		private void UpdateButtons()
		{
			restriction.gameObject.SetActive(false);
			xBuyButton.gameObject.SetActive(false);
			buyButton.gameObject.SetActive(false);
			equipButton.gameObject.SetActive(false);
			toContainerButton.gameObject.SetActive(false);
			if (Selected == Equipped)
			{
				cancelButton.gameObject.SetActive(false);
				closeButton.gameObject.SetActive(true);
				return;
			}
			cancelButton.gameObject.SetActive(true);
			closeButton.gameObject.SetActive(false);
			Avatar avatar = _avatars[Selected];
			if (avatar.UserItem != null)
			{
				equipButton.gameObject.SetActive(true);
				avatar.Unlocked = true;
			}
			else if (!avatar.Unlocked)
			{
				restriction.text = string.Format(restrictionLocalization.Value, _avatars[Selected].MinRank);
				restriction.gameObject.SetActive(true);
			}
			else if (avatar.XPrice > 0)
			{
				xBuyButton.gameObject.SetActive(true);
			}
			else if (avatar.Price > 0)
			{
				buyButton.gameObject.SetActive(true);
			}
			else
			{
				toContainerButton.gameObject.SetActive(true);
			}
		}
	}
}
