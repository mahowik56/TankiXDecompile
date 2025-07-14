using Platform.Kernel.ECS.ClientEntitySystem.API;

namespace Tanks.Battle.ClientCore.Impl
{
	public class WeaponRotationUpdateInputEvent : Event
	{
		public float DeltaTime { get; set; }

		public WeaponRotationUpdateInputEvent(float deltaTime)
		{
			DeltaTime = deltaTime;
		}
	}
}
