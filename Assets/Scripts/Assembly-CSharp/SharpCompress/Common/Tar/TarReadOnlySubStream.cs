using System;
using System.IO;

namespace SharpCompress.Common.Tar
{
	internal class TarReadOnlySubStream : Stream
	{
		private int amountRead;

		private long BytesLeftToRead { get; set; }

		public Stream Stream { get; private set; }

		public override bool CanRead
		{
			get
			{
				return true;
			}
		}

		public override bool CanSeek
		{
			get
			{
				return false;
			}
		}

		public override bool CanWrite
		{
			get
			{
				return false;
			}
		}

		public override long Length
		{
			get
			{
				throw new NotImplementedException();
			}
		}

		public override long Position
		{
			get
			{
				throw new NotImplementedException();
			}
			set
			{
				throw new NotImplementedException();
			}
		}

		public TarReadOnlySubStream(Stream stream, long bytesToRead)
		{
			Stream = stream;
			BytesLeftToRead = bytesToRead;
		}

		protected override void Dispose(bool disposing)
		{
			if (!disposing)
			{
				return;
			}
			int num = amountRead % 512;
			if (num != 0)
			{
				num = 512 - num;
				if (num != 0)
				{
					byte[] buffer = new byte[num];
					Stream.ReadFully(buffer);
				}
			}
		}

		public override void Flush()
		{
			throw new NotImplementedException();
		}

		public override int Read(byte[] buffer, int offset, int count)
		{
			if (BytesLeftToRead < count)
			{
				count = (int)BytesLeftToRead;
			}
			int num = Stream.Read(buffer, offset, count);
			if (num > 0)
			{
				BytesLeftToRead -= num;
				amountRead += num;
			}
			return num;
		}

		public override long Seek(long offset, SeekOrigin origin)
		{
			throw new NotImplementedException();
		}

		public override void SetLength(long value)
		{
			throw new NotImplementedException();
		}

		public override void Write(byte[] buffer, int offset, int count)
		{
			throw new NotImplementedException();
		}
	}
}
