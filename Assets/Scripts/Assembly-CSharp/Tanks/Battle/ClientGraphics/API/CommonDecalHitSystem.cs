using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientCore.API;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.API
{
	public class CommonDecalHitSystem : AbstractDecalHitSystem
	{
		[OnEventFire]
		public void Init(NodeAddedEvent evt, SingleNode<MapInstanceComponent> mapInstance, SingleNode<DecalSettingsComponent> settingsNode)
		{
			DecalSettingsComponent component = settingsNode.component;
			DecalManagerComponent decalManagerComponent = new DecalManagerComponent();
			decalManagerComponent.DecalMeshBuilder = new DecalMeshBuilder();
			decalManagerComponent.DecalMeshBuilder.WarmupMeshCaches(mapInstance.component.SceneRoot);
			decalManagerComponent.BulletHoleDecalManager = new BulletHoleDecalManager(mapInstance.component.SceneRoot, component.MaxCount, component.LifeTimeMultipler, decalManagerComponent.DecalsQueue);
			decalManagerComponent.EnableDecals = component.EnableDecals;
			mapInstance.Entity.AddComponent(decalManagerComponent);
		}

		[OnEventFire]
		public void Release(NodeRemoveEvent evt, SingleNode<MapInstanceComponent> mapInstance)
		{
			mapInstance.Entity.RemoveComponent<DecalManagerComponent>();
		}

		[OnEventFire]
		public void DrawHitDecal(HitEvent evt, SingleNode<DynamicDecalProjectorComponent> decalProjectorNode, [JoinByTank] SingleNode<MuzzlePointComponent> muzzlePointNode, [JoinAll] SingleNode<DecalManagerComponent> decalManagerNode)
		{
			if (decalManagerNode.component.EnableDecals)
			{
				DrawHitDecal(evt, decalManagerNode.component, decalProjectorNode.component, muzzlePointNode.component);
			}
		}

		[OnEventFire]
		public void DrawBulletHitDecal(BulletHitEvent evt, Node node, [JoinByTank] SingleNode<DynamicDecalProjectorComponent> decalHitNode, [JoinByTank] SingleNode<MuzzlePointComponent> muzzlePointNode, [JoinAll] SingleNode<DecalManagerComponent> decalManagerNode)
		{
			if (decalManagerNode.component.EnableDecals && evt is BulletStaticHitEvent)
			{
				DynamicDecalProjectorComponent component = decalHitNode.component;
				Vector3 barrelOriginWorld = new MuzzleVisualAccessor(muzzlePointNode.component).GetBarrelOriginWorld();
				Vector3 normalized = (evt.Position - barrelOriginWorld).normalized;
				DrawHitDecal(decalManagerNode.component, component, barrelOriginWorld, normalized);
			}
		}
	}
}
