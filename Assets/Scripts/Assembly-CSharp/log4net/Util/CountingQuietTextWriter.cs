using System;
using System.IO;
using log4net.Core;

namespace log4net.Util
{
	public class CountingQuietTextWriter : QuietTextWriter
	{
		private long m_countBytes;

		public long Count
		{
			get
			{
				return m_countBytes;
			}
			set
			{
				m_countBytes = value;
			}
		}

		public CountingQuietTextWriter(TextWriter writer, IErrorHandler errorHandler)
			: base(writer, errorHandler)
		{
			m_countBytes = 0L;
		}

		public override void Write(char value)
		{
			try
			{
				base.Write(value);
				m_countBytes += Encoding.GetByteCount(new char[1] { value });
			}
			catch (Exception e)
			{
				base.ErrorHandler.Error("Failed to write [" + value + "].", e, ErrorCode.WriteFailure);
			}
		}

		public override void Write(char[] buffer, int index, int count)
		{
			if (count > 0)
			{
				try
				{
					base.Write(buffer, index, count);
					m_countBytes += Encoding.GetByteCount(buffer, index, count);
				}
				catch (Exception e)
				{
					base.ErrorHandler.Error("Failed to write buffer.", e, ErrorCode.WriteFailure);
				}
			}
		}

		public override void Write(string str)
		{
			if (str != null && str.Length > 0)
			{
				try
				{
					base.Write(str);
					m_countBytes += Encoding.GetByteCount(str);
				}
				catch (Exception e)
				{
					base.ErrorHandler.Error("Failed to write [" + str + "].", e, ErrorCode.WriteFailure);
				}
			}
		}
	}
}
