using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientCore.API;
using Tanks.Battle.ClientGraphics.API;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class TankJumpSoundSystem : ECSSystem
	{
		public class TankInitNode : Node
		{
			public TankVisualRootComponent tankVisualRoot;

			public AssembledTankComponent assembledTank;

			public TankJumpSoundPrefabComponent tankJumpSoundPrefab;
		}

		public class TankJumpNode : Node
		{
			public TankJumpComponent tankJump;

			public TankJumpSoundComponent tankJumpSound;
		}

		[OnEventFire]
		public void CreateCommonTankSounds(NodeAddedEvent evt, TankInitNode tank)
		{
			AudioSource audioSource = Object.Instantiate(tank.tankJumpSoundPrefab.Sound);
			audioSource.transform.SetParent(tank.tankVisualRoot.transform, false);
			tank.Entity.AddComponent(new TankJumpSoundComponent(audioSource));
		}

		[OnEventFire]
		public void PlayJumpSound(NodeAddedEvent evt, TankJumpNode tank, [JoinAll] SingleNode<SoundListenerBattleStateComponent> soundListener)
		{
			tank.tankJumpSound.Sound.Play();
		}
	}
}
