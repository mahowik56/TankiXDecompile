using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using YamlDotNet.Core;
using YamlDotNet.Core.Events;

namespace YamlDotNet.RepresentationModel
{
	[Serializable]
	public class YamlStream : IEnumerable<YamlDocument>, IEnumerable
	{
		private readonly IList<YamlDocument> documents = new List<YamlDocument>();

		public IList<YamlDocument> Documents
		{
			get
			{
				return documents;
			}
		}

		public YamlStream()
		{
		}

		public YamlStream(params YamlDocument[] documents)
			: this((IEnumerable<YamlDocument>)documents)
		{
		}

		public YamlStream(IEnumerable<YamlDocument> documents)
		{
			foreach (YamlDocument document in documents)
			{
				this.documents.Add(document);
			}
		}

		public void Add(YamlDocument document)
		{
			documents.Add(document);
		}

		public void Load(TextReader input)
		{
			Load(new EventReader(new Parser(input)));
		}

		public void Load(EventReader reader)
		{
			documents.Clear();
			reader.Expect<StreamStart>();
			while (!reader.Accept<StreamEnd>())
			{
				YamlDocument item = new YamlDocument(reader);
				documents.Add(item);
			}
			reader.Expect<StreamEnd>();
		}

		public void Save(TextWriter output)
		{
			Save(output, true);
		}

		public void Save(TextWriter output, bool assignAnchors)
		{
			IEmitter emitter = new Emitter(output);
			emitter.Emit(new StreamStart());
			foreach (YamlDocument document in documents)
			{
				document.Save(emitter, assignAnchors);
			}
			emitter.Emit(new StreamEnd());
		}

		public void Accept(IYamlVisitor visitor)
		{
			visitor.Visit(this);
		}

		public IEnumerator<YamlDocument> GetEnumerator()
		{
			return documents.GetEnumerator();
		}

		IEnumerator IEnumerable.GetEnumerator()
		{
			return GetEnumerator();
		}
	}
}
