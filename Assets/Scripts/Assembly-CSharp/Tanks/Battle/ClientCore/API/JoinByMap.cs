using System;
using Platform.Kernel.ECS.ClientEntitySystem.API;

namespace Tanks.Battle.ClientCore.API
{
	[JoinBy(typeof(MapGroupComponent))]
	[AttributeUsage(AttributeTargets.Class | AttributeTargets.Parameter, Inherited = false)]
	public class JoinByMap : Attribute
	{
	}
}
