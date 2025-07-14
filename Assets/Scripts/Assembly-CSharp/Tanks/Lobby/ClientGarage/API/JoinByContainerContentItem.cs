using System;
using Platform.Kernel.ECS.ClientEntitySystem.API;

namespace Tanks.Lobby.ClientGarage.API
{
	[JoinBy(typeof(ContainerContentItemGroupComponent))]
	[AttributeUsage(AttributeTargets.Class | AttributeTargets.Parameter, AllowMultiple = false, Inherited = false)]
	public class JoinByContainerContentItem : Attribute
	{
	}
}
