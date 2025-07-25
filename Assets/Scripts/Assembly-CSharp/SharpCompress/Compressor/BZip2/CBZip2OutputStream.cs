using System.IO;

namespace SharpCompress.Compressor.BZip2
{
	internal class CBZip2OutputStream : Stream
	{
		internal class StackElem
		{
			internal int ll;

			internal int hh;

			internal int dd;
		}

		protected const int SETMASK = 2097152;

		protected const int CLEARMASK = -2097153;

		protected const int GREATER_ICOST = 15;

		protected const int LESSER_ICOST = 0;

		protected const int SMALL_THRESH = 20;

		protected const int DEPTH_THRESH = 10;

		protected const int QSORT_STACK_SIZE = 1000;

		private bool finished;

		private int last;

		private int origPtr;

		private int blockSize100k;

		private bool blockRandomised;

		private int bytesOut;

		private int bsBuff;

		private int bsLive;

		private CRC mCrc = new CRC();

		private bool[] inUse = new bool[256];

		private int nInUse;

		private char[] seqToUnseq = new char[256];

		private char[] unseqToSeq = new char[256];

		private char[] selector = new char[18002];

		private char[] selectorMtf = new char[18002];

		private char[] block;

		private int[] quadrant;

		private int[] zptr;

		private short[] szptr;

		private int[] ftab;

		private int nMTF;

		private int[] mtfFreq = new int[258];

		private int workFactor;

		private int workDone;

		private int workLimit;

		private bool firstAttempt;

		private int nBlocksRandomised;

		private int currentChar = -1;

		private int runLength;

		private bool disposed;

		private int blockCRC;

		private int combinedCRC;

		private int allowableBlockSize;

		private Stream bsStream;

		private bool leaveOpen;

		private int[] incs = new int[14]
		{
			1, 4, 13, 40, 121, 364, 1093, 3280, 9841, 29524,
			88573, 265720, 797161, 2391484
		};

		public override bool CanRead
		{
			get
			{
				return false;
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
				return true;
			}
		}

		public override long Length
		{
			get
			{
				return 0L;
			}
		}

		public override long Position
		{
			get
			{
				return 0L;
			}
			set
			{
			}
		}

		public CBZip2OutputStream(Stream inStream)
			: this(inStream, 9, false)
		{
		}

		public CBZip2OutputStream(Stream inStream, bool leaveOpen)
			: this(inStream, 9, leaveOpen)
		{
		}

		public CBZip2OutputStream(Stream inStream, int inBlockSize, bool leaveOpen)
		{
			block = null;
			quadrant = null;
			zptr = null;
			ftab = null;
			inStream.WriteByte(66);
			inStream.WriteByte(90);
			BsSetStream(inStream, leaveOpen);
			workFactor = 50;
			if (inBlockSize > 9)
			{
				inBlockSize = 9;
			}
			if (inBlockSize < 1)
			{
				inBlockSize = 1;
			}
			blockSize100k = inBlockSize;
			AllocateCompressStructures();
			Initialize();
			InitBlock();
		}

		private static void Panic()
		{
		}

		private void MakeMaps()
		{
			nInUse = 0;
			for (int i = 0; i < 256; i++)
			{
				if (inUse[i])
				{
					seqToUnseq[nInUse] = (char)i;
					unseqToSeq[i] = (char)nInUse;
					nInUse++;
				}
			}
		}

