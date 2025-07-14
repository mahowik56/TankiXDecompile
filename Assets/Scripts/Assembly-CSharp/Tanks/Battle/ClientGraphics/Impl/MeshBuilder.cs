using System.Collections.Generic;
using Tanks.Battle.ClientGraphics.API;
using UnityEngine;

namespace Tanks.Battle.ClientGraphics.Impl
{
	public class MeshBuilder
	{
		private const int INITIAL_BUFFER_SIZE = 100;

		private Dictionary<long, int> hashToIndex = new Dictionary<long, int>();

		private List<int> triangles = new List<int>(300);

		private List<Vector3> vertices = new List<Vector3>(100);

		private List<Vector3> normals = new List<Vector3>(100);

		private List<Vector2> uvs = new List<Vector2>(100);

		private List<Vector2> uvs2 = new List<Vector2>(100);

		private List<SurfaceType> surfaceTypes = new List<SurfaceType>(100);

		private List<Color> colors = new List<Color>(100);

		private Color color;

		public List<int> Triangles
		{
			get
			{
				return triangles;
			}
		}

		public List<Vector3> Vertices
		{
			get
			{
				return vertices;
			}
		}

		public List<Vector3> Normals
		{
			get
			{
				return normals;
			}
		}

		public List<Vector2> UVs
		{
			get
			{
				return uvs;
			}
		}

		public List<SurfaceType> SurfaceTypes
		{
			get
			{
				return surfaceTypes;
			}
		}

		public List<Vector2> UVs2
		{
			get
			{
				return uvs2;
			}
		}

		public void Clear()
		{
			hashToIndex.Clear();
			triangles.Clear();
			vertices.Clear();
			normals.Clear();
			uvs.Clear();
			uvs2.Clear();
			colors.Clear();
			surfaceTypes.Clear();
		}

		public void ClearWeldHashing()
		{
			hashToIndex.Clear();
		}

		public void AddTriangle(int id0, int id1, int id2)
		{
			triangles.Add(id0);
			triangles.Add(id1);
			triangles.Add(id2);
		}

		public void AddUV(Vector2 uv)
		{
			uvs.Add(uv);
		}

		public int AddVertex(VertexData vertexData)
		{
			int count = vertices.Count;
			vertices.Add(vertexData.vertex);
			normals.Add(vertexData.normal);
			surfaceTypes.Add(vertexData.surfaceType);
			return count;
		}

		public int AddVertexWeld(long weldHash, VertexData vertexData, Vector2 uv, Color color)
		{
			int value;
			if (!hashToIndex.TryGetValue(weldHash, out value))
			{
				value = AddVertex(vertexData);
				hashToIndex.Add(weldHash, value);
				uvs.Add(uv);
				colors.Add(color);
			}
			return value;
		}

		public int AddVertexWeld(long weldHash, VertexData vertexData, Vector2 uv, Vector2 uv2, Color color)
		{
			int value;
			if (!hashToIndex.TryGetValue(weldHash, out value))
			{
				value = AddVertex(vertexData);
				hashToIndex.Add(weldHash, value);
				uvs.Add(uv);
				uvs2.Add(uv2);
				colors.Add(color);
			}
			return value;
		}

		public int AddVertexWeldAndTransform(long weldHash, VertexData vertexData, Transform transform)
		{
			int value;
			if (!hashToIndex.TryGetValue(weldHash, out value))
			{
				value = vertices.Count;
				vertices.Add(transform.TransformPoint(vertexData.vertex));
				normals.Add(transform.TransformDirection(vertexData.normal));
				surfaceTypes.Add(vertexData.surfaceType);
				hashToIndex.Add(weldHash, value);
			}
			return value;
		}

		public bool BuildToMesh(Mesh mesh, bool tangents)
		{
			if (Vertices.Count == 0)
			{
				return false;
			}
			mesh.Clear();
			mesh.vertices = Vertices.ToArray();
			mesh.normals = Normals.ToArray();
			mesh.triangles = Triangles.ToArray();
			mesh.uv = UVs.ToArray();
			if (uvs2.Count > 0)
			{
				mesh.uv2 = uvs2.ToArray();
			}
			mesh.colors = colors.ToArray();
			if (tangents)
			{
				mesh.tangents = CalculateTangents();
			}
			mesh.RecalculateBounds();
			return true;
		}

		public Vector4[] CalculateTangents()
		{
			int count = vertices.Count;
			int num = triangles.Count / 3;
			Vector4[] array = new Vector4[count];
			Vector3[] array2 = new Vector3[count];
			Vector3[] array3 = new Vector3[count];
			int num2 = 0;
			for (int i = 0; i < num; i++)
			{
				int num3 = triangles[num2];
				int num4 = triangles[num2 + 1];
				int num5 = triangles[num2 + 2];
				Vector3 vector = vertices[num3];
				Vector3 vector2 = vertices[num4];
				Vector3 vector3 = vertices[num5];
				Vector2 vector4 = uvs[num3];
				Vector2 vector5 = uvs[num4];
				Vector2 vector6 = uvs[num5];
				float num6 = vector2.x - vector.x;
				float num7 = vector3.x - vector.x;
				float num8 = vector2.y - vector.y;
				float num9 = vector3.y - vector.y;
				float num10 = vector2.z - vector.z;
				float num11 = vector3.z - vector.z;
				float num12 = vector5.x - vector4.x;
				float num13 = vector6.x - vector4.x;
				float num14 = vector5.y - vector4.y;
				float num15 = vector6.y - vector4.y;
				float num16 = num12 * num15 - num13 * num14;
				float num17 = 0f;
				if (num16 != 0f)
				{
					num17 = 1f / num16;
				}
				Vector3 vector7 = new Vector3((num15 * num6 - num14 * num7) * num17, (num15 * num8 - num14 * num9) * num17, (num15 * num10 - num14 * num11) * num17);
				Vector3 vector8 = new Vector3((num12 * num7 - num13 * num6) * num17, (num12 * num9 - num13 * num8) * num17, (num12 * num11 - num13 * num10) * num17);
				array2[num3] += vector7;
				array2[num4] += vector7;
				array2[num5] += vector7;
				array3[num3] += vector8;
				array3[num4] += vector8;
				array3[num5] += vector8;
				num2 += 3;
			}
			for (int j = 0; j < count; j++)
			{
				Vector3 normal = normals[j];
				Vector3 tangent = array2[j];
				Vector3.OrthoNormalize(ref normal, ref tangent);
				array[j].x = tangent.x;
				array[j].y = tangent.y;
				array[j].z = tangent.z;
				array[j].w = ((!(Vector3.Dot(Vector3.Cross(normal, tangent), array3[j]) < 0f)) ? 1f : (-1f));
			}
			return array;
		}
	}
}
