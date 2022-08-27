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
// - Add a splash and particle trail
// - Integrate Attacking
// - Disable Totsugeki on Rope / Spring find more buggy opportunities
// - Think of a better solution than cancelling totsugeki on walls (I want it to just be on wall climb)
// - How should ground Totsugeki work? (Raise you above the ground slightly?)
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