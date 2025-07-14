using System;

namespace WebSocketSharp
{
	public class CloseEventArgs : EventArgs
	{
		private bool _clean;

		private ushort _code;

		private PayloadData _payloadData;

		private string _reason;

		internal PayloadData PayloadData
		{
			get
			{
				return _payloadData ?? (_payloadData = new PayloadData(_code.Append(_reason)));
			}
		}

		public ushort Code
		{
			get
			{
				return _code;
			}
		}

		public string Reason
		{
			get
			{
				return _reason ?? string.Empty;
			}
		}

		public bool WasClean
		{
			get
			{
				return _clean;
			}
			internal set
			{
				_clean = value;
			}
		}

		internal CloseEventArgs()
		{
			_code = 1005;
			_payloadData = PayloadData.Empty;
		}

		internal CloseEventArgs(ushort code)
		{
			_code = code;
		}

		internal CloseEventArgs(CloseStatusCode code)
			: this((ushort)code)
		{
		}

		internal CloseEventArgs(PayloadData payloadData)
		{
			_payloadData = payloadData;
			byte[] applicationData = payloadData.ApplicationData;
			int num = applicationData.Length;
			_code = (ushort)((num <= 1) ? 1005 : applicationData.SubArray(0, 2).ToUInt16(ByteOrder.Big));
			_reason = ((num <= 2) ? string.Empty : applicationData.SubArray(2, num - 2).UTF8Decode());
		}

		internal CloseEventArgs(ushort code, string reason)
		{
			_code = code;
			_reason = reason;
		}

		internal CloseEventArgs(CloseStatusCode code, string reason)
			: this((ushort)code, reason)
		{
		}
	}
}
