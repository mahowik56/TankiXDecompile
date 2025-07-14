using System;
using System.Collections;
using System.Text;
using System.Xml;
using log4net.Core;
using log4net.Util;

namespace log4net.Layout
{
	public class XmlLayout : XmlLayoutBase
	{
		private string m_prefix = "log4net";

		private string m_elmEvent = "event";

		private string m_elmMessage = "message";

		private string m_elmData = "data";

		private string m_elmProperties = "properties";

		private string m_elmException = "exception";

		private string m_elmLocation = "locationInfo";

		private bool m_base64Message;

		private bool m_base64Properties;

		private const string PREFIX = "log4net";

		private const string ELM_EVENT = "event";

		private const string ELM_MESSAGE = "message";

		private const string ELM_PROPERTIES = "properties";

		private const string ELM_GLOBAL_PROPERTIES = "global-properties";

		private const string ELM_DATA = "data";

		private const string ELM_EXCEPTION = "exception";

		private const string ELM_LOCATION = "locationInfo";

		private const string ATTR_LOGGER = "logger";

		private const string ATTR_TIMESTAMP = "timestamp";

		private const string ATTR_LEVEL = "level";

		private const string ATTR_THREAD = "thread";

		private const string ATTR_DOMAIN = "domain";

		private const string ATTR_IDENTITY = "identity";

		private const string ATTR_USERNAME = "username";

		private const string ATTR_CLASS = "class";

		private const string ATTR_METHOD = "method";

		private const string ATTR_FILE = "file";

		private const string ATTR_LINE = "line";

		private const string ATTR_NAME = "name";

		private const string ATTR_VALUE = "value";

		public string Prefix
		{
			get
			{
				return m_prefix;
			}
			set
			{
				m_prefix = value;
			}
		}

		public bool Base64EncodeMessage
		{
			get
			{
				return m_base64Message;
			}
			set
			{
				m_base64Message = value;
			}
		}

		public bool Base64EncodeProperties
		{
			get
			{
				return m_base64Properties;
			}
			set
			{
				m_base64Properties = value;
			}
		}

		public XmlLayout()
		{
		}

		public XmlLayout(bool locationInfo)
			: base(locationInfo)
		{
		}

		public override void ActivateOptions()
		{
			base.ActivateOptions();
			if (m_prefix != null && m_prefix.Length > 0)
			{
				m_elmEvent = m_prefix + ":event";
				m_elmMessage = m_prefix + ":message";
				m_elmProperties = m_prefix + ":properties";
				m_elmData = m_prefix + ":data";
				m_elmException = m_prefix + ":exception";
				m_elmLocation = m_prefix + ":locationInfo";
			}
		}

		protected override void FormatXml(XmlWriter writer, LoggingEvent loggingEvent)
		{
			writer.WriteStartElement(m_elmEvent);
			writer.WriteAttributeString("logger", loggingEvent.LoggerName);
			writer.WriteAttributeString("timestamp", XmlConvert.ToString(loggingEvent.TimeStamp, XmlDateTimeSerializationMode.Local));
			writer.WriteAttributeString("level", loggingEvent.Level.DisplayName);
			writer.WriteAttributeString("thread", loggingEvent.ThreadName);
			if (loggingEvent.Domain != null && loggingEvent.Domain.Length > 0)
			{
				writer.WriteAttributeString("domain", loggingEvent.Domain);
			}
			if (loggingEvent.Identity != null && loggingEvent.Identity.Length > 0)
			{
				writer.WriteAttributeString("identity", loggingEvent.Identity);
			}
			if (loggingEvent.UserName != null && loggingEvent.UserName.Length > 0)
			{
				writer.WriteAttributeString("username", loggingEvent.UserName);
			}
			writer.WriteStartElement(m_elmMessage);
			if (!Base64EncodeMessage)
			{
				Transform.WriteEscapedXmlString(writer, loggingEvent.RenderedMessage, base.InvalidCharReplacement);
			}
			else
			{
				byte[] bytes = Encoding.UTF8.GetBytes(loggingEvent.RenderedMessage);
				string textData = Convert.ToBase64String(bytes, 0, bytes.Length);
				Transform.WriteEscapedXmlString(writer, textData, base.InvalidCharReplacement);
			}
			writer.WriteEndElement();
			PropertiesDictionary properties = loggingEvent.GetProperties();
			if (properties.Count > 0)
			{
				writer.WriteStartElement(m_elmProperties);
				foreach (DictionaryEntry item in (IEnumerable)properties)
				{
					writer.WriteStartElement(m_elmData);
					writer.WriteAttributeString("name", Transform.MaskXmlInvalidCharacters((string)item.Key, base.InvalidCharReplacement));
					string text = null;
					if (!Base64EncodeProperties)
					{
						text = Transform.MaskXmlInvalidCharacters(loggingEvent.Repository.RendererMap.FindAndRender(item.Value), base.InvalidCharReplacement);
					}
					else
					{
						byte[] bytes2 = Encoding.UTF8.GetBytes(loggingEvent.Repository.RendererMap.FindAndRender(item.Value));
						text = Convert.ToBase64String(bytes2, 0, bytes2.Length);
					}
					writer.WriteAttributeString("value", text);
					writer.WriteEndElement();
				}
				writer.WriteEndElement();
			}
			string exceptionString = loggingEvent.GetExceptionString();
			if (exceptionString != null && exceptionString.Length > 0)
			{
				writer.WriteStartElement(m_elmException);
				Transform.WriteEscapedXmlString(writer, exceptionString, base.InvalidCharReplacement);
				writer.WriteEndElement();
			}
			if (base.LocationInfo)
			{
				LocationInfo locationInformation = loggingEvent.LocationInformation;
				writer.WriteStartElement(m_elmLocation);
				writer.WriteAttributeString("class", locationInformation.ClassName);
				writer.WriteAttributeString("method", locationInformation.MethodName);
				writer.WriteAttributeString("file", locationInformation.FileName);
				writer.WriteAttributeString("line", locationInformation.LineNumber);
				writer.WriteEndElement();
			}
			writer.WriteEndElement();
		}
	}
}
