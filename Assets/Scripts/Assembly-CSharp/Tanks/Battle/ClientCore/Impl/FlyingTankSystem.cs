using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientCore.API;
using UnityEngine;

namespace Tanks.Battle.ClientCore.Impl
{
	public class FlyingTankSystem : ECSSystem
	{
		public class FlyingTank : Node
		{
			public TankActiveStateComponent tankActiveState;

			public RigidbodyComponent rigidbody;

			public FlyingTankComponent flyingTank;
		}

		private const float MINIMAL_HEIGHT = 0.02f;

		[OnEventFire]
		public void Fall(UpdateEvent e, FlyingTank tank)
		{
			Ray ray = new Ray
			{
				origin = tank.rigidbody.Rigidbody.position,
				direction = Vector3.down
			};
			RaycastHit hitInfo;
			if (Physics.Raycast(ray, out hitInfo, 0.02f, (1 << Layers.STATIC) | (1 << Layers.VISUAL_STATIC)))
			{
				ScheduleEvent<FlyingTankGroundedEvent>(tank);
			}
		}
	}
}
