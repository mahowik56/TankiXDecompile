using System;

namespace Platform.Kernel.ECS.ClientEntitySystem.API
{
	[AttributeUsage(AttributeTargets.Interface, AllowMultiple = false, Inherited = false)]
	public class OverrideConfigPathAttribute : Attribute
	{
		internal readonly string configPath;

		internal readonly PathOverrideType pathOverrideType;

		public OverrideConfigPathAttribute(string configPath, PathOverrideType overrideType = PathOverrideType.ABSOLUTE)
		{
			this.configPath = configPath;
			pathOverrideType = overrideType;
		}
	}
}
