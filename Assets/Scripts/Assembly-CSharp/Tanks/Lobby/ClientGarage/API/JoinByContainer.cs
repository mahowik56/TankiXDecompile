using System;
using Platform.Kernel.ECS.ClientEntitySystem.API;

namespace Tanks.Lobby.ClientGarage.API
{
	[JoinBy(typeof(ContainerGroupComponent))]
	[AttributeUsage(AttributeTargets.Class | AttributeTargets.Parameter, AllowMultiple = false, Inherited = false)]
	public class JoinByContainer : Attribute
	{
	}
}
