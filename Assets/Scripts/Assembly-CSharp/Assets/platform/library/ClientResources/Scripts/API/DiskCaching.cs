using UnityEngine;

namespace Assets.platform.library.ClientResources.Scripts.API
{
	public static class DiskCaching
	{
		private static bool enabled;

		public static bool Enabled
		{
			get
			{
				return enabled;
			}
			set
			{
				enabled = value;
			}
		}

		public static long MaximumAvailableDiskSpace
		{
			set
			{
				Caching.maximumAvailableDiskSpace = value;
			}
		}

		public static int ExpirationDelay
		{
			set
			{
				Caching.expirationDelay = value;
			}
		}

		public static bool CompressionEnambled
		{
			set
			{
				Caching.compressionEnabled = value;
			}
		}

		static DiskCaching()
		{
			enabled = Caching.enabled;
		}
	}
}
