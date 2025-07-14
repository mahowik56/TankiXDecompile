using System;
using Platform.Kernel.ECS.ClientEntitySystem.API;

namespace Tanks.Lobby.ClientGarage.Impl
{
	[JoinBy(typeof(TutorialGroupComponent))]
	[AttributeUsage(AttributeTargets.Class | AttributeTargets.Parameter, AllowMultiple = false, Inherited = false)]
	public class JoinByTutorial : Attribute
	{
	}
}
