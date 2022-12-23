global function HealthCommand
global function Health
global function HealthCMD

void function HealthCommand() {
    #if SERVER
    AddClientCommandCallback("health", HealthCMD);
    AddClientCommandCallback("hp", HealthCMD);
    #endif
}

bool function HealthCMD(entity player, array < string > args) {
    #if SERVER
	array<entity> players = GetPlayerArray()
    hadGift_Admin = false;
    CheckAdmin(player);
    if (hadGift_Admin != true) {
        Kprint( player, "未检测到管理员权限.");
        return true;
    }

    // if player only typed "health"
    if (args.len() == 0) {
        Kprint( player, "至少输入一个有效的参数.");
        Kprint( player, "格式: health/hp <playerId> <value> , playerId = imc / militia / all");
        // print every single player's name and their id
        int i = 0;
        foreach(entity p in GetPlayerArray()) {
            string playername = p.GetPlayerName();
            Kprint( player, "[" + i.tostring() + "] " + playername);
            i++
        }
        return true;
    }
	string playername = player.GetPlayerName()
    array < entity > sheep1 = [];
    // if player typed "health somethinghere"
    switch (args[0]) {
        case ("all"):
            foreach(entity p in GetPlayerArray()) {
                if (p != null)
                    sheep1.append(p)
            }
            break;

        case ("imc"):
            foreach(entity p in GetPlayerArrayOfTeam(TEAM_IMC)) {
                if (p != null)
                    sheep1.append(p)
            }
            break;

        case ("militia"):
            foreach(entity p in GetPlayerArrayOfTeam(TEAM_MILITIA)) {
                if (p != null)
                    sheep1.append(p)
            }
            break;

        default:
            CheckPlayerName(args[0])
                foreach (entity p in successfulnames)
                    sheep1.append(p)
            break;
    }

    // if player typed "gift correctId" with no further arguments
    if (args.len() == 1) {
        GetHealth(sheep1)
        return true;
    }
    int value = 1;
     if (args.len() > 1) {
        value = args[1].tointeger()
    }

    if (args.len() > 2 )
	{
		Kprint( player, "只需输入两个参数.")
		return true;
	}
    CMDsender = player
    thread Health(sheep1, value)
    #endif
    return true;
}

void function Health(array < entity > player, int value) {
    #if SERVER
    foreach(entity localPlayer in player)
	{
        if (IsAlive(localPlayer))
        {
        if (value > 524287)
            value = 524286
        if (!localPlayer.IsTitan())
        {
		    localPlayer.SetMaxHealth(value)
            localPlayer.SetHealth(value)
		    Kprint( CMDsender, "设定 " + localPlayer.GetPlayerName() + " 的生命值为: " + localPlayer.GetHealth())
        } else
        {
            int oldvalue = value
            if (value < 2500)
                value = 2500
            localPlayer.SetMaxHealth(value)
            localPlayer.SetHealth(oldvalue)
		    Kprint( CMDsender, "设定 " + localPlayer.GetPlayerName() + " 的泰坦生命值为: " + localPlayer.GetHealth())
        }
        }
    }
    #endif
}

void function GetHealth(array < entity > player) {
    #if SERVER
    foreach(entity localPlayer in player)
	{
        if (IsAlive(localPlayer))
        {
        if (!localPlayer.IsTitan())
		    Kprint( CMDsender, localPlayer.GetPlayerName() + " 的生命值: " + localPlayer.GetHealth())
        else
		    Kprint( CMDsender, localPlayer.GetPlayerName() + " 的泰坦生命值: " + localPlayer.GetHealth())
        }
    }
    #endif
}