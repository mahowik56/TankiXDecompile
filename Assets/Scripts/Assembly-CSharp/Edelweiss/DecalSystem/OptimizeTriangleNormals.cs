using System.Collections.Generic;
using UnityEngine;

namespace Edelweiss.DecalSystem
{
	internal class OptimizeTriangleNormals
	{
		private SortedDictionary<int, Vector3> m_TriangleIndexToNormalDictionary = new SortedDictionary<int, Vector3>();

		public int Count
		{
			get
			{
				return m_TriangleIndexToNormalDictionary.Count;
			}
		}

		public Vector3 this[int a_TriangleIndex]
		{
			get
			{
				return m_TriangleIndexToNormalDictionary[a_TriangleIndex];
			}
		}

		public void Clear()
		{
			m_TriangleIndexToNormalDictionary.Clear();
		}

		public bool HasTriangleNormal(int a_TriangleIndex)
		{
			return m_TriangleIndexToNormalDictionary.ContainsKey(a_TriangleIndex);
		}

		public void AddTriangleNormal(int a_TriangleIndex, Vector3 a_TriangleNormal)
		{
			m_TriangleIndexToNormalDictionary.Add(a_TriangleIndex, a_TriangleNormal);
		}

		public void RemoveTriangleNormal(int a_TriangleIndex)
		{
			m_TriangleIndexToNormalDictionary.Remove(a_TriangleIndex);
		}
	}
}
