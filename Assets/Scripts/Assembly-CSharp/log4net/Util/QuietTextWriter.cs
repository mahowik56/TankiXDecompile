using System;
using System.IO;
using log4net.Core;

namespace log4net.Util
{
	public class QuietTextWriter : TextWriterAdapter
	{
		private IErrorHandler m_errorHandler;

		private bool m_closed;

		public IErrorHandler ErrorHandler
		{
			get
			{
				return m_errorHandler;
			}
			set
			{
				if (value == null)
				{
					throw new ArgumentNullException("value");
				}
				m_errorHandler = value;
			}
		}

		public bool Closed
		{
			get
			{
				return m_closed;
			}
		}

		public QuietTextWriter(TextWriter writer, IErrorHandler errorHandler)
			: base(writer)
		{
			if (errorHandler == null)
			{
				throw new ArgumentNullException("errorHandler");
			}
			ErrorHandler = errorHandler;
		}

		public override void Write(char value)
		{
			try
			{
				base.Write(value);
			}
			catch (Exception e)
			{
				m_errorHandler.Error("Failed to write [" + value + "].", e, ErrorCode.WriteFailure);
			}
		}

		public override void Write(char[] buffer, int index, int count)
		{
			try
			{
				base.Write(buffer, index, count);
			}
			catch (Exception e)
			{
				m_errorHandler.Error("Failed to write buffer.", e, ErrorCode.WriteFailure);
			}
		}

		public override void Write(string value)
		{
			try
			{
				base.Write(value);
			}
			catch (Exception e)
			{
				m_errorHandler.Error("Failed to write [" + value + "].", e, ErrorCode.WriteFailure);
			}
		}

		public override void Close()
		{
			m_closed = true;
			base.Close();
		}
	}
}
