global function TeleportCommand
global function Teleport
global function TeleportCMD

void function TeleportCommand()
{
	#if SERVER
	AddClientCommandCallback("teleport", TeleportCMD);
	AddClientCommandCallback("tp", TeleportCMD);
	#endif
}

bool function TeleportCMD(entity player, array<string> args)
{
	#if SERVER
	entity weapon = null;
	string weaponId = ("");
	array<entity> players = GetPlayerArray();
	hadGift_Admin = false;
	CheckAdmin(player);
	if (hadGift_Admin != true)
	{
		Kprint( player, "未检测到管理员权限.");
		return true;
	}

	// if player only typed "gift"
	if (args.len() == 0)
	{
		Kprint( player, "至少输入一个有效的参数.");
		Kprint( player, "格式: teleport/tp <playerId1> <playerId2> / imc / militia / all / crosshair");
		Kprint( player, "例: teleport/tp all 0, 将所有玩家传送至0号玩家的位置")
		Kprint( player, "Example: teleport/tp 4 crosshair, 将4号玩家传送至你的准星所指位置")
		Kprint( player, "Example: teleport/tp 0 all, 不可用，无法将0号玩家传送到多名玩家的位置")
		// print every single player's name and their id
		int i = 0;
		foreach (entity p in GetPlayerArray())
		{
			string playername = p.GetPlayerName();
			Kprint( player, "[" + i.tostring() + "] " + playername);
			i++
		}
		return true;
	}

	array<entity> sheep1 = [];
	entity sheep2 = null;

	// if player typed "Teleport somethinghere"
	switch (args[0])
	{
		case ("all"):
			foreach (entity p in GetPlayerArray())
			{
				if (p != null) {
					sheep1.append(p);
					Kprint( player, "添加 " + p.GetPlayerName());
				}
			}
		break;

		case ("imc"):
			foreach (entity p in GetPlayerArrayOfTeam( TEAM_IMC ))
			{
				if (p != null)
					sheep1.append(p);
			}
		break;

		case ("militia"):
			foreach (entity p in GetPlayerArrayOfTeam( TEAM_MILITIA ))
			{
				if (p != null)
					sheep1.append(p);
			}
		break;

		case ("crosshair"):
			Kprint( player, "你应该把 crosshair 放到第二个参数的位置")
			return true;
		break;

		default:
            CheckPlayerName(args[0])
				foreach (entity p in successfulnames)
                    sheep1.append(p)
		break;
	}

	if (args.len() == 1)
	{
		print ("2 arguments required.")
		return true;
	}
	bool useCrosshair = false
	switch (args[1])
	{
		case ("all"):
			Kprint( player, "兄啊你可不能把所有人都传送到多个目标位置.")
			return true;
		break;

		case ("imc"):
			Kprint( player, "兄啊你可不能把所有人都传送到多个目标位置.")
			return true;

		break;

		case ("militia"):
			Kprint( player, "兄啊你可不能把所有人都传送到多个目标位置.")
			return true;

		break;

		case ("crosshair"):
			useCrosshair = true;
			sheep2 = player
		break;

		default:
            CheckPlayerName(args[1])
				foreach (entity p in successfulnames)
            		sheep2 = p
		break;
	}
	if (args.len() > 2 )
	{
		Kprint( player, "只能输入两个参数.")
		return true;
	}
	CMDsender = player
	Teleport(sheep1, sheep2, useCrosshair)
	#endif
	return true;
}

void function Teleport( array<entity> player1 , entity player2 , bool useCrosshair )
{
	if (IsAlive(player2))
	{
		vector origin = GetPlayerCrosshairOrigin( player2 );
		vector angles = player2.EyeAngles();
		angles.x = 0;
		angles.z = 0;

	#if SERVER
		foreach (entity sheep in player1)
		{
			if (useCrosshair)
			{
				Kprint( CMDsender, "将 " + sheep.GetPlayerName() + " 移动至你的准星.")

				vector spawnPos = origin;
				vector spawnAng = angles;

				sheep.SetOrigin(origin)
				sheep.SetAngles(spawnAng)
			}
			else
			{
				vector origin = player2.GetOrigin();
				vector angles = player2.EyeAngles();

				sheep.SetOrigin(origin)
				sheep.SetAngles(angles)
				Kprint( CMDsender, "将 " + sheep.GetPlayerName() + " 移动至 " + player2.GetPlayerName() + " 的位置.")
			}
		}
	}
	return;
#endif
}
