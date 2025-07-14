using System.Collections.Generic;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientCore.API;
using Tanks.Battle.ClientCore.Impl;
using Tanks.Battle.ClientGraphics.API;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class ShaftAimingRendererSystem : ECSSystem
	{
		public class RendererNode : Node
		{
			public BaseRendererComponent baseRenderer;

			public TankGroupComponent tankGroup;

			public TankPartComponent tankPart;
		}

		public class TankNode : Node
		{
			public TankShaderComponent tankShader;

			public TrackRendererComponent trackRenderer;

			public TankGroupComponent tankGroup;

			public TankComponent tank;

			public TankActiveStateComponent tankActiveState;

			public TankOpaqueShaderBlockersComponent tankOpaqueShaderBlockers;
		}

		public class TankActivationInvisibilityEffectNode : TankNode
		{
			public TankInvisibilityEffectActivationStateComponent tankInvisibilityEffectActivationState;
		}

		public class TankDeactivationInvisibilityEffectNode : TankNode
		{
			public TankInvisibilityEffectDeactivationStateComponent tankInvisibilityEffectDeactivationState;
		}

		public class TankWorkingInvisibilityEffectNode : TankNode
		{
			public TankInvisibilityEffectWorkingStateComponent tankInvisibilityEffectWorkingState;
		}

		[Not(typeof(TankInvisibilityEffectWorkingStateComponent))]
		[Not(typeof(TankInvisibilityEffectDeactivationStateComponent))]
		[Not(typeof(TankInvisibilityEffectActivationStateComponent))]
		public class TankNotInvisibilityEffectNode : TankNode
		{
		}

		public class ShaftAimingRendererEffectNode : Node
		{
			public ShaftStateControllerComponent shaftStateController;

			public ShaftAimingRendererEffectComponent shaftAimingRendererEffect;

			public TankGroupComponent tankGroup;
		}

		public class AimingWorkActivationNode : Node
		{
			public ShaftAimingWorkActivationStateComponent shaftAimingWorkActivationState;

			public ShaftStateControllerComponent shaftStateController;

			public ShaftAimingRendererEffectComponent shaftAimingRendererEffect;

			public TankGroupComponent tankGroup;
		}

		public class AimingIdleReducingNode : Node
		{
			public ShaftIdleStateComponent shaftIdleState;

			public ShaftStateControllerComponent shaftStateController;

			public ShaftAimingRendererEffectComponent shaftAimingRendererEffect;

			public ShaftAimingRendererReducingAlphaComponent shaftAimingRendererReducingAlpha;

			public ShaftAimingRendererQueueMapComponent shaftAimingRendererQueueMap;

			public TankGroupComponent tankGroup;
		}

		public class AimingRecoveringNode : Node
		{
			public ShaftStateControllerComponent shaftStateController;

			public ShaftAimingRendererRecoveringAlphaComponent shaftAimingRendererRecoveringAlpha;

			public ShaftAimingRendererEffectComponent shaftAimingRendererEffect;

			public TankGroupComponent tankGroup;
		}

		public class AimingWorkActivationAlphaTransitionNode : Node
		{
			public ShaftAimingWorkActivationStateComponent shaftAimingWorkActivationState;

			public ShaftStateControllerComponent shaftStateController;

			public ShaftAimingRendererReducingAlphaComponent shaftAimingRendererReducingAlpha;

			public ShaftAimingRendererEffectComponent shaftAimingRendererEffect;

			public ShaftStateConfigComponent shaftStateConfig;

			public TankGroupComponent tankGroup;
		}

		[OnEventFire]
		public void StartReducing(NodeAddedEvent evt, AimingWorkActivationNode weapon, [JoinByTank] TankActivationInvisibilityEffectNode tank, [JoinByTank] ICollection<RendererNode> renderers)
		{
			StartReducing(weapon, tank, renderers, false);
		}

		[OnEventFire]
		public void StartReducing(NodeAddedEvent evt, AimingWorkActivationNode weapon, [JoinByTank] TankDeactivationInvisibilityEffectNode tank, [JoinByTank] ICollection<RendererNode> renderers)
		{
			StartReducing(weapon, tank, renderers, false);
		}

		[OnEventFire]
		public void StartReducing(NodeAddedEvent evt, AimingWorkActivationNode weapon, [JoinByTank] TankWorkingInvisibilityEffectNode tank, [JoinByTank] ICollection<RendererNode> renderers)
		{
			StartReducing(weapon, tank, renderers, false);
		}

		[OnEventFire]
		public void StartReducing(NodeAddedEvent evt, AimingWorkActivationNode weapon, [JoinByTank] TankNotInvisibilityEffectNode tank, [JoinByTank] ICollection<RendererNode> renderers)
		{
			StartReducing(weapon, tank, renderers, true);
		}

		private void StartReducing(AimingWorkActivationNode weapon, TankNode tank, ICollection<RendererNode> renderers, bool switchShader)
		{
			ScheduleEvent(new AddTankShaderEffectEvent(ClientGraphicsConstants.SHAFT_AIMING_EFFECT), tank);
			if (switchShader)
			{
				Shader transparentShader = tank.tankShader.TransparentShader;
				SetTransparentMode(renderers, tank, transparentShader);
			}
			if (weapon.Entity.HasComponent<ShaftAimingRendererRecoveringAlphaComponent>())
			{
				weapon.Entity.RemoveComponent<ShaftAimingRendererRecoveringAlphaComponent>();
			}
			float alpha = TankMaterialsUtil.GetAlpha(tank.trackRenderer.Renderer);
			weapon.Entity.AddComponent(new ShaftAimingRendererReducingAlphaComponent(alpha));
			ShaftAimingRendererQueueMapComponent shaftAimingRendererQueueMapComponent = new ShaftAimingRendererQueueMapComponent();
			foreach (RendererNode renderer in renderers)
			{
				Material[] materials = renderer.baseRenderer.Renderer.materials;
				foreach (Material material in materials)
				{
					shaftAimingRendererQueueMapComponent.QueueMap.Add(material, material.renderQueue);
					material.renderQueue = weapon.shaftAimingRendererEffect.TransparentRenderQueue;
				}
			}
			weapon.Entity.AddComponent(shaftAimingRendererQueueMapComponent);
		}

		[OnEventFire]
		public void ProcessReducing(UpdateEvent evt, AimingWorkActivationAlphaTransitionNode weapon, [JoinByTank] TankNode tank, [JoinByTank] ICollection<RendererNode> renderers)
		{
			float t = weapon.shaftAimingWorkActivationState.ActivationTimer / weapon.shaftStateConfig.ActivationToWorkingTransitionTimeSec;
			float num = Mathf.Lerp(weapon.shaftAimingRendererReducingAlpha.InitialAlpha, ClientGraphicsConstants.TRANSPARENT_ALPHA, t);
			float alpha = num;
			SetTransparentMode(renderers, tank, null, alpha);
		}

		[OnEventFire]
		public void SwitchAlphaMode(NodeAddedEvent evt, AimingIdleReducingNode weapon)
		{
			weapon.Entity.RemoveComponent<ShaftAimingRendererReducingAlphaComponent>();
			foreach (Material key in weapon.shaftAimingRendererQueueMap.QueueMap.Keys)
			{
				key.renderQueue = weapon.shaftAimingRendererQueueMap.QueueMap[key];
			}
			weapon.Entity.RemoveComponent<ShaftAimingRendererQueueMapComponent>();
			weapon.Entity.AddComponent<ShaftAimingRendererRecoveringAlphaComponent>();
		}

		[OnEventFire]
		public void SetOpaqueModeOnExitTankActiveState(NodeRemoveEvent evt, TankNode tank, [JoinByTank] ShaftAimingRendererEffectNode weapon, [JoinByTank] ICollection<RendererNode> renderers)
		{
			float oPAQUE_ALPHA = ClientGraphicsConstants.OPAQUE_ALPHA;
			SetTransparentMode(renderers, tank, null, oPAQUE_ALPHA);
			ScheduleEvent(new StopTankShaderEffectEvent(ClientGraphicsConstants.SHAFT_AIMING_EFFECT, false), tank);
		}

		[OnEventFire]
		public void RecoverAlpha(TimeUpdateEvent evt, AimingRecoveringNode weapon, [JoinByTank] TankNode tank, [JoinByTank] ICollection<RendererNode> renderers)
		{
			float alphaRecoveringSpeed = weapon.shaftAimingRendererEffect.AlphaRecoveringSpeed;
			float alpha = TankMaterialsUtil.GetAlpha(tank.trackRenderer.Renderer);
			float num = alpha + alphaRecoveringSpeed * evt.DeltaTime;
			if (num >= ClientGraphicsConstants.OPAQUE_ALPHA)
			{
				ICollection<RendererNode> renderers2 = renderers;
				TankNode tank2 = tank;
				float oPAQUE_ALPHA = ClientGraphicsConstants.OPAQUE_ALPHA;
				SetTransparentMode(renderers2, tank2, null, oPAQUE_ALPHA);
				ScheduleEvent(new StopTankShaderEffectEvent(ClientGraphicsConstants.SHAFT_AIMING_EFFECT, false), tank);
				weapon.Entity.RemoveComponent<ShaftAimingRendererRecoveringAlphaComponent>();
			}
			else
			{
				ICollection<RendererNode> renderers2 = renderers;
				TankNode tank2 = tank;
				float oPAQUE_ALPHA = num;
				SetTransparentMode(renderers2, tank2, null, oPAQUE_ALPHA);
			}
		}

		private void SetTransparentMode(ICollection<RendererNode> renderers, TankNode tank, Shader targetShader = null, float alpha = -1f)
		{
			foreach (RendererNode renderer in renderers)
			{
				if (targetShader != null)
				{
					ClientGraphicsUtil.ApplyShaderToRenderer(renderer.baseRenderer.Renderer, targetShader);
				}
				if (alpha == 0f || tank.Entity.HasComponent<TankPartIntersectedWithCameraStateComponent>())
				{
					renderer.baseRenderer.Renderer.enabled = false;
				}
				else if (alpha > 0f)
				{
					TankMaterialsUtil.SetAlpha(renderer.baseRenderer.Renderer, alpha);
					renderer.baseRenderer.Renderer.enabled = true;
				}
			}
		}
	}
}
