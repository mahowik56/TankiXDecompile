using UnityEngine;

public class RandomOffset : MonoBehaviour
{
	[SerializeField]
	private float min;

	[SerializeField]
	private float max = 1f;

	private void OnEnable()
	{
		GetComponent<Animator>().SetFloat("offset", Random.Range(min, max));
	}
}
