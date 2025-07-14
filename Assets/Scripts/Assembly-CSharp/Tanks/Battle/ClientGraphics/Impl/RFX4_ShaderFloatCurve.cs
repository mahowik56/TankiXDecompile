using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class RFX4_ShaderFloatCurve : MonoBehaviour
	{
		public RFX4_ShaderProperties ShaderFloatProperty = RFX4_ShaderProperties._Cutoff;

		public AnimationCurve FloatCurve = AnimationCurve.EaseInOut(0f, 0f, 1f, 1f);

		public float GraphTimeMultiplier = 1f;

		public float GraphIntensityMultiplier = 1f;

		public bool IsLoop;

		public bool UseSharedMaterial;

		private bool canUpdate;

		private float startTime;

		private Material mat;

		private float startFloat;

		private int propertyID;

		private string shaderProperty;

		private bool isInitialized;

		private void Awake()
		{
			Renderer component = GetComponent<Renderer>();
			if (component == null)
			{
				Projector component2 = GetComponent<Projector>();
				if (component2 != null)
				{
					if (!UseSharedMaterial)
					{
						if (!component2.material.name.EndsWith("(Instance)"))
						{
							component2.material = new Material(component2.material)
							{
								name = component2.material.name + " (Instance)"
							};
						}
						mat = component2.material;
					}
					else
					{
						mat = component2.material;
					}
				}
			}
			else if (!UseSharedMaterial)
			{
				mat = component.material;
			}
			else
			{
				mat = component.sharedMaterial;
			}
			shaderProperty = ShaderFloatProperty.ToString();
			if (mat.HasProperty(shaderProperty))
			{
				propertyID = Shader.PropertyToID(shaderProperty);
			}
			startFloat = mat.GetFloat(propertyID);
			float value = FloatCurve.Evaluate(0f) * GraphIntensityMultiplier;
			mat.SetFloat(propertyID, value);
			isInitialized = true;
		}

		private void OnEnable()
		{
			startTime = Time.time;
			canUpdate = true;
			if (isInitialized)
			{
				float value = FloatCurve.Evaluate(0f) * GraphIntensityMultiplier;
				mat.SetFloat(propertyID, value);
			}
		}

		private void Update()
		{
			float num = Time.time - startTime;
			if (canUpdate)
			{
				float value = FloatCurve.Evaluate(num / GraphTimeMultiplier) * GraphIntensityMultiplier;
				mat.SetFloat(propertyID, value);
			}
			if (num >= GraphTimeMultiplier)
			{
				if (IsLoop)
				{
					startTime = Time.time;
				}
				else
				{
					canUpdate = false;
				}
			}
		}

		private void OnDisable()
		{
			if (UseSharedMaterial)
			{
				mat.SetFloat(propertyID, startFloat);
			}
		}

		private void OnDestroy()
		{
			if (!UseSharedMaterial)
			{
				if (mat != null)
				{
					Object.DestroyImmediate(mat);
				}
				mat = null;
			}
		}
	}
}
