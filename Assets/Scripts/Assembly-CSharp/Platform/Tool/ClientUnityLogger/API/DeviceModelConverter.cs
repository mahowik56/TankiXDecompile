using System.IO;
using UnityEngine;
using log4net.Util;

namespace Platform.Tool.ClientUnityLogger.API
{
	public class DeviceModelConverter : PatternConverter
	{
		public const string KEY = "deviceModel";

		protected override void Convert(TextWriter writer, object state)
		{
			writer.Write(UnityEngine.SystemInfo.deviceModel);
		}
	}
}
