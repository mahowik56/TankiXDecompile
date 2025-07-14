using log4net.Core;

namespace log4net.Repository.Hierarchy
{
	internal class DefaultLoggerFactory : ILoggerFactory
	{
		internal sealed class LoggerImpl : Logger
		{
			internal LoggerImpl(string name)
				: base(name)
			{
			}
		}

		internal DefaultLoggerFactory()
		{
		}

		public Logger CreateLogger(ILoggerRepository repository, string name)
		{
			if (name == null)
			{
				return new RootLogger(repository.LevelMap.LookupWithDefault(Level.Debug));
			}
			return new LoggerImpl(name);
		}
	}
}
