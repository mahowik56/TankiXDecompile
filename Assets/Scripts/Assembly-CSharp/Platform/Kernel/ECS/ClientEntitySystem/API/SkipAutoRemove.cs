using System;

namespace Platform.Kernel.ECS.ClientEntitySystem.API
{
	[AttributeUsage(AttributeTargets.Class)]
	public class SkipAutoRemove : Attribute
	{
	}
}
