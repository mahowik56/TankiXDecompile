using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class SupplyAnimationPlayer
	{
		private Animator animator;

		private int paramID;

		public SupplyAnimationPlayer(Animator animator, string animationParameterName)
		{
			this.animator = animator;
			paramID = Animator.StringToHash(animationParameterName);
		}

		public void StartAnimation()
		{
			animator.SetBool(paramID, true);
			animator.Update(0f);
		}

		public void StopAnimation()
		{
			animator.SetBool(paramID, false);
		}
	}
}
