using TMPro;
using Tanks.Lobby.ClientControls.API;
using UnityEngine;
using UnityEngine.UI;

namespace Tanks.Battle.ClientHUD.Impl
{
	[RequireComponent(typeof(Animator))]
	public class HPBar : HUDBar
	{
		[SerializeField]
		private Image fill;

		[SerializeField]
		private Image fillUnderDiff;

		[SerializeField]
		private Image diff;

		[SerializeField]
		private TankPartItemIcon hullIcon;

		[SerializeField]
		private TextMeshProUGUI hpValues;

		private float deltaHP;

		public long HullId
		{
			set
			{
				hullIcon.SetIconWithName(value.ToString());
			}
		}

		public float Diff
		{
			get
			{
				return deltaHP;
			}
		}

		public override float CurrentValue
		{
			get
			{
				return currentValue;
			}
			set
			{
				Change(value - currentValue);
			}
		}

		public override float AmountPerSegment
		{
			get
			{
				return maxValue;
			}
		}

		public void Change(float delta)
		{
			deltaHP = delta;
			deltaHP = Clamp(currentValue + deltaHP) - currentValue;
			Animator component = GetComponent<Animator>();
			if (component.isActiveAndEnabled)
			{
				component.SetInteger("Diff", (int)deltaHP);
				component.SetTrigger("Start");
			}
			float num = Mathf.Max(currentValue + deltaHP, currentValue);
			float num2 = Mathf.Min(currentValue + deltaHP, currentValue);
			float num3 = num2 / maxValue;
			SetFillAmount(fill, num3);
			fill.color = ((!(num3 > 0.2f)) ? new Color32(byte.MaxValue, 59, 59, byte.MaxValue) : new Color32(168, byte.MaxValue, 47, byte.MaxValue));
			float num4 = num / maxValue - num3;
			SetFillAmount(diff, num4);
			float width = ((RectTransform)base.transform).rect.width;
			diff.rectTransform.anchoredPosition = new Vector2(width * num3, diff.rectTransform.anchoredPosition.y);
			fillUnderDiff.rectTransform.anchoredPosition = new Vector2(width * num3, fillUnderDiff.rectTransform.anchoredPosition.y);
			SetFillAmount(fillUnderDiff, num4 - num3);
			UpdateHPValues((int)(currentValue + Mathf.Max(0f, deltaHP)));
		}

		private void SetFillAmount(Image image, float fillAmount)
		{
			image.rectTransform.anchorMax = new Vector2(fillAmount, 1f);
		}

		public void ResetDiff()
		{
			currentValue = Clamp(currentValue + deltaHP);
			deltaHP = 0f;
			float num = currentValue / maxValue;
			SetFillAmount(fill, num);
			fill.color = ((!(num > 0.2f)) ? new Color32(byte.MaxValue, 59, 59, byte.MaxValue) : new Color32(168, byte.MaxValue, 47, byte.MaxValue));
			UpdateHPValues((int)currentValue);
		}

		protected override void OnMaxValueChanged()
		{
			ResetDiff();
		}

		private void UpdateHPValues(int value)
		{
			hpValues.text = string.Format("{0}/<size=16>{1}", value, (int)maxValue);
		}
	}
}
