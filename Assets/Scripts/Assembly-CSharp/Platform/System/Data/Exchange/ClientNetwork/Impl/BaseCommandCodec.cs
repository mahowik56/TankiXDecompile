using Platform.Library.ClientProtocol.API;

namespace Platform.System.Data.Exchange.ClientNetwork.Impl
{
	public abstract class BaseCommandCodec<T> : CommandCodec, Codec where T : Command, new()
	{
		public abstract void Init(Protocol protocol);

		public abstract void Encode(ProtocolBuffer protocolBuffer, object data);

		public virtual object Decode(ProtocolBuffer protocolBuffer)
		{
			return new T();
		}

		public virtual void DecodeToInstance(ProtocolBuffer protocolBuffer, object instance)
		{
		}
	}
}
