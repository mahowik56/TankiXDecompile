using System;
using System.Collections;
using log4net.Core;

namespace log4net.Util
{
	public sealed class ThreadContextStack : IFixingRequired
	{
		private sealed class StackFrame
		{
			private readonly string m_message;

			private readonly StackFrame m_parent;

			private string m_fullMessage;

			internal string Message
			{
				get
				{
					return m_message;
				}
			}

			internal string FullMessage
			{
				get
				{
					if (m_fullMessage == null && m_parent != null)
					{
						m_fullMessage = m_parent.FullMessage + " " + m_message;
					}
					return m_fullMessage;
				}
			}

			internal StackFrame(string message, StackFrame parent)
			{
				m_message = message;
				m_parent = parent;
				if (parent == null)
				{
					m_fullMessage = message;
				}
			}
		}

		private struct AutoPopStackFrame : IDisposable
		{
			private Stack m_frameStack;

			private int m_frameDepth;

			internal AutoPopStackFrame(Stack frameStack, int frameDepth)
			{
				m_frameStack = frameStack;
				m_frameDepth = frameDepth;
			}

			public void Dispose()
			{
				if (m_frameDepth >= 0 && m_frameStack != null)
				{
					while (m_frameStack.Count > m_frameDepth)
					{
						m_frameStack.Pop();
					}
				}
			}
		}

		private Stack m_stack = new Stack();

		public int Count
		{
			get
			{
				return m_stack.Count;
			}
		}

		internal Stack InternalStack
		{
			get
			{
				return m_stack;
			}
			set
			{
				m_stack = value;
			}
		}

		internal ThreadContextStack()
		{
		}

		public void Clear()
		{
			m_stack.Clear();
		}

		public string Pop()
		{
			Stack stack = m_stack;
			if (stack.Count > 0)
			{
				return ((StackFrame)stack.Pop()).Message;
			}
			return string.Empty;
		}

		public IDisposable Push(string message)
		{
			Stack stack = m_stack;
			stack.Push(new StackFrame(message, (stack.Count <= 0) ? null : ((StackFrame)stack.Peek())));
			return new AutoPopStackFrame(stack, stack.Count - 1);
		}

		internal string GetFullMessage()
		{
			Stack stack = m_stack;
			if (stack.Count > 0)
			{
				return ((StackFrame)stack.Peek()).FullMessage;
			}
			return null;
		}

		public override string ToString()
		{
			return GetFullMessage();
		}

		object IFixingRequired.GetFixedObject()
		{
			return GetFullMessage();
		}
	}
}
