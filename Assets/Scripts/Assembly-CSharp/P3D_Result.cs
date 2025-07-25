using System;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class P3D_Result
{
	private static List<P3D_Result> pool = new List<P3D_Result>();

	public Vector3 Weights;

	public P3D_Triangle Triangle;

	public float Distance01;

	public Vector2 UV1
	{
		get
		{
			return Triangle.Coord1A * Weights.x + Triangle.Coord1B * Weights.y + Triangle.Coord1C * Weights.z;
		}
	}

	public Vector2 UV2
	{
		get
		{
			return Triangle.Coord2A * Weights.x + Triangle.Coord2B * Weights.y + Triangle.Coord2C * Weights.z;
		}
	}

	public Vector2 Point
	{
		get
		{
			return Triangle.PointA * Weights.x + Triangle.PointB * Weights.y + Triangle.PointC * Weights.z;
		}
	}

	public static P3D_Result Spawn()
	{
		if (pool.Count > 0)
		{
			int index = pool.Count - 1;
			P3D_Result result = pool[index];
			pool.RemoveAt(index);
			return result;
		}
		return new P3D_Result();
	}

	public static P3D_Result Despawn(P3D_Result result)
	{
		pool.Add(result);
		return null;
	}

	public Vector2 GetUV(P3D_CoordType coord)
	{
		switch (coord)
		{
		case P3D_CoordType.UV1:
			return UV1;
		case P3D_CoordType.UV2:
			return UV2;
		default:
			return default(Vector2);
		}
	}
}
