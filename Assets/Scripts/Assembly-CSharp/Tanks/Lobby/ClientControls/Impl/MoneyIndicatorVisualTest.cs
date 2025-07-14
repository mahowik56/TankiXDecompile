using System.Collections;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;

namespace Tanks.Lobby.ClientControls.Impl
{
	public class MoneyIndicatorVisualTest : MonoBehaviour
	{
		public UserMoneyIndicatorComponent userMoneyIndicator;

		private void Start()
		{
			StartCoroutine(Test());
		}

		private IEnumerator Test()
		{
			while (true)
			{
				yield return new WaitForSeconds(Random.Range(2, 10));
				userMoneyIndicator.SetMoneyAnimated(Random.Range(0, 99999999));
			}
		}
	}
}
