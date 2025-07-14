using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using YamlDotNet.Core;
using YamlDotNet.Core.Events;

namespace YamlDotNet.RepresentationModel
{
	[Serializable]
	public class YamlMappingNode : YamlNode, IEnumerable<KeyValuePair<YamlNode, YamlNode>>, IEnumerable
	{
		private readonly IDictionary<YamlNode, YamlNode> children = new Dictionary<YamlNode, YamlNode>();

		public IDictionary<YamlNode, YamlNode> Children
		{
			get
			{
				return children;
			}
		}

		public MappingStyle Style { get; set; }

		public override IEnumerable<YamlNode> AllNodes
		{
			get
			{
				yield return this;
				foreach (KeyValuePair<YamlNode, YamlNode> child in children)
				{
					foreach (YamlNode allNode in child.Key.AllNodes)
					{
						yield return allNode;
					}
					foreach (YamlNode allNode2 in child.Value.AllNodes)
					{
						yield return allNode2;
					}
				}
			}
		}

		public override YamlNodeType NodeType
		{
			get
			{
				return YamlNodeType.Mapping;
			}
		}

		internal YamlMappingNode(EventReader events, DocumentLoadingState state)
		{
			MappingStart yamlEvent = events.Expect<MappingStart>();
			Load(yamlEvent, state);
			bool flag = false;
			while (!events.Accept<MappingEnd>())
			{
				YamlNode yamlNode = YamlNode.ParseNode(events, state);
				YamlNode yamlNode2 = YamlNode.ParseNode(events, state);
				try
				{
					children.Add(yamlNode, yamlNode2);
				}
				catch (ArgumentException innerException)
				{
					throw new YamlException(yamlNode.Start, yamlNode.End, "Duplicate key", innerException);
				}
				flag = flag || yamlNode is YamlAliasNode || yamlNode2 is YamlAliasNode;
			}
			if (flag)
			{
				state.AddNodeWithUnresolvedAliases(this);
			}
			events.Expect<MappingEnd>();
		}

		public YamlMappingNode()
		{
		}

		public YamlMappingNode(params KeyValuePair<YamlNode, YamlNode>[] children)
			: this((IEnumerable<KeyValuePair<YamlNode, YamlNode>>)children)
		{
		}

		public YamlMappingNode(IEnumerable<KeyValuePair<YamlNode, YamlNode>> children)
		{
			foreach (KeyValuePair<YamlNode, YamlNode> child in children)
			{
				this.children.Add(child);
			}
		}

		public YamlMappingNode(params YamlNode[] children)
			: this((IEnumerable<YamlNode>)children)
		{
		}

		public YamlMappingNode(IEnumerable<YamlNode> children)
		{
			using (IEnumerator<YamlNode> enumerator = children.GetEnumerator())
			{
				while (enumerator.MoveNext())
				{
					YamlNode current = enumerator.Current;
					if (!enumerator.MoveNext())
					{
						throw new ArgumentException("When constructing a mapping node with a sequence, the number of elements of the sequence must be even.");
					}
					Add(current, enumerator.Current);
				}
			}
		}

		public void Add(YamlNode key, YamlNode value)
		{
			children.Add(key, value);
		}

		public void Add(string key, YamlNode value)
		{
			children.Add(new YamlScalarNode(key), value);
		}

		public void Add(YamlNode key, string value)
		{
			children.Add(key, new YamlScalarNode(value));
		}

		public void Add(string key, string value)
		{
			children.Add(new YamlScalarNode(key), new YamlScalarNode(value));
		}

		internal override void ResolveAliases(DocumentLoadingState state)
		{
			Dictionary<YamlNode, YamlNode> dictionary = null;
			Dictionary<YamlNode, YamlNode> dictionary2 = null;
			foreach (KeyValuePair<YamlNode, YamlNode> child in children)
			{
				if (child.Key is YamlAliasNode)
				{
					if (dictionary == null)
					{
						dictionary = new Dictionary<YamlNode, YamlNode>();
					}
					dictionary.Add(child.Key, state.GetNode(child.Key.Anchor, true, child.Key.Start, child.Key.End));
				}
				if (child.Value is YamlAliasNode)
				{
					if (dictionary2 == null)
					{
						dictionary2 = new Dictionary<YamlNode, YamlNode>();
					}
					dictionary2.Add(child.Key, state.GetNode(child.Value.Anchor, true, child.Value.Start, child.Value.End));
				}
			}
			if (dictionary2 != null)
			{
				foreach (KeyValuePair<YamlNode, YamlNode> item in dictionary2)
				{
					children[item.Key] = item.Value;
				}
			}
			if (dictionary == null)
			{
				return;
			}
			foreach (KeyValuePair<YamlNode, YamlNode> item2 in dictionary)
			{
				YamlNode value = children[item2.Key];
				children.Remove(item2.Key);
				children.Add(item2.Value, value);
			}
		}

		internal override void Emit(IEmitter emitter, EmitterState state)
		{
			emitter.Emit(new MappingStart(base.Anchor, base.Tag, true, Style));
			foreach (KeyValuePair<YamlNode, YamlNode> child in children)
			{
				child.Key.Save(emitter, state);
				child.Value.Save(emitter, state);
			}
			emitter.Emit(new MappingEnd());
		}

		public override void Accept(IYamlVisitor visitor)
		{
			visitor.Visit(this);
		}

		public override bool Equals(object other)
		{
			YamlMappingNode yamlMappingNode = other as YamlMappingNode;
			if (yamlMappingNode == null || !Equals(yamlMappingNode) || children.Count != yamlMappingNode.children.Count)
			{
				return false;
			}
			foreach (KeyValuePair<YamlNode, YamlNode> child in children)
			{
				YamlNode value;
				if (!yamlMappingNode.children.TryGetValue(child.Key, out value) || !YamlNode.SafeEquals(child.Value, value))
				{
					return false;
				}
			}
			return true;
		}

		public override int GetHashCode()
		{
			int num = base.GetHashCode();
			foreach (KeyValuePair<YamlNode, YamlNode> child in children)
			{
				num = YamlNode.CombineHashCodes(num, YamlNode.GetHashCode(child.Key));
				num = YamlNode.CombineHashCodes(num, YamlNode.GetHashCode(child.Value));
			}
			return num;
		}

		public override string ToString()
		{
			StringBuilder stringBuilder = new StringBuilder("{ ");
			foreach (KeyValuePair<YamlNode, YamlNode> child in children)
			{
				if (stringBuilder.Length > 2)
				{
					stringBuilder.Append(", ");
				}
				stringBuilder.Append("{ ").Append(child.Key).Append(", ")
					.Append(child.Value)
					.Append(" }");
			}
			stringBuilder.Append(" }");
			return stringBuilder.ToString();
		}

		public IEnumerator<KeyValuePair<YamlNode, YamlNode>> GetEnumerator()
		{
			return children.GetEnumerator();
		}

		IEnumerator IEnumerable.GetEnumerator()
		{
			return GetEnumerator();
		}
	}
}
