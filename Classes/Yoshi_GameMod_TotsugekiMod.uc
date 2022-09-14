/*
* Totsugeki!!!
*
*/
class Yoshi_GameMod_TotsugekiMod extends GameMod;

//
// TODO
//

//
// Touch Types TODO
//

// 
// Ready to Test
//

//
// Need Changes
//

// COLLECT Time Pieces - working but need to cancel as well
// Volumes - not working
// Hat_GiantHeatDial - They end up calling HitWall........... Rude.......

//
// Need to be made
//

// Cancel Totsugeki on Endorsements (should also go for collects with auto skip off)
// Impact Interact Trees
// Dynamic Actors in general (NPCS)
// Hat_CarryObject_Stackable
// Should not be able to hit enemy line of sight volumes LOL
// rift orbs and rift orb balls in purple rifts

//
// General TODO
// 

// - Parade owls are scary broken (but not like super broken just enough that it's concerning)
// - Limit Totsugeki to 2D in Mafia Boss fight?

event OnModLoaded() 
{
	if(`GameManager.GetCurrentMapFilename() ~= `GameManager.TitleScreenMapName) return;

	HookActorSpawn(class'Hat_Player', 'Hat_Player');
}

event OnHookedActorSpawn(Object NewActor, Name Identifier) 
{
	if(Identifier == 'Hat_Player') {
		SetTimer(0.3, false, NameOf(GiveItem), self, NewActor);
	} 
}

//Defaulting to false as give because the SetTimer call is dumb and overrides defaults, sorry for confusing logic!!!!!!!!
function GiveItem(Hat_Player ply, bool bTakeAway)
{
	class'Yoshi_Dolphin'.static.Print("GiveItem" @ `ShowVar(ply) @ `ShowVar(ply.Controller) @ `ShowVar(bTakeAway));
	if(ply.Controller == None) return;

	if (!bTakeAway)
		Hat_PlayerController(ply.Controller).GetLoadout().AddBackpack(class'Hat_Loadout'.static.MakeLoadoutItem(class'Yoshi_Hat_Ability_Totsugeki'), false);
	else
		Hat_PlayerController(ply.Controller).GetLoadout().RemoveBackpack(class'Hat_Loadout'.static.MakeLoadoutItem(class'Yoshi_Hat_Ability_Totsugeki'));
}

event OnModUnloaded() 
{
	local Hat_Player ply;

	foreach DynamicActors(class'Hat_Player', ply) {
		GiveItem(ply, true);
	}
}