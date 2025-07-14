using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class RFX4_ScaleCurves : MonoBehaviour
	{
		public AnimationCurve FloatCurve = AnimationCurve.EaseInOut(0f, 0f, 1f, 1f);

		public float GraphTimeMultiplier = 1f;

		public float GraphIntensityMultiplier = 1f;

		public bool IsLoop;

		private bool canUpdate;

		private float startTime;

		private Transform t;

		private int nameId;

		private Projector proj;

		private Vector3 startScale;

		private void Awake()
		{
			t = GetComponent<Transform>();
			startScale = t.localScale;
			t.localScale = Vector3.zero;
			proj = GetComponent<Projector>();
		}

		private void OnEnable()
		{
			startTime = Time.time;
			canUpdate = true;
			t.localScale = Vector3.zero;
		}

		private void Update()
		{
			float num = Time.time - startTime;
			if (canUpdate)
			{
				float num2 = FloatCurve.Evaluate(num / GraphTimeMultiplier) * GraphIntensityMultiplier;
				t.localScale = num2 * startScale;
				if (proj != null)
				{
					proj.orthographicSize = num2;
				}
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
}
