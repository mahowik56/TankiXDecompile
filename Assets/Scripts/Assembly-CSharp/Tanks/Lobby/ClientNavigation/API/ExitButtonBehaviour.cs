using UnityEngine;
using UnityEngine.UI;

namespace Tanks.Lobby.ClientNavigation.API
{
	[RequireComponent(typeof(Button))]
	public class ExitButtonBehaviour : MonoBehaviour
	{
		private void Awake()
		{
			GetComponent<Button>().onClick.AddListener(Application.Quit);
		}
	}
}
