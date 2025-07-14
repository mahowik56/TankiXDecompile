using System;
using System.Collections.Generic;
using System.Linq;
using Platform.Kernel.ECS.ClientEntitySystem.API;
using Tanks.Lobby.ClientCommunicator.Impl;

public class ChatCommands
{
	private class Command
	{
		public string CommandText;

		public int ParamsCount = 1;

		public Func<string[], Event> CreateEventFunc;
	}

	private static List<Command> CommandList = new List<Command>
	{
		new Command
		{
			CommandText = "/leave",
			ParamsCount = 0,
			CreateEventFunc = Leave
		},
		new Command
		{
			CommandText = "/invite",
			CreateEventFunc = Invite
		},
		new Command
		{
			CommandText = "/w",
			CreateEventFunc = CreatePersonal
		},
		new Command
		{
			CommandText = "/block",
			CreateEventFunc = Mute
		},
		new Command
		{
			CommandText = "/mute",
			CreateEventFunc = Mute
		},
		new Command
		{
			CommandText = "/unblock",
			CreateEventFunc = Unmute
		},
		new Command
		{
			CommandText = "/unmute",
			CreateEventFunc = Unmute
		},
		new Command
		{
			CommandText = "/kick",
			CreateEventFunc = Kick
		}
	};

	private static Event Leave(string[] parameters)
	{
		return new LeaveFromChatEvent();
	}

	private static Event Invite(string[] parameters)
	{
		InviteUserToChatEvent inviteUserToChatEvent = new InviteUserToChatEvent();
		inviteUserToChatEvent.UserUid = parameters[0];
		return inviteUserToChatEvent;
	}

	private static Event CreatePersonal(string[] parameters)
	{
		OpenPersonalChannelEvent openPersonalChannelEvent = new OpenPersonalChannelEvent();
		openPersonalChannelEvent.UserUid = parameters[0];
		return openPersonalChannelEvent;
	}

	private static Event Mute(string[] parameters)
	{
		MuteUserEvent muteUserEvent = new MuteUserEvent();
		muteUserEvent.UserUid = parameters[0];
		return muteUserEvent;
	}

	private static Event Unmute(string[] parameters)
	{
		UnmuteUserEvent unmuteUserEvent = new UnmuteUserEvent();
		unmuteUserEvent.UserUid = parameters[0];
		return unmuteUserEvent;
	}

	private static Event Kick(string[] parameters)
	{
		KickUserFromChatEvent kickUserFromChatEvent = new KickUserFromChatEvent();
		kickUserFromChatEvent.UserUid = parameters[0];
		return kickUserFromChatEvent;
	}

	public static bool IsCommand(string message, out Event commandEvent)
	{
		commandEvent = null;
		if (message.StartsWith("/"))
		{
			string[] array = message.Split(' ');
			foreach (Command command in CommandList)
			{
				if (array[0] == command.CommandText)
				{
					if (array.Length != command.ParamsCount + 1)
					{
						return false;
					}
					List<string> list = array.ToList();
					list.RemoveAt(0);
					commandEvent = command.CreateEventFunc(list.ToArray());
					return true;
				}
			}
		}
		return false;
	}
}
