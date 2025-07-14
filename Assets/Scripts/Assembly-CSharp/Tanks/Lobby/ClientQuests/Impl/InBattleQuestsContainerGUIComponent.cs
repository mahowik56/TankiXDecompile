using Platform.Library.ClientUnityIntegration.API;
using UnityEngine;

namespace Tanks.Lobby.ClientQuests.Impl
{
	public class InBattleQuestsContainerGUIComponent : BehaviourComponent
	{
		[SerializeField]
		private GameObject questPrefab;

		[SerializeField]
		private GameObject questsContainer;

		public GameObject CreateQuestItem()
		{
			GameObject gameObject = Object.Instantiate(questPrefab);
			gameObject.transform.SetParent(questsContainer.transform, false);
			SendMessage("RefreshCurve", SendMessageOptions.DontRequireReceiver);
			return gameObject;
		}

		public void DeleteAllQuests()
		{
			foreach (Transform item in questsContainer.transform)
			{
				Object.Destroy(item.gameObject);
			}
		}

		public void CreateQuest()
		{
			CreateQuestItem();
		}

		public void RemoveQuest()
		{
			Object.Destroy(questsContainer.transform.GetChild(questsContainer.transform.childCount - 1).gameObject);
		}
	}
}
