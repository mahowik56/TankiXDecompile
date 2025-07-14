using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientCore.API;

namespace Tanks.Battle.ClientCore.Impl
{
	public class VulcanGyroscopeSystem : ECSSystem
	{
		public class VulcanNode : Node
		{
			public VulcanWeaponStateComponent vulcanWeaponState;

			public WeaponGyroscopeRotationComponent weaponGyroscopeRotation;

			public WeaponGyroscopeComponent weaponGyroscope;
		}

		public class VulcanGyroscopeNode : VulcanNode
		{
			public VulcanGyroscopeEnabledComponent vulcanGyroscopeEnabled;
		}

		public class VulcanStartSpeedUpNode : VulcanNode
		{
			public VulcanSpeedUpComponent vulcanSpeedUp;

			public TankGroupComponent tankGroup;
		}

		[Not(typeof(VulcanGyroscopeEnabledComponent))]
		public class VulcanShootingWithoutGyroscopeEnabledNode : VulcanNode
		{
			public WeaponStreamShootingComponent weaponStreamShooting;

			public TankGroupComponent tankGroup;
		}

		public class VulcanSlowDownNode : Node
		{
			public VulcanSlowDownComponent vulcanSlowDown;

			public VulcanWeaponStateComponent vulcanWeaponState;

			public VulcanGyroscopeEnabledComponent vulcanGyroscopeEnabled;
		}

		public class VulcanSlowDownForNRNode : Node
		{
			public VulcanSlowDownComponent vulcanSlowDown;

			public VulcanWeaponStateComponent vulcanWeaponState;
		}

		public class ActiveTankNode : Node
		{
			public TankActiveStateComponent tankActiveState;

			public TankGroupComponent tankGroup;
		}

		public class TankDeadStateNode : Node
		{
			public TankDeadStateComponent tankDeadState;

			public TankGroupComponent tankGroup;
		}

		[OnEventFire]
		public void SyncGyroscopePower(UpdateEvent evt, VulcanGyroscopeNode vulcanGyroscope)
		{
			float forceMult = vulcanGyroscope.weaponGyroscope.ForceMult;
			float state = vulcanGyroscope.vulcanWeaponState.State;
			vulcanGyroscope.weaponGyroscopeRotation.GyroscopePower = forceMult * state;
		}

		[OnEventFire]
		public void DisableGyroscope(NodeRemoveEvent e, VulcanGyroscopeNode vulcanGyroscope)
		{
			vulcanGyroscope.weaponGyroscopeRotation.GyroscopePower = 0f;
		}

		[OnEventFire]
		public void AddGyroscopeComponent(NodeAddedEvent evt, VulcanStartSpeedUpNode vulcanSpeedUp, [JoinByTank] ActiveTankNode selfActiveTank)
		{
			SetupGyroscope(vulcanSpeedUp, vulcanSpeedUp.vulcanWeaponState.State);
		}

		[OnEventFire]
		public void AddGyroscopeComponentShootingState(NodeAddedEvent evt, VulcanShootingWithoutGyroscopeEnabledNode vulcanShooting, [JoinByTank] ActiveTankNode selfActiveTank)
		{
			SetupGyroscope(vulcanShooting, vulcanShooting.vulcanWeaponState.State);
		}

		[OnEventFire]
		public void RemoveGyroscopeComponent(NodeRemoveEvent evt, VulcanSlowDownForNRNode nr, [JoinSelf] VulcanSlowDownNode vulcan)
		{
			Entity entity = vulcan.Entity;
			entity.RemoveComponent<VulcanGyroscopeEnabledComponent>();
		}

		[OnEventFire]
		public void RemoveGyroscopeComponent(NodeAddedEvent evt, SingleNode<VulcanIdleComponent> node, [JoinSelf] SingleNode<VulcanGyroscopeEnabledComponent> vulcan)
		{
			Entity entity = vulcan.Entity;
			entity.RemoveComponent<VulcanGyroscopeEnabledComponent>();
		}

		[OnEventFire]
		public void Clean(NodeRemoveEvent evt, TankDeadStateNode node, [JoinByTank] SingleNode<VulcanGyroscopeEnabledComponent> vulcan)
		{
			vulcan.Entity.RemoveComponent<VulcanGyroscopeEnabledComponent>();
		}

		private static void SetupGyroscope(VulcanNode vulcan, float state)
		{
			vulcan.Entity.AddComponentIfAbsent<VulcanGyroscopeEnabledComponent>();
			vulcan.weaponGyroscopeRotation.GyroscopePower = state;
		}
	}
}
