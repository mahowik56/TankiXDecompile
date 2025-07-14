using System.IO;
using Platform.Library.ClientUnityIntegration.API;
using log4net.Util;

namespace Platform.Tool.ClientUnityLogger.API
{
	public class UserUIDConverter : PatternConverter
	{
		public const string KEY = "UserUID";

		protected override void Convert(TextWriter writer, object state)
		{
			writer.Write(ECStoLoggerGateway.UserUID);
		}
	}
}
