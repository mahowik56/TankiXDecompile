using System;
using System.Collections.Generic;
using UnityEngine;

namespace Edelweiss.DecalSystem
{
	public abstract class SkinnedDecals : GenericDecals<SkinnedDecals, SkinnedDecalProjectorBase, SkinnedDecalsMesh>
	{
		private List<SkinnedDecalsMeshRenderer> m_SkinnedDecalsMeshRenderers = new List<SkinnedDecalsMeshRenderer>();

		public override bool CastShadows
		{
			get
			{
				return SkinnedDecalsMeshRenderers[0].SkinnedMeshRenderer.castShadows;
			}
			set
			{
				SkinnedDecalsMeshRenderer[] skinnedDecalsMeshRenderers = SkinnedDecalsMeshRenderers;
				foreach (SkinnedDecalsMeshRenderer skinnedDecalsMeshRenderer in skinnedDecalsMeshRenderers)
				{
					skinnedDecalsMeshRenderer.SkinnedMeshRenderer.castShadows = value;
				}
			}
		}

		public override bool ReceiveShadows
		{
			get
			{
				return SkinnedDecalsMeshRenderers[0].SkinnedMeshRenderer.receiveShadows;
			}
			set
			{
				SkinnedDecalsMeshRenderer[] skinnedDecalsMeshRenderers = SkinnedDecalsMeshRenderers;
				foreach (SkinnedDecalsMeshRenderer skinnedDecalsMeshRenderer in skinnedDecalsMeshRenderers)
				{
					skinnedDecalsMeshRenderer.SkinnedMeshRenderer.receiveShadows = value;
				}
			}
		}

		public override bool UseLightProbes
		{
			get
			{
				return SkinnedDecalsMeshRenderers[0].SkinnedMeshRenderer.useLightProbes;
			}
			set
			{
				SkinnedDecalsMeshRenderer[] skinnedDecalsMeshRenderers = SkinnedDecalsMeshRenderers;
				foreach (SkinnedDecalsMeshRenderer skinnedDecalsMeshRenderer in skinnedDecalsMeshRenderers)
				{
					skinnedDecalsMeshRenderer.SkinnedMeshRenderer.useLightProbes = value;
				}
			}
		}

		public override Transform LightProbeAnchor
		{
			get
			{
				return SkinnedDecalsMeshRenderers[0].SkinnedMeshRenderer.probeAnchor;
			}
			set
			{
				SkinnedDecalsMeshRenderer[] skinnedDecalsMeshRenderers = SkinnedDecalsMeshRenderers;
				foreach (SkinnedDecalsMeshRenderer skinnedDecalsMeshRenderer in skinnedDecalsMeshRenderers)
				{
					skinnedDecalsMeshRenderer.SkinnedMeshRenderer.probeAnchor = value;
				}
			}
		}

		public SkinnedDecalsMeshRenderer[] SkinnedDecalsMeshRenderers
		{
			get
			{
				return m_SkinnedDecalsMeshRenderers.ToArray();
			}
		}

		public bool IsSkinnedDecalsMeshRenderer(SkinnedMeshRenderer a_SkinnedMeshRenderer)
		{
			bool result = false;
			foreach (SkinnedDecalsMeshRenderer skinnedDecalsMeshRenderer in m_SkinnedDecalsMeshRenderers)
			{
				if (a_SkinnedMeshRenderer == skinnedDecalsMeshRenderer.SkinnedMeshRenderer)
				{
					result = true;
					break;
				}
			}
			return result;
		}

		public override void ApplyMaterialToMeshRenderers()
		{
			base.ApplyMaterialToMeshRenderers();
			Material material = null;
			if (base.CurrentTextureAtlasType == TextureAtlasType.Builtin)
			{
				material = base.CurrentMaterial;
			}
			else if (base.CurrentTextureAtlasType == TextureAtlasType.Reference && base.CurrentTextureAtlasAsset != null)
			{
				material = base.CurrentTextureAtlasAsset.material;
			}
			foreach (SkinnedDecalsMeshRenderer skinnedDecalsMeshRenderer in m_SkinnedDecalsMeshRenderers)
			{
				if (Application.isPlaying)
				{
					skinnedDecalsMeshRenderer.SkinnedMeshRenderer.material = material;
				}
				else
				{
					skinnedDecalsMeshRenderer.SkinnedMeshRenderer.sharedMaterial = material;
				}
			}
		}

