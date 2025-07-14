using System;
using Tanks.Battle.ClientCore.API;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public static class CameraPositionCalculator
	{
		private const float minDistanceToTarget = 3f;

		private const float sphereRadius = 0.5f;

		private const float MIN_CAMERA_ANGLE = (float)Math.PI / 36f;

		private const float FIXED_PITCH = (float)Math.PI / 18f;

		private const float PITCH_CORRECTION_COEFF = 1f;

		private const float MAX_POSITION_ERROR = 0.1f;

		private const float MAX_ANGLE_ERROR = (float)Math.PI / 180f;

		private const float LINEAR_SPEED_THRESHOLD = 0.1f;

		private const float ANGULAR_SPEED_THRESHOLD = 0.1f;

		private const float CORRECTION_HEIGHT = 0.2f;

		private const int MAX_CAMERA_MOVE_SPEED = 5;

		private const float MAX_CAMERA_ROTATE_SPEED = 9f;

		private const float MIN_CAMERA_ROTATE_SPEED = 3f;

		private const float MAX_ANGLE_BETWEEN_CAMERA_AND_WEAPON = 90f;

		private const float MIN_TANK_LENGTH = 1.2f;

		private const float MAX_TANK_LENGTH = 3.181962f;

		public static Vector3 CalculateCameraPosition(Transform target, BaseRendererComponent tankRendererComponent, Vector3 tankBoundsCenter, BezierPosition bezierPosition, CameraData cameraData, Vector3 cameraOffset, float additionalAngle)
		{
			GameObject gameObject = target.gameObject;
			Vector3 position = target.position;
			Vector3 localPosition = target.parent.localPosition;
			Transform parent = target.parent;
			float z = tankRendererComponent.Mesh.bounds.extents.z;
			float b = (z - 1.2f) / 1.981962f;
			b = Mathf.Max(0f, b);
			float num = z * b;
			if (parent != null)
			{
				num -= target.parent.InverseTransformPoint(tankBoundsCenter).z - localPosition.z;
			}
			Vector3 vector = new Vector3(0f, 0f, 0f - num);
			Quaternion quaternion = Quaternion.Euler(target.rotation.eulerAngles + new Vector3(0f, additionalAngle, 0f));
			Vector3 vector2 = quaternion * (vector - new Vector3(0f, 0f, localPosition.z));
			Vector3 vector3 = position + quaternion * (localPosition + cameraOffset);
			Vector3 targetDirection = Quaternion.Euler(new Vector3(0f, additionalAngle, 0f)) * target.forward;
			Vector3 vector4 = vector3 + Vector3.up * 0.2f;
			float cameraElevationAngleTan = bezierPosition.GetCameraHeight() / bezierPosition.GetCameraHorizontalDistance();
			bool hasCollision = false;
			bool hasCollision2 = false;
			Vector3 cameraDirection = CalculateCameraDirection(cameraElevationAngleTan, targetDirection);
			Vector3 vector5 = CalculateCollisionPoint(vector4, cameraDirection, bezierPosition.GetDistanceToPivot(), gameObject, out hasCollision);
			float magnitude = (vector4 - vector5).magnitude;
			cameraData.collisionDistanceRatio = magnitude / bezierPosition.GetDistanceToPivot();
			if (magnitude < 3f)
			{
				float rayLength = 3f - magnitude;
				return CalculateCollisionPoint(vector5, -Vector3.up, rayLength, gameObject, out hasCollision2);
			}
			int layerMask = LayerMasksUtils.RemoveLayerFromMask(LayerMasks.STATIC, gameObject.layer);
			Vector3 normalized = vector2.normalized;
			RaycastHit hitInfo;
			if (Physics.Raycast(vector5, normalized, out hitInfo, vector2.magnitude, layerMask))
			{
				return vector5 + Mathf.Max(hitInfo.distance - 0.5f, 0f) * normalized;
			}
			return vector5 + vector2;
		}

		private static Vector3 CalculateCameraDirection(float cameraElevationAngleTan, Vector3 targetDirection)
		{
			Vector3 horizontalDirection = GetHorizontalDirection(targetDirection);
			Vector3 vector = new Vector3(0f, 0f - cameraElevationAngleTan, 0f);
			return (horizontalDirection + vector).normalized;
		}

		private static Vector3 GetHorizontalDirection(Vector3 targetDirection)
		{
			float num = Mathf.Sqrt(targetDirection.x * targetDirection.x + targetDirection.z * targetDirection.z);
			Vector3 result = default(Vector3);
			if (num < 1E-05f)
			{
				result.x = 1f;
				result.z = 0f;
			}
			else
			{
				result.x = targetDirection.x / num;
				result.z = targetDirection.z / num;
			}
			result.y = 0f;
			return result;
		}

		private static Vector3 CalculateCollisionPoint(Vector3 targetPosition, Vector3 cameraDirection, float rayLength, GameObject exlusionGameObject, out bool hasCollision)
		{
			Vector3 vector = default(Vector3);
			int layerMask = LayerMasksUtils.RemoveLayerFromMask(LayerMasks.STATIC, exlusionGameObject.layer);
			RaycastHit hitInfo;
			hasCollision = Physics.Raycast(targetPosition, -cameraDirection, out hitInfo, rayLength, layerMask);
			if (hasCollision)
			{
				return hitInfo.point + 0.5f * hitInfo.normal;
			}
			return targetPosition - cameraDirection * rayLength;
		}

		public static Vector3 CalculateLinearMovement(float dt, Vector3 cameraCalculated, Vector3 cameraReal, CameraData cameraData, Transform target, bool mouse)
		{
			Vector3 vector = cameraCalculated - cameraReal;
			float magnitude = vector.magnitude;
			if (magnitude > 0.1f)
			{
				cameraData.linearSpeed = 5f * (magnitude - 0.1f);
			}
			if (mouse)
			{
				float num = Vector3.Angle(cameraCalculated - target.position, cameraReal - target.position);
				float b = magnitude / dt;
				float num2 = Mathf.Lerp(0f, 90f, num / 90f);
				float num3 = Mathf.Sin((270f + num2) * ((float)Math.PI / 180f));
				cameraData.linearSpeed = Mathf.Lerp(cameraData.linearSpeed, b, num3 + 1f);
			}
			float num4 = Mathf.Clamp(cameraData.linearSpeed * dt, 0f, magnitude);
			vector.Normalize();
			vector *= num4;
			cameraReal += vector;
			cameraData.linearSpeed = MathUtil.Snap(cameraData.linearSpeed, 0f, 0.1f);
			return cameraReal;
		}

		public static void CalculatePitchMovement(ref Vector3 rotation, BezierPosition bezierPosition, float dt, CameraData cameraData, bool mouse = false)
		{
			float num = 0f - GetPitchAngle(cameraData, bezierPosition);
			float num2 = MathUtil.ClampAngle(rotation.x);
			float num3 = MathUtil.ClampAngleFast(num - num2);
			cameraData.pitchSpeed = GetAngularSpeed(num3, cameraData.pitchSpeed, mouse);
			float num4 = cameraData.pitchSpeed * dt;
			if ((num3 > 0f && num4 > num3) || (num3 < 0f && num4 < num3))
			{
				num4 = num3;
			}
			rotation.x += num4;
			cameraData.pitchSpeed = MathUtil.Snap(cameraData.pitchSpeed, 0f, 0.1f);
		}

		public static void CalculateYawMovement(Vector3 targetDirection, ref Vector3 rotation, float dt, CameraData cameraData, bool mouse = false)
		{
			float num = Mathf.Atan2(targetDirection.x, targetDirection.z);
			float num2 = MathUtil.ClampAngle(rotation.y);
			float num3 = MathUtil.ClampAngleFast(num - num2);
			cameraData.yawSpeed = GetAngularSpeed(num3, cameraData.yawSpeed, mouse);
			float num4 = cameraData.yawSpeed * dt;
			if ((num3 > 0f && num4 > num3) || (num3 < 0f && num4 < num3))
			{
				num4 = num3;
			}
			rotation.y += num4;
			cameraData.yawSpeed = MathUtil.Snap(cameraData.yawSpeed, 0f, 0.1f);
		}

		private static float GetAngularSpeed(float angleError, float currentSpeed, bool mouse = false)
		{
			float num = ((!mouse) ? 3f : 9f);
			if (angleError < -(float)Math.PI / 180f)
			{
				return num * (angleError + (float)Math.PI / 180f);
			}
			if (angleError > (float)Math.PI / 180f)
			{
				return num * (angleError - (float)Math.PI / 180f);
			}
			return currentSpeed;
		}

		public static float GetPitchAngle(CameraData cameraData, BezierPosition bezierPosition)
		{
			float num = bezierPosition.elevationAngle - (float)Math.PI / 18f;
			if (num < 0f)
			{
				num = 0f;
			}
			float collisionDistanceRatio = cameraData.collisionDistanceRatio;
			if (collisionDistanceRatio >= 1f || num < (float)Math.PI / 36f || !cameraData.pitchCorrectionEnabled)
			{
				return 0f - num;
			}
			float num2 = bezierPosition.GetDistanceToPivot() * Mathf.Sin(num);
			return 0f - Mathf.Atan2(collisionDistanceRatio * num2, 1f * num2 * (1f / Mathf.Tan(num) - (1f - collisionDistanceRatio) / Mathf.Tan(bezierPosition.elevationAngle)));
		}

		public static void SmoothReturnRoll(ref Vector3 rotation, float rollReturnSpeedDegPerSec, float deltaTime)
		{
			float num = rollReturnSpeedDegPerSec * ((float)Math.PI / 180f);
			rotation.z = MathUtil.ClampAngle(rotation.z);
			if (rotation.z > 0f)
			{
				rotation.z -= num * deltaTime;
				rotation.z = SnapNegativeRotationToZero(rotation.z);
			}
			else if (rotation.z < 0f)
			{
				rotation.z += num * deltaTime;
				rotation.z = SnapPositiveRotationToZero(rotation.z);
			}
		}

		private static float SnapNegativeRotationToZero(float rotationAngle)
		{
			return (!(rotationAngle < 0f)) ? rotationAngle : 0f;
		}

		private static float SnapPositiveRotationToZero(float rotationAngle)
		{
			return (!(rotationAngle > 0f)) ? rotationAngle : 0f;
		}

		public static TransformData GetTargetFollowCameraTransformData(Transform target, BaseRendererComponent tankRendererComponent, Vector3 tankBoundsCenter, BezierPosition bezierPosition, Vector3 cameraOffset)
		{
			CameraData cameraData = new CameraData();
			Vector3 position = CalculateCameraPosition(target, tankRendererComponent, tankBoundsCenter, bezierPosition, cameraData, cameraOffset, 0f);
			float cameraHeight = bezierPosition.GetCameraHeight();
			Vector3 vector = target.TransformDirection(Vector3.forward);
			Vector3 vector2 = new Vector3(0f - GetPitchAngle(cameraData, bezierPosition), Mathf.Atan2(vector.x, vector.z), 0f);
			return new TransformData
			{
				Position = position,
				Rotation = Quaternion.Euler(vector2 * 57.29578f)
			};
		}
	}
}
