using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;
using YamlDotNet.Core;
using YamlDotNet.Core.Events;

namespace YamlDotNet.RepresentationModel
{
	[Serializable]
	[DebuggerDisplay("Count = {children.Count}")]
	public class YamlSequenceNode : YamlNode, IEnumerable<YamlNode>, IEnumerable
	{
		private readonly IList<YamlNode> children = new List<YamlNode>();

		public IList<YamlNode> Children
		{
			get
			{
				return children;
			}
		}

		public SequenceStyle Style { get; set; }

		public override IEnumerable<YamlNode> AllNodes
		{
			get
			{
				yield return this;
				foreach (YamlNode child in children)
				{
					foreach (YamlNode allNode in child.AllNodes)
					{
						yield return allNode;
					}
				}
			}
		}

		public override YamlNodeType NodeType
		{
			get
			{
				return YamlNodeType.Sequence;
			}
		}

		internal YamlSequenceNode(EventReader events, DocumentLoadingState state)
		{
			SequenceStart yamlEvent = events.Expect<SequenceStart>();
			Load(yamlEvent, state);
			bool flag = false;
			while (!events.Accept<SequenceEnd>())
			{
				YamlNode yamlNode = YamlNode.ParseNode(events, state);
				children.Add(yamlNode);
				flag = flag || yamlNode is YamlAliasNode;
			}
			if (flag)
			{
				state.AddNodeWithUnresolvedAliases(this);
			}
			events.Expect<SequenceEnd>();
		}

		public YamlSequenceNode()
		{
		}

		public YamlSequenceNode(params YamlNode[] children)
			: this((IEnumerable<YamlNode>)children)
		{
		}

		public YamlSequenceNode(IEnumerable<YamlNode> children)
		{
			foreach (YamlNode child in children)
			{
				this.children.Add(child);
			}
		}

		public void Add(YamlNode child)
		{
			children.Add(child);
		}

		public void Add(string child)
		{
			children.Add(new YamlScalarNode(child));
		}

		internal override void ResolveAliases(DocumentLoadingState state)
		{
			for (int i = 0; i < children.Count; i++)
			{
				if (children[i] is YamlAliasNode)
				{
					children[i] = state.GetNode(children[i].Anchor, true, children[i].Start, children[i].End);
				}
			}
		}

		internal override void Emit(IEmitter emitter, EmitterState state)
		{
			emitter.Emit(new SequenceStart(base.Anchor, base.Tag, true, Style));
			foreach (YamlNode child in children)
			{
				child.Save(emitter, state);
			}
			emitter.Emit(new SequenceEnd());
		}

		public override void Accept(IYamlVisitor visitor)
		{
			visitor.Visit(this);
		}

		public override bool Equals(object other)
		{
			YamlSequenceNode yamlSequenceNode = other as YamlSequenceNode;
			if (yamlSequenceNode == null || !Equals(yamlSequenceNode) || children.Count != yamlSequenceNode.children.Count)
			{
				return false;
			}
			for (int i = 0; i < children.Count; i++)
			{
				if (!YamlNode.SafeEquals(children[i], yamlSequenceNode.children[i]))
				{
					return false;
				}
			}
			return true;
		}

		public override int GetHashCode()
		{
			int num = base.GetHashCode();
			foreach (YamlNode child in children)
			{
				num = YamlNode.CombineHashCodes(num, YamlNode.GetHashCode(child));
			}
			return num;
		}

		public override string ToString()
		{
			StringBuilder stringBuilder = new StringBuilder("[ ");
			foreach (YamlNode child in children)
			{
				if (stringBuilder.Length > 2)
				{
					stringBuilder.Append(", ");
				}
				stringBuilder.Append(child);
			}
			stringBuilder.Append(" ]");
			return stringBuilder.ToString();
		}

		public IEnumerator<YamlNode> GetEnumerator()
		{
			return Children.GetEnumerator();
		}

		IEnumerator IEnumerable.GetEnumerator()
		{
			return GetEnumerator();
		}
	}
}
