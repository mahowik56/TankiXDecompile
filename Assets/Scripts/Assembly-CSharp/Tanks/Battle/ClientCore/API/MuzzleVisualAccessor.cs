using UnityEngine;

namespace Tanks.Battle.ClientCore.API
{
	public struct MuzzleVisualAccessor
	{
		private MuzzlePointComponent component;

		public MuzzleVisualAccessor(MuzzlePointComponent component)
		{
			this.component = component;
		}

		public int GetCurrentIndex()
		{
			return component.CurrentIndex;
		}

		public Vector3 GetWorldPosition()
		{
			return component.Current.position;
		}

		public Vector3 GetBarrelOriginWorld()
		{
			Vector3 localPosition = component.Current.localPosition;
			localPosition.z = 0f;
			return component.Current.parent.TransformPoint(localPosition);
		}

		public Vector3 GetWorldPositionShiftDirectionBarrel(float shiftValue)
		{
			Vector3 localPosition = component.Current.localPosition;
			localPosition.z *= shiftValue;
			return component.Current.parent.TransformPoint(localPosition);
		}

		public Vector3 GetWorldMiddlePosition()
		{
			Vector3 zero = Vector3.zero;
			Transform[] points = component.Points;
			foreach (Transform transform in points)
			{
				zero += component.Current.position;
			}
			return zero / component.Points.Length;
		}

		public Vector3 GetFireDirectionWorld()
		{
			return component.Current.forward;
		}

		public Vector3 GetLeftDirectionWorld()
		{
			return -component.Current.right;
		}

		public Vector3 GetUpDirectionWorld()
		{
			return component.Current.up;
		}
	}
}
