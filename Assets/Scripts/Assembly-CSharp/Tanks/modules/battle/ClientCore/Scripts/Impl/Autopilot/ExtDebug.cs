using System.Runtime.InteropServices;
using UnityEngine;

namespace tanks.modules.battle.ClientCore.Scripts.Impl.Autopilot
{
	public static class ExtDebug
	{
		[StructLayout(LayoutKind.Sequential, Size = 1)]
		public struct Box
		{
			public Vector3 localFrontTopLeft { get; private set; }

			public Vector3 localFrontTopRight { get; private set; }

			public Vector3 localFrontBottomLeft { get; private set; }

			public Vector3 localFrontBottomRight { get; private set; }

			public Vector3 localBackTopLeft
			{
				get
				{
					return -localFrontBottomRight;
				}
			}

			public Vector3 localBackTopRight
			{
				get
				{
					return -localFrontBottomLeft;
				}
			}

			public Vector3 localBackBottomLeft
			{
				get
				{
					return -localFrontTopRight;
				}
			}

			public Vector3 localBackBottomRight
			{
				get
				{
					return -localFrontTopLeft;
				}
			}

			public Vector3 frontTopLeft
			{
				get
				{
					return localFrontTopLeft + origin;
				}
			}

			public Vector3 frontTopRight
			{
				get
				{
					return localFrontTopRight + origin;
				}
			}

			public Vector3 frontBottomLeft
			{
				get
				{
					return localFrontBottomLeft + origin;
				}
			}

			public Vector3 frontBottomRight
			{
				get
				{
					return localFrontBottomRight + origin;
				}
			}

			public Vector3 backTopLeft
			{
				get
				{
					return localBackTopLeft + origin;
				}
			}

			public Vector3 backTopRight
			{
				get
				{
					return localBackTopRight + origin;
				}
			}

			public Vector3 backBottomLeft
			{
				get
				{
					return localBackBottomLeft + origin;
				}
			}

			public Vector3 backBottomRight
			{
				get
				{
					return localBackBottomRight + origin;
				}
			}

			public Vector3 origin { get; private set; }

			public Box(Vector3 origin, Vector3 halfExtents, Quaternion orientation)
				: this(origin, halfExtents)
			{
				Rotate(orientation);
			}

			public Box(Vector3 origin, Vector3 halfExtents)
			{
				this = default(Box);
				localFrontTopLeft = new Vector3(0f - halfExtents.x, halfExtents.y, 0f - halfExtents.z);
				localFrontTopRight = new Vector3(halfExtents.x, halfExtents.y, 0f - halfExtents.z);
				localFrontBottomLeft = new Vector3(0f - halfExtents.x, 0f - halfExtents.y, 0f - halfExtents.z);
				localFrontBottomRight = new Vector3(halfExtents.x, 0f - halfExtents.y, 0f - halfExtents.z);
				this.origin = origin;
			}

			public void Rotate(Quaternion orientation)
			{
				localFrontTopLeft = RotatePointAroundPivot(localFrontTopLeft, Vector3.zero, orientation);
				localFrontTopRight = RotatePointAroundPivot(localFrontTopRight, Vector3.zero, orientation);
				localFrontBottomLeft = RotatePointAroundPivot(localFrontBottomLeft, Vector3.zero, orientation);
				localFrontBottomRight = RotatePointAroundPivot(localFrontBottomRight, Vector3.zero, orientation);
			}
		}

		public static void DrawBoxCastOnHit(Vector3 origin, Vector3 halfExtents, Quaternion orientation, Vector3 direction, float hitInfoDistance, Color color)
		{
			origin = CastCenterOnCollision(origin, direction, hitInfoDistance);
			DrawBox(origin, halfExtents, orientation, color);
		}

		public static void DrawBoxCastBox(Vector3 origin, Vector3 halfExtents, Quaternion orientation, Vector3 direction, float distance, Color color)
		{
			direction.Normalize();
			Box box = new Box(origin, halfExtents, orientation);
			Box box2 = new Box(origin + direction * distance, halfExtents, orientation);
			Debug.DrawLine(box.backBottomLeft, box2.backBottomLeft, color);
			Debug.DrawLine(box.backBottomRight, box2.backBottomRight, color);
			Debug.DrawLine(box.backTopLeft, box2.backTopLeft, color);
			Debug.DrawLine(box.backTopRight, box2.backTopRight, color);
			Debug.DrawLine(box.frontTopLeft, box2.frontTopLeft, color);
			Debug.DrawLine(box.frontTopRight, box2.frontTopRight, color);
			Debug.DrawLine(box.frontBottomLeft, box2.frontBottomLeft, color);
			Debug.DrawLine(box.frontBottomRight, box2.frontBottomRight, color);
			DrawBox(box, color);
			DrawBox(box2, color);
		}

		public static void DrawBox(Vector3 origin, Vector3 halfExtents, Quaternion orientation, Color color)
		{
			DrawBox(new Box(origin, halfExtents, orientation), color);
		}

		public static void DrawBox(Box box, Color color)
		{
			Debug.DrawLine(box.frontTopLeft, box.frontTopRight, color);
			Debug.DrawLine(box.frontTopRight, box.frontBottomRight, color);
			Debug.DrawLine(box.frontBottomRight, box.frontBottomLeft, color);
			Debug.DrawLine(box.frontBottomLeft, box.frontTopLeft, color);
			Debug.DrawLine(box.backTopLeft, box.backTopRight, color);
			Debug.DrawLine(box.backTopRight, box.backBottomRight, color);
			Debug.DrawLine(box.backBottomRight, box.backBottomLeft, color);
			Debug.DrawLine(box.backBottomLeft, box.backTopLeft, color);
			Debug.DrawLine(box.frontTopLeft, box.backTopLeft, color);
			Debug.DrawLine(box.frontTopRight, box.backTopRight, color);
			Debug.DrawLine(box.frontBottomRight, box.backBottomRight, color);
			Debug.DrawLine(box.frontBottomLeft, box.backBottomLeft, color);
		}

		private static Vector3 CastCenterOnCollision(Vector3 origin, Vector3 direction, float hitInfoDistance)
		{
			return origin + direction.normalized * hitInfoDistance;
		}

		private static Vector3 RotatePointAroundPivot(Vector3 point, Vector3 pivot, Quaternion rotation)
		{
			Vector3 vector = point - pivot;
			return pivot + rotation * vector;
		}
	}
}
