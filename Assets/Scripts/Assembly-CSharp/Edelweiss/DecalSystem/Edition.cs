using UnityEngine;

namespace Edelweiss.DecalSystem
{
	public class Edition
	{
		public static bool IsDecalSystemFree
		{
			get
			{
				return false;
			}
		}

		public static bool IsDX11
		{
			get
			{
				return SystemInfo.graphicsShaderLevel >= 41;
			}
		}
	}
}
