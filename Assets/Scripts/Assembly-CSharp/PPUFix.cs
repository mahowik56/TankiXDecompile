using UnityEngine;

public class PPUFix : MonoBehaviour
{
	private Canvas canvas;

	private float prevPPU;

	private void Start()
	{
		canvas = GetComponent<Canvas>();
	}

	private void Update()
	{
		float num = 100f / canvas.scaleFactor;
		if (!Mathf.Approximately(num, prevPPU))
		{
			prevPPU = num;
			canvas.referencePixelsPerUnit = num;
		}
	}
}