		public override void ApplyRenderersEditability()
		{
			base.ApplyRenderersEditability();
			HideFlags hideFlags = HideFlags.None;
			if (!base.AreRenderersEditable)
			{
				hideFlags = HideFlags.NotEditable;
			}
			foreach (SkinnedDecalsMeshRenderer skinnedDecalsMeshRenderer in m_SkinnedDecalsMeshRenderers)
			{
				skinnedDecalsMeshRenderer.gameObject.hideFlags = hideFlags;
			}
		}

		public override void OnEnable()
		{
			InitializeDecalsMeshRenderers();
			if (m_SkinnedDecalsMeshRenderers.Count == 0)
			{
				PushSkinnedDecalsMeshRenderer();
			}
		}

		public override void InitializeDecalsMeshRenderers()
		{
			m_SkinnedDecalsMeshRenderers.Clear();
			Transform cachedTransform = base.CachedTransform;
			for (int i = 0; i < cachedTransform.childCount; i++)
			{
				Transform child = cachedTransform.GetChild(i);
				SkinnedDecalsMeshRenderer component = child.GetComponent<SkinnedDecalsMeshRenderer>();
				if (component != null)
				{
					m_SkinnedDecalsMeshRenderers.Add(component);
				}
			}
		}

		public override void UpdateDecalsMeshes(SkinnedDecalsMesh a_DecalsMesh)
		{
			base.UpdateDecalsMeshes(a_DecalsMesh);
			if (a_DecalsMesh.Vertices.Count <= 65535)
			{
				if (m_SkinnedDecalsMeshRenderers.Count == 0)
				{
					PushSkinnedDecalsMeshRenderer();
				}
				else if (m_SkinnedDecalsMeshRenderers.Count > 1)
				{
					while (m_SkinnedDecalsMeshRenderers.Count > 1)
					{
						PopSkinnedDecalsMeshRenderer();
					}
				}
				SkinnedDecalsMeshRenderer a_SkinnedDecalsMeshRenderer = m_SkinnedDecalsMeshRenderers[0];
				ApplyToSkinnedDecalsMeshRenderer(a_SkinnedDecalsMeshRenderer, a_DecalsMesh);
			}
			else
			{
				int num = 0;
				for (int i = 0; i < a_DecalsMesh.Projectors.Count; i++)
				{
					GenericDecalProjectorBase a_FirstProjector = a_DecalsMesh.Projectors[i];
					GenericDecalProjectorBase a_LastProjector = a_DecalsMesh.Projectors[i];
					if (num >= m_SkinnedDecalsMeshRenderers.Count)
					{
						PushSkinnedDecalsMeshRenderer();
					}
					SkinnedDecalsMeshRenderer a_SkinnedDecalsMeshRenderer2 = m_SkinnedDecalsMeshRenderers[num];
					int num2 = 0;
					int num3 = i;
					GenericDecalProjectorBase genericDecalProjectorBase = a_DecalsMesh.Projectors[i];
					while (i < a_DecalsMesh.Projectors.Count && num2 + genericDecalProjectorBase.DecalsMeshVertexCount <= 65535)
					{
						a_LastProjector = genericDecalProjectorBase;
						num2 += genericDecalProjectorBase.DecalsMeshVertexCount;
						i++;
						if (i < a_DecalsMesh.Projectors.Count)
						{
							genericDecalProjectorBase = a_DecalsMesh.Projectors[i];
						}
					}
					if (num3 != i)
					{
						ApplyToSkinnedDecalsMeshRenderer(a_SkinnedDecalsMeshRenderer2, a_DecalsMesh, a_FirstProjector, a_LastProjector);
						num++;
					}
				}
				while (num + 1 < m_SkinnedDecalsMeshRenderers.Count)
				{
					PopSkinnedDecalsMeshRenderer();
				}
			}
			SetDecalsMeshesAreNotOptimized();
		}

