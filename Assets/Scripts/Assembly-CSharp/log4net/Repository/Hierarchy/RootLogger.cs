using System;
using log4net.Core;
using log4net.Util;

namespace log4net.Repository.Hierarchy
{
	public class RootLogger : Logger
	{
		private static readonly Type declaringType = typeof(RootLogger);

		public override Level EffectiveLevel
		{
			get
			{
				return base.Level;
			}
		}

		public override Level Level
		{
			get
			{
				return base.Level;
			}
			set
			{
				if (value == null)
				{
					LogLog.Error(declaringType, "You have tried to set a null level to root.", new LogException());
				}
				else
				{
					base.Level = value;
				}
			}
		}

		public RootLogger(Level level)
			: base("root")
		{
			Level = level;
		}
	}
}
