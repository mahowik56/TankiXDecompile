using log4net.Util;

namespace log4net.Core
{
	public class SecurityContextProvider
	{
		private static SecurityContextProvider s_defaultProvider = new SecurityContextProvider();

		public static SecurityContextProvider DefaultProvider
		{
			get
			{
				return s_defaultProvider;
			}
			set
			{
				s_defaultProvider = value;
			}
		}

		protected SecurityContextProvider()
		{
		}

		public virtual SecurityContext CreateSecurityContext(object consumer)
		{
			return NullSecurityContext.Instance;
		}
	}
}