		[Obsolete("UpdateSkinnedDecalsMeshes is deprecated, please use UpdateDecalsMeshes instead.")]
		public void UpdateSkinnedDecalsMeshes(SkinnedDecalsMesh a_SkinnedDecalsMesh)
		{
			UpdateDecalsMeshes(a_SkinnedDecalsMesh);
		}

		public override void UpdateVertexColors(SkinnedDecalsMesh a_DecalsMesh)
		{
			base.UpdateVertexColors(a_DecalsMesh);
			int a_LowerListIndex = 0;
			int num = 0;
			for (int i = 0; i < m_SkinnedDecalsMeshRenderers.Count; i++)
			{
				SkinnedDecalsMeshRenderer skinnedDecalsMeshRenderer = m_SkinnedDecalsMeshRenderers[i];
				Mesh sharedMesh = skinnedDecalsMeshRenderer.SkinnedMeshRenderer.sharedMesh;
				num = num + sharedMesh.vertexCount - 1;
				Color[] a_Array = a_DecalsMesh.PreservedVertexColorArrays[i];
				CopyListRangeToArray(ref a_Array, a_DecalsMesh.VertexColors, a_LowerListIndex, num);
				sharedMesh.colors = a_Array;
				a_LowerListIndex = num;
			}
		}

		public override void UpdateProjectedUVs(SkinnedDecalsMesh a_DecalsMesh)
		{
			base.UpdateProjectedUVs(a_DecalsMesh);
			int a_LowerListIndex = 0;
			int num = 0;
			for (int i = 0; i < m_SkinnedDecalsMeshRenderers.Count; i++)
			{
				SkinnedDecalsMeshRenderer skinnedDecalsMeshRenderer = m_SkinnedDecalsMeshRenderers[i];
				Mesh sharedMesh = skinnedDecalsMeshRenderer.SkinnedMeshRenderer.sharedMesh;
				num = num + sharedMesh.vertexCount - 1;
				Vector2[] a_Array = a_DecalsMesh.PreservedProjectedUVArrays[i];
				CopyListRangeToArray(ref a_Array, a_DecalsMesh.UVs, a_LowerListIndex, num);
				sharedMesh.uv = a_Array;
				a_LowerListIndex = num;
			}
		}

		public override void UpdateProjectedUV2s(SkinnedDecalsMesh a_DecalsMesh)
		{
			base.UpdateProjectedUV2s(a_DecalsMesh);
			int a_LowerListIndex = 0;
			int num = 0;
			for (int i = 0; i < m_SkinnedDecalsMeshRenderers.Count; i++)
			{
				SkinnedDecalsMeshRenderer skinnedDecalsMeshRenderer = m_SkinnedDecalsMeshRenderers[i];
				Mesh sharedMesh = skinnedDecalsMeshRenderer.SkinnedMeshRenderer.sharedMesh;
				num = num + sharedMesh.vertexCount - 1;
				Vector2[] a_Array = a_DecalsMesh.PreservedProjectedUV2Arrays[i];
				CopyListRangeToArray(ref a_Array, a_DecalsMesh.UV2s, a_LowerListIndex, num);
				sharedMesh.uv2 = a_Array;
				a_LowerListIndex = num;
			}
		}

		private void PushSkinnedDecalsMeshRenderer()
		{
			GameObject gameObject = new GameObject("Decals Mesh Renderer");
			Transform transform = gameObject.transform;
			transform.parent = base.transform;
			transform.localPosition = Vector3.zero;
			transform.localRotation = Quaternion.identity;
			transform.localScale = Vector3.one;
			SkinnedDecalsMeshRenderer skinnedDecalsMeshRenderer = AddSkinnedDecalsMeshRendererComponentToGameObject(gameObject);
			skinnedDecalsMeshRenderer.SkinnedMeshRenderer.material = base.CurrentMaterial;
			m_SkinnedDecalsMeshRenderers.Add(skinnedDecalsMeshRenderer);
		}

