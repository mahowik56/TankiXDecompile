using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientCore.Impl;
using Tanks.Battle.ClientGraphics.API;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class TransformTimeSmoothingSystem : ECSSystem
	{
		public class TimeSmoothingNode : Node
		{
			public TransformTimeSmoothingComponent transformTimeSmoothing;

			public TransformTimeSmoothingDataComponent transformTimeSmoothingData;
		}

		private const float LOW_FPS_FRAME_TIME = 1f / 30f;

		private const float SMOOTH_SPEED = 1.1999999f;

		private const float MIN_LERP_FACTOR = 0.4f;

		private const float MAX_LERP_FACTOR = 1.2f;

		public static readonly float ROTATION_CORRECTION_LERP_COEFF = 0.95f;

		private int lastFrame;

		private float frameLeaderDeltaAngle;

		private float frameLeaderDeltaPosition;

		[OnEventFire]
		public void Init(NodeAddedEvent e, SingleNode<TransformTimeSmoothingComponent> node)
		{
			Transform transform = node.component.Transform;
			TransformTimeSmoothingDataComponent transformTimeSmoothingDataComponent = new TransformTimeSmoothingDataComponent();
			transformTimeSmoothingDataComponent.LastPosition = transform.position;
			transformTimeSmoothingDataComponent.LastRotation = transform.rotation;
			transformTimeSmoothingDataComponent.LerpFactor = 1f;
			node.Entity.AddComponent(transformTimeSmoothingDataComponent);
		}

		[OnEventFire]
		public void Destroy(NodeRemoveEvent e, SingleNode<TransformTimeSmoothingComponent> node)
		{
			node.Entity.RemoveComponent<TransformTimeSmoothingDataComponent>();
		}

		[OnEventFire]
		public void TransformSmoothCalculation(TransformTimeSmoothingEvent e, TimeSmoothingNode node)
		{
			bool flag = node.transformTimeSmoothing.UseCorrectionByFrameLeader && Time.frameCount > lastFrame;
			Transform transform = node.transformTimeSmoothing.Transform;
			TransformTimeSmoothingDataComponent transformTimeSmoothingData = node.transformTimeSmoothingData;
			float smoothDeltaTime = Time.smoothDeltaTime;
			float num = Mathf.Clamp(smoothDeltaTime / Time.deltaTime, 0.4f, 1f);
			if (num < transformTimeSmoothingData.LerpFactor)
			{
				transformTimeSmoothingData.LerpFactor = num;
			}
			else
			{
				float num2 = 1.1999999f * smoothDeltaTime * (1f - Mathf.Sqrt(transformTimeSmoothingData.LerpFactor));
				transformTimeSmoothingData.LerpFactor = Mathf.Clamp(transformTimeSmoothingData.LerpFactor + num2, 0.4f, 1f);
			}
			Vector3 vector = Vector3.SlerpUnclamped(transformTimeSmoothingData.LastPosition, transform.position, transformTimeSmoothingData.LerpFactor);
			Quaternion quaternion = Quaternion.SlerpUnclamped(transformTimeSmoothingData.LastRotation, transform.rotation, transformTimeSmoothingData.LerpFactor);
			if (PhysicsUtil.IsValidVector3(vector) && PhysicsUtil.IsValidQuaternion(quaternion))
			{
				transform.SetPositionSafe(vector);
				transform.SetRotationSafe(quaternion);
			}
			transformTimeSmoothingData.LastRotationDeltaAngle = Quaternion.Angle(transformTimeSmoothingData.LastRotation, transform.rotation);
			frameLeaderDeltaPosition = (transformTimeSmoothingData.LastPosition - transform.position).magnitude;
			float num3 = 1f;
			float num4 = 1f;
			if (node.transformTimeSmoothing.UseCorrectionByFrameLeader && !flag)
			{
				float num5 = 0.1f;
				if (frameLeaderDeltaAngle > num5 && transformTimeSmoothingData.LastRotationDeltaAngle > num5)
				{
					num3 = Mathf.Abs((transformTimeSmoothingData.LastRotationDeltaAngle * (1f - transformTimeSmoothingData.LerpFactor) + frameLeaderDeltaAngle * transformTimeSmoothingData.LerpFactor) / frameLeaderDeltaAngle);
				}
				if (frameLeaderDeltaPosition > num5)
				{
					num4 = Mathf.Abs((frameLeaderDeltaPosition * (1f - transformTimeSmoothingData.LerpFactor) + frameLeaderDeltaPosition * transformTimeSmoothingData.LerpFactor) / frameLeaderDeltaPosition);
				}
			}
			float t = Mathf.Clamp(transformTimeSmoothingData.LerpFactor * num4, 0.4f, 1.2f);
			float t2 = Mathf.Clamp(transformTimeSmoothingData.LerpFactor * num3, 0.4f, 1.2f);
			vector = Vector3.SlerpUnclamped(transformTimeSmoothingData.LastPosition, transform.position, t);
			quaternion = Quaternion.SlerpUnclamped(transformTimeSmoothingData.LastRotation, transform.rotation, t2);
			if (PhysicsUtil.IsValidVector3(vector) && PhysicsUtil.IsValidQuaternion(quaternion))
			{
				transform.SetPositionSafe(vector);
				transform.SetRotationSafe(quaternion);
			}
			transformTimeSmoothingData.LastRotationDeltaAngle = Quaternion.Angle(transformTimeSmoothingData.LastRotation, transform.rotation);
			if (flag)
			{
				lastFrame = Time.frameCount;
				frameLeaderDeltaAngle = transformTimeSmoothingData.LastRotationDeltaAngle;
				frameLeaderDeltaPosition = (transformTimeSmoothingData.LastPosition - transform.position).magnitude;
			}
			transformTimeSmoothingData.LastPosition = transform.position;
			transformTimeSmoothingData.LastRotation = transform.rotation;
		}
	}
}
