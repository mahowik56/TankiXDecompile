using System.IO;

namespace SharpCompress.IO
{
	internal class NonDisposingStream : Stream
	{
		public Stream Stream { get; private set; }

		public override bool CanRead
		{
			get
			{
				return Stream.CanRead;
			}
		}

		public override bool CanSeek
		{
			get
			{
				return Stream.CanSeek;
			}
		}

		public override bool CanWrite
		{
			get
			{
				return Stream.CanWrite;
			}
		}

		public override long Length
		{
			get
			{
				return Stream.Length;
			}
		}

		public override long Position
		{
			get
			{
				return Stream.Position;
			}
			set
			{
				Stream.Position = value;
			}
		}

		public NonDisposingStream(Stream stream)
		{
			Stream = stream;
		}

		protected override void Dispose(bool disposing)
		{
			if (!disposing)
			{
			}
		}

		public override void Flush()
		{
			Stream.Flush();
		}

		public override int Read(byte[] buffer, int offset, int count)
		{
			return Stream.Read(buffer, offset, count);
		}

		public override long Seek(long offset, SeekOrigin origin)
		{
			return Stream.Seek(offset, origin);
		}

		public override void SetLength(long value)
		{
			Stream.SetLength(value);
		}

		public override void Write(byte[] buffer, int offset, int count)
		{
			Stream.Write(buffer, offset, count);
		}
	}
}