		private void PopSkinnedDecalsMeshRenderer()
		{
			SkinnedDecalsMeshRenderer skinnedDecalsMeshRenderer = m_SkinnedDecalsMeshRenderers[m_SkinnedDecalsMeshRenderers.Count - 1];
			if (Application.isPlaying)
			{
				UnityEngine.Object.Destroy(skinnedDecalsMeshRenderer.SkinnedMeshRenderer.sharedMesh);
				UnityEngine.Object.Destroy(skinnedDecalsMeshRenderer.gameObject);
			}
			m_SkinnedDecalsMeshRenderers.RemoveAt(m_SkinnedDecalsMeshRenderers.Count - 1);
		}

		private void ApplyToSkinnedDecalsMeshRenderer(SkinnedDecalsMeshRenderer a_SkinnedDecalsMeshRenderer, SkinnedDecalsMesh a_SkinnedDecalsMesh)
		{
			Mesh mesh = MeshOfSkinnedDecalsMeshRenderer(a_SkinnedDecalsMeshRenderer);
			mesh.Clear();
			if (!Edition.IsDX11)
			{
				mesh.MarkDynamic();
			}
			if (a_SkinnedDecalsMesh.OriginalVertices.Count == 0)
			{
				mesh.vertices = new Vector3[1];
				if (base.CurrentNormalsMode != NormalsMode.None)
				{
					mesh.normals = new Vector3[1];
				}
				if (base.CurrentTangentsMode != TangentsMode.None)
				{
					mesh.tangents = new Vector4[1];
				}
				if (base.UseVertexColors)
				{
					mesh.colors = new Color[1];
				}
				mesh.uv = new Vector2[1];
				if (base.CurrentUV2Mode != UV2Mode.None)
				{
					mesh.uv2 = new Vector2[1];
				}
				mesh.boneWeights = new BoneWeight[1];
				mesh.bindposes = new Matrix4x4[1];
				a_SkinnedDecalsMeshRenderer.SkinnedMeshRenderer.bones = new Transform[1] { a_SkinnedDecalsMeshRenderer.transform };
				a_SkinnedDecalsMeshRenderer.SkinnedMeshRenderer.localBounds = mesh.bounds;
				a_SkinnedDecalsMeshRenderer.SkinnedMeshRenderer.updateWhenOffscreen = false;
				return;
			}
			mesh.vertices = a_SkinnedDecalsMesh.OriginalVertices.ToArray();
			if (base.CurrentNormalsMode != NormalsMode.None)
			{
				mesh.normals = a_SkinnedDecalsMesh.Normals.ToArray();
			}
			if (base.CurrentTangentsMode != TangentsMode.None)
			{
				mesh.tangents = a_SkinnedDecalsMesh.Tangents.ToArray();
			}
			if (base.UseVertexColors)
			{
				Color[] array = a_SkinnedDecalsMesh.VertexColors.ToArray();
				if (a_SkinnedDecalsMesh.PreserveVertexColorArrays)
				{
					a_SkinnedDecalsMesh.PreservedVertexColorArrays.Add(array);
				}
				mesh.colors = array;
			}
			Vector2[] array2 = a_SkinnedDecalsMesh.UVs.ToArray();
			if (a_SkinnedDecalsMesh.PreserveProjectedUVArrays)
			{
				a_SkinnedDecalsMesh.PreservedProjectedUVArrays.Add(array2);
			}
			mesh.uv = array2;
			if (base.CurrentUV2Mode != UV2Mode.None)
			{
				Vector2[] array3 = a_SkinnedDecalsMesh.UV2s.ToArray();
				if (a_SkinnedDecalsMesh.PreserveProjectedUV2Arrays)
				{
					a_SkinnedDecalsMesh.PreservedProjectedUV2Arrays.Add(array3);
				}
				mesh.uv2 = array3;
			}
			mesh.boneWeights = a_SkinnedDecalsMesh.BoneWeights.ToArray();
			mesh.triangles = a_SkinnedDecalsMesh.Triangles.ToArray();
			mesh.bindposes = a_SkinnedDecalsMesh.BindPoses.ToArray();
			a_SkinnedDecalsMeshRenderer.SkinnedMeshRenderer.bones = a_SkinnedDecalsMesh.Bones.ToArray();
			a_SkinnedDecalsMeshRenderer.SkinnedMeshRenderer.localBounds = mesh.bounds;
			a_SkinnedDecalsMeshRenderer.SkinnedMeshRenderer.updateWhenOffscreen = true;
		}

