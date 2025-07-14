using TMPro;
using UnityEngine;

[ExecuteInEditMode]
public class LoginRewardItemTooltip : MonoBehaviour
{
	[SerializeField]
	private RectTransform text;

	[SerializeField]
	private RectTransform back;

	public string Text
	{
		get
		{
			return text.GetComponent<TextMeshProUGUI>().text;
		}
		set
		{
			text.GetComponent<TextMeshProUGUI>().text = value;
		}
	}

	private void Update()
	{
		back.sizeDelta = new Vector2(270f, text.sizeDelta.y + 30f);
	}
}
