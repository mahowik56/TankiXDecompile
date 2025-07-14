using UnityEngine;

public class ChatSection : MonoBehaviour
{
	[SerializeField]
	private Transform header;

	[SerializeField]
	private Transform hideIcon;

	private bool hiden;

	public void SwitchHideState()
	{
		hiden = !hiden;
		hideIcon.transform.localScale = new Vector3(1f, hiden ? 1 : (-1), 1f) * 0.25f;
		foreach (object item in base.transform)
		{
			if (item != header)
			{
				((Transform)item).gameObject.SetActive(!hiden);
			}
		}
	}
}
