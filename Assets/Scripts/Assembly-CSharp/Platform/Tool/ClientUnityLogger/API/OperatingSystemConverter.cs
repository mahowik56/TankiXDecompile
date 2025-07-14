using System.IO;
using UnityEngine;
using log4net.Util;

namespace Platform.Tool.ClientUnityLogger.API
{
	public class OperatingSystemConverter : PatternConverter
	{
		public const string KEY = "operatingSystem";

		protected override void Convert(TextWriter writer, object state)
		{
			writer.Write(UnityEngine.SystemInfo.operatingSystem);
		}
	}
}
