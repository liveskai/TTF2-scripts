global function getTeamCommand
global function getTeam
global function getTeamCMD

void function getTeamCommand() {
    #if SERVER
    AddClientCommandCallback("getteam", getTeamCMD);
    #endif
}

bool function getTeamCMD(entity player, array < string > args) {
    #if SERVER
	array<entity> players = GetPlayerArray()
    hadGift_Admin = false;
    CheckAdmin(player);
    if (hadGift_Admin != true) {
        Kprint( player, "未检测到管理员权限.");
        return true;
    }

    // if player only typed "gift"
    if (args.len() == 0) {
        Kprint( player, "至少输入一个有效的参数.");
        Kprint( player, "格式: getteam <playername> , ideally I made it so it can autofill for you.");
        // print every single player's name and their id
        int i = 0;
        foreach(entity p in GetPlayerArray()) {
            string playername = p.GetPlayerName();
            Kprint( player, "[" + i.tostring() + "] " + playername);
            i++
        }
        return true;
    }
    array < entity > sheep1 = [];
    // if player typed "announce somethinghere"
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


    if (args.len() > 1 )
	{
		Kprint( player, "只需输入一个参数.")
		return true;
	}
    CMDsender = player
    thread getTeam(sheep1)
    #endif
    return true;
}

void function getTeam(array < entity > player) {
    #if SERVER
    int i = 0;
    foreach(entity localPlayer in player)
	{
        string playername = localPlayer.GetPlayerName()
        if (localPlayer.GetTeam() == TEAM_MILITIA)
            Kprint( CMDsender, "[" + i.tostring() + "] " + playername + " 的队伍是反抗军(militita)." );
        if (localPlayer.GetTeam() == TEAM_IMC)
            Kprint( CMDsender, "[" + i.tostring() + "] " + playername + " 的队伍是IMC(imc)." );

        i++
    }
    #endif
}