using System;

namespace Platform.Kernel.ECS.ClientEntitySystem.API
{
	[AttributeUsage(AttributeTargets.Method, AllowMultiple = false, Inherited = false)]
	public class AutoAdded : Attribute
	{
	}
}
