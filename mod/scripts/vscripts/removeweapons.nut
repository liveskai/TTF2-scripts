global function RemoveWeaponsCommand
global function RemoveWeapon
global function RemoveWeaponsCMD

void function RemoveWeaponsCommand()
{
	#if SERVER
	AddClientCommandCallback("removeweapon", RemoveWeaponsCMD);
	AddClientCommandCallback("rw", RemoveWeaponsCMD);
	#endif
}

bool function RemoveWeaponsCMD(entity player, array<string> args)
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
		Kprint( player, "格式: removeweapon/rw <playerId> <playerId2> ... / imc / militia / all");
		Kprint( player, "注意这只能移除主武器");
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
	// if player typed "rw somethinghere"
	switch (args[0])
	{
		case ("all"):
			foreach (entity p in GetPlayerArray())
			{
				if (p != null)
					RemoveWeapon(p)
			}
		break;

		case ("imc"):
			foreach (entity p in GetPlayerArrayOfTeam( TEAM_IMC ))
			{
				if (p != null)
					RemoveWeapon(p)
			}
		break;

		case ("militia"):
			foreach (entity p in GetPlayerArrayOfTeam( TEAM_MILITIA ))
			{
				if (p != null)
					RemoveWeapon(p)
			}
		break;

		default:
			CheckPlayerName(args[0])
				foreach (entity p in successfulnames)
                    RemoveWeapon(p)
		break;
	}
	if (args.len() > 1) {
		array<string> playersname = args.slice(1);
		foreach (string playerId in playersname)
		{
			CheckPlayerName(playerId)
				foreach (entity p in successfulnames)
                    RemoveWeapon(p)
		}
	}
	#endif
	return true;
}

void function RemoveWeapon( entity player )
{
	#if SERVER
	array<entity> weapons = player.GetMainWeapons()
	foreach (entity weapon in weapons)
	{
		if (weapon == null)
			break;
		string weaponId = weapon.GetWeaponClassName()
		if (weapon != player.GetOffhandWeapon( OFFHAND_MELEE) ) {
			try
			{
				player.TakeWeaponNow(weaponId)
				Kprint( player, "移除了 " + player.GetPlayerName() + " 的武器!")
			} catch(exception)
			{
				Kprint( player, "无法取走 " + player.GetPlayerName() + " 的 " + weaponId + " !")
			}
		}
	}

	/*weapons = player.GetOffhandWeapons()
	foreach (entity weapon in weapons)
	{
		if (weapon == null)
			break;
		string weaponId = weapon.GetWeaponClassName()
		try
		{
			player.TakeWeaponNow(weaponId)
		} catch(exception)
		{
			Kprint( player, "Can't take " + player.GetPlayerName() + "'s " + weaponId + "!")
		}
	}*/
#endif
}
