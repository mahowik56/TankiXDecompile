using System.Collections.Generic;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientCore.API;
using UnityEngine;

namespace Tanks.Battle.ClientCore.Impl
{
	public class MuzzlePointSystem : ECSSystem
	{
		public const string MUZZLE_POINT_NAME = "muzzle_point";

		[OnEventFire]
		public void CreateMuzzlePoint(NodeAddedEvent e, SingleNode<WeaponVisualRootComponent> weaponVisualNode)
		{
			List<Transform> list = new List<Transform>();
			Transform transform = weaponVisualNode.component.transform;
			if (transform.name == "muzzle_point")
			{
				list.Add(transform);
			}
			foreach (Transform item in transform)
			{
				if (item.name == "muzzle_point")
				{
					list.Add(item);
				}
			}
			MuzzlePointComponent muzzlePointComponent = new MuzzlePointComponent();
			muzzlePointComponent.Points = list.ToArray();
			MuzzlePointComponent component = muzzlePointComponent;
			weaponVisualNode.Entity.AddComponent(component);
			weaponVisualNode.Entity.AddComponent<MuzzlePointInitializedComponent>();
		}
	}
}
