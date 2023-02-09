global function SmartPistolFFA_Init

void function SmartPistolFFA_Init()
{
	AddCallback_OnPlayerRespawned( OnPlayerRespawned )
}

void function OnPlayerRespawned( entity player )
{
	thread GiveSonar(player)
}
void function GiveSonar(entity player)
{
	while(true)
	{
	if(!IsAlive(player)||!IsValid( player )||!player.IsPlayer()||GetGameState()==eGameState.Postmatch)
	break;

	if (!Hightlight_HasEnemyHighlight(player, "enemy_boss_bounty"))
	Highlight_SetEnemyHighlight( player, "enemy_boss_bounty" )

	wait 0.1
	}
}