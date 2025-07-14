using System;
using System.Collections.Generic;
using System.Text;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Platform.Library.ClientDataStructures.API;

namespace Platform.Kernel.ECS.ClientEntitySystem.Impl
{
	public class HandlerArgumentLogPart : LogPart
	{
		private readonly ICollection<Entity> entities;

		private readonly HandlerArgument handlerArgument;

		private readonly IDictionary<Entity, ICollection<Type>> missingComponentsByEntity = new Dictionary<Entity, ICollection<Type>>();

		private string MessageForNoEntities
		{
			get
			{
				return "\tNo entity for node=" + NodeClassName;
			}
		}

		private string MessageForMissingNode
		{
			get
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(string.Format("\tMissing node={0}\n\t", NodeClassName));
				foreach (Entity key in missingComponentsByEntity.Keys)
				{
					ICollection<Type> collection = missingComponentsByEntity[key];
					string value = string.Format("\tEntity={0}; Missing components={1}, parameter=[{2}]", EcsToStringUtil.ToString(key), EcsToStringUtil.ToString(collection), handlerArgument.NodeNumber + 1);
					stringBuilder.Append(value);
					stringBuilder.Append("\n\t");
				}
				return stringBuilder.ToString();
			}
		}

		private string NodeClassName
		{
			get
			{
				return handlerArgument.ClassInstanceDescription.NodeClass.Name;
			}
		}

		public HandlerArgumentLogPart(HandlerArgument handlerArgument, ICollection<Entity> entities)
		{
			this.handlerArgument = handlerArgument;
			this.entities = entities;
			if (!handlerArgument.Collection)
			{
				FindMostSuitableEntities(handlerArgument, entities);
			}
		}

		private void FindMostSuitableEntities(HandlerArgument handlerArgument, ICollection<Entity> entities)
		{
			int num = int.MaxValue;
			foreach (Entity entity in entities)
			{
				ICollection<Type> missingComponents = GetMissingComponents(entity, handlerArgument.NodeDescription);
				if (missingComponents.Count != 0 && missingComponents.Count < num)
				{
					num = missingComponents.Count;
				}
				else if (missingComponents.Count == 0)
				{
					num = 0;
					break;
				}
			}
			if (num <= 0)
			{
				return;
			}
			foreach (Entity entity2 in entities)
			{
				ICollection<Type> missingComponents2 = GetMissingComponents(entity2, handlerArgument.NodeDescription);
				if (missingComponents2.Count == num)
				{
					missingComponentsByEntity.Add(entity2, missingComponents2);
				}
			}
		}

		public virtual Optional<string> GetSkipReason()
		{
			if (entities.Count == 0)
			{
				return Optional<string>.of(MessageForNoEntities);
			}
			if (missingComponentsByEntity.Count == 0)
			{
				return Optional<string>.empty();
			}
			return Optional<string>.of(MessageForMissingNode);
		}

		private static ICollection<Type> GetMissingComponents(Entity entity, NodeDescription nodeDescription)
		{
			List<Type> list = new List<Type>();
			foreach (Type component in nodeDescription.Components)
			{
				if (!entity.HasComponent(component))
				{
					list.Add(component);
				}
			}
			return list;
		}
	}
}