		protected static void HbMakeCodeLengths(char[] len, int[] freq, int alphaSize, int maxLen)
		{
			int[] array = new int[260];
			int[] array2 = new int[516];
			int[] array3 = new int[516];
			for (int i = 0; i < alphaSize; i++)
			{
				array2[i + 1] = ((freq[i] == 0) ? 1 : freq[i]) << 8;
			}
			while (true)
			{
				int num = alphaSize;
				int num2 = 0;
				array[0] = 0;
				array2[0] = 0;
				array3[0] = -2;
				for (int i = 1; i <= alphaSize; i++)
				{
					array3[i] = -1;
					num2++;
					array[num2] = i;
					int num3 = num2;
					int num4 = array[num3];
					while (array2[num4] < array2[array[num3 >> 1]])
					{
						array[num3] = array[num3 >> 1];
						num3 >>= 1;
					}
					array[num3] = num4;
				}
				if (num2 >= 260)
				{
					Panic();
				}
				while (num2 > 1)
				{
					int num5 = array[1];
					array[1] = array[num2];
					num2--;
					int num6 = 0;
					int num7 = 0;
					int num8 = 0;
					num6 = 1;
					num8 = array[num6];
					while (true)
					{
						num7 = num6 << 1;
						if (num7 > num2)
						{
							break;
						}
						if (num7 < num2 && array2[array[num7 + 1]] < array2[array[num7]])
						{
							num7++;
						}
						if (array2[num8] < array2[array[num7]])
						{
							break;
						}
						array[num6] = array[num7];
						num6 = num7;
					}
					array[num6] = num8;
					int num9 = array[1];
					array[1] = array[num2];
					num2--;
					int num10 = 0;
					int num11 = 0;
					int num12 = 0;
					num10 = 1;
					num12 = array[num10];
					while (true)
					{
						num11 = num10 << 1;
						if (num11 > num2)
						{
							break;
						}
						if (num11 < num2 && array2[array[num11 + 1]] < array2[array[num11]])
						{
							num11++;
						}
						if (array2[num12] < array2[array[num11]])
						{
							break;
						}
						array[num10] = array[num11];
						num10 = num11;
					}
					array[num10] = num12;
					num++;
					array3[num5] = (array3[num9] = num);
					array2[num] = (int)((array2[num5] & 0xFFFFFF00u) + (array2[num9] & 0xFFFFFF00u)) | (1 + (((array2[num5] & 0xFF) <= (array2[num9] & 0xFF)) ? (array2[num9] & 0xFF) : (array2[num5] & 0xFF)));
					array3[num] = -1;
					num2++;
					array[num2] = num;
					int num13 = 0;
					int num14 = 0;
					num13 = num2;
					num14 = array[num13];
					while (array2[num14] < array2[array[num13 >> 1]])
					{
						array[num13] = array[num13 >> 1];
						num13 >>= 1;
					}
					array[num13] = num14;
				}
				if (num >= 516)
				{
					Panic();
				}
				bool flag = false;
				for (int i = 1; i <= alphaSize; i++)
				{
					int num15 = 0;
					int num16 = i;
					while (array3[num16] >= 0)
					{
						num16 = array3[num16];
						num15++;
					}
					len[i - 1] = (char)num15;
					if (num15 > maxLen)
					{
						flag = true;
					}
				}
				if (!flag)
				{
					break;
				}
				for (int i = 1; i < alphaSize; i++)
				{
					int num15 = array2[i] >> 8;
					num15 = 1 + num15 / 2;
					array2[i] = num15 << 8;
				}
			}
		}

		public override void WriteByte(byte bv)
		{
			int num = (256 + bv) % 256;
			if (currentChar != -1)
			{
				if (currentChar == num)
				{
					runLength++;
					if (runLength > 254)
					{
						WriteRun();
						currentChar = -1;
						runLength = 0;
					}
				}
				else
				{
					WriteRun();
					runLength = 1;
					currentChar = num;
				}
			}
			else
			{
				currentChar = num;
				runLength++;
			}
		}

		private void WriteRun()
		{
			if (last < allowableBlockSize)
			{
				inUse[currentChar] = true;
				for (int i = 0; i < runLength; i++)
				{
					mCrc.UpdateCRC((ushort)currentChar);
				}
				switch (runLength)
				{
				case 1:
					last++;
					block[last + 1] = (char)currentChar;
					break;
				case 2:
					last++;
					block[last + 1] = (char)currentChar;
					last++;
					block[last + 1] = (char)currentChar;
					break;
				case 3:
					last++;
					block[last + 1] = (char)currentChar;
					last++;
					block[last + 1] = (char)currentChar;
					last++;
					block[last + 1] = (char)currentChar;
					break;
				default:
					inUse[runLength - 4] = true;
					last++;
					block[last + 1] = (char)currentChar;
					last++;
					block[last + 1] = (char)currentChar;
					last++;
					block[last + 1] = (char)currentChar;
					last++;
					block[last + 1] = (char)currentChar;
					last++;
					block[last + 1] = (char)(runLength - 4);
					break;
				}
			}
			else
			{
				EndBlock();
				InitBlock();
				WriteRun();
			}
		}

		protected override void Dispose(bool disposing)
		{
			if (disposing && !disposed)
			{
				Finish();
				disposed = true;
				Dispose();
				if (!leaveOpen)
				{
					bsStream.Dispose();
				}
				bsStream = null;
			}
		}

