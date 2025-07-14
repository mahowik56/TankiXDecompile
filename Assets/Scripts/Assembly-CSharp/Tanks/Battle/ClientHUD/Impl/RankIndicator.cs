using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Battle.ClientHUD.API;
using Tanks.Lobby.ClientControls.API;
using Tanks.Lobby.ClientProfile.API;
using UnityEngine;

namespace Tanks.Battle.ClientHUD.Impl
{
	public class RankIndicator : AnimatedIndicatorWithFinishComponent<PersonalBattleResultRankIndicatorFinishedComponent>
	{
		[SerializeField]
		private ImageListSkin currentLevel;

		[SerializeField]
		private ImageListSkin nextLevel;

		[SerializeField]
		private ExperienceIndicator exp;

		private long fromExp;

		private long toExp;

		private NormalizedAnimatedValue animation;

		private int level;

		private int[] levels;

		private void Awake()
		{
			animation = GetComponent<NormalizedAnimatedValue>();
		}

		public void Init(Entity screenEntity, long fromExp, long toExp, int[] levels)
		{
			SetEntity(screenEntity);
			LevelInfo info = LevelInfo.Get(fromExp, levels);
			level = info.Level;
			this.levels = levels;
			this.fromExp = fromExp;
			this.toExp = toExp;
			exp.Init(info);
			currentLevel.SelectSprite((info.Level + 1).ToString());
			if (!info.IsMaxLevel)
			{
				nextLevel.SelectSprite((info.Level + 2).ToString());
			}
			GetComponent<Animator>().SetTrigger("Start");
		}

		public void Update()
		{
			float num = animation.value * (float)(toExp - fromExp);
			LevelInfo info = LevelInfo.Get(fromExp + (long)num, levels);
			if (info.Level != level)
			{
				GetComponent<Animator>().SetTrigger("Up");
				level = info.Level;
				exp.LevelUp();
			}
			exp.Change(info);
			TryToSetAnimationFinished(info.AbsolutExperience, toExp);
		}

		private void UpdateLevel()
		{
			float num = animation.value * (float)(toExp - fromExp);
			LevelInfo levelInfo = LevelInfo.Get(fromExp + (long)num, levels);
			currentLevel.SelectSprite((levelInfo.Level + 1).ToString());
			if (!levelInfo.IsMaxLevel)
			{
				nextLevel.SelectSprite((levelInfo.Level + 2).ToString());
			}
		}
	}
}
