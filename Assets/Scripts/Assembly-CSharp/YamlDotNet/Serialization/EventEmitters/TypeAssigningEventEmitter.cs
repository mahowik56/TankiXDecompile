using System;
using System.Globalization;
using YamlDotNet.Core;

namespace YamlDotNet.Serialization.EventEmitters
{
	public sealed class TypeAssigningEventEmitter : ChainedEventEmitter
	{
		private readonly bool _assignTypeWhenDifferent;

		public TypeAssigningEventEmitter(IEventEmitter nextEmitter, bool assignTypeWhenDifferent)
			: base(nextEmitter)
		{
			_assignTypeWhenDifferent = assignTypeWhenDifferent;
		}

		public override void Emit(ScalarEventInfo eventInfo)
		{
			ScalarStyle style = ScalarStyle.Plain;
			TypeCode typeCode = ((eventInfo.Source.Value != null) ? eventInfo.Source.Type.GetTypeCode() : TypeCode.Empty);
			switch (typeCode)
			{
			case TypeCode.Boolean:
				eventInfo.Tag = "tag:yaml.org,2002:bool";
				eventInfo.RenderedValue = YamlFormatter.FormatBoolean(eventInfo.Source.Value);
				break;
			case TypeCode.SByte:
			case TypeCode.Byte:
			case TypeCode.Int16:
			case TypeCode.UInt16:
			case TypeCode.Int32:
			case TypeCode.UInt32:
			case TypeCode.Int64:
			case TypeCode.UInt64:
				eventInfo.Tag = "tag:yaml.org,2002:int";
				eventInfo.RenderedValue = YamlFormatter.FormatNumber(eventInfo.Source.Value);
				break;
			case TypeCode.Single:
				eventInfo.Tag = "tag:yaml.org,2002:float";
				eventInfo.RenderedValue = YamlFormatter.FormatNumber((float)eventInfo.Source.Value);
				break;
			case TypeCode.Double:
				eventInfo.Tag = "tag:yaml.org,2002:float";
				eventInfo.RenderedValue = YamlFormatter.FormatNumber((double)eventInfo.Source.Value);
				break;
			case TypeCode.Decimal:
				eventInfo.Tag = "tag:yaml.org,2002:float";
				eventInfo.RenderedValue = YamlFormatter.FormatNumber(eventInfo.Source.Value);
				break;
			case TypeCode.Char:
			case TypeCode.String:
				eventInfo.Tag = "tag:yaml.org,2002:str";
				eventInfo.RenderedValue = eventInfo.Source.Value.ToString();
				style = ScalarStyle.Any;
				break;
			case TypeCode.DateTime:
				eventInfo.Tag = "tag:yaml.org,2002:timestamp";
				eventInfo.RenderedValue = YamlFormatter.FormatDateTime(eventInfo.Source.Value);
				break;
			case TypeCode.Empty:
				eventInfo.Tag = "tag:yaml.org,2002:null";
				eventInfo.RenderedValue = string.Empty;
				break;
			default:
				if (eventInfo.Source.Type == typeof(TimeSpan))
				{
					eventInfo.RenderedValue = YamlFormatter.FormatTimeSpan(eventInfo.Source.Value);
					break;
				}
				throw new NotSupportedException(string.Format(CultureInfo.InvariantCulture, "TypeCode.{0} is not supported.", typeCode));
			}
			eventInfo.IsPlainImplicit = true;
			if (eventInfo.Style == ScalarStyle.Any)
			{
				eventInfo.Style = style;
			}
			base.Emit(eventInfo);
		}

		public override void Emit(MappingStartEventInfo eventInfo)
		{
			AssignTypeIfDifferent(eventInfo);
			base.Emit(eventInfo);
		}

		public override void Emit(SequenceStartEventInfo eventInfo)
		{
			AssignTypeIfDifferent(eventInfo);
			base.Emit(eventInfo);
		}

		private void AssignTypeIfDifferent(ObjectEventInfo eventInfo)
		{
			if (_assignTypeWhenDifferent && eventInfo.Source.Value != null && eventInfo.Source.Type != eventInfo.Source.StaticType)
			{
				eventInfo.Tag = "!" + eventInfo.Source.Type.AssemblyQualifiedName;
			}
		}
	}
}
