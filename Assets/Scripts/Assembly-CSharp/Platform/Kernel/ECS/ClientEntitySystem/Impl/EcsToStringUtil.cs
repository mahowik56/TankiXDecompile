using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using Platform.Kernel.ECS.ClientEntitySystem.API;

namespace Platform.Kernel.ECS.ClientEntitySystem.Impl
{
	public class EcsToStringUtil
	{
		private static Type[] emptyTypes = new Type[0];

		public static string ToString(ICollection<Type> components)
		{
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.Append('[');
			bool flag = true;
			foreach (Type component in components)
			{
				if (flag)
				{
					flag = false;
				}
				else
				{
					stringBuilder.Append(',');
				}
				stringBuilder.Append(component.Name);
			}
			stringBuilder.Append(']');
			return stringBuilder.ToString();
		}

		public static string ToStringWithProperties(object obj, string delimeter = ", ")
		{
			string name = obj.GetType().Name;
			PropertyInfo[] properties = obj.GetType().GetProperties(BindingFlags.Instance | BindingFlags.Public | BindingFlags.FlattenHierarchy);
			if (properties.Length == 0)
			{
				return name;
			}
			name += " [";
			PropertyInfo propertyInfo = null;
			try
			{
				int num = 0;
				PropertyInfo[] array = properties;
				foreach (PropertyInfo propertyInfo2 in array)
				{
					num++;
					if (NeedShow(propertyInfo2))
					{
						propertyInfo = propertyInfo2;
						string text = name;
						name = text + propertyInfo2.Name + "=" + PropertyToString(obj, propertyInfo2);
						if (num < properties.Length)
						{
							name += delimeter;
						}
					}
				}
			}
			catch (Exception ex)
			{
				string text = name;
				name = text + ex.Message + " property=" + propertyInfo;
			}
			return name + "]";
		}

		public static object PropertyToString(object obj, PropertyInfo property)
		{
			object value = property.GetValue(obj, BindingFlags.Default, null, null, null);
			if (value == null)
			{
				return "null";
			}
			if (value is string)
			{
				return value;
			}
			if (typeof(IEnumerable).IsAssignableFrom(property.PropertyType) && !HasToStringMethod(property.PropertyType))
			{
				return EnumerableToString((IEnumerable)value, ",");
			}
			return value;
		}

		private static bool HasToStringMethod(Type type)
		{
			return type.GetMethod("ToString", emptyTypes).DeclaringType != typeof(object);
		}

		public static string EnumerableToString(IEnumerable enumerable)
		{
			return EnumerableToString(enumerable, ",");
		}

		public static string EnumerableToString(IEnumerable enumerable, string separator)
		{
			return enumerable.GetType().Name + EnumerableWithoutTypeToString(enumerable, separator);
		}

		public static string EnumerableWithoutTypeToString(IEnumerable enumerable, string separator)
		{
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.Append('[');
			int num = 0;
			foreach (object item in enumerable)
			{
				if (num > 0)
				{
					stringBuilder.Append(separator);
				}
				stringBuilder.Append(item);
				num++;
			}
			stringBuilder.Append(']');
			return stringBuilder.ToString();
		}

		private static bool NeedShow(PropertyInfo property)
		{
			if (!typeof(Component).IsAssignableFrom(property.DeclaringType))
			{
				return false;
			}
			bool flag = property.GetCustomAttributes(typeof(ObsoleteAttribute), false).Count() > 0;
			return !flag;
		}

		public static string ToString(Entity entity)
		{
			if (entity is EntityStub)
			{
				return "[EntityStub]";
			}
			return string.Format("[Name={0},\tid={1}]", entity.Name, entity.Id);
		}

		public static string ToStringWithComponents(EntityInternal entity)
		{
			if (entity is EntityStub)
			{
				return "[EntityStub]";
			}
			return string.Format("[{0},\t{1},\t{2}]", entity.Name, entity.Id, ToString(entity.ComponentClasses));
		}

		public static string ToString(Handler handler)
		{
			StringBuilder stringBuilder = new StringBuilder();
			MethodInfo method = handler.Method;
			string value = AttributesToString(method.GetCustomAttributes(true));
			stringBuilder.Append(value);
			stringBuilder.Append(" ");
			stringBuilder.Append(method.DeclaringType.Name + "." + method.Name);
			stringBuilder.Append("(" + ToString(method) + ")");
			stringBuilder.Append(" ");
			stringBuilder.Append("\n");
			return stringBuilder.ToString();
		}

		public static string ToString(MethodInfo method)
		{
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.Append(method.DeclaringType.Name).Append("::").Append(method.Name)
				.Append("(");
			ParameterInfo[] parameters = method.GetParameters();
			for (int i = 0; i < parameters.Length; i++)
			{
				ParameterInfo parameterInfo = parameters[i];
				if (i > 0)
				{
					stringBuilder.Append(", ");
				}
				object[] customAttributes = parameterInfo.GetCustomAttributes(true);
				if (customAttributes.Length > 0)
				{
					stringBuilder.Append(AttributesToString(customAttributes));
					stringBuilder.Append(" ");
				}
				if (parameterInfo.ParameterType.IsSubclassOf(typeof(ICollection)))
				{
					stringBuilder.Append("Collection<" + parameterInfo.ParameterType.GetGenericArguments()[0].Name + ">");
				}
				else
				{
					stringBuilder.Append(parameterInfo.ParameterType.Name);
				}
			}
			stringBuilder.Append(")");
			return stringBuilder.ToString();
		}

		public static string AttributesToString(object[] annotations)
		{
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.Append('[');
			bool flag = true;
			foreach (object obj in annotations)
			{
				if (flag)
				{
					flag = false;
				}
				else
				{
					stringBuilder.Append(',');
				}
				stringBuilder.Append(obj.GetType().Name);
			}
			stringBuilder.Append(']');
			return stringBuilder.ToString();
		}

		public static string ToString(ICollection<Handler> handlers)
		{
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.Append('[');
			bool flag = true;
			foreach (Handler handler in handlers)
			{
				if (flag)
				{
					flag = false;
				}
				else
				{
					stringBuilder.Append(',');
				}
				stringBuilder.Append(handler.Method.Name);
			}
			stringBuilder.Append(']');
			return stringBuilder.ToString();
		}

		public static object ToString(object[] objects)
		{
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.Append('[');
			bool flag = true;
			foreach (object value in objects)
			{
				if (flag)
				{
					flag = false;
				}
				else
				{
					stringBuilder.Append(',');
				}
				stringBuilder.Append(value);
			}
			stringBuilder.Append(']');
			return stringBuilder.ToString();
		}
	}
}
