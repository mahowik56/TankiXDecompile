using System;

namespace WebSocketSharp
{
	public class MessageEventArgs : EventArgs
	{
		private string _data;

		private bool _dataSet;

		private Opcode _opcode;

		private byte[] _rawData;

		public string Data
		{
			get
			{
				if (!_dataSet)
				{
					_data = ((_opcode == Opcode.Binary) ? BitConverter.ToString(_rawData) : _rawData.UTF8Decode());
					_dataSet = true;
				}
				return _data;
			}
		}

		public bool IsBinary
		{
			get
			{
				return _opcode == Opcode.Binary;
			}
		}

		public bool IsPing
		{
			get
			{
				return _opcode == Opcode.Ping;
			}
		}

		public bool IsText
		{
			get
			{
				return _opcode == Opcode.Text;
			}
		}

		public byte[] RawData
		{
			get
			{
				return _rawData;
			}
		}

		[Obsolete("This property will be removed. Use any of the Is properties instead.")]
		public Opcode Type
		{
			get
			{
				return _opcode;
			}
		}

		internal MessageEventArgs(WebSocketFrame frame)
		{
			_opcode = frame.Opcode;
			_rawData = frame.PayloadData.ApplicationData;
		}

		internal MessageEventArgs(Opcode opcode, byte[] rawData)
		{
			if ((ulong)rawData.LongLength > PayloadData.MaxLength)
			{
				throw new WebSocketException(CloseStatusCode.TooBig);
			}
			_opcode = opcode;
			_rawData = rawData;
		}
	}
}
