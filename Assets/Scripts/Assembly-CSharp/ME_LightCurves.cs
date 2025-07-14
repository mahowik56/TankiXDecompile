using UnityEngine;

public class ME_LightCurves : MonoBehaviour
{
	public AnimationCurve LightCurve = AnimationCurve.EaseInOut(0f, 0f, 1f, 1f);

	public float GraphTimeMultiplier = 1f;

	public float GraphIntensityMultiplier = 1f;

	public bool IsLoop;

	private bool canUpdate;

	private float startTime;

	private Light lightSource;

	private void Awake()
	{
		lightSource = GetComponent<Light>();
		lightSource.intensity = LightCurve.Evaluate(0f);
	}

	private void OnEnable()
	{
		startTime = Time.time;
		canUpdate = true;
	}

	private void Update()
	{
		float num = Time.time - startTime;
		if (canUpdate)
		{
			float intensity = LightCurve.Evaluate(num / GraphTimeMultiplier) * GraphIntensityMultiplier;
			lightSource.intensity = intensity;
		}
		if (num >= GraphTimeMultiplier)
		{
			if (IsLoop)
			{
				startTime = Time.time;
			}
			else
			{
				canUpdate = false;
			}
		}
	}
}
