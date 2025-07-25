using System;
using UnityEngine;

namespace AmplifyBloom
{
	[Serializable]
	public class VersionInfo
	{
		public const byte Major = 1;

		public const byte Minor = 1;

		public const byte Release = 2;

		private static string StageSuffix = "_dev001";

		[SerializeField]
		private int m_major;

		[SerializeField]
		private int m_minor;

		[SerializeField]
		private int m_release;

		public int Number
		{
			get
			{
				return m_major * 100 + m_minor * 10 + m_release;
			}
		}

		private VersionInfo()
		{
			m_major = 1;
			m_minor = 1;
			m_release = 2;
		}

		private VersionInfo(byte major, byte minor, byte release)
		{
			m_major = major;
			m_minor = minor;
			m_release = release;
		}

		public static string StaticToString()
		{
			return string.Format("{0}.{1}.{2}", (byte)1, (byte)1, (byte)2) + StageSuffix;
		}

		public override string ToString()
		{
			return string.Format("{0}.{1}.{2}", m_major, m_minor, m_release) + StageSuffix;
		}

		public static VersionInfo Current()
		{
			return new VersionInfo(1, 1, 2);
		}

		public static bool Matches(VersionInfo version)
		{
			return version.m_major == 1 && version.m_minor == 1 && 2 == version.m_release;
		}
	}
}
