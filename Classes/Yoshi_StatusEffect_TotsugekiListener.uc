/*
* TOTSUGEKI!!!!!!!! (This class is for administrating cooldowns / player events for totsugeki'ing)
*
*/
class Yoshi_StatusEffect_TotsugekiListener extends Hat_StatusEffect
	dependsOn(Yoshi_InputPack);

var bool OnCooldown;

var bool WasHookshotSwinging;

var InputPack InputPack;

function OnAdded(Actor a) 
{
    Super.OnAdded(a);

	class'Yoshi_InputPack'.static.AttachController(ReceivedPlayerInput, PlayerController(Pawn(a).Controller), InputPack);
}

simulated function OnRemoved(Actor a) 
{
	class'Yoshi_InputPack'.static.DetachController(InputPack);

	Super.OnRemoved(a);
}

function bool Update(float delta) 
{
	CheckHookshotRefresh();

	return true;
}

function bool ReceivedPlayerInput(int ControllerId, name Key, EInputEvent EventType, float AmountDepressed, bool bGamepad)
{
	if(EventType != IE_Pressed) return false;

	if(Key == 'Hat_Player_Crouch')
	{
		return Totsugeki();
	}

	return false;
}

function bool CanUseTotsugeki()
{
	if(OnCooldown) return false;
	if(Hat_Player(Owner).HasStatusEffect(class'Yoshi_StatusEffect_Totsugeki')) return false;

	return true;
}

function bool Totsugeki()
{
	if(!CanUseTotsugeki()) return false;

	Hat_Player(Owner).GiveStatusEffect(class'Yoshi_StatusEffect_Totsugeki');
	SetCooldown(true);

	return true;
}

function SetCooldown(bool NewCooldown) 
{
	OnCooldown = NewCooldown;
}

function CheckHookshotRefresh() 
{
	local bool IsHookshotSwinging;

	IsHookShotSwinging = Hat_Player(Owner).IsHookShotSwinging();
	if(WasHookshotSwinging && !IsHookShotSwinging) {
		SetCooldown(false);
	}
	else if(!WasHookshotSwinging && IsHookShotSwinging) {
		Hat_Player(Owner).ClearStatusEffects(BitWise(class'Hat_Ability'.const.AbilityClearFlag_Hookshot));
	}

	WasHookshotSwinging = IsHookShotSwinging;
}

function OnLanded(optional bool UnusualScenario) 
{
	SetCooldown(false);
}

function OnSpringJump() 
{
	SetCooldown(false);
}

defaultproperties
{
	Infinite=true
}