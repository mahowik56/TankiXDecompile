using System.Collections.Generic;
using UnityEngine;

namespace Tanks.Battle.ClientHUD.Impl
{
	public class HUDBar : MonoBehaviour
	{
		private readonly List<Ruler> rulers = new List<Ruler>();

		protected float currentValue;

		protected float maxValue;

		protected List<Ruler> Rulers
		{
			get
			{
				if (rulers.Count == 0)
				{
					GetComponentsInChildren(true, rulers);
				}
				return rulers;
			}
		}

		public float MaxValue
		{
			get
			{
				return maxValue;
			}
			set
			{
				if (maxValue != value)
				{
					maxValue = value;
					UpdateSegments();
					OnMaxValueChanged();
				}
			}
		}

		public virtual float CurrentValue
		{
			get
			{
				return currentValue;
			}
			set
			{
				currentValue = value;
			}
		}

		public virtual float AmountPerSegment
		{
			get
			{
				return 0f;
			}
			set
			{
			}
		}

		protected void UpdateSegments()
		{
			for (int i = 0; i < Rulers.Count; i++)
			{
				Rulers[i].segmentsCount = (int)(maxValue / AmountPerSegment);
				Rulers[i].UpdateSegments();
			}
		}

		protected virtual void OnMaxValueChanged()
		{
		}

		protected float Clamp(float value)
		{
			float a = value;
			a = Mathf.Min(a, maxValue);
			return Mathf.Max(0f, a);
		}
	}
}
