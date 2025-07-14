using System;
using System.Collections.Generic;
using System.IO;
using Platform.System.Data.Statics.ClientYaml.API;
using YamlDotNet.Serialization;

namespace Platform.System.Data.Statics.ClientYaml.Impl
{
	public class YamlServiceImpl : YamlService
	{
		protected Serializer Serializer { get; set; }

		protected Deserializer Deserializer { get; set; }

		public YamlServiceImpl()
		{
			Serializer = new Serializer(SerializationOptions.None, new CamelToPascalCaseNamingConvention());
			Deserializer = new Deserializer(null, new PascalToCamelCaseNamingConvertion());
		}

		public string Dump(object data)
		{
			StringWriter stringWriter = new StringWriter();
			Serializer.Serialize(stringWriter, data);
			return stringWriter.ToString();
		}

		public void Dump(object data, FileInfo file)
		{
			using (FileStream stream = file.OpenWrite())
			{
				using (StreamWriter writer = new StreamWriter(stream))
				{
					Serializer.Serialize(writer, data);
				}
			}
		}

		public T Load<T>(FileInfo file)
		{
			using (FileStream stream = file.OpenRead())
			{
				using (StreamReader input = new StreamReader(stream))
				{
					return Deserializer.Deserialize<T>(input);
				}
			}
		}

		public T Load<T>(YamlNodeImpl node)
		{
			return (T)Load(node, typeof(T));
		}

		public virtual object Load(YamlNodeImpl node, Type type)
		{
			string data = Dump(node.innerDictionary);
			return Load(data, type);
		}

		public T Load<T>(string data)
		{
			StringReader input = new StringReader(data);
			return Deserializer.Deserialize<T>(input);
		}

		public T Load<T>(TextReader reader)
		{
			return Deserializer.Deserialize<T>(reader);
		}

		public object Load(string data, Type type)
		{
			StringReader input = new StringReader(data);
			return Deserializer.Deserialize(input, type);
		}

		public YamlNodeImpl Load(FileInfo file)
		{
			using (FileStream stream = file.OpenRead())
			{
				using (StreamReader data = new StreamReader(stream))
				{
					return Load(data);
				}
			}
		}

		public YamlNodeImpl Load(string data)
		{
			return Load(new StringReader(data));
		}

		public YamlNodeImpl Load(TextReader data)
		{
			object obj = Deserializer.Deserialize(data);
			return new YamlNodeImpl((Dictionary<object, object>)obj);
		}

		public void RegisterConverter(IYamlTypeConverter converter)
		{
			Serializer.RegisterTypeConverter(converter);
			Deserializer.RegisterTypeConverter(converter);
		}
	}
}
