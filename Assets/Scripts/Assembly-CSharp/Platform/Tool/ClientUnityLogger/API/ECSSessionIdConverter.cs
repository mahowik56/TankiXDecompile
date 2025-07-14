using System.IO;
using Platform.Library.ClientUnityIntegration.API;
using log4net.Util;

namespace Platform.Tool.ClientUnityLogger.API
{
	public class ECSSessionIdConverter : PatternConverter
	{
		public const string KEY = "ECSSessionId";

		protected override void Convert(TextWriter writer, object state)
		{
			writer.Write(ECStoLoggerGateway.ClientSessionId);
		}
	}
}