		public void Finish()
		{
			if (!finished)
			{
				if (runLength > 0)
				{
					WriteRun();
				}
				currentChar = -1;
				EndBlock();
				EndCompression();
				finished = true;
				Flush();
			}
		}

		public override void Flush()
		{
			bsStream.Flush();
		}

		private void Initialize()
		{
			bytesOut = 0;
			nBlocksRandomised = 0;
			BsPutUChar(104);
			BsPutUChar(48 + blockSize100k);
			combinedCRC = 0;
		}

		private void InitBlock()
		{
			mCrc.InitialiseCRC();
			last = -1;
			for (int i = 0; i < 256; i++)
			{
				inUse[i] = false;
			}
			allowableBlockSize = 100000 * blockSize100k - 20;
		}

		private void EndBlock()
		{
			blockCRC = mCrc.GetFinalCRC();
			combinedCRC = (combinedCRC << 1) | (int)((uint)combinedCRC >> 31);
			combinedCRC ^= blockCRC;
			DoReversibleTransformation();
			BsPutUChar(49);
			BsPutUChar(65);
			BsPutUChar(89);
			BsPutUChar(38);
			BsPutUChar(83);
			BsPutUChar(89);
			BsPutint(blockCRC);
			if (blockRandomised)
			{
				BsW(1, 1);
				nBlocksRandomised++;
			}
			else
			{
				BsW(1, 0);
			}
			MoveToFrontCodeAndSend();
		}

		private void EndCompression()
		{
			BsPutUChar(23);
			BsPutUChar(114);
			BsPutUChar(69);
			BsPutUChar(56);
			BsPutUChar(80);
			BsPutUChar(144);
			BsPutint(combinedCRC);
			BsFinishedWithStream();
		}

		private void HbAssignCodes(int[] code, char[] length, int minLen, int maxLen, int alphaSize)
		{
			int num = 0;
			for (int i = minLen; i <= maxLen; i++)
			{
				for (int j = 0; j < alphaSize; j++)
				{
					if (length[j] == i)
					{
						code[j] = num;
						num++;
					}
				}
				num <<= 1;
			}
		}

		private void BsSetStream(Stream f, bool leaveOpen)
		{
			bsStream = f;
			bsLive = 0;
			bsBuff = 0;
			bytesOut = 0;
			this.leaveOpen = leaveOpen;
		}

		private void BsFinishedWithStream()
		{
			while (bsLive > 0)
			{
				int num = bsBuff >> 24;
				try
				{
					bsStream.WriteByte((byte)num);
				}
				catch (IOException ex)
				{
					throw ex;
				}
				bsBuff <<= 8;
				bsLive -= 8;
				bytesOut++;
			}
		}

		private void BsW(int n, int v)
		{
			while (bsLive >= 8)
			{
				int num = bsBuff >> 24;
				try
				{
					bsStream.WriteByte((byte)num);
				}
				catch (IOException ex)
				{
					throw ex;
				}
				bsBuff <<= 8;
				bsLive -= 8;
				bytesOut++;
			}
			bsBuff |= v << 32 - bsLive - n;
			bsLive += n;
		}

		private void BsPutUChar(int c)
		{
			BsW(8, c);
		}

		private void BsPutint(int u)
		{
			BsW(8, (u >> 24) & 0xFF);
			BsW(8, (u >> 16) & 0xFF);
			BsW(8, (u >> 8) & 0xFF);
			BsW(8, u & 0xFF);
		}

		private void BsPutIntVS(int numBits, int c)
		{
			BsW(numBits, c);
		}

