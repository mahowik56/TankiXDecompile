using System.Collections;
using System.Globalization;
using System.IO;
using System.Text;
using log4net.Repository;

namespace log4net.Util
{
	public abstract class PatternConverter
	{
		private static readonly string[] SPACES = new string[6] { " ", "  ", "    ", "        ", "                ", "                                " };

		private PatternConverter m_next;

		private int m_min = -1;

		private int m_max = int.MaxValue;

		private bool m_leftAlign;

		private string m_option;

		private ReusableStringWriter m_formatWriter = new ReusableStringWriter(CultureInfo.InvariantCulture);

		private const int c_renderBufferSize = 256;

		private const int c_renderBufferMaxCapacity = 1024;

		private PropertiesDictionary properties;

		public virtual PatternConverter Next
		{
			get
			{
				return m_next;
			}
		}

		public virtual FormattingInfo FormattingInfo
		{
			get
			{
				return new FormattingInfo(m_min, m_max, m_leftAlign);
			}
			set
			{
				m_min = value.Min;
				m_max = value.Max;
				m_leftAlign = value.LeftAlign;
			}
		}

		public virtual string Option
		{
			get
			{
				return m_option;
			}
			set
			{
				m_option = value;
			}
		}

		public PropertiesDictionary Properties
		{
			get
			{
				return properties;
			}
			set
			{
				properties = value;
			}
		}

		protected abstract void Convert(TextWriter writer, object state);

		public virtual PatternConverter SetNext(PatternConverter patternConverter)
		{
			m_next = patternConverter;
			return m_next;
		}

		public virtual void Format(TextWriter writer, object state)
		{
			if (m_min < 0 && m_max == int.MaxValue)
			{
				Convert(writer, state);
				return;
			}
			string value = null;
			int num;
			lock (m_formatWriter)
			{
				m_formatWriter.Reset(1024, 256);
				Convert(m_formatWriter, state);
				StringBuilder stringBuilder = m_formatWriter.GetStringBuilder();
				num = stringBuilder.Length;
				if (num > m_max)
				{
					value = stringBuilder.ToString(num - m_max, m_max);
					num = m_max;
				}
				else
				{
					value = stringBuilder.ToString();
				}
			}
			if (num < m_min)
			{
				if (m_leftAlign)
				{
					writer.Write(value);
					SpacePad(writer, m_min - num);
				}
				else
				{
					SpacePad(writer, m_min - num);
					writer.Write(value);
				}
			}
			else
			{
				writer.Write(value);
			}
		}

		protected static void SpacePad(TextWriter writer, int length)
		{
			while (length >= 32)
			{
				writer.Write(SPACES[5]);
				length -= 32;
			}
			for (int num = 4; num >= 0; num--)
			{
				if ((length & (1 << num)) != 0)
				{
					writer.Write(SPACES[num]);
				}
			}
		}

		protected static void WriteDictionary(TextWriter writer, ILoggerRepository repository, IDictionary value)
		{
			WriteDictionary(writer, repository, value.GetEnumerator());
		}

		protected static void WriteDictionary(TextWriter writer, ILoggerRepository repository, IDictionaryEnumerator value)
		{
			writer.Write("{");
			bool flag = true;
			while (value.MoveNext())
			{
				if (flag)
				{
					flag = false;
				}
				else
				{
					writer.Write(", ");
				}
				WriteObject(writer, repository, value.Key);
				writer.Write("=");
				WriteObject(writer, repository, value.Value);
			}
			writer.Write("}");
		}

		protected static void WriteObject(TextWriter writer, ILoggerRepository repository, object value)
		{
			if (repository != null)
			{
				repository.RendererMap.FindAndRender(value, writer);
			}
			else if (value == null)
			{
				writer.Write(SystemInfo.NullText);
			}
			else
			{
				writer.Write(value.ToString());
			}
		}
	}
}
