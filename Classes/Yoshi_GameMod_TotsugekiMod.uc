/*
* Totsugeki!!!
*
*/
class Yoshi_GameMod_TotsugekiMod extends GameMod
	dependsOn(Yoshi_InputPack);

var InputPack InputPacks[2];

var bool IsEnabled; //Replace with badge later this is temporary and bad

// How should it be triggered?
// - Replace Dive *Prototype Attempt*
// - Hat Ability

// TODO List
// Fix Invisible Hat Kid
// Restrict ability to Move
// Restrict being able to use ability infinitely

event OnModLoaded() {
	if(`GameManager.GetCurrentMapFilename() ~= `GameManager.TitleScreenMapName) return;

	HookActorSpawn(class'Hat_PlayerController', 'Hat_PlayerController');
}

event OnHookedActorSpawn(Object NewActor, Name Identifier) {
	local InputPack NewPack;

	if(Identifier == 'Hat_PlayerController') {
		if(`GameManager.IsPlayerOne(PlayerController(NewActor)))
		{
			class'Yoshi_InputPack'.static.AttachController(ReceivedNativeInputKeyPlayerOne, PlayerController(NewActor), NewPack);
			InputPacks[0] = NewPack;
		}
		else
		{
			class'Yoshi_InputPack'.static.AttachController(ReceivedNativeInputKeyPlayerTwo, PlayerController(NewActor), NewPack);
			InputPacks[1] = NewPack;
		}
	} 
}

function bool ReceivedNativeInputKeyPlayerOne(int ControllerId, name Key, EInputEvent EventType, float AmountDepressed, bool bGamepad)
{
	if(InputPacks[0].PlyCon != None)
	{
		return ReceivedPlayerInput(Hat_Player(InputPacks[0].PlyCon.Pawn), ControllerId, Key, EventType, AmountDepressed, bGamepad);
	}

	return false;
}

function bool ReceivedNativeInputKeyPlayerTwo(int ControllerId, name Key, EInputEvent EventType, float AmountDepressed, bool bGamepad)
{
	if(InputPacks[1].PlyCon != None)
	{
		return ReceivedPlayerInput(Hat_Player(InputPacks[1].PlyCon.Pawn), ControllerId, Key, EventType, AmountDepressed, bGamepad);
	}

	return false;
}

function bool ReceivedPlayerInput(Hat_Player ply, int ControllerId, name Key, EInputEvent EventType, float AmountDepressed, bool bGamepad)
{
	if(EventType != IE_Pressed) return false;

	if(Key == 'Hat_Player_Crouch')
	{
		ply.GiveStatusEffect(class'Yoshi_StatusEffect_Totsugeki');
		return true;
	}

	return false;
}

defaultproperties
{
	IsEnabled=true
}