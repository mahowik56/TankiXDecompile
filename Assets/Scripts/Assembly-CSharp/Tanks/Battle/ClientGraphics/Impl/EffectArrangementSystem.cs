using Platform.Kernel.ECS.ClientEntitySystem.API;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class EffectArrangementSystem : ECSSystem
	{
		public class GraphicEffectArrangementNode : Node
		{
			public GraphicEffectComponent graphicEffect;
		}

		private const string EFFECT_ROOT_NAME = "Graphic Effects";

		private GameObject allEffectsRoot;

		public EffectArrangementSystem()
		{
			allEffectsRoot = GameObject.Find("Graphic Effects");
			if (allEffectsRoot == null)
			{
				allEffectsRoot = new GameObject();
				allEffectsRoot.name = "Graphic Effects";
			}
		}

		[OnEventComplete]
		public void OnArrangeGraphicEffectEvent(ArrangeGraphicEffectEvent evt, GraphicEffectArrangementNode graphicEffect)
		{
			graphicEffect.graphicEffect.EffectObject.transform.parent = allEffectsRoot.transform;
		}
	}
}
