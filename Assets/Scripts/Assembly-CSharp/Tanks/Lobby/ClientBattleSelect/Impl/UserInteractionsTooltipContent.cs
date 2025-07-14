using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientUnityIntegration.API;
using TMPro;
using Tanks.Lobby.ClientControls.API;
using Tanks.Lobby.ClientGarage.API;
using Tanks.Lobby.ClientUserProfile.API;
using UnityEngine;
using UnityEngine.UI;

namespace Tanks.Lobby.ClientBattleSelect.Impl
{
	internal class UserInteractionsTooltipContent : ECSBehaviour, ITooltipContent
	{
		public GameObject addToFriendsButton;

		public GameObject muteButton;

		public GameObject reportButton;

		public GameObject copyNameButton;

		public GameObject responceMessagePrefab;

		public float displayTime = 10f;

		public LocalizedField requrestSendLocalization;

		public LocalizedField requestFriendshipLocalization;

		public LocalizedField muteStateLocalization;

		public LocalizedField unmuteStateLocalization;

		public LocalizedField addToFriendsResponce;

		public LocalizedField activateBlockResponce;

		public LocalizedField deactivateBlockResponce;

		public LocalizedField reportResponce;

		public LocalizedField copied;

		private long interactableUserId;

		private Entity selfUserEntity;

		private RectTransform rect;

		private string blockText;

		private InteractionSource interactionSource;

		private long sourceId;

		private string otherUserName;

		public void SendFriendRequest()
		{
			NewEvent(new RequestFriendshipByUserId(interactableUserId, interactionSource, sourceId)).Attach(selfUserEntity).Schedule();
			ShowResponse(addToFriendsResponce.Value);
			HideTooltip();
		}

		public void SendBlockUnblockRequest()
		{
			NewEvent(new ChangeBlockStateByUserIdRequest(interactableUserId, interactionSource, sourceId)).Attach(selfUserEntity).Schedule();
			ShowResponse(blockText);
			HideTooltip();
		}

		public void SendReportRequest()
		{
			NewEvent(new ReportUserByUserId(interactableUserId, interactionSource, sourceId)).Attach(selfUserEntity).Schedule();
			ShowResponse(reportResponce.Value);
			HideTooltip();
		}

		public void CopyName()
		{
			GUIUtility.systemCopyBuffer = otherUserName;
			ShowResponse(copied.Value);
			HideTooltip();
		}

		private void ShowResponse(string respondText)
		{
			GameObject gameObject = Object.Instantiate(responceMessagePrefab);
			gameObject.transform.SetParent(base.transform.parent.parent, false);
			gameObject.GetComponent<RectTransform>().position = Input.mousePosition;
			gameObject.GetComponentInChildren<TextMeshProUGUI>().text = respondText;
			gameObject.SetActive(true);
			float length = gameObject.GetComponentInChildren<Animator>().GetCurrentAnimatorStateInfo(0).length;
			Object.Destroy(gameObject, length);
		}

		private void HideTooltip()
		{
			TooltipController.Instance.HideTooltip();
		}

		public void Init(object data)
		{
			UserInteractionsData userInteractionsData = (UserInteractionsData)data;
			selfUserEntity = userInteractionsData.selfUserEntity;
			SetFriendshipButtonState(userInteractionsData.canRequestFrendship, userInteractionsData.friendshipRequestWasSend);
			blockText = ((!userInteractionsData.isMuted) ? activateBlockResponce.Value : deactivateBlockResponce.Value);
			interactableUserId = userInteractionsData.userId;
			interactionSource = userInteractionsData.interactionSource;
			sourceId = userInteractionsData.sourceId;
			otherUserName = userInteractionsData.OtherUserName;
			copyNameButton.SetActive(!string.IsNullOrEmpty(userInteractionsData.OtherUserName));
			reportButton.SetActive(!userInteractionsData.isReported);
			SetMuteButtonState(userInteractionsData);
			Invoke("HideTooltipOnIdle", displayTime);
		}

		private void SetFriendshipButtonState(bool canRequestFriendship, bool friendshipRequestWasSend)
		{
			addToFriendsButton.SetActive(canRequestFriendship || friendshipRequestWasSend);
			TextMeshProUGUI componentInChildren = addToFriendsButton.GetComponentInChildren<TextMeshProUGUI>();
			componentInChildren.text = (canRequestFriendship ? requestFriendshipLocalization.Value : ((!friendshipRequestWasSend) ? string.Empty : requrestSendLocalization.Value));
			componentInChildren.color = ((!friendshipRequestWasSend) ? Color.white : Color.gray);
			addToFriendsButton.GetComponent<Button>().interactable = !friendshipRequestWasSend;
		}

		private void SetMuteButtonState(UserInteractionsData userData)
		{
			TextMeshProUGUI componentInChildren = muteButton.GetComponentInChildren<TextMeshProUGUI>();
			componentInChildren.text = ((!userData.isMuted) ? muteStateLocalization.Value : unmuteStateLocalization.Value);
		}

		private void HideTooltipOnIdle()
		{
			if (PointerOutsideMenu())
			{
				HideTooltip();
			}
			else
			{
				Invoke("HideTooltipOnIdle", displayTime);
			}
		}

		private bool PointerOutsideMenu()
		{
			return !RectTransformUtility.RectangleContainsScreenPoint(rect, Input.mousePosition);
		}

		public void Awake()
		{
			rect = GetComponent<RectTransform>();
		}

		public void Update()
		{
			bool flag = Input.GetMouseButtonDown(0) || Input.GetMouseButtonDown(1);
			bool keyUp = Input.GetKeyUp(KeyCode.Tab);
			bool keyUp2 = Input.GetKeyUp(KeyCode.Escape);
			if ((flag && PointerOutsideMenu()) || keyUp || keyUp2)
			{
				HideTooltip();
			}
		}
	}
}
