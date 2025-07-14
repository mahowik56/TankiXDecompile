using CurvedUI;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientCore.API;
using Tanks.Battle.ClientCore.Impl;
using Tanks.Battle.ClientGraphics.API;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class CommonWeaponVisualBuilderSystem : ECSSystem
	{
		public class WeaponGraphicsNode : Node
		{
			public WeaponVisualRootComponent weaponVisualRoot;

			public TankGroupComponent tankGroup;
		}

		public class WeaponGraphicsRendererNode : WeaponGraphicsNode
		{
			public BaseRendererComponent baseRenderer;

			public WeaponPreparedByEntityBehaviourComponent weaponPreparedByEntityBehaviour;
		}

		public class BattleCameraNode : Node
		{
			public CameraRootTransformComponent cameraRootTransform;

			public BattleCameraComponent battleCamera;
		}

		[OnEventFire]
		public void BuildVisualWeapon(NodeAddedEvent evt, WeaponGraphicsNode weaponGraphics)
		{
			Entity entity = weaponGraphics.Entity;
			BaseRendererComponent baseRendererComponent = new BaseRendererComponent();
			Renderer renderer = (baseRendererComponent.Renderer = TankBuilderUtil.GetWeaponRenderer(weaponGraphics.weaponVisualRoot.gameObject));
			baseRendererComponent.Mesh = (baseRendererComponent.Renderer as SkinnedMeshRenderer).sharedMesh;
			entity.AddComponent<StartMaterialsComponent>();
			entity.AddComponent(baseRendererComponent);
			Bounds bounds = renderer.bounds;
			WeaponBoundsComponent weaponBoundsComponent = new WeaponBoundsComponent();
			weaponBoundsComponent.WeaponBounds = bounds;
			WeaponBoundsComponent component = weaponBoundsComponent;
			entity.AddComponent(component);
		}

		[OnEventFire]
		public void BuildWeaponGraphics(NodeAddedEvent e, [Combine] WeaponGraphicsRendererNode weapon, BattleCameraNode camera)
		{
			Renderer renderer = weapon.baseRenderer.Renderer;
			if (!weapon.Entity.HasComponent<CameraVisibleTriggerComponent>())
			{
				CameraVisibleTriggerComponent cameraVisibleTriggerComponent = renderer.gameObject.AddComponentIfMissing<CameraVisibleTriggerComponent>();
				cameraVisibleTriggerComponent.MainCameraTransform = camera.cameraRootTransform.Root;
				weapon.Entity.AddComponent(cameraVisibleTriggerComponent);
			}
			else
			{
				CameraVisibleTriggerComponent component = weapon.Entity.GetComponent<CameraVisibleTriggerComponent>();
				component.MainCameraTransform = camera.cameraRootTransform.Root;
			}
		}
	}
}
