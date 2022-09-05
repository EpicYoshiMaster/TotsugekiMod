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

// Priorities

//
// Touch Types TODO
//
// Cancel Totsugeki on Endorsements (should also go for collects with auto skip off)
// Impact Interact Trees
// BREAK Breakable Boxes
// HIT Levers
// Dynamic Actors in general (NPCS)
// COLLECT Time Pieces
// Trigger Volumes
// Hat_DivaGreetSpot
// Hat_GiantHeatDial
// Hat_Hazard_MafiaBall
// Hat_GiantFaucetHandle
// Hat_CarryObject_Stackable
// Hat_MetroVacuum
// Should not be able to hit enemy line of sight volumes LOL

// - Parade owls are scary broken (but not like super broken just enough that it's concerning)
// - Look into how totsugeki is busting through walls
// - Implement a list of exception actors to also end on Touch
// - Consider ending Totsugeki on landing
// - Disable Totsugeki on Rope / Spring find more buggy opportunities
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