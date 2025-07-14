using System;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientUnityIntegration.Impl;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class CameraFOVUpdateSystem : ECSSystem
	{
		public class CameraFOVUpdateNode : Node
		{
			public CameraFOVUpdateComponent cameraFOVUpdate;

			public BattleCameraComponent battleCamera;

			public CameraComponent camera;
		}

		public class CameraNode : Node
		{
			public BattleCameraComponent battleCamera;

			public CameraComponent camera;
		}

		private const float NARROW_SCREEN = 12f;

		private const float WIDE_SCREEN = 16f;

		private const float DIVIDER = 9f;

		private const float DEFAULT_FOV_RAD = (float)Math.PI / 2f;

		[OnEventFire]
		public void UpdateOptimalCameraFov(NodeAddedEvent evt, CameraNode cameraNode)
		{
			UpdateOptimalFOV(cameraNode);
			cameraNode.camera.FOV = cameraNode.battleCamera.OptimalFOV;
		}

		[OnEventFire]
		public void UpdateOptimalCameraFov(ViewportResizeEvent evt, CameraNode cameraNode)
		{
			UpdateOptimalFOV(cameraNode);
		}

		[OnEventComplete]
		public void ApplyCalculatedFOVToCamera(ViewportResizeEvent evt, CameraFOVUpdateNode cameraNode)
		{
			cameraNode.camera.FOV = cameraNode.battleCamera.OptimalFOV;
		}

		private void UpdateOptimalFOV(CameraNode cameraNode)
		{
			float optimalFOV = CalculateCameraFovInRad() * 57.29578f * 0.5f;
			cameraNode.battleCamera.OptimalFOV = optimalFOV;
		}

		private float CalculateCameraFovInRad()
		{
			float num = (float)Screen.height / 9f;
			float num2 = (float)Screen.width / num;
			if (num2 <= 12f)
			{
				return (float)Math.PI / 2f;
			}
			float num3 = num2 - 4f;
			if (num3 < 12f)
			{
				num3 = 12f;
			}
			float f = num3 * num;
			float num4 = Mathf.Sqrt(Mathf.Pow(f, 2f) + Mathf.Pow(Screen.height, 2f)) * 0.5f / Mathf.Tan((float)Math.PI / 4f);
			return Mathf.Atan(Mathf.Sqrt(Mathf.Pow(Screen.width, 2f) + Mathf.Pow(Screen.height, 2f)) * 0.5f / num4) * 2f;
		}
	}
}
