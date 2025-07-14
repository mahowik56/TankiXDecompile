using System;
using System.Collections.Generic;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	[Serializable]
	public class GrassLocationParams
	{
		public Texture2D uvMask;

		public bool whiteAsEmpty;

		public float blackThreshold;

		public List<GameObject> terrainObjects = new List<GameObject>();

		public float densityPerMeter = 1f;

		public float grassCombineWidth = 20f;

		public float GrassStep
		{
			get
			{
				return Mathf.Sqrt(1f / densityPerMeter) / 2f;
			}
		}
	}
}
