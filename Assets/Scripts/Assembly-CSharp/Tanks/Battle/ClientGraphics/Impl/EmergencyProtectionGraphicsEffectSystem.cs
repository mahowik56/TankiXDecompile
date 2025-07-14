using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientCore.API;
using Tanks.Battle.ClientCore.Impl;
using Tanks.Battle.ClientGraphics.API;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class EmergencyProtectionGraphicsEffectSystem : ECSSystem
	{
		public class TankNode : Node
		{
			public TankComponent tank;

			public AssembledTankActivatedStateComponent assembledTankActivatedState;

			public SimpleEmergencyProtectionGraphicEffectComponent simpleEmergencyProtectionGraphicEffect;

			public TankOpaqueShaderBlockersComponent tankOpaqueShaderBlockers;

			public RendererInitializedComponent rendererInitialized;

			public TankGroupComponent tankGroup;

			public TankShaderComponent tankShader;

			public BaseRendererComponent baseRenderer;

			public TankInvisibilityEffectUnityComponent tankInvisibilityEffectUnity;

			public HealingGraphicsEffectReadyComponent healingGraphicsEffectReady;

			public TankVisualRootComponent tankVisualRoot;

			public TankSoundRootComponent tankSoundRoot;

			public VisualMountPointComponent visualMountPoint;
		}

		public class TankReadyNode : TankNode
		{
			public EmergencyProtectionTankShaderEffectReadyComponent emergencyProtectionTankShaderEffectReady;
		}

		public class HealingTankReadyNode : TankReadyNode
		{
			public HealingGraphicEffectComponent healingGraphicEffect;
		}

		public class LifestealTankReadyNode : TankReadyNode
		{
			public LifestealGraphicsEffectComponent lifestealGraphicsEffect;

			public LifestealGraphicsEffectReadyComponent lifestealGraphicsEffectReady;
		}

		public class ActiveTankReadyNode : TankReadyNode
		{
			public TankActiveStateComponent tankActiveState;
		}

		public class ReadyTankInvisibilityEffectIdleStateNode : ActiveTankReadyNode
		{
			public TankInvisibilityEffectIdleStateComponent tankInvisibilityEffectIdleState;
		}

		public class ReadyTankInvisibilityEffectWorkingStateNode : ActiveTankReadyNode
		{
			public TankInvisibilityEffectWorkingStateComponent tankInvisibilityEffectWorkingState;
		}

		public class ReadyTankInvisibilityEffectActivationStateNode : ActiveTankReadyNode
		{
			public TankInvisibilityEffectActivationStateComponent tankInvisibilityEffectActivationState;
		}

		public class ReadyTankInvisibilityEffectDeactivationStateNode : ActiveTankReadyNode
		{
			public TankInvisibilityEffectDeactivationStateComponent tankInvisibilityEffectDeactivationState;
		}

		public class WeaponNode : Node
		{
			public WeaponComponent weapon;

			public WeaponVisualRootComponent weaponVisualRoot;

			public BaseRendererComponent baseRenderer;

			public RendererInitializedComponent rendererInitialized;

			public TankGroupComponent tankGroup;
		}

		public class PlayEmergencyProtectionShaderEffectEvent : Platform.Kernel.ECS.ClientEntitySystem.API.Event
		{
		}

		public class PlayEmergencyProtectionEffectEvent : Platform.Kernel.ECS.ClientEntitySystem.API.Event
		{
		}

		[OnEventFire]
		public void InitEmergencyProtectionEffect(NodeAddedEvent e, TankNode tank, [JoinByTank][Context] WeaponNode weapon)
		{
			tank.Entity.RemoveComponentIfPresent<EmergencyProtectionTankShaderEffectReadyComponent>();
			tank.simpleEmergencyProtectionGraphicEffect.InitRepairGraphicsEffect(new HealingGraphicEffectInputs(tank.Entity, tank.baseRenderer.Renderer as SkinnedMeshRenderer), new WeaponHealingGraphicEffectInputs(weapon.Entity, weapon.weaponVisualRoot.transform, weapon.baseRenderer.Renderer as SkinnedMeshRenderer), tank.tankSoundRoot.SoundRootTransform, tank.visualMountPoint.MountPoint);
			tank.Entity.AddComponent<EmergencyProtectionTankShaderEffectReadyComponent>();
		}

		[OnEventFire]
		public void PlayEmergencyProtectionEffect(TriggerEffectExecuteEvent e, SingleNode<EmergencyProtectionEffectComponent> effect, [JoinByTank] ActiveTankReadyNode tank)
		{
			ScheduleEvent<PlayEmergencyProtectionEffectEvent>(tank);
		}

		[OnEventFire]
		public void PrepareEmergencyProtectionEffect(PlayEmergencyProtectionEffectEvent evt, ActiveTankReadyNode tank)
		{
			ScheduleEvent<PlayEmergencyProtectionShaderEffectEvent>(tank);
		}

		[OnEventFire]
		public void PrepareEmergencyProtectionEffect(PlayEmergencyProtectionShaderEffectEvent evt, ActiveTankReadyNode tank)
		{
			ScheduleEvent(new AddTankShaderEffectEvent(ClientGraphicsConstants.EMERGENCY_PROTECTION_EFFECT), tank);
		}

		[OnEventFire]
		public void StopHealingGraphicEfect(PlayEmergencyProtectionShaderEffectEvent evt, HealingTankReadyNode tank)
		{
			tank.healingGraphicEffect.StopEffect();
		}

		[OnEventFire]
		public void StopLifestealGraphicEfect(PlayEmergencyProtectionShaderEffectEvent evt, LifestealTankReadyNode tank)
		{
			tank.lifestealGraphicsEffect.StopEffect();
		}

		[OnEventComplete]
		public void StartEmergencyProtectionEffect(PlayEmergencyProtectionShaderEffectEvent evt, ReadyTankInvisibilityEffectIdleStateNode tank)
		{
			tank.simpleEmergencyProtectionGraphicEffect.StartEffect(tank.tankShader.TransparentShader);
		}

		[OnEventComplete]
		public void StartEmergencyProtectionEffect(PlayEmergencyProtectionShaderEffectEvent evt, ReadyTankInvisibilityEffectWorkingStateNode tank)
		{
			tank.simpleEmergencyProtectionGraphicEffect.StartEffect(tank.tankInvisibilityEffectUnity.InvisibilityEffectShader);
		}

		[OnEventComplete]
		public void StartEmergencyProtectionEffect(PlayEmergencyProtectionShaderEffectEvent evt, ReadyTankInvisibilityEffectActivationStateNode tank)
		{
			tank.simpleEmergencyProtectionGraphicEffect.StartEffect(tank.tankInvisibilityEffectUnity.InvisibilityEffectTransitionShader);
		}

		[OnEventComplete]
		public void StartEmergencyProtectionEffect(PlayEmergencyProtectionShaderEffectEvent evt, ReadyTankInvisibilityEffectDeactivationStateNode tank)
		{
			tank.simpleEmergencyProtectionGraphicEffect.StartEffect(tank.tankInvisibilityEffectUnity.InvisibilityEffectTransitionShader);
		}

		[OnEventFire]
		public void StopEmergencyProtectionEffect(NodeRemoveEvent e, ActiveTankReadyNode tank)
		{
			tank.simpleEmergencyProtectionGraphicEffect.StopEffect();
		}

		[OnEventFire]
		public void StopEmergencyProtectionEffect(StopEmergencyProtectionTankShaderEffectEvent e, SingleNode<TankComponent> tank)
		{
			ScheduleEvent(new StopTankShaderEffectEvent(ClientGraphicsConstants.EMERGENCY_PROTECTION_EFFECT, false), tank);
		}
	}
}
