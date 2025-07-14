using System.Collections.Generic;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.API
{
	public class MapWayPointsComponent : MonoBehaviour, Platform.Kernel.ECS.ClientEntitySystem.API.Component
	{
		public static int PATH_REMEMBER_LENGTH = 3;

		[SerializeField]
		private Vector3[] wayPoints;

		[SerializeField]
		[HideInInspector]
		private int[] bestWays;

		private Dictionary<long, int> hash2index = new Dictionary<long, int>();

		private static float CELL_SIZE = 1f;

		private static int WORLD_CELLS_SIZE = 1000;

		public void Create(GameObject waypointsRoot)
		{
			int childCount = waypointsRoot.transform.childCount;
			wayPoints = new Vector3[childCount];
			bestWays = new int[childCount * childCount];
			int num = 0;
			foreach (Transform item in waypointsRoot.transform)
			{
				wayPoints[num++] = item.position;
			}
		}

		public bool StorePath(Vector3 from, Vector3 to, Vector3 next)
		{
			int wayPointIndex = GetWayPointIndex(from);
			int wayPointIndex2 = GetWayPointIndex(to);
			int wayPointIndex3 = GetWayPointIndex(next);
			if (wayPointIndex < 0 || wayPointIndex2 < 0)
			{
				return false;
			}
			int num = wayPointIndex * wayPoints.Length + wayPointIndex2;
			bestWays[num] = wayPointIndex3;
			return true;
		}

		public Vector3 GetPath(Vector3 from, Vector3 to)
		{
			int wayPointIndex = GetWayPointIndex(from);
			int wayPointIndex2 = GetWayPointIndex(to);
			if (wayPointIndex < 0 || wayPointIndex2 < 0 || wayPointIndex == wayPointIndex2)
			{
				return to;
			}
			int num = wayPointIndex * wayPoints.Length + wayPointIndex2;
			int num2 = bestWays[num];
			if (num2 < 0 || num2 == wayPointIndex2)
			{
				return to;
			}
			return wayPoints[num2];
		}

		public int GetWayPointIndex(Vector3 position)
		{
			long positionHash = GetPositionHash(position);
			if (hash2index.ContainsKey(positionHash))
			{
				return hash2index[positionHash];
			}
			int nearestPointIndex = GetNearestPointIndex(position);
			hash2index.Add(positionHash, nearestPointIndex);
			return nearestPointIndex;
		}

		public int GetNearestPointIndex(Vector3 position)
		{
			float num = float.MaxValue;
			int result = -1;
			for (int i = 0; i < wayPoints.Length; i++)
			{
				float sqrMagnitude = (wayPoints[i] - position).sqrMagnitude;
				if (sqrMagnitude < num)
				{
					result = i;
					num = sqrMagnitude;
				}
			}
			return result;
		}

		public void ShowWay(Vector3 from, Vector3 to)
		{
			for (int i = 0; i < 1000; i++)
			{
				Vector3 path = GetPath(from, to);
				from = path;
				if (path == to)
				{
					break;
				}
			}
		}

		private long GetPositionHash(Vector3 position)
		{
			return (long)(position.x / CELL_SIZE) % WORLD_CELLS_SIZE + (long)(position.z / CELL_SIZE) % WORLD_CELLS_SIZE * WORLD_CELLS_SIZE * 2 + (long)(position.y / CELL_SIZE) % WORLD_CELLS_SIZE * WORLD_CELLS_SIZE * 2 * WORLD_CELLS_SIZE * 2;
		}
	}
}
