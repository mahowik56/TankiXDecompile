using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientDataStructures.API;
using Tanks.Battle.ClientCore.API;
using UnityEngine;

namespace Tanks.Battle.ClientCore.Impl
{
	public class TargetSectorCollectorSystem : ECSSystem
	{
		public class WeaponNode : Node
		{
			public MuzzlePointComponent muzzlePoint;

			public WeaponInstanceComponent weaponInstance;
		}

		public class OwnerTankNode : Node
		{
			public TankComponent tank;
		}

		public class TargetTankNode : Node
		{
			public TankActiveStateComponent tankActiveState;

			public RigidbodyComponent rigidbody;

			public TankCollidersComponent tankColliders;
		}

		public class TeamNode : Node
		{
			public TeamComponent team;

			public TeamGroupComponent teamGroup;
		}

		[StructLayout(LayoutKind.Sequential, Size = 1)]
		private struct LookAt
		{
			public Vector3 Position { get; set; }

			public Vector3 Left { get; set; }

			public Vector3 Forward { get; set; }

			public Vector3 Up { get; set; }
		}

		[StructLayout(LayoutKind.Sequential, Size = 1)]
		private struct LookTo
		{
			public Vector3 Position { get; set; }

			public float Radius { get; set; }
		}

		public const float TANK_LENGTH_TO_HEIGHT_COEFF = 0.6f;

		[OnEventFire]
		public void CollectTargetSectors(CollectTargetSectorsEvent e, WeaponNode weaponNode, [JoinByBattle] ICollection<TargetTankNode> targetTankNodes, WeaponNode weaponNode1, [JoinByTank] OwnerTankNode ownerTankNode, [JoinByTeam] Optional<TeamNode> team)
		{
			MuzzleLogicAccessor muzzleLogicAccessor = new MuzzleLogicAccessor(weaponNode.muzzlePoint, weaponNode.weaponInstance);
			bool flag = team.IsPresent();
			long num = ((!flag) ? 0 : team.Get().teamGroup.Key);
			LookAt lookAt = new LookAt
			{
				Position = muzzleLogicAccessor.GetBarrelOriginWorld(),
				Forward = muzzleLogicAccessor.GetFireDirectionWorld(),
				Left = muzzleLogicAccessor.GetLeftDirectionWorld(),
				Up = muzzleLogicAccessor.GetUpDirectionWorld()
			};
			IEnumerator<TargetTankNode> enumerator = targetTankNodes.GetEnumerator();
			while (enumerator.MoveNext())
			{
				TargetTankNode current = enumerator.Current;
				if (!ownerTankNode.Entity.Equals(current.Entity) && (!flag || num != current.Entity.GetComponent<TeamGroupComponent>().Key))
				{
					BoxCollider boxCollider = (BoxCollider)current.tankColliders.TankToTankCollider;
					LookTo lookTo = new LookTo
					{
						Position = boxCollider.bounds.center,
						Radius = CalculateTankMinimalRadius(lookAt.Forward, boxCollider)
					};
					AddTargetSector(lookAt, lookTo, e.TargetingCone, e.TargetSectors, e.VAllowableAngleAcatter, e.HAllowableAngleAcatter);
				}
			}
		}

		private void AddTargetSector(LookAt lookAt, LookTo lookTo, TargetingCone targetingCone, ICollection<TargetSector> sectors, float vDelta, float hDelta)
		{
			Vector3 lhs = lookTo.Position - lookAt.Position;
			float magnitude = lhs.magnitude;
			if (magnitude > targetingCone.Distance || magnitude < lookTo.Radius)
			{
				return;
			}
			float num = (float)(Math.Asin(lookTo.Radius / magnitude) * 180.0 / Math.PI);
			float num2 = num + vDelta;
			float num3 = num + hDelta;
			float num4 = Vector3.Dot(lhs, lookAt.Left);
			float num5 = Vector3.Dot(lhs, lookAt.Forward);
			float num6 = Vector3.Dot(lhs, lookAt.Up);
			float num7 = (float)(Math.Atan2(num4, num5) * 180.0 / Math.PI);
			if (!(num7 < 0f - (num3 + targetingCone.HAngle)) && !(num7 > targetingCone.HAngle + num3))
			{
				float num8 = (float)(Math.Atan2(num6, num5) * 180.0 / Math.PI);
				float num9 = Math.Max(num8 - num2, 0f - targetingCone.VAngleDown);
				float num10 = Math.Min(num8 + num2, targetingCone.VAngleUp);
				if (num9 < num10)
				{
					TargetSector item = new TargetSector
					{
						Down = num9,
						Up = num10,
						Distance = magnitude
					};
					sectors.Add(item);
				}
			}
		}

		private float CalculateTankMinimalRadius(Vector3 forward, BoxCollider collider)
		{
			return collider.size.magnitude * 0.5f;
		}
	}
}
