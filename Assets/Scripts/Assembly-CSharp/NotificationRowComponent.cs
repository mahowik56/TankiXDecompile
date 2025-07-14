using UnityEngine;
using UnityEngine.UI;

public class NotificationRowComponent : MonoBehaviour
{
	private void Awake()
	{
		HorizontalLayoutGroup component = GetComponent<HorizontalLayoutGroup>();
		if (Screen.height > 1080)
		{
			component.spacing = Screen.width / 5;
		}
	}
}
