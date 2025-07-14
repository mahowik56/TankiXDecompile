using System.Runtime.InteropServices;
using Platform.Library.ClientProtocol.API;

namespace Tanks.Battle.ClientCore.Impl
{
	[StructLayout(LayoutKind.Sequential, Size = 1)]
	public struct MoveCommand
	{
		[ProtocolOptional]
		public Movement? Movement { get; set; }

		[ProtocolOptional]
		public float? WeaponRotation { get; set; }

		[ProtocolOptional]
		public float TankControlVertical { get; set; }

		[ProtocolOptional]
		public float TankControlHorizontal { get; set; }

		[ProtocolOptional]
		public float WeaponRotationControl { get; set; }

		public int ClientTime { get; set; }

		public override string ToString()
		{
			return string.Format("MoveCommand[Movement={0}, WeaponRotation={1}]", Movement, WeaponRotation);
		}

		public bool IsDiscrete()
		{
			return IsFloatDiscrete(TankControlVertical) && IsFloatDiscrete(TankControlHorizontal) && IsFloatDiscrete(WeaponRotationControl);
		}

		private bool IsFloatDiscrete(float val)
		{
			return val == 0f || val == 1f || val == -1f;
		}
	}
}
