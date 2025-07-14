using System.IO;
using Platform.Library.ClientUnityIntegration.API;
using log4net.Util;

namespace Platform.Tool.ClientUnityLogger.API
{
	public class ServerUrlConverter : PatternConverter
	{
		public const string KEY = "InitUrl";

		protected override void Convert(TextWriter writer, object state)
		{
			if (StartupConfiguration.Config != null)
			{
				writer.Write(StartupConfiguration.Config.InitUrl);
			}
		}
	}
}
