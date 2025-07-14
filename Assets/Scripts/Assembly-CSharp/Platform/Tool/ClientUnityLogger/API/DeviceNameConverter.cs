using System.IO;
using UnityEngine;
using log4net.Util;

namespace Platform.Tool.ClientUnityLogger.API
{
	public class DeviceNameConverter : PatternConverter
	{
		public const string KEY = "deviceName";

		protected override void Convert(TextWriter writer, object state)
		{
			writer.Write(UnityEngine.SystemInfo.deviceName);
		}
	}
}
