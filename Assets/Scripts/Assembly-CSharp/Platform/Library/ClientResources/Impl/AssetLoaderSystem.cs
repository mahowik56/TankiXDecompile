using System.Collections.Generic;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientLogger.API;
using Platform.Library.ClientResources.API;
using UnityEngine;
using log4net;

namespace Platform.Library.ClientResources.Impl
{
	public class AssetLoaderSystem : ECSSystem
	{
		public class AssetRequestNode : Node
		{
			public AssetReferenceComponent assetReference;

			public AssetRequestComponent assetRequest;
		}

		[Not(typeof(PreloadComponent))]
		public class AssetDependenciesNode : Node
		{
			public AssetReferenceComponent assetReference;

			public AssetBundlesLoadDataComponent assetBundlesLoadData;
		}

		public class DatabaseNode : Node
		{
			public AssetBundleDatabaseComponent assetBundleDatabase;

			public AssetStorageComponent assetStorage;
		}

		private ILog log;

		[OnEventFire]
		public void ProcessAssetRequest(NodeAddedEvent e, [Combine] AssetRequestNode node, DatabaseNode db)
		{
			string assetGuid = node.assetReference.Reference.AssetGuid;
			AssetBundleDatabase assetBundleDatabase = db.assetBundleDatabase.AssetBundleDatabase;
			AssetInfo assetInfo = assetBundleDatabase.GetAssetInfo(assetGuid);
			Entity entity = node.Entity;
			if (db.assetStorage.Contains(assetGuid))
			{
				Object data = db.assetStorage.Get(assetGuid);
				AttachResourceToEntity(data, assetInfo.ObjectName, entity);
			}
			else
			{
				HashSet<AssetBundleInfo> hashSet = new HashSet<AssetBundleInfo>();
				CollectBundles(assetInfo, hashSet);
				PrepareLoadingRequest(entity, hashSet);
			}
		}

		private void PrepareLoadingRequest(Entity request, HashSet<AssetBundleInfo> bundleInfos)
		{
			request.AddComponent(new AssetGroupComponent(request));
			AssetBundlesLoadDataComponent assetBundlesLoadDataComponent = new AssetBundlesLoadDataComponent();
			assetBundlesLoadDataComponent.AllBundles = bundleInfos;
			assetBundlesLoadDataComponent.BundlesToLoad = new List<AssetBundleInfo>(bundleInfos);
			assetBundlesLoadDataComponent.LoadingBundles = new HashSet<AssetBundleInfo>();
			assetBundlesLoadDataComponent.LoadedBundles = new Dictionary<AssetBundleInfo, AssetBundle>();
			request.AddComponent(assetBundlesLoadDataComponent);
			request.AddComponent<ResourceLoadStatComponent>();
		}

		private bool FillAllAssetsFromStorage(IEnumerable<AssetReference> referencies, AssetStorageComponent storage, out List<Object> assetList)
		{
			assetList = new List<Object>(5);
			foreach (AssetReference referency in referencies)
			{
				if (storage.Contains(referency.AssetGuid))
				{
					assetList.Add(storage.Get(referency.AssetGuid));
					continue;
				}
				return false;
			}
			return true;
		}

		private void CollectBundles(AssetInfo info, ICollection<AssetBundleInfo> dependencies)
		{
			dependencies.Add(info.AssetBundleInfo);
			foreach (AssetBundleInfo allDependency in info.AssetBundleInfo.AllDependencies)
			{
				dependencies.Add(allDependency);
			}
		}

		[OnEventComplete]
		public void CompleteLoadAssetFromBundle(AssetBundlesLoadedEvent e, AssetDependenciesNode assetNode, [JoinAll] SingleNode<AssetBundleDatabaseComponent> db)
		{
			AssetBundleDatabase assetBundleDatabase = db.component.AssetBundleDatabase;
			AssetInfo assetInfo = assetBundleDatabase.GetAssetInfo(assetNode.assetReference.Reference.AssetGuid);
			Entity entity = assetNode.Entity;
			Object obj = ResolveAsset(assetInfo, assetNode.assetBundlesLoadData.LoadedBundles);
			AttachResourceToEntity(obj, assetInfo.ObjectName, entity);
			assetNode.assetReference.Reference.SetReference(obj);
			CleanLoadingRequest(assetNode.Entity);
		}

		public void AttachResourceToEntity(Object data, string name, Entity entity)
		{
			ResourceDataComponent resourceDataComponent = new ResourceDataComponent();
			resourceDataComponent.Data = data;
			resourceDataComponent.Name = name;
			entity.AddComponent(resourceDataComponent);
		}

		private void CleanLoadingRequest(Entity entity)
		{
			if (entity.HasComponent<AssetBundlesLoadDataComponent>())
			{
				entity.RemoveComponent<AssetBundlesLoadDataComponent>();
			}
			if (entity.HasComponent<AssetGroupComponent>())
			{
				entity.RemoveComponent<AssetGroupComponent>();
			}
			if (entity.HasComponent<ResourceLoadStatComponent>())
			{
				entity.RemoveComponent<ResourceLoadStatComponent>();
			}
		}

		private Object ResolveAsset(AssetInfo info, Dictionary<AssetBundleInfo, AssetBundle> cache)
		{
			AssetBundle assetBundle = cache[info.AssetBundleInfo];
			GetLogger().InfoFormat("LoadAsset objectName={0} objectType={1}", info.ObjectName, info.AssetType);
			return assetBundle.LoadAsset(info.ObjectName, info.AssetType);
		}

		private ILog GetLogger()
		{
			if (log == null)
			{
				log = LoggerProvider.GetLogger(this);
			}
			return log;
		}
	}
}
