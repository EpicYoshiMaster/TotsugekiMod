/*
* Totsugeki!!!
*
*/
class Yoshi_GameMod_TotsugekiMod extends GameMod;

// How should it be triggered?
// - Replace Dive *Prototype Attempt*
// - Hat Ability

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
// - Look into how totsugeki is busting through walls
// - Limit Totsugeki to 2D in Mafia Boss fight?
// - Experiment with control options to make it more fun

// For Later
// - Consider the vertical dolphin option?
// - Set up the mod as a Badge or Hat Ability

event OnModLoaded() 
{
	if(`GameManager.GetCurrentMapFilename() ~= `GameManager.TitleScreenMapName) return;

	HookActorSpawn(class'Hat_Player', 'Hat_Player');
}

event OnHookedActorSpawn(Object NewActor, Name Identifier) 
{
	if(Identifier == 'Hat_Player') {
		SetTimer(0.001, false, NameOf(GiveTotsugekiListener), self, NewActor);
	} 
}

function GiveTotsugekiListener(Hat_Player ply)
{
	ply.GiveStatusEffect(class'Yoshi_StatusEffect_TotsugekiListener');
}

event OnModUnloaded() 
{
	local Hat_Player ply;

	foreach DynamicActors(class'Hat_Player', ply) {
		ply.RemoveStatusEffect(class'Yoshi_StatusEffect_TotsugekiListener');
	}
}