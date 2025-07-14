using System;
using System.Collections.Generic;
using Platform.Library.ClientDataStructures.API;

namespace Platform.Kernel.ECS.ClientEntitySystem.Impl
{
	public class NodeDescriptionStorage
	{
		private readonly IDictionary<Type, ICollection<NodeDescription>> nodeDescriptionByComponentClass = new Dictionary<Type, ICollection<NodeDescription>>();

		private readonly ICollection<NodeDescription> nodes = new HashSet<NodeDescription>();

		public void AddNode(NodeDescription nodeDescription)
		{
			nodeDescription.Components.ForEach(delegate(Type c)
			{
				nodeDescriptionByComponentClass.ComputeIfAbsent(c, (Type t) => new HashSet<NodeDescription>()).Add(nodeDescription);
			});
			nodes.Add(nodeDescription);
		}

		public void RemoveNode(NodeDescription nodeDescription)
		{
			nodeDescription.Components.ForEach(delegate(Type c)
			{
				nodeDescriptionByComponentClass[c].Remove(nodeDescription);
			});
			nodes.Remove(nodeDescription);
		}

		public ICollection<NodeDescription> GetNodeDescriptions(Type componentClass)
		{
			ICollection<NodeDescription> value;
			if (nodeDescriptionByComponentClass.TryGetValue(componentClass, out value))
			{
				return value;
			}
			return Collections.EmptyList<NodeDescription>();
		}

		public bool Contains(NodeDescription nodeDescription)
		{
			return nodes.Contains(nodeDescription);
		}

		public virtual ICollection<NodeDescription> GetNodeDescriptions()
		{
			return nodes;
		}
	}
}
