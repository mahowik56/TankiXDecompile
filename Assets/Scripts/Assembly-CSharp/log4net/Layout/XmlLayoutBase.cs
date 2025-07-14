using System;
using System.IO;
using System.Xml;
using log4net.Core;
using log4net.Util;

namespace log4net.Layout
{
	public abstract class XmlLayoutBase : LayoutSkeleton
	{
		private bool m_locationInfo;

		private string m_invalidCharReplacement = "?";

		public bool LocationInfo
		{
			get
			{
				return m_locationInfo;
			}
			set
			{
				m_locationInfo = value;
			}
		}

		public string InvalidCharReplacement
		{
			get
			{
				return m_invalidCharReplacement;
			}
			set
			{
				m_invalidCharReplacement = value;
			}
		}

		public override string ContentType
		{
			get
			{
				return "text/xml";
			}
		}

		protected XmlLayoutBase()
			: this(false)
		{
			IgnoresException = false;
		}

		protected XmlLayoutBase(bool locationInfo)
		{
			IgnoresException = false;
			m_locationInfo = locationInfo;
		}

		public override void ActivateOptions()
		{
		}

		public override void Format(TextWriter writer, LoggingEvent loggingEvent)
		{
			if (loggingEvent == null)
			{
				throw new ArgumentNullException("loggingEvent");
			}
			XmlTextWriter xmlTextWriter = new XmlTextWriter(new ProtectCloseTextWriter(writer));
			xmlTextWriter.Formatting = Formatting.None;
			xmlTextWriter.Namespaces = false;
			FormatXml(xmlTextWriter, loggingEvent);
			xmlTextWriter.WriteWhitespace(SystemInfo.NewLine);
			xmlTextWriter.Close();
		}

		protected abstract void FormatXml(XmlWriter writer, LoggingEvent loggingEvent);
	}
}
