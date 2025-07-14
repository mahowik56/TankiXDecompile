using System;
using Platform.Library.ClientProtocol.API;

namespace Platform.Library.ClientProtocol.Impl
{
	public class EnumCodec : NotOptionalCodec
	{
		private readonly Type enumType;

		public EnumCodec(Type enumType)
		{
			this.enumType = enumType;
		}

		public override void Init(Protocol protocol)
		{
		}

		public override void Encode(ProtocolBuffer protocolBuffer, object data)
		{
			base.Encode(protocolBuffer, data);
			Enum obj = (Enum)data;
			if (obj.GetTypeCode() != TypeCode.Byte)
			{
				throw new UnsupportedEnumTypeCodeException(obj.GetTypeCode());
			}
			protocolBuffer.Writer.Write((byte)data);
		}

		public override object Decode(ProtocolBuffer protocolBuffer)
		{
			return Enum.ToObject(enumType, protocolBuffer.Reader.ReadByte());
		}
	}
}
