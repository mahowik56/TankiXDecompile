using System;
using UnityEngine;

namespace Edelweiss.DecalSystem
{
	[Serializable]
	public class UVRectangle
	{
		public string name = "UVRectangle";

		public Vector2 lowerLeftUV = Vector2.zero;

		public Vector2 upperRightUV = Vector3.one;

		public Vector2 Size
		{
			get
			{
				return upperRightUV - lowerLeftUV;
			}
		}

		public UVRectangle()
		{
			name = "UVRectangle";
			lowerLeftUV = Vector2.zero;
			upperRightUV = Vector2.one;
		}

		public UVRectangle(UVRectangle a_Other)
		{
			name = string.Copy(a_Other.name);
			lowerLeftUV = a_Other.lowerLeftUV;
			upperRightUV = a_Other.upperRightUV;
		}

		public override string ToString()
		{
			return name;
		}
	}
}
