using System;
using System.IO;
using System.Text;

namespace log4net.Util
{
	public abstract class TextWriterAdapter : TextWriter
	{
		private TextWriter m_writer;

		protected TextWriter Writer
		{
			get
			{
				return m_writer;
			}
			set
			{
				m_writer = value;
			}
		}

		public override Encoding Encoding
		{
			get
			{
				return m_writer.Encoding;
			}
		}

		public override IFormatProvider FormatProvider
		{
			get
			{
				return m_writer.FormatProvider;
			}
		}

		public override string NewLine
		{
			get
			{
				return m_writer.NewLine;
			}
			set
			{
				m_writer.NewLine = value;
			}
		}

		protected TextWriterAdapter(TextWriter writer)
		{
			m_writer = writer;
		}

		public override void Close()
		{
			m_writer.Close();
		}

		protected override void Dispose(bool disposing)
		{
			if (disposing)
			{
				((IDisposable)m_writer).Dispose();
			}
		}

		public override void Flush()
		{
			m_writer.Flush();
		}

		public override void Write(char value)
		{
			m_writer.Write(value);
		}

		public override void Write(char[] buffer, int index, int count)
		{
			m_writer.Write(buffer, index, count);
		}

		public override void Write(string value)
		{
			m_writer.Write(value);
		}
	}
}
