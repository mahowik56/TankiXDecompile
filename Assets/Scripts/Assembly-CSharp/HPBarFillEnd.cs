using UnityEngine;

public class HPBarFillEnd : BarFillEnd
{
	[SerializeField]
	private AnimationCurve topCurve;

	[SerializeField]
	private AnimationCurve bottomCurve;

	public override float FillAmount
	{
		set
		{
			base.FillAmount = value;
			image.offsetMax = new Vector2(image.offsetMax.x, 0f - topCurve.Evaluate(value));
			image.offsetMin = new Vector2(image.offsetMin.x, bottomCurve.Evaluate(value));
		}
	}
}
