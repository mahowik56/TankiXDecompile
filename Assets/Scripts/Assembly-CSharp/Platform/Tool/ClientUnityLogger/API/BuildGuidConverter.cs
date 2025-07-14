using System.IO;
using UnityEngine;
using log4net.Util;

namespace Platform.Tool.ClientUnityLogger.API
{
	public class BuildGuidConverter : PatternConverter
	{
		public const string KEY = "buildGUID";

		protected override void Convert(TextWriter writer, object state)
		{
			writer.Write(Application.buildGUID);
		}
	}
}
