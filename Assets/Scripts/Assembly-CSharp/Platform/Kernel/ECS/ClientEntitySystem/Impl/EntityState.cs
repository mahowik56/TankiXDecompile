using System;
using System.Collections.Generic;
using System.Reflection;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientDataStructures.API;

namespace Platform.Kernel.ECS.ClientEntitySystem.Impl
{
	public class EntityState
	{
		private readonly IDictionary<Type, FieldInfo> fields;

		private readonly NodeDescription nodeDescription;

		public Node Node { get; private set; }

		public Entity Entity
		{
			set
			{
				Node.Entity = value;
			}
		}

		public ICollection<Type> Components
		{
			get
			{
				return nodeDescription.BaseComponents;
			}
		}

		public EntityState(Type nodeClass, NodeDescription nodeDescription)
		{
			this.nodeDescription = nodeDescription;
			fields = new Dictionary<Type, FieldInfo>();
			CreateNode(nodeClass);
			ParseFields();
		}

		private void CreateNode(Type nodeClass)
		{
			Node = (Node)nodeClass.GetConstructors()[0].Invoke(Collections.EmptyArray);
		}

		private void ParseFields()
		{
			Type type = Node.GetType();
			FieldInfo[] array = type.GetFields(BindingFlags.DeclaredOnly | BindingFlags.Instance | BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic);
			FieldInfo[] array2 = array;
			foreach (FieldInfo fieldInfo in array2)
			{
				if (typeof(Component).IsAssignableFrom(fieldInfo.FieldType))
				{
					fields[fieldInfo.FieldType] = fieldInfo;
				}
			}
		}

		public void AssignValue(Type componentClass, Component value)
		{
			FieldInfo fieldInfo = fields[componentClass];
			fieldInfo.SetValue(Node, value);
		}
	}
}
