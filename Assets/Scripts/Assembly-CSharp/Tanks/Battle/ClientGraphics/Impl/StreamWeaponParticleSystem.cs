using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientCore.API;
using Tanks.Battle.ClientCore.Impl;
using Tanks.Battle.ClientGraphics.API;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class StreamWeaponParticleSystem : ECSSystem
	{
		public class StreamWeaponEffectInitNode : Node
		{
			public StreamEffectComponent streamEffect;

			public MuzzlePointComponent muzzlePoint;

			public TankGroupComponent tankGroup;
		}

		public class WorkingNode : Node
		{
			public StreamEffectReadyComponent streamEffectReady;

			public StreamEffectComponent streamEffect;

			public StreamWeaponWorkingComponent streamWeaponWorking;

			public WeaponUnblockedComponent weaponUnblocked;
		}

		public class AssembledActivatedTankNode : Node
		{
			public AssembledTankActivatedStateComponent assembledTankActivatedState;

			public TankFriendlyEnemyStatusDefinedComponent tankFriendlyEnemyStatusDefined;

			public TankGroupComponent tankGroup;
		}

		[OnEventFire]
		public void Init(NodeAddedEvent evt, StreamWeaponEffectInitNode node, [Context][JoinByTank] AssembledActivatedTankNode tank, [JoinAll] SingleNode<StreamWeaponSettingsComponent> settings)
		{
			node.streamEffect.Init(node.muzzlePoint);
			node.streamEffect.Instance.ApplySettings(settings.component);
			node.Entity.AddComponent<StreamEffectReadyComponent>();
		}

		[OnEventFire]
		public void StartParticleSystems(NodeAddedEvent e, WorkingNode weapon)
		{
			weapon.streamEffect.Instance.Play();
		}

		[OnEventFire]
		public void StopParticleSystems(NodeRemoveEvent e, WorkingNode weapon)
		{
			StreamEffectBehaviour instance = weapon.streamEffect.Instance;
			if ((bool)instance)
			{
				instance.Stop();
			}
		}

		[OnEventFire]
		public void StopParticleSystems(NodeRemoveEvent e, AssembledActivatedTankNode tankNode, [JoinByTank] WorkingNode weapon)
		{
			StreamEffectBehaviour instance = weapon.streamEffect.Instance;
			if ((bool)instance)
			{
				instance.Stop();
			}
		}
	}
}
