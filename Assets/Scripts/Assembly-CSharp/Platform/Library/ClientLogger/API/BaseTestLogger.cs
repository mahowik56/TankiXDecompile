using Platform.Kernel.OSGi.ClientCore.API;
using log4net;

namespace Platform.Library.ClientLogger.API
{
	public class BaseTestLogger
	{
		[Inject]
		public static ILog Log { get; set; }

		public BaseTestLogger()
		{
			LoggerProvider.Init();
		}
	}
}
