using System;
using System.Collections.Generic;
using System.Globalization;
using YamlDotNet.Core;
using YamlDotNet.Core.Events;

namespace YamlDotNet.RepresentationModel
{
	[Serializable]
	public class YamlDocument
	{
		private class AnchorAssigningVisitor : YamlVisitor
		{
			private readonly HashSet<string> existingAnchors = new HashSet<string>();

			private readonly Dictionary<YamlNode, bool> visitedNodes = new Dictionary<YamlNode, bool>();

			public void AssignAnchors(YamlDocument document)
			{
				existingAnchors.Clear();
				visitedNodes.Clear();
				document.Accept(this);
				Random random = new Random();
				foreach (KeyValuePair<YamlNode, bool> visitedNode in visitedNodes)
				{
					if (visitedNode.Value)
					{
						string text;
						do
						{
							text = random.Next().ToString(CultureInfo.InvariantCulture);
						}
						while (existingAnchors.Contains(text));
						existingAnchors.Add(text);
						visitedNode.Key.Anchor = text;
					}
				}
			}

			private void VisitNode(YamlNode node)
			{
				if (string.IsNullOrEmpty(node.Anchor))
				{
					bool value;
					if (visitedNodes.TryGetValue(node, out value))
					{
						if (!value)
						{
							visitedNodes[node] = true;
						}
					}
					else
					{
						visitedNodes.Add(node, false);
					}
				}
				else
				{
					existingAnchors.Add(node.Anchor);
				}
			}

			protected override void Visit(YamlScalarNode scalar)
			{
				VisitNode(scalar);
			}

			protected override void Visit(YamlMappingNode mapping)
			{
				VisitNode(mapping);
			}

			protected override void Visit(YamlSequenceNode sequence)
			{
				VisitNode(sequence);
			}
		}

		public YamlNode RootNode { get; private set; }

		public IEnumerable<YamlNode> AllNodes
		{
			get
			{
				return RootNode.AllNodes;
			}
		}

		public YamlDocument(YamlNode rootNode)
		{
			RootNode = rootNode;
		}

		public YamlDocument(string rootNode)
		{
			RootNode = new YamlScalarNode(rootNode);
		}

		internal YamlDocument(EventReader events)
		{
			DocumentLoadingState documentLoadingState = new DocumentLoadingState();
			events.Expect<DocumentStart>();
			while (!events.Accept<DocumentEnd>())
			{
				RootNode = YamlNode.ParseNode(events, documentLoadingState);
				if (RootNode is YamlAliasNode)
				{
					throw new YamlException();
				}
			}
			documentLoadingState.ResolveAliases();
			events.Expect<DocumentEnd>();
		}

		private void AssignAnchors()
		{
			AnchorAssigningVisitor anchorAssigningVisitor = new AnchorAssigningVisitor();
			anchorAssigningVisitor.AssignAnchors(this);
		}

		internal void Save(IEmitter emitter, bool assignAnchors = true)
		{
			if (assignAnchors)
			{
				AssignAnchors();
			}
			emitter.Emit(new DocumentStart());
			RootNode.Save(emitter, new EmitterState());
			emitter.Emit(new DocumentEnd(false));
		}

		public void Accept(IYamlVisitor visitor)
		{
			visitor.Visit(this);
		}
	}
}
