using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace YamlDotNet.Serialization
{
	public sealed class YamlAttributeOverrides
	{
		private readonly Dictionary<Type, Dictionary<string, List<Attribute>>> overrides = new Dictionary<Type, Dictionary<string, List<Attribute>>>();

		public ICollection<Attribute> this[Type type, string member]
		{
			get
			{
				Dictionary<string, List<Attribute>> value;
				if (!overrides.TryGetValue(type, out value))
				{
					return null;
				}
				List<Attribute> value2;
				if (!value.TryGetValue(member, out value2))
				{
					return null;
				}
				return value2;
			}
		}

		public T GetAttribute<T>(Type type, string member) where T : Attribute
		{
			ICollection<Attribute> collection = this[type, member];
			return (collection != null) ? collection.OfType<T>().FirstOrDefault() : ((T)null);
		}

		public void Add(Type type, string member, Attribute attribute)
		{
			Dictionary<string, List<Attribute>> value;
			if (!overrides.TryGetValue(type, out value))
			{
				value = new Dictionary<string, List<Attribute>>();
				overrides.Add(type, value);
			}
			List<Attribute> value2;
			if (!value.TryGetValue(member, out value2))
			{
				value2 = new List<Attribute>();
				value.Add(member, value2);
			}
			if (value2.Any((Attribute attr) => attr.GetType().IsInstanceOf(attribute)))
			{
				throw new InvalidOperationException(string.Format(CultureInfo.InvariantCulture, "Attribute ({3}) already set for Type {0}, Member {1}", type.FullName, member, attribute));
			}
			value2.Add(attribute);
		}
	}
}