		private void SendMTFValues()
		{
			char[][] array = CBZip2InputStream.InitCharArray(6, 258);
			int num = 0;
			int num2 = nInUse + 2;
			for (int i = 0; i < 6; i++)
			{
				for (int j = 0; j < num2; j++)
				{
					array[i][j] = '\u000f';
				}
			}
			if (nMTF <= 0)
			{
				Panic();
			}
			int num3 = ((nMTF < 200) ? 2 : ((nMTF < 600) ? 3 : ((nMTF < 1200) ? 4 : ((nMTF >= 2400) ? 6 : 5))));
			int num4 = num3;
			int num5 = nMTF;
			int num6 = 0;
			while (num4 > 0)
			{
				int num7 = num5 / num4;
				int num8 = num6 - 1;
				int k;
				for (k = 0; k < num7; k += mtfFreq[num8])
				{
					if (num8 >= num2 - 1)
					{
						break;
					}
					num8++;
				}
				if (num8 > num6 && num4 != num3 && num4 != 1 && (num3 - num4) % 2 == 1)
				{
					k -= mtfFreq[num8];
					num8--;
				}
				for (int j = 0; j < num2; j++)
				{
					if (j >= num6 && j <= num8)
					{
						array[num4 - 1][j] = '\0';
					}
					else
					{
						array[num4 - 1][j] = '\u000f';
					}
				}
				num4--;
				num6 = num8 + 1;
				num5 -= k;
			}
			int[][] array2 = CBZip2InputStream.InitIntArray(6, 258);
			int[] array3 = new int[6];
			short[] array4 = new short[6];
			for (int l = 0; l < 4; l++)
			{
				for (int i = 0; i < num3; i++)
				{
					array3[i] = 0;
				}
				for (int i = 0; i < num3; i++)
				{
					for (int j = 0; j < num2; j++)
					{
						array2[i][j] = 0;
					}
				}
				num = 0;
				int num9 = 0;
				num6 = 0;
				while (num6 < nMTF)
				{
					int num8 = num6 + 50 - 1;
					if (num8 >= nMTF)
					{
						num8 = nMTF - 1;
					}
					for (int i = 0; i < num3; i++)
					{
						array4[i] = 0;
					}
					if (num3 == 6)
					{
						short num11;
						short num12;
						short num13;
						short num14;
						short num15;
						short num10 = (num11 = (num12 = (num13 = (num14 = (num15 = 0)))));
						for (int m = num6; m <= num8; m++)
						{
							short num16 = szptr[m];
							num10 += (short)array[0][num16];
							num11 += (short)array[1][num16];
							num12 += (short)array[2][num16];
							num13 += (short)array[3][num16];
							num14 += (short)array[4][num16];
							num15 += (short)array[5][num16];
						}
						array4[0] = num10;
						array4[1] = num11;
						array4[2] = num12;
						array4[3] = num13;
						array4[4] = num14;
						array4[5] = num15;
					}
					else
					{
						for (int m = num6; m <= num8; m++)
						{
							short num17 = szptr[m];
							for (int i = 0; i < num3; i++)
							{
								array4[i] += (short)array[i][num17];
							}
						}
					}
					int num18 = 999999999;
					int num19 = -1;
					for (int i = 0; i < num3; i++)
					{
						if (array4[i] < num18)
						{
							num18 = array4[i];
							num19 = i;
						}
					}
					num9 += num18;
					array3[num19]++;
					selector[num] = (char)num19;
					num++;
					for (int m = num6; m <= num8; m++)
					{
						array2[num19][szptr[m]]++;
					}
					num6 = num8 + 1;
				}
				for (int i = 0; i < num3; i++)
				{
					HbMakeCodeLengths(array[i], array2[i], num2, 20);
				}
			}
			array2 = null;
			array3 = null;
			array4 = null;
			if (num3 >= 8)
			{
				Panic();
			}
			if (num >= 32768 || num > 18002)
			{
				Panic();
			}
			char[] array5 = new char[6];
			for (int m = 0; m < num3; m++)
			{
				array5[m] = (char)m;
			}
			for (int m = 0; m < num; m++)
			{
				char c = selector[m];
				int num20 = 0;
				char c2 = array5[num20];
				while (c != c2)
				{
					num20++;
					char c3 = c2;
					c2 = array5[num20];
					array5[num20] = c3;
				}
				array5[0] = c2;
				selectorMtf[m] = (char)num20;
			}
			int[][] array6 = CBZip2InputStream.InitIntArray(6, 258);
			for (int i = 0; i < num3; i++)
			{
				int num21 = 32;
				int num22 = 0;
				for (int m = 0; m < num2; m++)
				{
					if (array[i][m] > num22)
					{
						num22 = array[i][m];
					}
					if (array[i][m] < num21)
					{
						num21 = array[i][m];
					}
				}
				if (num22 > 20)
				{
					Panic();
				}
				if (num21 < 1)
				{
					Panic();
				}
				HbAssignCodes(array6[i], array[i], num21, num22, num2);
			}
			bool[] array7 = new bool[16];
			for (int m = 0; m < 16; m++)
			{
				array7[m] = false;
				for (int num20 = 0; num20 < 16; num20++)
				{
					if (inUse[m * 16 + num20])
					{
						array7[m] = true;
					}
				}
			}
			for (int m = 0; m < 16; m++)
			{
				if (array7[m])
				{
					BsW(1, 1);
				}
				else
				{
					BsW(1, 0);
				}
			}
			for (int m = 0; m < 16; m++)
			{
				if (!array7[m])
				{
					continue;
				}
				for (int num20 = 0; num20 < 16; num20++)
				{
					if (inUse[m * 16 + num20])
					{
						BsW(1, 1);
					}
					else
					{
						BsW(1, 0);
					}
				}
			}
			BsW(3, num3);
			BsW(15, num);
			for (int m = 0; m < num; m++)
			{
				for (int num20 = 0; num20 < selectorMtf[m]; num20++)
				{
					BsW(1, 1);
				}
				BsW(1, 0);
			}
			for (int i = 0; i < num3; i++)
			{
				int n = array[i][0];
				BsW(5, n);
				for (int m = 0; m < num2; m++)
				{
					for (; n < array[i][m]; n++)
					{
						BsW(2, 2);
					}
					while (n > array[i][m])
					{
						BsW(2, 3);
						n--;
					}
					BsW(1, 0);
				}
			}
			int num23 = 0;
			num6 = 0;
			while (num6 < nMTF)
			{
				int num8 = num6 + 50 - 1;
				if (num8 >= nMTF)
				{
					num8 = nMTF - 1;
				}
				for (int m = num6; m <= num8; m++)
				{
					BsW(array[(uint)selector[num23]][szptr[m]], array6[(uint)selector[num23]][szptr[m]]);
				}
				num6 = num8 + 1;
				num23++;
			}
			if (num23 != num)
			{
				Panic();
			}
		}

