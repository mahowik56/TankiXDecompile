using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientCore.API;
using UnityEngine;

namespace Tanks.Battle.ClientCore.Impl
{
	public class KickbackSystem : ECSSystem
	{
		public class KickbackNode : Node
		{
			public KickbackComponent kickback;

			public TankGroupComponent tankGroup;

			public MuzzlePointComponent muzzlePoint;

			public DiscreteWeaponComponent discreteWeapon;

			public WeaponInstanceComponent weaponInstance;
		}

		public class TankNode : Node
		{
			public TankComponent tank;

			public TankGroupComponent tankGroup;

			public RigidbodyComponent rigidbody;
		}

		[OnEventFire]
		public void StartKickback(BaseShotEvent evt, KickbackNode weapon, [JoinByTank] TankNode tank)
		{
			KickbackComponent kickback = weapon.kickback;
			MuzzleLogicAccessor muzzleLogicAccessor = new MuzzleLogicAccessor(weapon.muzzlePoint, weapon.weaponInstance);
			Vector3 vector = -muzzleLogicAccessor.GetFireDirectionWorld() * kickback.KickbackForce;
			Vector3 worldPosition = muzzleLogicAccessor.GetWorldPosition();
			tank.rigidbody.Rigidbody.AddForceAtPositionSafe(vector * WeaponConstants.WEAPON_FORCE_MULTIPLIER, worldPosition);
		}
	}
}
