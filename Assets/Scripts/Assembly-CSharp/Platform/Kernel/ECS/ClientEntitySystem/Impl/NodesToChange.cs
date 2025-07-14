using System.Collections.Generic;
using System.Runtime.InteropServices;

namespace Platform.Kernel.ECS.ClientEntitySystem.Impl
{
	[StructLayout(LayoutKind.Sequential, Size = 1)]
	public struct NodesToChange
	{
		public ICollection<NodeDescription> NodesToAdd { get; set; }

		public ICollection<NodeDescription> NodesToRemove { get; set; }

		public void Init()
		{
			NodesToAdd.Clear();
			NodesToRemove.Clear();
		}

		public NodesToChange Clone(NodesToChange original)
		{
			return new NodesToChange
			{
				NodesToAdd = new List<NodeDescription>(original.NodesToAdd),
				NodesToRemove = new List<NodeDescription>(original.NodesToRemove)
			};
		}
	}
}