		private void MoveToFrontCodeAndSend()
		{
			BsPutIntVS(24, origPtr);
			GenerateMTFValues();
			SendMTFValues();
		}

		private void SimpleSort(int lo, int hi, int d)
		{
			int num = hi - lo + 1;
			if (num < 2)
			{
				return;
			}
			int i;
			for (i = 0; incs[i] < num; i++)
			{
			}
			for (i--; i >= 0; i--)
			{
				int num2 = incs[i];
				int num3 = lo + num2;
				while (num3 <= hi)
				{
					int num4 = zptr[num3];
					int num5 = num3;
					while (FullGtU(zptr[num5 - num2] + d, num4 + d))
					{
						zptr[num5] = zptr[num5 - num2];
						num5 -= num2;
						if (num5 <= lo + num2 - 1)
						{
							break;
						}
					}
					zptr[num5] = num4;
					num3++;
					if (num3 > hi)
					{
						break;
					}
					num4 = zptr[num3];
					num5 = num3;
					while (FullGtU(zptr[num5 - num2] + d, num4 + d))
					{
						zptr[num5] = zptr[num5 - num2];
						num5 -= num2;
						if (num5 <= lo + num2 - 1)
						{
							break;
						}
					}
					zptr[num5] = num4;
					num3++;
					if (num3 > hi)
					{
						break;
					}
					num4 = zptr[num3];
					num5 = num3;
					while (FullGtU(zptr[num5 - num2] + d, num4 + d))
					{
						zptr[num5] = zptr[num5 - num2];
						num5 -= num2;
						if (num5 <= lo + num2 - 1)
						{
							break;
						}
					}
					zptr[num5] = num4;
					num3++;
					if (workDone > workLimit && firstAttempt)
					{
						return;
					}
				}
			}
		}

		private void Vswap(int p1, int p2, int n)
		{
			int num = 0;
			while (n > 0)
			{
				num = zptr[p1];
				zptr[p1] = zptr[p2];
				zptr[p2] = num;
				p1++;
				p2++;
				n--;
			}
		}

		private char Med3(char a, char b, char c)
		{
			if (a > b)
			{
				char c2 = a;
				a = b;
				b = c2;
			}
			if (b > c)
			{
				char c2 = b;
				b = c;
				c = c2;
			}
			if (a > b)
			{
				b = a;
			}
			return b;
		}

