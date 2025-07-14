using Platform.Library.ClientUnityIntegration.API;
using UnityEngine;

namespace Tanks.Battle.ClientHUD.Impl
{
	public class SelfTargetHitFeedbackHUDConfigComponent : BehaviourComponent
	{
		private const float Z_VALUE = 0.5f;

		private const float LENGTH = 10f;

		[SerializeField]
		private SelfTargetHitFeedbackHUDInstanceComponent effectPrefab;

		[SerializeField]
		private BoxCollider coliderHelper;

		public SelfTargetHitFeedbackHUDInstanceComponent EffectPrefab
		{
			get
			{
				return effectPrefab;
			}
		}

		public Vector2? GetBoundPosition(Vector3 targetPos, Vector2 hitVecViewportSpace)
		{
			Vector3 normalized = coliderHelper.transform.TransformVector(new Vector3(hitVecViewportSpace.x, hitVecViewportSpace.y, 0f)).normalized;
			Vector3 vector = coliderHelper.transform.TransformPoint(new Vector3(targetPos.x, targetPos.y, 0.5f));
			Vector3 origin = vector - normalized * 10f;
			Ray ray = new Ray(origin, normalized);
			RaycastHit hitInfo;
			if (!coliderHelper.Raycast(ray, out hitInfo, 10f))
			{
				return null;
			}
			Vector3 vector2 = coliderHelper.transform.InverseTransformPoint(hitInfo.point);
			return new Vector2(vector2.x, vector2.y);
		}
	}
}
