using UnityEngine;
using UnityEngine.Rendering;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class TutorialTankPartOutline : MonoBehaviour
	{
		public Shader outlineShader;

		public void Init(GameObject tankPart)
		{
			SkinnedMeshRenderer component = tankPart.GetComponent<SkinnedMeshRenderer>();
			Mesh sharedMesh = component.sharedMesh;
			Material material = new Material(outlineShader);
			MeshFilter meshFilter = base.gameObject.AddComponent<MeshFilter>();
			meshFilter.sharedMesh = sharedMesh;
			MeshRenderer meshRenderer = base.gameObject.AddComponent<MeshRenderer>();
			Material[] array = new Material[component.sharedMaterials.Length];
			for (int i = 0; i < array.Length; i++)
			{
				array[i] = material;
			}
			meshRenderer.sharedMaterials = array;
			meshRenderer.lightProbeUsage = LightProbeUsage.Off;
			meshRenderer.reflectionProbeUsage = ReflectionProbeUsage.Off;
			meshRenderer.shadowCastingMode = ShadowCastingMode.Off;
			meshRenderer.receiveShadows = false;
			if (base.transform.parent != null && base.transform.parent.GetComponent<TutorialTankPartOutline>() != null)
			{
				Object.Destroy(base.gameObject.GetComponent<OutlineObject>());
			}
		}

		public void Disable()
		{
			OutlineObject component = GetComponent<OutlineObject>();
			if (component != null)
			{
				component.Enable = false;
			}
		}
	}
}
