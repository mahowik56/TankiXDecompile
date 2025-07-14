using System.Collections.Generic;
using System.Linq;
using Lobby.ClientUserProfile.API;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Kernel.OSGi.ClientCore.API;
using Platform.Library.ClientDataStructures.API;
using Tanks.Battle.ClientCore.API;
using Tanks.Battle.ClientCore.Impl;
using Tanks.Battle.ClientGraphics.API;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class SpectatorCameraManagerSystem : ECSSystem
	{
		public enum SwitchUserDirection
		{
			PrevUser = 0,
			NextUser = 1
		}

		public class SwitchFollowedUserEvent : Platform.Kernel.ECS.ClientEntitySystem.API.Event
		{
			public SwitchUserDirection switchUserDirection;

			public SwitchFollowedUserEvent(SwitchUserDirection switchUserDirection)
			{
				this.switchUserDirection = switchUserDirection;
			}
		}

		public class SetNewTargetCameraEvent : Platform.Kernel.ECS.ClientEntitySystem.API.Event
		{
		}

		public class SpectatorNode : Node
		{
			public UserInBattleAsSpectatorComponent userInBattleAsSpectator;

			public SelfBattleUserComponent selfBattleUser;

			public UserReadyToBattleComponent userReadyToBattle;

			public UserGroupComponent userGroup;
		}

		public class CameraNode : Node
		{
			public CameraComponent camera;

			public CameraTransformDataComponent cameraTransformData;

			public CameraESMComponent cameraESM;

			public BattleCameraComponent battleCamera;
		}

		public class SpectatorCameraNode : CameraNode
		{
			public SpectatorCameraComponent spectatorCamera;
		}

		public class FollowCameraNode : SpectatorCameraNode
		{
			public FollowCameraComponent followCamera;

			public BezierPositionComponent bezierPosition;

			public CameraOffsetConfigComponent cameraOffsetConfig;

			public TransitionCameraComponent transitionCamera;
		}

		public class FreeCameraNode : SpectatorCameraNode
		{
			public FreeCameraComponent freeCamera;
		}

		public class MouseOrbitCameraNode : SpectatorCameraNode
		{
			public MouseOrbitCameraComponent mouseOrbitCamera;

			public TransitionCameraComponent transitionCamera;
		}

		[Not(typeof(FreeCameraComponent))]
		public class NotFreeCameraNode : SpectatorCameraNode
		{
		}

		public class UserUidNode : Node
		{
			public UserGroupComponent userGroup;

			public UserUidComponent userUid;

			public BattleGroupComponent battleGroup;
		}

		public class ReadyBattleUserAsTankNode : Node
		{
			public UserReadyToBattleComponent userReadyToBattle;

			public UserInBattleAsTankComponent userInBattleAsTank;

			public UserGroupComponent userGroup;
		}

		public class WeaponInstanceNode : Node
		{
			public WeaponInstanceComponent weaponInstance;

			public TankPartComponent tankPart;

			public UserGroupComponent userGroup;
		}

		public class BattleUserNode : Node
		{
			public BattleUserComponent battleUser;

			public UserGroupComponent userGroup;
		}

		public class FollowedBattleUserNode : Node
		{
			public FollowedBattleUserComponent followedBattleUser;

			public UserGroupComponent userGroup;
		}

		public static readonly string SCREEN_SHOT_FILE_NAME = "TankiX";

		[Inject]
		public static InputManager InputManager { get; set; }

		[OnEventFire]
		public void InitSpectatorCamera(NodeAddedEvent e, SpectatorNode spectator, [JoinAll] CameraNode camera)
		{
			camera.cameraESM.Esm.ChangeState<CameraStates.CameraFreeState>();
			camera.Entity.AddComponent<SpectatorCameraComponent>();
		}

		[OnEventFire]
		public void Screenshot(UpdateEvent evt, SingleNode<SpectatorCameraComponent> cameraNode)
		{
			if (InputManager.CheckAction(SpectatorCameraActions.Screenshot))
			{
				Application.CaptureScreenshot(SCREEN_SHOT_FILE_NAME + "_" + cameraNode.component.SequenceScreenshot + ".png");
			}
		}

		[OnEventFire]
		public void ChangeCameraState(UpdateEvent e, FollowCameraNode camera)
		{
			if (InputManager.GetActionKeyDown(SpectatorCameraActions.MouseOrbitMode))
			{
				camera.cameraESM.Esm.ChangeState<CameraStates.CameraOrbitState>().mouseOrbitCamera.targetRotation = camera.cameraTransformData.Data.Rotation;
			}
		}

		[OnEventFire]
		public void ChangeCameraState(UpdateEvent e, MouseOrbitCameraNode camera)
		{
			if (InputManager.GetActionKeyDown(SpectatorCameraActions.MouseOrbitMode))
			{
				camera.cameraESM.Esm.ChangeState<CameraStates.CameraFollowState>();
			}
		}

		[OnEventFire]
		public void ChangeCameraState(SpectatorGoBackRequestEvent e, Node anyNode, [JoinAll] NotFreeCameraNode camera)
		{
			camera.cameraESM.Esm.ChangeState<CameraStates.CameraFreeState>();
		}

		[OnEventFire]
		public void SwitchFollowedTank(UpdateEvent e, SpectatorCameraNode camera, [JoinAll] FollowedBattleUserNode followedUser, [JoinByUser] UserUidNode userUid)
		{
			if (InputManager.GetActionKeyDown(SpectatorCameraActions.PrevTank) || Input.GetMouseButtonDown(UnityInputConstants.MOUSE_BUTTON_RIGHT))
			{
				ScheduleEvent(new SwitchFollowedUserEvent(SwitchUserDirection.PrevUser), userUid.Entity);
			}
			else if (InputManager.GetActionKeyDown(SpectatorCameraActions.NextTank) || Input.GetMouseButtonDown(UnityInputConstants.MOUSE_BUTTON_LEFT))
			{
				ScheduleEvent(new SwitchFollowedUserEvent(SwitchUserDirection.NextUser), userUid.Entity);
			}
		}

		[OnEventFire]
		public void SwitchFollowedUser(SwitchFollowedUserEvent e, UserUidNode userNode1, [JoinByUser] FollowedBattleUserNode followedUser, [JoinByBattle] ICollection<UserUidNode> allUserUids, UserUidNode userNode2, [JoinByBattle] ICollection<ReadyBattleUserAsTankNode> tankUsers)
		{
			List<UserUidNode> userUids = FilterUsers(allUserUids, tankUsers, userNode1, followedUser);
			UserUidNode userUidForFollowingTank = GetUserUidForFollowingTank(userUids, userNode1, e.switchUserDirection);
			if (!userNode1.Equals(userUidForFollowingTank))
			{
				ScheduleEvent<SetNewTargetCameraEvent>(userUidForFollowingTank.Entity);
			}
		}

		[OnEventFire]
		public void SetNewTargetToCamera(SetNewTargetCameraEvent e, UserUidNode user, [JoinByUser] BattleUserNode battleUser, [JoinAll] FollowedBattleUserNode prevFollowedUser, [JoinAll] FollowCameraNode camera)
		{
			prevFollowedUser.Entity.RemoveComponent<FollowedBattleUserComponent>();
			battleUser.Entity.AddComponent<FollowedBattleUserComponent>();
			CameraOffsetConfigComponent cameraOffsetConfig = camera.cameraOffsetConfig;
			Vector3 vector = new Vector3(cameraOffsetConfig.XOffset, cameraOffsetConfig.YOffset, cameraOffsetConfig.ZOffset);
			BezierPosition bezierPosition = camera.bezierPosition.BezierPosition;
			camera.transitionCamera.CameraSaveData = CameraSaveData.CreateFollowData(user.userUid.Uid, bezierPosition.GetBaseRatio(), bezierPosition.GetRatioOffset());
			camera.cameraESM.Esm.ChangeState<CameraStates.CameraTransitionState>();
		}

		[OnEventFire]
		public void SetNewTargetToCamera(SetNewTargetCameraEvent e, UserUidNode user, [JoinByUser] BattleUserNode battleUser, [JoinAll] FollowedBattleUserNode prevFollowedUser, [JoinAll] MouseOrbitCameraNode camera)
		{
			prevFollowedUser.Entity.RemoveComponent<FollowedBattleUserComponent>();
			battleUser.Entity.AddComponent<FollowedBattleUserComponent>();
			camera.transitionCamera.CameraSaveData = CameraSaveData.CreateMouseOrbitData(user.userUid.Uid, camera.mouseOrbitCamera.distance, camera.mouseOrbitCamera.targetRotation);
			camera.cameraESM.Esm.ChangeState<CameraStates.CameraTransitionState>();
		}

		private List<UserUidNode> FilterUsers(ICollection<UserUidNode> users, ICollection<ReadyBattleUserAsTankNode> tanks, UserUidNode currentUser, FollowedBattleUserNode currentBattleUser)
		{
			List<ReadyBattleUserAsTankNode> tanksList = tanks.ToList();
			if (currentBattleUser.Entity.HasComponent<TeamGroupComponent>())
			{
				long currentTeamKey = currentBattleUser.Entity.GetComponent<TeamGroupComponent>().Key;
				List<ReadyBattleUserAsTankNode> list = tanksList.Where((ReadyBattleUserAsTankNode tank) => tank.Entity.GetComponent<TeamGroupComponent>().Key != currentTeamKey).ToList();
				if (list.Count > 0)
				{
					tanksList = list;
				}
			}
			List<UserUidNode> list2 = users.Where((UserUidNode user) => tanksList.Exists((ReadyBattleUserAsTankNode tank) => user.userGroup.Key == tank.userGroup.Key)).ToList();
			if (!list2.Exists((UserUidNode user) => user.Equals(currentUser)))
			{
				list2.Add(currentUser);
			}
			return list2;
		}

		private UserUidNode GetUserUidForFollowingTank(List<UserUidNode> userUids, UserUidNode currentTargetUserUid, SwitchUserDirection switchUserDirection)
		{
			List<string> list = userUids.Select((UserUidNode x) => x.userUid.Uid).ToList();
			string uid = currentTargetUserUid.userUid.Uid;
			list.Sort();
			int num = list.IndexOf(uid);
			switch (switchUserDirection)
			{
			case SwitchUserDirection.PrevUser:
				num--;
				break;
			case SwitchUserDirection.NextUser:
				num++;
				break;
			}
			num += list.Count;
			uid = list[num % list.Count];
			return userUids.Single((UserUidNode x) => x.userUid.Uid == uid);
		}

		[OnEventFire]
		public void UnlinkCamera(NodeAddedEvent e, SingleNode<FreeCameraComponent> freeCamera, [JoinAll] SingleNode<FollowedBattleUserComponent> followedBattleUser)
		{
			if (!followedBattleUser.component.UserHasLeftBattle)
			{
				followedBattleUser.Entity.RemoveComponent<FollowedBattleUserComponent>();
			}
		}

		[OnEventFire]
		public void FollowUser(CameraFollowEvent e, BattleUserNode battleUser, [JoinAll] Optional<FollowedBattleUserNode> prevFollowedBattleUser, [JoinAll] SingleNode<CameraESMComponent> camera)
		{
			if (prevFollowedBattleUser.IsPresent())
			{
				prevFollowedBattleUser.Get().Entity.RemoveComponent<FollowedBattleUserComponent>();
			}
			battleUser.Entity.AddComponent<TeleportCameraIntentComponent>();
			battleUser.Entity.AddComponent<FollowedBattleUserComponent>();
			camera.component.Esm.ChangeState<CameraStates.CameraFollowState>();
		}

		[OnEventFire]
		public void FollowNewUser(NodeAddedEvent e, FollowedBattleUserNode followedBattleUser, [JoinByUser] WeaponInstanceNode weaponInstanceNode, [JoinAll][Combine] Optional<SingleNode<TeleportCameraIntentComponent>> moveIntent)
		{
			CameraTargetComponent cameraTargetComponent = new CameraTargetComponent();
			cameraTargetComponent.TargetObject = weaponInstanceNode.weaponInstance.WeaponInstance;
			CameraTargetComponent component = cameraTargetComponent;
			weaponInstanceNode.Entity.AddComponent(component);
			if (moveIntent.IsPresent())
			{
				ScheduleEvent<CameraFollowEvent>(weaponInstanceNode.Entity);
				moveIntent.Get().Entity.RemoveComponent<TeleportCameraIntentComponent>();
			}
		}

		[OnEventComplete]
		public void ReturnToFreeCamera(NodeRemoveEvent e, BattleUserNode battleUser, [JoinByUser] FollowedBattleUserNode followedBattleUser, [JoinAll] SingleNode<CameraESMComponent> camera)
		{
			followedBattleUser.followedBattleUser.UserHasLeftBattle = true;
			camera.component.Esm.ChangeState<CameraStates.CameraFreeState>();
		}

		[OnEventFire]
		public void StopFollowUser(NodeRemoveEvent e, FollowedBattleUserNode followedBattleUser, [JoinByUser] SingleNode<CameraTargetComponent> cameraTarget)
		{
			cameraTarget.Entity.RemoveComponent<CameraTargetComponent>();
		}

		[OnEventFire]
		public void StopFollowUser(NodeRemoveEvent e, FollowedBattleUserNode followedBattleUser, [JoinAll] SingleNode<TeleportCameraIntentComponent> moveCameraIntent)
		{
			followedBattleUser.Entity.RemoveComponent<TeleportCameraIntentComponent>();
		}
	}
}
