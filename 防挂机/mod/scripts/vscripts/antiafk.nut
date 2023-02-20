untyped
global function antiafkInit

void function antiafkInit() {
    AddPrivateMatchModeSettingArbitrary("#MODE_SETTING_CATEGORY_SERVERTOOLS", "antiafk_grace", "60.0" )
    AddPrivateMatchModeSettingArbitrary("#MODE_SETTING_CATEGORY_SERVERTOOLS", "antiafk_gracedead", "60.0" )
    AddPrivateMatchModeSettingArbitrary("#MODE_SETTING_CATEGORY_SERVERTOOLS", "antiafk_warn", "20.0" )
    AddPrivateMatchModeSettingArbitrary("#MODE_SETTING_CATEGORY_SERVERTOOLS", "antiafk_interval", "2.0" )

    if ( GetConVarBool( "antiafk_enabled" ) ) {
        print("ANTIAFK ENABLED")
        AddCallback_GameStateEnter( eGameState.Playing, Playing)
    }
}

bool function IsImmune( entity player ){
    array<string> immunes = split( GetConVarString("antiafk_immune"), "|")

    if (immunes.contains(player.GetUID().tostring())){
        return true
    }
    return false
}

struct {
	table<entity, float> lastmoved = {}
} file

enum eAntiAfkPlayerState
{
	ACTIVE
	SUSPICIOUS
    AFK
}

void function Playing(){
    AddCallback_OnClientConnected( AddPlayerCallbacks )
    AddCallback_OnClientDisconnected( DeletePlayerRecords )
    AddCallback_OnPlayerRespawned( Moved )

    foreach (entity player in GetPlayerArray()){
        AddPlayerCallbacks( player )
    }

    thread CheckAfkKickThread()
}

int function GetAfkState( entity player ){

    float localgrace = GetCurrentPlaylistVarFloat("antiafk_grace", 60.0)
    float warn = GetCurrentPlaylistVarFloat("antiafk_warn", 20.0)

    // different grace when dead
    if ( !IsAlive(player) ){
        localgrace = GetCurrentPlaylistVarFloat("antiafk_gracedead", 60.0)
    }

    if ( player in file.lastmoved){
        float lastmove = file.lastmoved[ player ]
        if (Time() > lastmove + (localgrace - warn)){

            if (Time() > lastmove + localgrace){
                return eAntiAfkPlayerState.AFK
            }

            return eAntiAfkPlayerState.SUSPICIOUS
        }
    }
    return eAntiAfkPlayerState.ACTIVE
}

void function NotifyPlayer( entity player ){
    float interval = GetCurrentPlaylistVarFloat("antiafk_interval", 5.0)
    try {
        for (local i = 0; i < interval.tointeger(); i+=1){
            SendHudMessage( player, GetConVarString("antiafk_message"), -1, 0.4, 255, 255, 255, 0, 0.05, 0.9, 0.05 )
            wait 1
        }
    } catch (ex) {}
}


void function CheckAfkKickThread(){
    while (true){
        if ( GetGameState() == eGameState.Playing ){
            foreach (entity player in GetPlayerArray()){

                // guard player missing
                if ( !player.IsPlayer() ){
                    DeletePlayerRecords( player )
                    return
                }

                if (IsImmune(player)){
                    return
                }

                int afkstate = GetAfkState(player)

                switch ( afkstate ){

                    case eAntiAfkPlayerState.SUSPICIOUS:
                        thread NotifyPlayer( player )
                        break

                    case eAntiAfkPlayerState.AFK:
                        print("ANTIAFK KICKED " + player)
                        ServerCommand("kickid "+ player.GetUID())
                        break
                }
            }
        }
        wait GetCurrentPlaylistVarFloat("antiafk_interval", 5.0)
    }
}

void function Moved( entity player ){
    file.lastmoved[ player ] <- Time()
}

bool function bMoved( entity player ){
    Moved( player )
    return true
}

void function AddPlayerCallbacks( entity player ){
    AddPlayerPressedForwardCallback( player, bMoved )
    AddPlayerPressedBackCallback( player, bMoved )
    AddPlayerPressedLeftCallback( player, bMoved )
    AddPlayerPressedRightCallback( player, bMoved )
    AddButtonPressedPlayerInputCallback( player, IN_ZOOM, Moved )
    AddButtonPressedPlayerInputCallback( player, IN_ZOOM_TOGGLE, Moved )
    AddButtonPressedPlayerInputCallback( player, IN_OFFHAND0, Moved )
    AddButtonPressedPlayerInputCallback( player, IN_OFFHAND1, Moved )
    AddButtonPressedPlayerInputCallback( player, IN_OFFHAND2, Moved )
    AddButtonPressedPlayerInputCallback( player, IN_OFFHAND3, Moved )
    AddButtonPressedPlayerInputCallback( player, IN_OFFHAND4, Moved )
    AddButtonPressedPlayerInputCallback( player, IN_ATTACK, Moved )
    AddPlayerMovementEventCallback( player, ePlayerMovementEvents.JUMP, Moved )
    AddPlayerMovementEventCallback( player, ePlayerMovementEvents.DODGE, Moved )
    AddPlayerMovementEventCallback( player, ePlayerMovementEvents.LEAVE_GROUND, Moved )
    AddPlayerMovementEventCallback( player, ePlayerMovementEvents.TOUCH_GROUND, Moved )
    AddPlayerMovementEventCallback( player, ePlayerMovementEvents.MANTLE, Moved )
    AddPlayerMovementEventCallback( player, ePlayerMovementEvents.BEGIN_WALLRUN, Moved )
    AddPlayerMovementEventCallback( player, ePlayerMovementEvents.END_WALLRUN, Moved )
    AddPlayerMovementEventCallback( player, ePlayerMovementEvents.BEGIN_WALLHANG, Moved )
    AddPlayerMovementEventCallback( player, ePlayerMovementEvents.END_WALLHANG, Moved )
}

void function DeletePlayerRecords( entity player ){
    if (player in file.lastmoved){
        delete file.lastmoved[ player ]
    }
}
