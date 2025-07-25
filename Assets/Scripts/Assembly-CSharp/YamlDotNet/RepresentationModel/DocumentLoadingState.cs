using System;
using System.Collections.Generic;
using System.Globalization;
using YamlDotNet.Core;

namespace YamlDotNet.RepresentationModel
{
	internal class DocumentLoadingState
	{
		private readonly IDictionary<string, YamlNode> anchors = new Dictionary<string, YamlNode>();

		private readonly IList<YamlNode> nodesWithUnresolvedAliases = new List<YamlNode>();

		public void AddAnchor(YamlNode node)
		{
			if (node.Anchor == null)
			{
				throw new ArgumentException("The specified node does not have an anchor");
			}
			if (anchors.ContainsKey(node.Anchor))
			{
				throw new DuplicateAnchorException(node.Start, node.End, string.Format(CultureInfo.InvariantCulture, "The anchor '{0}' already exists", node.Anchor));
			}
			anchors.Add(node.Anchor, node);
		}

		public YamlNode GetNode(string anchor, bool throwException, Mark start, Mark end)
		{
			YamlNode value;
			if (anchors.TryGetValue(anchor, out value))
			{
				return value;
			}
			if (throwException)
			{
				throw new AnchorNotFoundException(start, end, string.Format(CultureInfo.InvariantCulture, "The anchor '{0}' does not exists", anchor));
			}
			return null;
		}

		public void AddNodeWithUnresolvedAliases(YamlNode node)
		{
			nodesWithUnresolvedAliases.Add(node);
		}

		public void ResolveAliases()
		{
			foreach (YamlNode nodesWithUnresolvedAlias in nodesWithUnresolvedAliases)
			{
				nodesWithUnresolvedAlias.ResolveAliases(this);
			}
		}
	}
}