		private void QSort3(int loSt, int hiSt, int dSt)
		{
			StackElem[] array = new StackElem[1000];
			for (int i = 0; i < 1000; i++)
			{
				array[i] = new StackElem();
			}
			int num = 0;
			array[num].ll = loSt;
			array[num].hh = hiSt;
			array[num].dd = dSt;
			num++;
			while (num > 0)
			{
				if (num >= 1000)
				{
					Panic();
				}
				num--;
				int ll = array[num].ll;
				int hh = array[num].hh;
				int dd = array[num].dd;
				if (hh - ll < 20 || dd > 10)
				{
					SimpleSort(ll, hh, dd);
					if (workDone > workLimit && firstAttempt)
					{
						break;
					}
					continue;
				}
				int num2 = Med3(block[zptr[ll] + dd + 1], block[zptr[hh] + dd + 1], block[zptr[ll + hh >> 1] + dd + 1]);
				int num4;
				int num3 = (num4 = ll);
				int num6;
				int num5 = (num6 = hh);
				int num7;
				while (true)
				{
					if (num3 <= num5)
					{
						num7 = block[zptr[num3] + dd + 1] - num2;
						if (num7 == 0)
						{
							int num8 = 0;
							num8 = zptr[num3];
							zptr[num3] = zptr[num4];
							zptr[num4] = num8;
							num4++;
							num3++;
							continue;
						}
						if (num7 <= 0)
						{
							num3++;
							continue;
						}
					}
					while (num3 <= num5)
					{
						num7 = block[zptr[num5] + dd + 1] - num2;
						if (num7 == 0)
						{
							int num9 = 0;
							num9 = zptr[num5];
							zptr[num5] = zptr[num6];
							zptr[num6] = num9;
							num6--;
							num5--;
						}
						else
						{
							if (num7 < 0)
							{
								break;
							}
							num5--;
						}
					}
					if (num3 > num5)
					{
						break;
					}
					int num10 = zptr[num3];
					zptr[num3] = zptr[num5];
					zptr[num5] = num10;
					num3++;
					num5--;
				}
				if (num6 < num4)
				{
					array[num].ll = ll;
					array[num].hh = hh;
					array[num].dd = dd + 1;
					num++;
					continue;
				}
				num7 = ((num4 - ll >= num3 - num4) ? (num3 - num4) : (num4 - ll));
				Vswap(ll, num3 - num7, num7);
				int num11 = ((hh - num6 >= num6 - num5) ? (num6 - num5) : (hh - num6));
				Vswap(num3, hh - num11 + 1, num11);
				num7 = ll + num3 - num4 - 1;
				num11 = hh - (num6 - num5) + 1;
				array[num].ll = ll;
				array[num].hh = num7;
				array[num].dd = dd;
				num++;
				array[num].ll = num7 + 1;
				array[num].hh = num11 - 1;
				array[num].dd = dd + 1;
				num++;
				array[num].ll = num11;
				array[num].hh = hh;
				array[num].dd = dd;
				num++;
			}
		}

