using UnityEngine;

public class FitIn : MonoBehaviour
{
	[SerializeField]
	private RectTransform content;

	[SerializeField]
	private RectTransform viewport;

	private Animator animator;

	private void Awake()
	{
		animator = GetComponent<Animator>();
	}

	private void Update()
	{
		RectTransform component = GetComponent<RectTransform>();
		float num = 0f - component.anchoredPosition.y - content.anchoredPosition.y + component.rect.height;
		Vector2 anchoredPosition = content.anchoredPosition;
		if (num > viewport.rect.height && animator.GetBool("selected"))
		{
			anchoredPosition.y += num - viewport.rect.height;
			content.anchoredPosition = anchoredPosition;
		}
		if (anchoredPosition.y + viewport.rect.height > content.rect.height && !animator.GetBool("selected"))
		{
			anchoredPosition.y = Mathf.Max(0f, content.rect.height - viewport.rect.height);
			content.anchoredPosition = anchoredPosition;
		}
	}
}
