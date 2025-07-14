using TMPro;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;

namespace Tanks.Battle.ClientHUD.API
{
	public class QuestResultUI : MonoBehaviour
	{
		[SerializeField]
		private AnimatedDiffProgress progress;

		[SerializeField]
		private TextMeshProUGUI task;

		[SerializeField]
		private TextMeshProUGUI reward;
	}
}
