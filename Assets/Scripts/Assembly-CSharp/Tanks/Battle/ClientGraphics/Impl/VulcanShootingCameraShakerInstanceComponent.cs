using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientGraphics.API;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class VulcanShootingCameraShakerInstanceComponent : Component
	{
		public CameraShakeInstance Instance { get; set; }

		public float FadeOutTime { get; set; }

		public VulcanShootingCameraShakerInstanceComponent(CameraShakeInstance instance, float fadeOutTime)
		{
			Instance = instance;
			FadeOutTime = fadeOutTime;
		}
	}
}
