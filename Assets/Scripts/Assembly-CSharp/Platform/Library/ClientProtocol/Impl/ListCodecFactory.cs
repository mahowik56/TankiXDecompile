using System;
using System.Collections.Generic;
using Platform.Library.ClientProtocol.API;

namespace Platform.Library.ClientProtocol.Impl
{
	public class ListCodecFactory : CodecFactory
	{
		public Codec CreateCodec(Protocol protocol, CodecInfoWithAttributes codecInfoWithAttrs)
		{
			Type type = codecInfoWithAttrs.Info.type;
			if (type.IsGenericType && type.GetGenericTypeDefinition() == typeof(List<>))
			{
				Type type2 = type.GetGenericArguments()[0];
				bool optional = false;
				bool varied = false;
				if (codecInfoWithAttrs.IsAttributePresent<ProtocolCollectionAttribute>())
				{
					ProtocolCollectionAttribute attribute = codecInfoWithAttrs.GetAttribute<ProtocolCollectionAttribute>();
					optional = attribute.Optional;
					varied = attribute.Varied;
				}
				CodecInfoWithAttributes elementCodecInfo = new CodecInfoWithAttributes(type2, optional, varied);
				return new ListCodec(type, elementCodecInfo);
			}
			return null;
		}
	}
}