		private void MainSort()
		{
			int[] array = new int[256];
			int[] array2 = new int[256];
			bool[] array3 = new bool[256];
			for (int i = 0; i < 20; i++)
			{
				block[last + i + 2] = block[i % (last + 1) + 1];
			}
			for (int i = 0; i <= last + 20; i++)
			{
				quadrant[i] = 0;
			}
			block[0] = block[last + 1];
			if (last < 4000)
			{
				for (int i = 0; i <= last; i++)
				{
					zptr[i] = i;
				}
				firstAttempt = false;
				workDone = (workLimit = 0);
				SimpleSort(0, last, 0);
				return;
			}
			int num = 0;
			for (int i = 0; i <= 255; i++)
			{
				array3[i] = false;
			}
			for (int i = 0; i <= 65536; i++)
			{
				ftab[i] = 0;
			}
			int num2 = block[0];
			for (int i = 0; i <= last; i++)
			{
				int num3 = block[i + 1];
				ftab[(num2 << 8) + num3]++;
				num2 = num3;
			}
			for (int i = 1; i <= 65536; i++)
			{
				ftab[i] += ftab[i - 1];
			}
			num2 = block[1];
			int num4;
			for (int i = 0; i < last; i++)
			{
				int num3 = block[i + 2];
				num4 = (num2 << 8) + num3;
				num2 = num3;
				ftab[num4]--;
				zptr[ftab[num4]] = i;
			}
			num4 = (int)(((uint)block[last + 1] << 8) + block[1]);
			ftab[num4]--;
			zptr[ftab[num4]] = last;
			for (int i = 0; i <= 255; i++)
			{
				array[i] = i;
			}
			int num5 = 1;
			do
			{
				num5 = 3 * num5 + 1;
			}
			while (num5 <= 256);
			do
			{
				num5 /= 3;
				for (int i = num5; i <= 255; i++)
				{
					int num6 = array[i];
					num4 = i;
					while (ftab[array[num4 - num5] + 1 << 8] - ftab[array[num4 - num5] << 8] > ftab[num6 + 1 << 8] - ftab[num6 << 8])
					{
						array[num4] = array[num4 - num5];
						num4 -= num5;
						if (num4 <= num5 - 1)
						{
							break;
						}
					}
					array[num4] = num6;
				}
			}
			while (num5 != 1);
			for (int i = 0; i <= 255; i++)
			{
				int num7 = array[i];
				for (num4 = 0; num4 <= 255; num4++)
				{
					int num8 = (num7 << 8) + num4;
					if ((ftab[num8] & 0x200000) == 2097152)
					{
						continue;
					}
					int num9 = ftab[num8] & -2097153;
					int num10 = (ftab[num8 + 1] & -2097153) - 1;
					if (num10 > num9)
					{
						QSort3(num9, num10, 2);
						num += num10 - num9 + 1;
						if (workDone > workLimit && firstAttempt)
						{
							return;
						}
					}
					ftab[num8] |= 2097152;
				}
				array3[num7] = true;
				if (i < 255)
				{
					int num11 = ftab[num7 << 8] & -2097153;
					int num12 = (ftab[num7 + 1 << 8] & -2097153) - num11;
					int j;
					for (j = 0; num12 >> j > 65534; j++)
					{
					}
					for (num4 = 0; num4 < num12; num4++)
					{
						int num13 = zptr[num11 + num4];
						int num14 = num4 >> j;
						quadrant[num13] = num14;
						if (num13 < 20)
						{
							quadrant[num13 + last + 1] = num14;
						}
					}
					if (num12 - 1 >> j > 65535)
					{
						Panic();
					}
				}
				for (num4 = 0; num4 <= 255; num4++)
				{
					array2[num4] = ftab[(num4 << 8) + num7] & -2097153;
				}
				for (num4 = ftab[num7 << 8] & -2097153; num4 < (ftab[num7 + 1 << 8] & -2097153); num4++)
				{
					num2 = block[zptr[num4]];
					if (!array3[num2])
					{
						zptr[array2[num2]] = ((zptr[num4] != 0) ? (zptr[num4] - 1) : last);
						array2[num2]++;
					}
				}
				for (num4 = 0; num4 <= 255; num4++)
				{
					ftab[(num4 << 8) + num7] |= 2097152;
				}
			}
		}

		private void RandomiseBlock()
		{
			int num = 0;
			int num2 = 0;
			for (int i = 0; i < 256; i++)
			{
				inUse[i] = false;
			}
			for (int i = 0; i <= last; i++)
			{
				if (num == 0)
				{
					num = (ushort)BZip2Constants.rNums[num2];
					num2++;
					if (num2 == 512)
					{
						num2 = 0;
					}
				}
				num--;
				block[i + 1] ^= ((num == 1) ? '\u0001' : '\0');
				block[i + 1] &= 'ÿ';
				inUse[(uint)block[i + 1]] = true;
			}
		}

		private void DoReversibleTransformation()
		{
			workLimit = workFactor * last;
			workDone = 0;
			blockRandomised = false;
			firstAttempt = true;
			MainSort();
			if (workDone > workLimit && firstAttempt)
			{
				RandomiseBlock();
				workLimit = (workDone = 0);
				blockRandomised = true;
				firstAttempt = false;
				MainSort();
			}
			origPtr = -1;
			for (int i = 0; i <= last; i++)
			{
				if (zptr[i] == 0)
				{
					origPtr = i;
					break;
				}
			}
			if (origPtr == -1)
			{
				Panic();
			}
		}

