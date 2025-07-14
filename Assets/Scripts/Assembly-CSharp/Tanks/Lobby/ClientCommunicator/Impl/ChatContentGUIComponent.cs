using Platform.Kernel.ECS.ClientEntitySystem.API;
using UnityEngine;
using UnityEngine.Serialization;

namespace Tanks.Lobby.ClientCommunicator.Impl
{
	public class ChatContentGUIComponent : MonoBehaviour, Platform.Kernel.ECS.ClientEntitySystem.API.Component
	{
		[FormerlySerializedAs("messageAsset")]
		[SerializeField]
		private GameObject messagePrefab;

		public GameObject MessagePrefab
		{
			get
			{
				return messagePrefab;
			}
		}

		public void ClearMessages()
		{
			foreach (Transform item in base.transform)
			{
				if (item.GetComponent<ChatMessageUIComponent>() != null)
				{
					Object.Destroy(item.gameObject);
				}
			}
		}
	}
}
