using System;
using UnityEngine;

[Serializable]
public struct P3D_GroupMask
{
	[SerializeField]
	private int mask;

	public P3D_GroupMask(int newMask)
	{
		mask = newMask;
	}

	public static implicit operator int(P3D_GroupMask groupMask)
	{
		return groupMask.mask;
	}

	public static implicit operator P3D_GroupMask(int mask)
	{
		return new P3D_GroupMask(mask);
	}
}
