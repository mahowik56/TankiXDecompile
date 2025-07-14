using System;
using System.Collections.Generic;
using System.IO;

namespace SharpCompress.IO
{
	public class ReadOnlyAppendingStream : Stream
	{
		private Queue<Stream> streams;

		private Stream current;

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
				throw new NotImplementedException();
			}
		}

		public override bool CanWrite
		{
			get
			{
				throw new NotImplementedException();
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

		public ReadOnlyAppendingStream(IEnumerable<Stream> streams)
		{
			this.streams = new Queue<Stream>(streams);
		}

		public override void Flush()
		{
			throw new NotImplementedException();
		}

		public override int Read(byte[] buffer, int offset, int count)
		{
			if (current == null && streams.Count == 0)
			{
				return -1;
			}
			if (current == null)
			{
				current = streams.Dequeue();
			}
			int i;
			int num;
			for (i = 0; i < count; i += num)
			{
				num = current.Read(buffer, offset + i, count - i);
				if (num <= 0)
				{
					if (streams.Count == 0)
					{
						return i;
					}
					current = streams.Dequeue();
				}
			}
			return i;
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
