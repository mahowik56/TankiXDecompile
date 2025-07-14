using System;
using System.Collections;
using System.Threading;
using log4net.Core;

namespace log4net.Appender
{
	public class RemotingAppender : BufferingAppenderSkeleton
	{
		public interface IRemoteLoggingSink
		{
			void LogEvents(LoggingEvent[] events);
		}

		private string m_sinkUrl;

		private IRemoteLoggingSink m_sinkObj;

		private int m_queuedCallbackCount;

		private ManualResetEvent m_workQueueEmptyEvent = new ManualResetEvent(true);

		public string Sink
		{
			get
			{
				return m_sinkUrl;
			}
			set
			{
				m_sinkUrl = value;
			}
		}

		public override void ActivateOptions()
		{
			base.ActivateOptions();
			IDictionary dictionary = new Hashtable();
			dictionary["typeFilterLevel"] = "Full";
			m_sinkObj = (IRemoteLoggingSink)Activator.GetObject(typeof(IRemoteLoggingSink), m_sinkUrl, dictionary);
		}

		protected override void SendBuffer(LoggingEvent[] events)
		{
			BeginAsyncSend();
			if (!ThreadPool.QueueUserWorkItem(SendBufferCallback, events))
			{
				EndAsyncSend();
				ErrorHandler.Error("RemotingAppender [" + base.Name + "] failed to ThreadPool.QueueUserWorkItem logging events in SendBuffer.");
			}
		}

		protected override void OnClose()
		{
			base.OnClose();
			if (!m_workQueueEmptyEvent.WaitOne(30000, false))
			{
				ErrorHandler.Error("RemotingAppender [" + base.Name + "] failed to send all queued events before close, in OnClose.");
			}
		}

		private void BeginAsyncSend()
		{
			m_workQueueEmptyEvent.Reset();
			Interlocked.Increment(ref m_queuedCallbackCount);
		}

		private void EndAsyncSend()
		{
			if (Interlocked.Decrement(ref m_queuedCallbackCount) <= 0)
			{
				m_workQueueEmptyEvent.Set();
			}
		}

		private void SendBufferCallback(object state)
		{
			try
			{
				LoggingEvent[] events = (LoggingEvent[])state;
				m_sinkObj.LogEvents(events);
			}
			catch (Exception e)
			{
				ErrorHandler.Error("Failed in SendBufferCallback", e);
			}
			finally
			{
				EndAsyncSend();
			}
		}
	}
}
