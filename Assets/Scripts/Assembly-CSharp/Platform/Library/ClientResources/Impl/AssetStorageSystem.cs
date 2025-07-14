using System.Collections.Generic;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientResources.API;
using UnityEngine;

namespace Platform.Library.ClientResources.Impl
{
	public class AssetStorageSystem : ECSSystem
	{
		public class DatabaseNode : Node
		{
			public AssetBundleDatabaseComponent assetBundleDatabase;

			public AssetStorageComponent assetStorage;
		}

		public class LoadedAssetNode : Node
		{
			public AssetRequestComponent assetRequest;

			public ResourceDataComponent resourceData;

			public AssetReferenceComponent assetReference;
		}

		public static int MANAGED_RESOURCE_EXPIRE_DURATION_SEC = 300;

		[OnEventFire]
		public void Add(NodeAddedEvent e, SingleNode<AssetBundleDatabaseComponent> databaseNode)
		{
			databaseNode.Entity.AddComponent<AssetStorageComponent>();
		}

		[OnEventFire]
		public void Store(NodeAddedEvent e, LoadedAssetNode assetNode, [JoinAll] DatabaseNode db)
		{
			AssetStorageComponent assetStorage = db.assetStorage;
			string assetGuid = assetNode.assetReference.Reference.AssetGuid;
			Object data = assetNode.resourceData.Data;
			if (data != null)
			{
				assetStorage.Put(assetGuid, data, assetNode.assetRequest.AssetStoreLevel);
			}
		}

		[OnEventFire]
		public void CleanStorage(UnloadUnusedAssetsEvent e, Node any, [JoinAll] DatabaseNode db)
		{
			AssetStorageComponent assetStorage = db.assetStorage;
			List<string> list = new List<string>(10);
			foreach (KeyValuePair<string, ResourceStorageEntry> managedReferency in db.assetStorage.ManagedReferencies)
			{
				ResourceStorageEntry value = managedReferency.Value;
				if (IsExpired(value))
				{
					list.Add(managedReferency.Key);
				}
			}
			foreach (string item in list)
			{
				assetStorage.Remove(item, AssetStoreLevel.MANAGED);
			}
		}

		private bool IsExpired(ResourceStorageEntry entry)
		{
			return entry.LastAccessTime + (float)MANAGED_RESOURCE_EXPIRE_DURATION_SEC > Time.time;
		}
	}
}