		private void ApplyToSkinnedDecalsMeshRenderer(SkinnedDecalsMeshRenderer a_SkinnedDecalsMeshRenderer, SkinnedDecalsMesh a_SkinnedDecalsMesh, GenericDecalProjectorBase a_FirstProjector, GenericDecalProjectorBase a_LastProjector)
		{
			int decalsMeshLowerVertexIndex = a_FirstProjector.DecalsMeshLowerVertexIndex;
			int decalsMeshUpperVertexIndex = a_LastProjector.DecalsMeshUpperVertexIndex;
			int decalsMeshLowerTriangleIndex = a_FirstProjector.DecalsMeshLowerTriangleIndex;
			int decalsMeshUpperTriangleIndex = a_LastProjector.DecalsMeshUpperTriangleIndex;
			Mesh mesh = MeshOfSkinnedDecalsMeshRenderer(a_SkinnedDecalsMeshRenderer);
			mesh.Clear();
			if (!Edition.IsDX11)
			{
				mesh.MarkDynamic();
			}
			Vector3[] a_Array = new Vector3[decalsMeshUpperVertexIndex - decalsMeshLowerVertexIndex + 1];
			CopyListRangeToArray(ref a_Array, a_SkinnedDecalsMesh.OriginalVertices, decalsMeshLowerVertexIndex, decalsMeshUpperVertexIndex);
			mesh.vertices = a_Array;
			BoneWeight[] a_Array2 = new BoneWeight[decalsMeshUpperVertexIndex - decalsMeshLowerVertexIndex + 1];
			CopyListRangeToArray(ref a_Array2, a_SkinnedDecalsMesh.BoneWeights, decalsMeshLowerVertexIndex, decalsMeshUpperVertexIndex);
			mesh.boneWeights = a_Array2;
			int[] a_Array3 = new int[decalsMeshUpperTriangleIndex - decalsMeshLowerTriangleIndex + 1];
			CopyListRangeToArray(ref a_Array3, a_SkinnedDecalsMesh.Triangles, decalsMeshLowerTriangleIndex, decalsMeshUpperTriangleIndex);
			for (int i = 0; i < a_Array3.Length; i++)
			{
				a_Array3[i] -= decalsMeshLowerVertexIndex;
			}
			mesh.triangles = a_Array3;
			Vector2[] a_Array4 = new Vector2[decalsMeshUpperVertexIndex - decalsMeshLowerVertexIndex + 1];
			CopyListRangeToArray(ref a_Array4, a_SkinnedDecalsMesh.UVs, decalsMeshLowerVertexIndex, decalsMeshUpperVertexIndex);
			if (a_SkinnedDecalsMesh.PreserveProjectedUVArrays)
			{
				a_SkinnedDecalsMesh.PreservedProjectedUVArrays.Add(a_Array4);
			}
			mesh.uv = a_Array4;
			if (base.CurrentUV2Mode != UV2Mode.None && base.CurrentUV2Mode != UV2Mode.Lightmapping)
			{
				Vector2[] a_Array5 = new Vector2[decalsMeshUpperVertexIndex - decalsMeshLowerVertexIndex + 1];
				CopyListRangeToArray(ref a_Array5, a_SkinnedDecalsMesh.UV2s, decalsMeshLowerVertexIndex, decalsMeshUpperVertexIndex);
				if (a_SkinnedDecalsMesh.PreserveProjectedUV2Arrays)
				{
					a_SkinnedDecalsMesh.PreservedProjectedUV2Arrays.Add(a_Array5);
				}
				mesh.uv2 = a_Array5;
			}
			else
			{
				mesh.uv2 = null;
			}
			if (base.CurrentNormalsMode != NormalsMode.None)
			{
				Vector3[] a_Array6 = new Vector3[decalsMeshUpperVertexIndex - decalsMeshLowerVertexIndex + 1];
				CopyListRangeToArray(ref a_Array6, a_SkinnedDecalsMesh.Normals, decalsMeshLowerVertexIndex, decalsMeshUpperVertexIndex);
				mesh.normals = a_Array6;
			}
			else
			{
				mesh.normals = null;
			}
			if (base.CurrentTangentsMode != TangentsMode.None)
			{
				Vector4[] a_Array7 = new Vector4[decalsMeshUpperVertexIndex - decalsMeshLowerVertexIndex + 1];
				CopyListRangeToArray(ref a_Array7, a_SkinnedDecalsMesh.Tangents, decalsMeshLowerVertexIndex, decalsMeshUpperVertexIndex);
				mesh.tangents = a_Array7;
			}
			else
			{
				mesh.tangents = null;
			}
			if (base.UseVertexColors)
			{
				Color[] a_Array8 = new Color[decalsMeshUpperVertexIndex - decalsMeshLowerVertexIndex + 1];
				CopyListRangeToArray(ref a_Array8, a_SkinnedDecalsMesh.VertexColors, decalsMeshLowerVertexIndex, decalsMeshUpperVertexIndex);
				if (a_SkinnedDecalsMesh.PreserveVertexColorArrays)
				{
					a_SkinnedDecalsMesh.PreservedVertexColorArrays.Add(a_Array8);
				}
				mesh.colors = a_Array8;
			}
			else
			{
				mesh.colors = null;
			}
			Matrix4x4[] bindposes = a_SkinnedDecalsMesh.BindPoses.ToArray();
			mesh.bindposes = bindposes;
			Transform[] bones = a_SkinnedDecalsMesh.Bones.ToArray();
			a_SkinnedDecalsMeshRenderer.SkinnedMeshRenderer.bones = bones;
			a_SkinnedDecalsMeshRenderer.SkinnedMeshRenderer.localBounds = mesh.bounds;
			a_SkinnedDecalsMeshRenderer.SkinnedMeshRenderer.updateWhenOffscreen = true;
		}

