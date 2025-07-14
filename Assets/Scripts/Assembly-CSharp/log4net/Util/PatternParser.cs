using System;
using System.Collections;
using System.Globalization;
using log4net.Core;

namespace log4net.Util
{
	public sealed class PatternParser
	{
		private sealed class StringLengthComparer : IComparer
		{
			public static readonly StringLengthComparer Instance = new StringLengthComparer();

			private StringLengthComparer()
			{
			}

			public int Compare(object x, object y)
			{
				string text = x as string;
				string text2 = y as string;
				if (text == null && text2 == null)
				{
					return 0;
				}
				if (text == null)
				{
					return 1;
				}
				if (text2 == null)
				{
					return -1;
				}
				return text2.Length.CompareTo(text.Length);
			}
		}

		private const char ESCAPE_CHAR = '%';

		private PatternConverter m_head;

		private PatternConverter m_tail;

		private string m_pattern;

		private Hashtable m_patternConverters = new Hashtable();

		private static readonly Type declaringType = typeof(PatternParser);

		public Hashtable PatternConverters
		{
			get
			{
				return m_patternConverters;
			}
		}

		public PatternParser(string pattern)
		{
			m_pattern = pattern;
		}

		public PatternConverter Parse()
		{
			string[] matches = BuildCache();
			ParseInternal(m_pattern, matches);
			return m_head;
		}

		private string[] BuildCache()
		{
			string[] array = new string[m_patternConverters.Keys.Count];
			m_patternConverters.Keys.CopyTo(array, 0);
			Array.Sort(array, 0, array.Length, StringLengthComparer.Instance);
			return array;
		}

		private void ParseInternal(string pattern, string[] matches)
		{
			int i = 0;
			while (i < pattern.Length)
			{
				int num = pattern.IndexOf('%', i);
				if (num < 0 || num == pattern.Length - 1)
				{
					ProcessLiteral(pattern.Substring(i));
					i = pattern.Length;
					continue;
				}
				if (pattern[num + 1] == '%')
				{
					ProcessLiteral(pattern.Substring(i, num - i + 1));
					i = num + 2;
					continue;
				}
				ProcessLiteral(pattern.Substring(i, num - i));
				i = num + 1;
				FormattingInfo formattingInfo = new FormattingInfo();
				if (i < pattern.Length && pattern[i] == '-')
				{
					formattingInfo.LeftAlign = true;
					i++;
				}
				for (; i < pattern.Length && char.IsDigit(pattern[i]); i++)
				{
					if (formattingInfo.Min < 0)
					{
						formattingInfo.Min = 0;
					}
					formattingInfo.Min = formattingInfo.Min * 10 + int.Parse(pattern[i].ToString(CultureInfo.InvariantCulture), NumberFormatInfo.InvariantInfo);
				}
				if (i < pattern.Length && pattern[i] == '.')
				{
					i++;
				}
				for (; i < pattern.Length && char.IsDigit(pattern[i]); i++)
				{
					if (formattingInfo.Max == int.MaxValue)
					{
						formattingInfo.Max = 0;
					}
					formattingInfo.Max = formattingInfo.Max * 10 + int.Parse(pattern[i].ToString(CultureInfo.InvariantCulture), NumberFormatInfo.InvariantInfo);
				}
				int num2 = pattern.Length - i;
				for (int j = 0; j < matches.Length; j++)
				{
					if (matches[j].Length > num2 || string.Compare(pattern, i, matches[j], 0, matches[j].Length, false, CultureInfo.InvariantCulture) != 0)
					{
						continue;
					}
					i += matches[j].Length;
					string option = null;
					if (i < pattern.Length && pattern[i] == '{')
					{
						i++;
						int num3 = pattern.IndexOf('}', i);
						if (num3 >= 0)
						{
							option = pattern.Substring(i, num3 - i);
							i = num3 + 1;
						}
					}
					ProcessConverter(matches[j], option, formattingInfo);
					break;
				}
			}
		}

		private void ProcessLiteral(string text)
		{
			if (text.Length > 0)
			{
				ProcessConverter("literal", text, new FormattingInfo());
			}
		}

		private void ProcessConverter(string converterName, string option, FormattingInfo formattingInfo)
		{
			LogLog.Debug(declaringType, "Converter [" + converterName + "] Option [" + option + "] Format [min=" + formattingInfo.Min + ",max=" + formattingInfo.Max + ",leftAlign=" + formattingInfo.LeftAlign + "]");
			ConverterInfo converterInfo = (ConverterInfo)m_patternConverters[converterName];
			if (converterInfo == null)
			{
				LogLog.Error(declaringType, "Unknown converter name [" + converterName + "] in conversion pattern.");
				return;
			}
			PatternConverter patternConverter = null;
			try
			{
				patternConverter = (PatternConverter)Activator.CreateInstance(converterInfo.Type);
			}
			catch (Exception ex)
			{
				LogLog.Error(declaringType, "Failed to create instance of Type [" + converterInfo.Type.FullName + "] using default constructor. Exception: " + ex.ToString());
			}
			patternConverter.FormattingInfo = formattingInfo;
			patternConverter.Option = option;
			patternConverter.Properties = converterInfo.Properties;
			IOptionHandler optionHandler = patternConverter as IOptionHandler;
			if (optionHandler != null)
			{
				optionHandler.ActivateOptions();
			}
			AddConverter(patternConverter);
		}

		private void AddConverter(PatternConverter pc)
		{
			if (m_head == null)
			{
				m_head = (m_tail = pc);
			}
			else
			{
				m_tail = m_tail.SetNext(pc);
			}
		}
	}
}
