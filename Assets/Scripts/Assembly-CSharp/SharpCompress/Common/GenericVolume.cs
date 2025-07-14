using System.IO;

namespace SharpCompress.Common
{
	public class GenericVolume : Volume
	{
		public override bool IsFirstVolume
		{
			get
			{
				return true;
			}
		}

		public override bool IsMultiVolume
		{
			get
			{
				return true;
			}
		}

		public GenericVolume(Stream stream, Options options)
			: base(stream, options)
		{
		}
	}
}
