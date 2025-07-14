using System;
using System.IO;

namespace SharpCompress.Compressor.Filters
{
	public class BCJ2Filter : Stream
	{
		private Stream baseStream;

		private byte[] input = new byte[4096];

		private int inputOffset;

		private int inputCount;

		private bool endReached;

		private long position;

		private byte[] output = new byte[4];

		private int outputOffset;

		private int outputCount;

		private byte[] control;

		private byte[] data1;

		private byte[] data2;

		private int controlPos;

		private int data1Pos;

		private int data2Pos;

		private ushort[] p = new ushort[258];

		private uint range;

		private uint code;

		private byte prevByte;

		private const int kNumTopBits = 24;

		private const int kTopValue = 16777216;

		private const int kNumBitModelTotalBits = 11;

		private const int kBitModelTotal = 2048;

		private const int kNumMoveBits = 5;

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
				return baseStream.Length + data1.Length + data2.Length;
			}
		}

		public override long Position
		{
			get
			{
				return position;
			}
			set
			{
				throw new NotImplementedException();
			}
		}

		public BCJ2Filter(byte[] control, byte[] data1, byte[] data2, Stream baseStream)
		{
			this.control = control;
			this.data1 = data1;
			this.data2 = data2;
			this.baseStream = baseStream;
			for (int i = 0; i < p.Length; i++)
			{
				p[i] = 1024;
			}
			code = 0u;
			range = uint.MaxValue;
			for (int i = 0; i < 5; i++)
			{
				code = (code << 8) | control[controlPos++];
			}
		}

		private static bool IsJ(byte b0, byte b1)
		{
			return (b1 & 0xFE) == 232 || IsJcc(b0, b1);
		}

		private static bool IsJcc(byte b0, byte b1)
		{
			return b0 == 15 && (b1 & 0xF0) == 128;
		}

		public override void Flush()
		{
			throw new NotImplementedException();
		}

		public override int Read(byte[] buffer, int offset, int count)
		{
			int num = 0;
			byte b = 0;
			while (!endReached && num < count)
			{
				while (outputOffset < outputCount)
				{
					b = output[outputOffset++];
					buffer[offset++] = b;
					num++;
					position++;
					prevByte = b;
					if (num == count)
					{
						return num;
					}
				}
				if (inputOffset == inputCount)
				{
					inputOffset = 0;
					inputCount = baseStream.Read(input, 0, input.Length);
					if (inputCount == 0)
					{
						endReached = true;
						break;
					}
				}
				b = input[inputOffset++];
				buffer[offset++] = b;
				num++;
				position++;
				if (!IsJ(prevByte, b))
				{
					prevByte = b;
					continue;
				}
				int num2;
				switch (b)
				{
				case 232:
					num2 = prevByte;
					break;
				case 233:
					num2 = 256;
					break;
				default:
					num2 = 257;
					break;
				}
				uint num3 = (range >> 11) * p[num2];
				if (code < num3)
				{
					range = num3;
					p[num2] += (ushort)(2048 - p[num2] >> 5);
					if (range < 16777216)
					{
						range <<= 8;
						code = (code << 8) | control[controlPos++];
					}
					prevByte = b;
					continue;
				}
				range -= num3;
				code -= num3;
				p[num2] -= (ushort)(p[num2] >> 5);
				if (range < 16777216)
				{
					range <<= 8;
					code = (code << 8) | control[controlPos++];
				}
				uint num4 = (uint)((b != 232) ? ((data2[data2Pos++] << 24) | (data2[data2Pos++] << 16) | (data2[data2Pos++] << 8) | data2[data2Pos++]) : ((data1[data1Pos++] << 24) | (data1[data1Pos++] << 16) | (data1[data1Pos++] << 8) | data1[data1Pos++]));
				num4 -= (uint)(int)(position + 4);
				output[0] = (byte)num4;
				output[1] = (byte)(num4 >> 8);
				output[2] = (byte)(num4 >> 16);
				output[3] = (byte)(num4 >> 24);
				outputOffset = 0;
				outputCount = 4;
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
