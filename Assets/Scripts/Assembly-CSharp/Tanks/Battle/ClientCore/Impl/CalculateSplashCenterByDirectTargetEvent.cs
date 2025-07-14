using UnityEngine;

namespace Tanks.Battle.ClientCore.Impl
{
	public class CalculateSplashCenterByDirectTargetEvent : CalculateSplashCenterEvent
	{
		public Vector3 DirectTargetLocalHitPoint { get; set; }

		public CalculateSplashCenterByDirectTargetEvent()
		{
		}

		public CalculateSplashCenterByDirectTargetEvent(Vector3 directTargetLocalHitPoint)
		{
			DirectTargetLocalHitPoint = directTargetLocalHitPoint;
		}

		public CalculateSplashCenterByDirectTargetEvent(SplashHitData splashHit, Vector3 directTargetLocalHitPoint)
			: base(splashHit)
		{
			DirectTargetLocalHitPoint = directTargetLocalHitPoint;
		}
	}
}
