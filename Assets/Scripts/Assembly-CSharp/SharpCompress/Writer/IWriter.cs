using System;
using System.IO;
using SharpCompress.Common;

namespace SharpCompress.Writer
{
	public interface IWriter : IDisposable
	{
		ArchiveType WriterType { get; }

		void Write(string filename, Stream source, DateTime? modificationTime);
	}
}
