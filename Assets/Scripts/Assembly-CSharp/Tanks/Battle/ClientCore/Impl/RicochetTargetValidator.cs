using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientCore.API;
using UnityEngine;

namespace Tanks.Battle.ClientCore.Impl
{
	public class RicochetTargetValidator : TargetValidator
	{
		private float bulletRadius;

		public RicochetTargetValidator(Entity ownerEntity, float bulletRadius)
			: base(ownerEntity)
		{
			this.bulletRadius = bulletRadius;
		}

		public override Ray ContinueOnStaticHit(Ray ray, Vector3 hitNormal, float distance)
		{
			return CalculateRicochet(ray, hitNormal, distance);
		}

		public override Ray ContinueOnTargetHit(Ray ray, Vector3 hitNormal, float distance)
		{
			return CalculateRicochet(ray, hitNormal, distance);
		}

		private Ray CalculateRicochet(Ray ray, Vector3 hitNormal, float distance)
		{
			Vector3 direction = ray.direction;
			return new Ray
			{
				origin = ray.GetPoint(distance - bulletRadius),
				direction = (direction - 2f * Vector3.Dot(direction, hitNormal) * hitNormal).normalized
			};
		}

		public override bool CanSkip(Entity targetEntity)
		{
			if (targetEntity.Equals(ownerEntity) || targetEntity.IsSameGroup<TeamGroupComponent>(ownerEntity))
			{
				return true;
			}
			return false;
		}
	}
}