		private bool FullGtU(int i1, int i2)
		{
			char c = block[i1 + 1];
			char c2 = block[i2 + 1];
			if (c != c2)
			{
				return c > c2;
			}
			i1++;
			i2++;
			c = block[i1 + 1];
			c2 = block[i2 + 1];
			if (c != c2)
			{
				return c > c2;
			}
			i1++;
			i2++;
			c = block[i1 + 1];
			c2 = block[i2 + 1];
			if (c != c2)
			{
				return c > c2;
			}
			i1++;
			i2++;
			c = block[i1 + 1];
			c2 = block[i2 + 1];
			if (c != c2)
			{
				return c > c2;
			}
			i1++;
			i2++;
			c = block[i1 + 1];
			c2 = block[i2 + 1];
			if (c != c2)
			{
				return c > c2;
			}
			i1++;
			i2++;
			c = block[i1 + 1];
			c2 = block[i2 + 1];
			if (c != c2)
			{
				return c > c2;
			}
			i1++;
			i2++;
			int num = last + 1;
			do
			{
				c = block[i1 + 1];
				c2 = block[i2 + 1];
				if (c != c2)
				{
					return c > c2;
				}
				int num2 = quadrant[i1];
				int num3 = quadrant[i2];
				if (num2 != num3)
				{
					return num2 > num3;
				}
				i1++;
				i2++;
				c = block[i1 + 1];
				c2 = block[i2 + 1];
				if (c != c2)
				{
					return c > c2;
				}
				num2 = quadrant[i1];
				num3 = quadrant[i2];
				if (num2 != num3)
				{
					return num2 > num3;
				}
				i1++;
				i2++;
				c = block[i1 + 1];
				c2 = block[i2 + 1];
				if (c != c2)
				{
					return c > c2;
				}
				num2 = quadrant[i1];
				num3 = quadrant[i2];
				if (num2 != num3)
				{
					return num2 > num3;
				}
				i1++;
				i2++;
				c = block[i1 + 1];
				c2 = block[i2 + 1];
				if (c != c2)
				{
					return c > c2;
				}
				num2 = quadrant[i1];
				num3 = quadrant[i2];
				if (num2 != num3)
				{
					return num2 > num3;
				}
				i1++;
				i2++;
				if (i1 > last)
				{
					i1 -= last;
					i1--;
				}
				if (i2 > last)
				{
					i2 -= last;
					i2--;
				}
				num -= 4;
				workDone++;
			}
			while (num >= 0);
			return false;
		}

		private void AllocateCompressStructures()
		{
			int num = 100000 * blockSize100k;
			block = new char[num + 1 + 20];
			quadrant = new int[num + 20];
			zptr = new int[num];
			ftab = new int[65537];
			if (block == null || quadrant == null || zptr == null || ftab == null)
			{
			}
			szptr = new short[2 * num];
		}

		private void GenerateMTFValues()
		{
			char[] array = new char[256];
			MakeMaps();
			int num = nInUse + 1;
			for (int i = 0; i <= num; i++)
			{
				mtfFreq[i] = 0;
			}
			int num2 = 0;
			int num3 = 0;
			for (int i = 0; i < nInUse; i++)
			{
				array[i] = (char)i;
			}
			for (int i = 0; i <= last; i++)
			{
				char c = unseqToSeq[(uint)block[zptr[i]]];
				int num4 = 0;
				char c2 = array[num4];
				while (c != c2)
				{
					num4++;
					char c3 = c2;
					c2 = array[num4];
					array[num4] = c3;
				}
				array[0] = c2;
				if (num4 == 0)
				{
					num3++;
					continue;
				}
				if (num3 > 0)
				{
					num3--;
					while (true)
					{
						switch (num3 % 2)
						{
						case 0:
							szptr[num2] = 0;
							num2++;
							mtfFreq[0]++;
							break;
						case 1:
							szptr[num2] = 1;
							num2++;
							mtfFreq[1]++;
							break;
						}
						if (num3 < 2)
						{
							break;
						}
						num3 = (num3 - 2) / 2;
					}
					num3 = 0;
				}
				szptr[num2] = (short)(num4 + 1);
				num2++;
				mtfFreq[num4 + 1]++;
			}
			if (num3 > 0)
			{
				num3--;
				while (true)
				{
					switch (num3 % 2)
					{
					case 0:
						szptr[num2] = 0;
						num2++;
						mtfFreq[0]++;
						break;
					case 1:
						szptr[num2] = 1;
						num2++;
						mtfFreq[1]++;
						break;
					}
					if (num3 < 2)
					{
						break;
					}
					num3 = (num3 - 2) / 2;
				}
			}
			szptr[num2] = (short)num;
			num2++;
			mtfFreq[num]++;
			nMTF = num2;
		}

		public override int Read(byte[] buffer, int offset, int count)
		{
			return 0;
		}

		public override long Seek(long offset, SeekOrigin origin)
		{
			return 0L;
		}

		public override void SetLength(long value)
		{
		}

		public override void Write(byte[] buffer, int offset, int count)
		{
			for (int i = 0; i < count; i++)
			{
				WriteByte(buffer[i + offset]);
			}
		}
	}
}
