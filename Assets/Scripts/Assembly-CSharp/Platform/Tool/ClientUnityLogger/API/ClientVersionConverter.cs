using System.IO;
using Platform.Library.ClientUnityIntegration.API;
using log4net.Util;

namespace Platform.Tool.ClientUnityLogger.API
{
	public class ClientVersionConverter : PatternConverter
	{
		public const string KEY = "ClientVersion";

		protected override void Convert(TextWriter writer, object state)
		{
			if (StartupConfiguration.Config != null)
			{
				writer.Write(StartupConfiguration.Config.CurrentClientVersion);
			}
		}
	}
}
