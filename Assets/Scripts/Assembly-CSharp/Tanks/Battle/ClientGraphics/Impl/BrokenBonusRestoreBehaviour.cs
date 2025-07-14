using LeopotamGroup.Collections;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class BrokenBonusRestoreBehaviour : MonoBehaviour
	{
		private readonly FastList<Vector3> _positions = new FastList<Vector3>();

		private readonly FastList<Quaternion> _rotations = new FastList<Quaternion>();

		private void Awake()
		{
			foreach (Transform item in base.transform)
			{
				_positions.Add(item.localPosition);
				_rotations.Add(item.localRotation);
			}
		}

		private void OnDisable()
		{
			int num = 0;
			foreach (Transform item in base.transform)
			{
				item.localPosition = _positions[num];
				item.localRotation = _rotations[num];
				num++;
			}
		}
	}
}
