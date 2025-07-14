using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class P3D_BrushPreview : MonoBehaviour
{
	private static List<P3D_BrushPreview> AllPreviews = new List<P3D_BrushPreview>();

	private MeshRenderer meshRenderer;

	private MeshFilter meshFilter;

	private Material material;

	private int age;

	private Material[] materials = new Material[1];

	public static void Show(Mesh mesh, int submeshIndex, Transform transform, float opacity, P3D_Matrix paintMatrix, Vector2 canvasResolution, Texture2D shape, Vector2 tiling, Vector2 offset)
	{
		for (int num = AllPreviews.Count - 1; num >= 0; num--)
		{
			P3D_BrushPreview p3D_BrushPreview = AllPreviews[num];
			if (p3D_BrushPreview != null && p3D_BrushPreview.age > 0)
			{
				p3D_BrushPreview.UpdateShow(mesh, submeshIndex, transform, opacity, paintMatrix, canvasResolution, shape, tiling, offset);
				return;
			}
		}
		GameObject gameObject = new GameObject("P3D_BrushPreview");
		gameObject.hideFlags = HideFlags.HideAndDontSave;
		P3D_BrushPreview p3D_BrushPreview2 = gameObject.AddComponent<P3D_BrushPreview>();
		p3D_BrushPreview2.hideFlags = HideFlags.HideAndDontSave;
		p3D_BrushPreview2.UpdateShow(mesh, submeshIndex, transform, opacity, paintMatrix, canvasResolution, shape, tiling, offset);
	}

	public static void Mark()
	{
		for (int num = AllPreviews.Count - 1; num >= 0; num--)
		{
			P3D_BrushPreview p3D_BrushPreview = AllPreviews[num];
			if (p3D_BrushPreview != null)
			{
				p3D_BrushPreview.age = 5;
			}
		}
	}

	public static void Sweep()
	{
		for (int num = AllPreviews.Count - 1; num >= 0; num--)
		{
			P3D_BrushPreview p3D_BrushPreview = AllPreviews[num];
			if (p3D_BrushPreview != null && p3D_BrushPreview.age > 1)
			{
				AllPreviews.RemoveAt(num);
				P3D_Helper.Destroy(p3D_BrushPreview.gameObject);
			}
		}
	}

	protected virtual void OnEnable()
	{
		AllPreviews.Add(this);
	}

	protected virtual void Update()
	{
		if (age >= 2)
		{
			P3D_Helper.Destroy(base.gameObject);
		}
		else
		{
			age++;
		}
	}

	protected virtual void OnDisable()
	{
		AllPreviews.Remove(this);
	}

	protected virtual void OnDestroy()
	{
		P3D_Helper.Destroy(material);
	}

	private void UpdateShow(Mesh mesh, int submeshIndex, Transform target, float opacity, P3D_Matrix paintMatrix, Vector2 canvasResolution, Texture2D shape, Vector2 tiling, Vector2 offset)
	{
		if (target != null)
		{
			if (meshRenderer == null)
			{
				meshRenderer = base.gameObject.AddComponent<MeshRenderer>();
			}
			if (meshFilter == null)
			{
				meshFilter = base.gameObject.AddComponent<MeshFilter>();
			}
			if (material == null)
			{
				material = new Material(Shader.Find("Hidden/P3D_BrushPreview"));
			}
			base.transform.position = target.position;
			base.transform.rotation = target.rotation;
			base.transform.localScale = target.lossyScale;
			material.hideFlags = HideFlags.HideAndDontSave;
			material.SetMatrix("_WorldMatrix", target.localToWorldMatrix);
			material.SetMatrix("_PaintMatrix", paintMatrix.Matrix4x4);
			material.SetVector("_CanvasResolution", canvasResolution);
			material.SetVector("_Tiling", tiling);
			material.SetVector("_Offset", offset);
			material.SetColor("_Color", new Color(1f, 1f, 1f, opacity));
			material.SetTexture("_Shape", shape);
			if (materials.Length != submeshIndex + 1)
			{
				materials = new Material[submeshIndex + 1];
			}
			for (int i = 0; i < submeshIndex; i++)
			{
				materials[i] = P3D_Helper.ClearMaterial;
			}
			materials[submeshIndex] = material;
			meshRenderer.sharedMaterials = materials;
			meshFilter.sharedMesh = mesh;
			age = 0;
		}
	}
}
