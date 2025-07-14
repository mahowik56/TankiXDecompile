using System.IO;

namespace SharpCompress.Compressor.Deflate
{
	internal class CRC32
	{
		private const int BUFFER_SIZE = 8192;

		private static readonly uint[] crc32Table;

		private uint runningCrc32Result = uint.MaxValue;

		private long totalBytesRead;

		public long TotalBytesRead
		{
			get
			{
				return totalBytesRead;
			}
		}

		public int Crc32Result
		{
			get
			{
				return (int)(~runningCrc32Result);
			}
		}

		static CRC32()
		{
			uint num = 3988292384u;
			crc32Table = new uint[256];
			for (uint num2 = 0u; num2 < 256; num2++)
			{
				uint num3 = num2;
				for (uint num4 = 8u; num4 != 0; num4--)
				{
					num3 = (((num3 & 1) != 1) ? (num3 >> 1) : ((num3 >> 1) ^ num));
				}
				crc32Table[num2] = num3;
			}
		}

		public int GetCrc32(Stream input)
		{
			return GetCrc32AndCopy(input, null);
		}

		public int GetCrc32AndCopy(Stream input, Stream output)
		{
			if (input == null)
			{
				throw new ZlibException("The input stream must not be null.");
			}
			byte[] array = new byte[8192];
			int count = 8192;
			totalBytesRead = 0L;
			int num = input.Read(array, 0, count);
			if (output != null)
			{
				output.Write(array, 0, num);
			}
			totalBytesRead += num;
			while (num > 0)
			{
				SlurpBlock(array, 0, num);
				num = input.Read(array, 0, count);
				if (output != null)
				{
					output.Write(array, 0, num);
				}
				totalBytesRead += num;
			}
			return (int)(~runningCrc32Result);
		}

		public int ComputeCrc32(int W, byte B)
		{
			return _InternalComputeCrc32((uint)W, B);
		}

		internal int _InternalComputeCrc32(uint W, byte B)
		{
			return (int)(crc32Table[(W ^ B) & 0xFF] ^ (W >> 8));
		}

		public void SlurpBlock(byte[] block, int offset, int count)
		{
			if (block == null)
			{
				throw new ZlibException("The data buffer must not be null.");
			}
			for (int i = 0; i < count; i++)
			{
				int num = offset + i;
				runningCrc32Result = (runningCrc32Result >> 8) ^ crc32Table[block[num] ^ (runningCrc32Result & 0xFF)];
			}
			totalBytesRead += count;
		}

		private uint gf2_matrix_times(uint[] matrix, uint vec)
		{
			uint num = 0u;
			int num2 = 0;
			while (vec != 0)
			{
				if ((vec & 1) == 1)
				{
					num ^= matrix[num2];
				}
				vec >>= 1;
				num2++;
			}
			return num;
		}

		private void gf2_matrix_square(uint[] square, uint[] mat)
		{
			for (int i = 0; i < 32; i++)
			{
				square[i] = gf2_matrix_times(mat, mat[i]);
			}
		}

		public void Combine(int crc, int length)
		{
			uint[] array = new uint[32];
			uint[] array2 = new uint[32];
			if (length == 0)
			{
				return;
			}
			uint num = ~runningCrc32Result;
			array2[0] = 3988292384u;
			uint num2 = 1u;
			for (int i = 1; i < 32; i++)
			{
				array2[i] = num2;
				num2 <<= 1;
			}
			gf2_matrix_square(array, array2);
			gf2_matrix_square(array2, array);
			uint num3 = (uint)length;
			do
			{
				gf2_matrix_square(array, array2);
				if ((num3 & 1) == 1)
				{
					num = gf2_matrix_times(array, num);
				}
				num3 >>= 1;
				if (num3 == 0)
				{
					break;
				}
				gf2_matrix_square(array2, array);
				if ((num3 & 1) == 1)
				{
					num = gf2_matrix_times(array2, num);
				}
				num3 >>= 1;
			}
			while (num3 != 0);
			num ^= (uint)crc;
			runningCrc32Result = ~num;
		}
	}
}
