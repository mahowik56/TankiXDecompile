using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;
using UnityEngine.UI;

namespace Tanks.Lobby.ClientControls.Impl
{
	public class CombatEventLog : MonoBehaviour, UILog
	{
		private class UserElementDescription
		{
			public string Uid { get; set; }

			public int RankIndex { get; set; }

			public Color ElementColor { get; set; }

			public UserElementDescription(string uid, int rankIndex, Color elementColor)
			{
				Uid = uid;
				RankIndex = rankIndex;
				ElementColor = elementColor;
			}
		}

		[SerializeField]
		private bool attachToRight = true;

		private const int INVALID_RANK = -1;

		private static readonly UserElementDescription PARSE_FAILED_ELEMENT = new UserElementDescription(string.Empty, -1, Color.black);

		[SerializeField]
		private CombatEventLogMessageContainter messagesContainer;

		private int currentlyVisibleMessages;

		private float scrollHeight;

		private int spaceBetweenMessages;

		private readonly Queue<CombatEventLogMessage> messagesToDelete = new Queue<CombatEventLogMessage>();

		private readonly Regex userPattern = new Regex("{[0-9][0-9]?[0-9]?:[0-9a-fA-F]*:[^}]*}");

		private void Awake()
		{
			spaceBetweenMessages = (int)messagesContainer.VerticalLayout.spacing;
			Vector2 anchoredPosition = messagesContainer.AnchoredPosition;
			anchoredPosition.y = scrollHeight;
			messagesContainer.AnchoredPosition = anchoredPosition;
		}

		private void Update()
		{
			DestroyMessageIfHidden();
			MoveMessage();
		}

		private void DestroyMessageIfHidden()
		{
			if (messagesToDelete.Count > 0)
			{
				LayoutElement layoutElement = messagesToDelete.Peek().LayoutElement;
				float num = messagesContainer.AnchoredPosition.y - layoutElement.preferredHeight - (float)spaceBetweenMessages;
				if (num >= 0f)
				{
					DestroyMessage(messagesToDelete.Dequeue());
				}
			}
		}

		private void MoveMessage()
		{
			if (messagesContainer.ChildCount > 0)
			{
				Vector2 anchoredPosition = messagesContainer.AnchoredPosition;
				if (anchoredPosition.y < scrollHeight)
				{
					anchoredPosition.y += scrollHeight * Time.deltaTime;
				}
				if (anchoredPosition.y > scrollHeight)
				{
					anchoredPosition.y = scrollHeight;
				}
				messagesContainer.AnchoredPosition = anchoredPosition;
			}
		}

		private void DestroyMessage(CombatEventLogMessage message)
		{
			float preferredHeight = message.LayoutElement.preferredHeight;
			scrollHeight -= preferredHeight + (float)spaceBetweenMessages;
			Vector2 anchoredPosition = messagesContainer.AnchoredPosition;
			anchoredPosition.y -= preferredHeight + (float)spaceBetweenMessages;
			messagesContainer.AnchoredPosition = anchoredPosition;
			if (message != null)
			{
				messagesContainer.DestroyMessage(message);
			}
			currentlyVisibleMessages--;
		}

		private void OnScrollLog(float height)
		{
			scrollHeight += height + (float)spaceBetweenMessages;
		}

		private void OnDeleteMessage(CombatEventLogMessage message)
		{
			messagesToDelete.Enqueue(message);
		}

		public void AddMessage(string messageText)
		{
			StartCoroutine(AddMessageCoroutine(messageText));
		}

		private IEnumerator AddMessageCoroutine(string messageText)
		{
			yield return new WaitForSeconds(0.1f);
			AddMessageImmediate(messageText);
			yield return new WaitForEndOfFrame();
			SendMessage("RefreshCurve", SendMessageOptions.DontRequireReceiver);
		}

