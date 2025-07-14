using System;
using Platform.Kernel.ECS.ClientEntitySystem.Impl;
using Platform.Library.ClientUnityIntegration.API;
using TMPro;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;
using UnityEngine.EventSystems;

namespace Tanks.Lobby.ClientCommunicator.Impl
{
	public class MessageObject : ECSBehaviour, IPointerClickHandler, IEventSystemHandler
	{
		[SerializeField]
		private bool first;

		[SerializeField]
		private RectTransform back;

		[SerializeField]
		private ImageSkin userAvatarImageSkin;

		[SerializeField]
		private GameObject userAvatar;

		[SerializeField]
		private GameObject systemAvatar;

		[SerializeField]
		private bool self;

		[SerializeField]
		private TMP_Text nick;

		[SerializeField]
		private TMP_Text text;

		[SerializeField]
		private TMP_Text time;

		[SerializeField]
		private GameObject _tooltipPrefab;

		private ChatMessage message;

		public bool First
		{
			get
			{
				return first;
			}
		}

		public ChatMessage Message
		{
			get
			{
				return message;
			}
		}

		public void Set(ChatMessage message, Func<ChatType, Color> getChatColorFunc)
		{
			if (first && !self)
			{
				nick.text = message.GetNickText();
			}
			text.text = message.GetMessageText();
			time.text = message.Time;
			if (!self && first)
			{
				userAvatar.SetActive(!message.System);
				systemAvatar.SetActive(message.System);
				if (!message.System)
				{
					userAvatarImageSkin.SpriteUid = message.AvatarId;
				}
			}
			this.message = message;
		}

		public void OnPointerClick(PointerEventData eventData)
		{
			if ((bool)_tooltipPrefab && eventData.button == PointerEventData.InputButton.Right)
			{
				string data = message.Author + ":" + message.Message;
				TooltipController.Instance.ShowTooltip(Input.mousePosition, data, _tooltipPrefab, false);
			}
		}

		private void Start()
		{
			if ((bool)nick)
			{
				nick.gameObject.GetComponent<ChatMessageClickHandler>().Handler = OnClick;
			}
			text.gameObject.GetComponent<ChatMessageClickHandler>().Handler = OnClick;
		}

		public void OnClick(PointerEventData eventData, string link)
		{
			if (!Message.System)
			{
				ScheduleEvent(new ChatMessageClickEvent
				{
					EventData = eventData,
					Link = link
				}, new EntityStub());
				if (Input.GetKey(KeyCode.LeftShift))
				{
					GUIUtility.systemCopyBuffer = link;
				}
			}
		}
	}
}
