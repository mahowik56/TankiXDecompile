using System.IO;
using UnityEngine;
using log4net.Util;

namespace Platform.Tool.ClientUnityLogger.API
{
	public class FrameCountConverter : PatternConverter
	{
		public const string KEY = "frameCount";

		protected override void Convert(TextWriter writer, object state)
		{
			writer.Write(Time.frameCount);
		}
	}
}