		public void AddMessageImmediate(string messageText)
		{
			CombatEventLogMessage messageInstanceAndAttachToContainer = messagesContainer.GetMessageInstanceAndAttachToContainer();
			ParseAndConstructMessageLine(messageText, messageInstanceAndAttachToContainer);
			currentlyVisibleMessages++;
			int maxVisibleMessages = messagesContainer.MaxVisibleMessages;
			List<CombatEventLogMessage> visibleChildMessages = messagesContainer.VisibleChildMessages;
			for (int i = 0; i < currentlyVisibleMessages - maxVisibleMessages; i++)
			{
				visibleChildMessages[i].RequestDelete();
			}
			messagesContainer.AddMessage(messageInstanceAndAttachToContainer);
		}

		private void ParseAndConstructMessageLine(string messageText, CombatEventLogMessage message)
		{
			MatchCollection matchCollection = userPattern.Matches(messageText);
			int count = matchCollection.Count;
			int num = 0;
			for (int i = 0; i < count; i++)
			{
				Match match = matchCollection[i];
				if (match.Index != num)
				{
					AddTextElement(messageText.Substring(num, match.Index - num), message);
				}
				AddUserElement(match.Value, message);
				num = match.Index + match.Length;
			}
			AddTextElement(messageText.Substring(num, messageText.Length - num), message);
		}

		private void AddTextElement(string text, CombatEventLogMessage message)
		{
			if (text.Length > 0)
			{
				string text2 = "<sprite name=\"";
				string oldValue = "\">";
				if (text.Contains(text2))
				{
					TankPartItemIcon imageInstance = messagesContainer.GetImageInstance();
					imageInstance.SetIconWithName(text.Replace(text2, string.Empty).Replace(oldValue, string.Empty).Replace(" ", string.Empty));
					message.Attach(imageInstance.RectTransform, attachToRight);
				}
				else
				{
					CombatEventLogText textInstance = messagesContainer.GetTextInstance();
					textInstance.Text.text = text;
					message.Attach(textInstance.RectTransform, attachToRight);
				}
			}
		}

		private void AddUserElement(string userElementString, CombatEventLogMessage message)
		{
			UserElementDescription userElementDescription = ParseAndValidateUserElement(userElementString);
			if (userElementDescription != PARSE_FAILED_ELEMENT)
			{
				CombatEventLogUser userInstance = messagesContainer.GetUserInstance();
				userInstance.RankIcon.SelectSprite(userElementDescription.RankIndex.ToString());
				userInstance.UserName.text = userElementDescription.Uid;
				userInstance.UserName.color = userElementDescription.ElementColor;
				message.Attach(userInstance.RectTransform, attachToRight);
			}
			else
			{
				AddTextElement(userElementString, message);
			}
		}

		private UserElementDescription ParseAndValidateUserElement(string userElementString)
		{
			string text = userElementString.Substring(1, userElementString.Length - 2);
			string[] array = text.Split(':');
			if (array.Length == 3)
			{
				return FinishParsing(array[0], array[1], array[2]);
			}
			return PARSE_FAILED_ELEMENT;
		}

		private UserElementDescription FinishParsing(string rankStr, string colorStr, string uidStr)
		{
			int num = ValidateAndParseRank(rankStr);
			Color color;
			bool flag = ColorUtility.TryParseHtmlString("#" + colorStr.ToLower(), out color);
			if (num != -1 && flag)
			{
				return new UserElementDescription(uidStr, num, color);
			}
			return PARSE_FAILED_ELEMENT;
		}

		private int ValidateAndParseRank(string rankStr)
		{
			try
			{
				int num = int.Parse(rankStr);
				int count = messagesContainer.UserPrefab.RankIcon.Count;
				if (num > 0 && num <= count)
				{
					return num;
				}
				return -1;
			}
			catch (Exception)
			{
				return -1;
			}
		}

		public void Clear()
		{
			currentlyVisibleMessages = 0;
			scrollHeight = 0f;
			messagesContainer.Clear();
		}
	}
}
