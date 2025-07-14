using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientResources.API;
using Platform.Library.ClientUnityIntegration.API;
using Tanks.Battle.ClientCore.Impl;
using Tanks.Battle.ClientGraphics.API;
using Tanks.Lobby.ClientGarage.API;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	internal class CustomTankBuilderSystem : ECSSystem
	{
		public class BattleResultsTankPositionNode : Node
		{
			public BattleResultsTankPositionComponent battleResultsTankPosition;
		}

		public class BattleResultsHullPositionNode : Node
		{
			public BattleResultsHullPositionComponent battleResultsHullPosition;
		}

		public class BattleResultsWeaponPositionNode : Node
		{
			public BattleResultsWeaponPositionComponent battleResultsWeaponPosition;
		}

		public class BattleResultsPaintPositionNode : Node
		{
			public BattleResultsPaintPositionComponent battleResultsPaintPosition;
		}

		public class BattleResultsCoverPositionNode : Node
		{
			public BattleResultsCoverPositionComponent battleResultsCoverPosition;
		}

		public class BuildBattleResultsHullNode : BattleResultsHullPositionNode
		{
			public AssetReferenceComponent assetReference;

			public ResourceDataComponent resourceData;
		}

		public class BuildBattleResultsWeaponNode : BattleResultsWeaponPositionNode
		{
			public AssetReferenceComponent assetReference;

			public ResourceDataComponent resourceData;
		}

		public class BuildBattleResultsPaintNode : BattleResultsPaintPositionNode
		{
			public AssetReferenceComponent assetReference;

			public ResourceDataComponent resourceData;
		}

		public class BuildBattleResultsCoverNode : BattleResultsCoverPositionNode
		{
			public AssetReferenceComponent assetReference;

			public ResourceDataComponent resourceData;
		}

		[OnEventFire]
		public void PrepareTankBattleResults(NodeAddedEvent e, BattleResultsTankPositionNode tank, BattleResultsHullPositionNode hullPosition, BattleResultsWeaponPositionNode weaponPosition, BattleResultsPaintPositionNode paintPosition, BattleResultsCoverPositionNode coverPosition)
		{
			Transform transform = hullPosition.battleResultsHullPosition.transform;
			transform.DestroyChildren();
			Entity entity = hullPosition.Entity;
			string hullGuid = tank.battleResultsTankPosition.hullGuid;
			hullPosition.Entity.AddComponent(new AssetReferenceComponent(new AssetReference(hullGuid)));
			hullPosition.Entity.AddComponent<AssetRequestComponent>();
			Transform transform2 = weaponPosition.battleResultsWeaponPosition.transform;
			transform2.DestroyChildren();
			Entity entity2 = weaponPosition.Entity;
			string weaponGuid = tank.battleResultsTankPosition.weaponGuid;
			weaponPosition.Entity.AddComponent(new AssetReferenceComponent(new AssetReference(weaponGuid)));
			weaponPosition.Entity.AddComponent<AssetRequestComponent>();
			Transform transform3 = paintPosition.battleResultsPaintPosition.transform;
			transform3.DestroyChildren();
			Entity entity3 = paintPosition.Entity;
			string paintGuid = tank.battleResultsTankPosition.paintGuid;
			paintPosition.Entity.AddComponent(new AssetReferenceComponent(new AssetReference(paintGuid)));
			paintPosition.Entity.AddComponent<AssetRequestComponent>();
			Transform transform4 = coverPosition.battleResultsCoverPosition.transform;
			transform4.DestroyChildren();
			Entity entity4 = coverPosition.Entity;
			string coverGuid = tank.battleResultsTankPosition.coverGuid;
			coverPosition.Entity.AddComponent(new AssetReferenceComponent(new AssetReference(coverGuid)));
			coverPosition.Entity.AddComponent<AssetRequestComponent>();
		}

		[OnEventFire]
		public void BuildTankBattleResults(NodeAddedEvent e, BuildBattleResultsHullNode hull, BuildBattleResultsWeaponNode weapon, BuildBattleResultsPaintNode paint, BuildBattleResultsCoverNode cover)
		{
			hull.Entity.RemoveComponent<BattleResultsHullPositionComponent>();
			weapon.Entity.RemoveComponent<BattleResultsWeaponPositionComponent>();
			paint.Entity.RemoveComponent<BattleResultsPaintPositionComponent>();
			cover.Entity.RemoveComponent<BattleResultsCoverPositionComponent>();
			GameObject gameObject = (GameObject)Object.Instantiate(hull.resourceData.Data);
			gameObject.transform.SetParent(hull.battleResultsHullPosition.transform, false);
			gameObject.transform.localPosition = Vector3.zero;
			gameObject.transform.localRotation = Quaternion.identity;
			Transform mountPoint = gameObject.GetComponent<MountPointComponent>().MountPoint;
			GameObject gameObject2 = (GameObject)Object.Instantiate(weapon.resourceData.Data);
			gameObject2.transform.SetParent(weapon.battleResultsWeaponPosition.transform, false);
			gameObject2.transform.localPosition = mountPoint.localPosition;
			gameObject2.transform.localRotation = mountPoint.localRotation;
			GameObject gameObject3 = (GameObject)Object.Instantiate(paint.resourceData.Data);
			gameObject3.transform.SetParent(gameObject.transform, false);
			gameObject3.transform.localPosition = Vector3.zero;
			GameObject gameObject4 = (GameObject)Object.Instantiate(cover.resourceData.Data);
			gameObject4.transform.SetParent(gameObject.transform, false);
			gameObject4.transform.localPosition = Vector3.zero;
			ApplyPaint(gameObject, gameObject2, gameObject3, gameObject4);
			ChangeLayer(hull.battleResultsHullPosition.gameObject);
			ChangeLayer(weapon.battleResultsWeaponPosition.gameObject);
		}

		private void ChangeLayer(GameObject go)
		{
			CustomTankBuilderLayerSetterComponent component = go.GetComponent<CustomTankBuilderLayerSetterComponent>();
			if (component != null)
			{
				SetLayerRecursively(go, component.Layer);
			}
		}

		private void SetLayerRecursively(GameObject obj, int newLayer)
		{
			if (null == obj)
			{
				return;
			}
			obj.layer = newLayer;
			foreach (Transform item in obj.transform)
			{
				if (!(null == item))
				{
					SetLayerRecursively(item.gameObject, newLayer);
				}
			}
		}

		private void ApplyPaint(GameObject tankInstance, GameObject weaponInstance, GameObject tankPaintInstance, GameObject weaponPaintInstance)
		{
			TankMaterialsUtil.ApplyColoring(TankBuilderUtil.GetHullRenderer(tankInstance), TankBuilderUtil.GetWeaponRenderer(weaponInstance), tankPaintInstance.GetComponent<ColoringComponent>(), weaponPaintInstance.GetComponent<ColoringComponent>());
		}

		[OnEventFire]
		public void BuildTank(BuildBattleResultTankEvent e, Node node, [JoinAll] SingleNode<CustomTankBuilder> tankBuilder)
		{
			RenderTexture newRenderTexture = (e.tankPreviewRenderTexture = new RenderTexture(1024, 1024, 24, RenderTextureFormat.ARGB32));
			tankBuilder.component.BuildTank(e.HullGuid, e.WeaponGuid, e.PaintGuid, e.CoverGuid, e.BestPlayerScreen, newRenderTexture);
		}

		[OnEventFire]
		public void ClearTank(ClearBattleResultTankEvent e, Node node, [JoinAll] SingleNode<CustomTankBuilder> tankBuilder)
		{
			tankBuilder.component.ClearContainer();
		}
	}
}
