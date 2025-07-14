using System;
using System.Collections.Generic;
using System.IO;
using SharpCompress.Archive.Tar;
using SharpCompress.Common;
using SharpCompress.Common.Tar;
using SharpCompress.Compressor;
using SharpCompress.Compressor.BZip2;
using SharpCompress.Compressor.Deflate;
using SharpCompress.IO;

namespace SharpCompress.Reader.Tar
{
	public class TarReader : AbstractReader<TarEntry, TarVolume>
	{
		private readonly TarVolume volume;

		private readonly CompressionType compressionType;

		public override TarVolume Volume
		{
			get
			{
				return volume;
			}
		}

		internal TarReader(Stream stream, CompressionType compressionType, Options options)
			: base(options, ArchiveType.Tar)
		{
			this.compressionType = compressionType;
			volume = new TarVolume(stream, options);
		}

		internal override Stream RequestInitialStream()
		{
			Stream stream = base.RequestInitialStream();
			switch (compressionType)
			{
			case CompressionType.BZip2:
				return new BZip2Stream(stream, CompressionMode.Decompress);
			case CompressionType.GZip:
				return new GZipStream(stream, CompressionMode.Decompress);
			case CompressionType.None:
				return stream;
			default:
				throw new NotSupportedException("Invalid compression type: " + compressionType);
			}
		}

		public static TarReader Open(Stream stream, Options options = Options.KeepStreamsOpen)
		{
			stream.CheckNotNull("stream");
			RewindableStream rewindableStream = new RewindableStream(stream);
			rewindableStream.StartRecording();
			rewindableStream.Rewind(false);
			if (BZip2Stream.IsBZip2(rewindableStream))
			{
				rewindableStream.Rewind(false);
				BZip2Stream stream2 = new BZip2Stream(rewindableStream, CompressionMode.Decompress);
				if (TarArchive.IsTarFile(stream2))
				{
					rewindableStream.Rewind(true);
					return new TarReader(rewindableStream, CompressionType.BZip2, options);
				}
				throw new InvalidFormatException("Not a tar file.");
			}
			rewindableStream.Rewind(true);
			return new TarReader(rewindableStream, CompressionType.None, options);
		}

		internal override IEnumerable<TarEntry> GetEntries(Stream stream)
		{
			return TarEntry.GetEntries(StreamingMode.Streaming, stream, compressionType);
		}
	}
}
