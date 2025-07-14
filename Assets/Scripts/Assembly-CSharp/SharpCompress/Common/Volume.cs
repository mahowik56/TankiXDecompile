using System;
using System.IO;
using SharpCompress.IO;

namespace SharpCompress.Common
{
	public abstract class Volume : IVolume, IDisposable
	{
		private readonly Stream actualStream;

		private bool disposed;

		internal Stream Stream
		{
			get
			{
				return new NonDisposingStream(actualStream);
			}
		}

		internal Options Options { get; private set; }

		public abstract bool IsFirstVolume { get; }

		public abstract bool IsMultiVolume { get; }

		internal Volume(Stream stream, Options options)
		{
			actualStream = stream;
			Options = options;
		}

		public void Dispose()
		{
			if (!((Enum)Options).HasFlag((Enum)Options.KeepStreamsOpen) && !disposed)
			{
				actualStream.Dispose();
				disposed = true;
			}
		}
	}
}
