using System.Collections.Generic;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using UnityEngine;
using UnityEngine.UI;

namespace Tanks.Lobby.ClientBattleSelect.API
{
	public class ScoreTableHeaderComponent : MonoBehaviour, Platform.Kernel.ECS.ClientEntitySystem.API.Component
	{
		public List<ScoreTableRowIndicator> headers = new List<ScoreTableRowIndicator>();

		[SerializeField]
		private RectTransform headerTitle;

		[SerializeField]
		private RectTransform scoreHeaderContainer;

		public void Clear()
		{
			foreach (Transform item in scoreHeaderContainer)
			{
				if (item != headerTitle)
				{
					Object.Destroy(item.gameObject);
				}
			}
		}

		public void AddHeader(ScoreTableRowIndicator headerPrefab)
		{
			ScoreTableRowIndicator scoreTableRowIndicator = Object.Instantiate(headerPrefab);
			scoreTableRowIndicator.transform.SetParent(scoreHeaderContainer, false);
		}

		public void SetDirty()
		{
			LayoutRebuilder.MarkLayoutForRebuild(scoreHeaderContainer);
		}
	}
}
