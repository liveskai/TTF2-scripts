global function Mod
global function PrintWeaponMods
global function GiveWM
global function GiveWMWait
global function GiveWeaponMod
global bool bypassPerms = false;

void function Mod()
{
	#if SERVER
	AddClientCommandCallback("mod", GiveWMWait);
	#endif
}

void function PrintWeaponMods(entity weapon)
{
	#if SERVER
	array<string> amods = GetWeaponMods_Global( weapon.GetWeaponClassName() );
	for( int i = 0; i < amods.len(); ++i )
	{
		string modId = amods[i]
		Kprint( CMDsender, "[" + i.tostring() + "] " + modId);
	}
	#endif
}

bool function GiveWMWait(entity player, array<string> args)
{
	#if SERVER
	thread GiveWM(player, args)
	#endif
	return true;
}

bool function GiveWM(entity player, array<string> args)
{
	#if SERVER
	if (player == null)
		return true;

	hadGift_Admin = false;
	CheckAdmin(player);
	if (hadGift_Admin != true && bypassPerms != true)
	{
		Kprint( player, "未检测到管理员权限.");
		return true;
	}
	entity weapon = player.GetActiveWeapon();

	if(weapon != null)
	{
		array<string> amods = GetWeaponMods_Global( weapon.GetWeaponClassName() );
		string modId = "";

		if (args.len() == 0)
		{
			Kprint( player, "请输入有效的配件ID.");
			Kprint( player, "不能输入多于四个配件.");
			Kprint( player, "你可以通过输入同样的配件ID来去除该配件.");
			CMDsender = player
			PrintWeaponMods(weapon);
			return true;
		}

		string newString = "";

		foreach (string newmodId in args)
		{
			try
			{
				int a = newmodId.tointeger();
				modId = amods[a];
			} catch(exception2)
			{
				Kprint( player, "错误: 未知ID, 假定其为配件ID.");
			}
			weapon = player.GetActiveWeapon();
			GiveWeaponMod(player, modId, weapon)
			newString += (modId + " ");
		}
		Kprint( player, "给予 " + player.GetPlayerName() + " 的配件ID为 " + newString);
		bypassPerms = false;
	} else {
		Kprint( player, "不可用的武器.");
		return true;
	}
	return true;
	#endif
}

void function GiveWeaponMod(entity player, string modId, entity weapon)
{
	#if SERVER
		string weaponId = weapon.GetWeaponClassName();
		bool removed = false;
		array<string> mods = weapon.GetMods();

		// checks if the mods is already on the weapon
		for( int i = 0; i < mods.len(); ++i )
		{
			if( mods[i] == modId )
			{
				mods.remove( i );
				removed = true;
				break;
			}
		}
		if( !removed )
		{
			if (mods.len() < 5 || modId.find("burn_mod") != -1)
				mods.append( modId ); // catch more than 4 mods
			else if (mods.len() > 4) {
				Kprint( player, "错误: 多余四个配件. 试着移除一些.");
				return;
			}
		}
		player.TakeWeaponNow( weaponId );
		try {
			player.GiveWeapon( weaponId, mods );
		} catch(exception2) {
			Kprint( player, "错误: 配件冲突.");
			for( int i = 0; i < mods.len(); ++i )
			{
				if( mods[i] == modId )
				{
					mods.remove( i );
					removed = true;
					break;
				}
			}
			player.GiveWeapon( weaponId, mods);
		}
		player.SetActiveWeaponByName( weaponId );
	#endif
}
