using System;
using System.Collections;
using System.Collections.Generic;

namespace WebSocketSharp
{
	internal class PayloadData : IEnumerable<byte>, IEnumerable
	{
		private byte[] _data;

		private long _extDataLength;

		private long _length;

		public static readonly PayloadData Empty;

		public static readonly ulong MaxLength;

		internal long ExtensionDataLength
		{
			get
			{
				return _extDataLength;
			}
			set
			{
				_extDataLength = value;
			}
		}

		internal bool IncludesReservedCloseStatusCode
		{
			get
			{
				return _length > 1 && _data.SubArray(0, 2).ToUInt16(ByteOrder.Big).IsReserved();
			}
		}

		public byte[] ApplicationData
		{
			get
			{
				return (_extDataLength <= 0) ? _data : _data.SubArray(_extDataLength, _length - _extDataLength);
			}
		}

		public byte[] ExtensionData
		{
			get
			{
				return (_extDataLength <= 0) ? WebSocket.EmptyBytes : _data.SubArray(0L, _extDataLength);
			}
		}

		public ulong Length
		{
			get
			{
				return (ulong)_length;
			}
		}

		static PayloadData()
		{
			Empty = new PayloadData();
			MaxLength = 9223372036854775807uL;
		}

		internal PayloadData()
		{
			_data = WebSocket.EmptyBytes;
		}

		internal PayloadData(byte[] data)
			: this(data, data.LongLength)
		{
		}

		internal PayloadData(byte[] data, long length)
		{
			_data = data;
			_length = length;
		}

		internal void Mask(byte[] key)
		{
			for (long num = 0L; num < _length; num++)
			{
				_data[num] ^= key[num % 4];
			}
		}

		public IEnumerator<byte> GetEnumerator()
		{
			byte[] data = _data;
			for (int i = 0; i < data.Length; i++)
			{
				yield return data[i];
			}
		}

		public byte[] ToArray()
		{
			return _data;
		}

		public override string ToString()
		{
			return BitConverter.ToString(_data);
		}

		IEnumerator IEnumerable.GetEnumerator()
		{
			return GetEnumerator();
		}
	}
}