		private static void CopyListRangeToArray<T>(ref T[] a_Array, List<T> a_List, int a_LowerListIndex, int a_UpperListIndex)
		{
			int num = 0;
			for (int i = a_LowerListIndex; i <= a_UpperListIndex; i++)
			{
				a_Array[num] = a_List[i];
				num++;
			}
		}

		private Mesh MeshOfSkinnedDecalsMeshRenderer(SkinnedDecalsMeshRenderer a_SkinnedDecalsMeshRenderer)
		{
			Mesh mesh;
			if (a_SkinnedDecalsMeshRenderer.SkinnedMeshRenderer.sharedMesh == null)
			{
				mesh = new Mesh();
				mesh.name = "Skinned Decal Mesh";
				a_SkinnedDecalsMeshRenderer.SkinnedMeshRenderer.sharedMesh = mesh;
			}
			else
			{
				mesh = a_SkinnedDecalsMeshRenderer.SkinnedMeshRenderer.sharedMesh;
				mesh.Clear();
			}
			return mesh;
		}

		public override void OptimizeDecalsMeshes()
		{
			base.OptimizeDecalsMeshes();
			foreach (SkinnedDecalsMeshRenderer skinnedDecalsMeshRenderer in m_SkinnedDecalsMeshRenderers)
			{
				if (skinnedDecalsMeshRenderer.SkinnedMeshRenderer != null && !(skinnedDecalsMeshRenderer.SkinnedMeshRenderer.sharedMesh != null))
				{
				}
			}
		}

		protected abstract SkinnedDecalsMeshRenderer AddSkinnedDecalsMeshRendererComponentToGameObject(GameObject a_GameObject);
	}
}
