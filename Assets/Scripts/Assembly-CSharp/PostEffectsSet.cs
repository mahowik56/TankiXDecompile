using UnityEngine;

public class PostEffectsSet : MonoBehaviour
{
	public string qualityName;

	public DepthTextureMode depthTextureMode;

	[SerializeField]
	private MonoBehaviour[] effects;

	public void SetActive(bool value)
	{
		if (effects != null)
		{
			for (int i = 0; i < effects.Length; i++)
			{
				effects[i].enabled = value;
			}
		}
		base.enabled = value;
	}
}
