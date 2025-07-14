using System.Collections.Generic;

namespace YamlDotNet.RepresentationModel
{
	public abstract class YamlVisitorBase : IYamlVisitor
	{
		protected virtual void Visit(YamlStream stream)
		{
			VisitChildren(stream);
		}

		protected virtual void Visited(YamlStream stream)
		{
		}

		protected virtual void Visit(YamlDocument document)
		{
			VisitChildren(document);
		}

		protected virtual void Visited(YamlDocument document)
		{
		}

		protected virtual void Visit(YamlScalarNode scalar)
		{
		}

		protected virtual void Visited(YamlScalarNode scalar)
		{
		}

		protected virtual void Visit(YamlSequenceNode sequence)
		{
			VisitChildren(sequence);
		}

		protected virtual void Visited(YamlSequenceNode sequence)
		{
		}

		protected virtual void Visit(YamlMappingNode mapping)
		{
			VisitChildren(mapping);
		}

		protected virtual void Visited(YamlMappingNode mapping)
		{
		}

		protected virtual void VisitPair(YamlNode key, YamlNode value)
		{
			key.Accept(this);
			value.Accept(this);
		}

		protected virtual void VisitChildren(YamlStream stream)
		{
			foreach (YamlDocument document in stream.Documents)
			{
				document.Accept(this);
			}
		}

		protected virtual void VisitChildren(YamlDocument document)
		{
			if (document.RootNode != null)
			{
				document.RootNode.Accept(this);
			}
		}

		protected virtual void VisitChildren(YamlSequenceNode sequence)
		{
			foreach (YamlNode child in sequence.Children)
			{
				child.Accept(this);
			}
		}

		protected virtual void VisitChildren(YamlMappingNode mapping)
		{
			foreach (KeyValuePair<YamlNode, YamlNode> child in mapping.Children)
			{
				VisitPair(child.Key, child.Value);
			}
		}

		void IYamlVisitor.Visit(YamlStream stream)
		{
			Visit(stream);
			Visited(stream);
		}

		void IYamlVisitor.Visit(YamlDocument document)
		{
			Visit(document);
			Visited(document);
		}

		void IYamlVisitor.Visit(YamlScalarNode scalar)
		{
			Visit(scalar);
			Visited(scalar);
		}

		void IYamlVisitor.Visit(YamlSequenceNode sequence)
		{
			Visit(sequence);
			Visited(sequence);
		}

		void IYamlVisitor.Visit(YamlMappingNode mapping)
		{
			Visit(mapping);
			Visited(mapping);
		}
	}
}
