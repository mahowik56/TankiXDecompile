using System;
using System.IO;

namespace SharpCompress.Common
{
	public class EntryStream : Stream
	{
		private Stream stream;

		private bool completed;

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

		internal EntryStream(Stream stream)
		{
			this.stream = stream;
		}

		public void SkipEntry()
		{
			byte[] array = new byte[4096];
			while (Read(array, 0, array.Length) > 0)
			{
			}
			completed = true;
		}

		protected override void Dispose(bool disposing)
		{
			if (!completed)
			{
				throw new InvalidOperationException("EntryStream has not been fully consumed.  Read the entire stream or use SkipEntry.");
			}
			base.Dispose(disposing);
			stream.Dispose();
		}

		public override void Flush()
		{
			throw new NotImplementedException();
		}

		public override int Read(byte[] buffer, int offset, int count)
		{
			int num = stream.Read(buffer, offset, count);
			if (num <= 0)
			{
				completed = true;
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
