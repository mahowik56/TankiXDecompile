using System;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class P3D_Triangle
{
	private static List<P3D_Triangle> pool = new List<P3D_Triangle>();

	public Vector3 PointA;

	public Vector3 PointB;

	public Vector3 PointC;

	public Vector2 Coord1A;

	public Vector2 Coord1B;

	public Vector2 Coord1C;

	public Vector2 Coord2A;

	public Vector2 Coord2B;

	public Vector2 Coord2C;

	public Vector3 Edge1
	{
		get
		{
			return PointB - PointA;
		}
	}

	public Vector3 Edge2
	{
		get
		{
			return PointC - PointA;
		}
	}

	public Vector3 Min
	{
		get
		{
			return Vector3.Min(PointA, Vector3.Min(PointB, PointC));
		}
	}

	public Vector3 Max
	{
		get
		{
			return Vector3.Max(PointA, Vector3.Max(PointB, PointC));
		}
	}

	public float MidX
	{
		get
		{
			return (PointA.x + PointB.x + PointC.x) / 3f;
		}
	}

	public float MidY
	{
		get
		{
			return (PointA.y + PointB.y + PointC.y) / 3f;
		}
	}

	public float MidZ
	{
		get
		{
			return (PointA.z + PointB.z + PointC.z) / 3f;
		}
	}

	public static P3D_Triangle Spawn()
	{
		if (pool.Count > 0)
		{
			int index = pool.Count - 1;
			P3D_Triangle result = pool[index];
			pool.RemoveAt(index);
			return result;
		}
		return new P3D_Triangle();
	}

	public static P3D_Triangle Despawn(P3D_Triangle triangle)
	{
		pool.Add(triangle);
		return null;
	}
}
