using System.Linq;
using Platform.Library.ClientUnityIntegration.API;
using UnityEngine;

namespace Tanks.Lobby.ClientControls.API
{
	public class DialogsContainer : BehaviourComponent
	{
		public Transform[] ignoredChilds;

		public T Get<T>() where T : MonoBehaviour
		{
			return GetComponentInChildren<T>(true);
		}

		public void CloseAll(string ignoredName = "")
		{
			foreach (Transform item in base.transform)
			{
				if (!string.Equals(ignoredName, item.gameObject.name) && (ignoredChilds == null || !ignoredChilds.Contains(item)))
				{
					item.gameObject.SetActive(false);
				}
			}
		}
	}
}
