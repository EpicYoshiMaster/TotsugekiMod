/*
* Totsugeki!!!
*
*/
class Yoshi_GameMod_TotsugekiMod extends GameMod;

// How should it be triggered?
// - Replace Dive *Prototype Attempt*
// - Hat Ability

// TODO
// - Provide way to cancel Totsugeki
// - Refresh Totsugeki on water
// - Experiment with control options to make it more fun
// - Look into ggst sfx

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