/*
* TOTSUGEKI!!!!!!!! (This class is for administrating cooldowns / player events for totsugeki'ing)
*
*/
class Yoshi_StatusEffect_TotsugekiListener extends Hat_StatusEffect
	dependsOn(Yoshi_InputPack);

var Yoshi_Dolphin Dolphin;

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
	local bool DidTotsugeki;
	if(EventType != IE_Pressed) return false;

	if(Key == 'Hat_Player_Crouch')
	{
		DidTotsugeki = Totsugeki();

		if(!DidTotsugeki && IsInTotsugeki())
		{
			UnTotsugeki();
			return true;
		}

		return DidTotsugeki;
	}

	return false;
}

function bool CanUseTotsugeki()
{
	if(OnCooldown) return false;
	if(IsInTotsugeki()) return false;
	if(!Hat_Player(Owner).CanMoveAll(true)) return false;
	if(Hat_Player(Owner).IsJumpDiving()) return false;
	if(Hat_Player(Owner).IsHookShotSwinging()) return false;
	if(Hat_Player(Owner).IsLedgeHanging()) return false;
	if(Hat_Player(Owner).IsWallSliding()) return false;
	if(Hat_Player(Owner).IsOnRope()) return false;
	if(Hat_Player(Owner).HasStatusEffect(class'Hat_StatusEffect_Lava')) return false; 
	if(Hat_Player(Owner).IsFirstPerson()) return false;
	if(Hat_PlayerController(Hat_Player(Owner).Controller).bCinematicMode) return false;
	if(Hat_PlayerController(Hat_Player(Owner).Controller).IsTalking()) return false;

	return true;
}

function bool IsInTotsugeki()
{
	return (Dolphin != None && Dolphin.UsingTotsugeki());
}

function bool Totsugeki()
{
	if(!CanUseTotsugeki()) return false;

	Dolphin = Owner.Spawn(class'Yoshi_Dolphin',,,Owner.Location,Owner.Rotation,,true);
	Dolphin.MountDolphin(Hat_Player(Owner));
	SetCooldown(true);

	return true;
}

function UnTotsugeki()
{
	if(Dolphin != None)
	{
		Dolphin.UnmountDolphin();
	}

	Dolphin = None;
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

function OnEnterWater(PhysicsVolume NewVolume) 
{
	SetCooldown(false);
}

function bool CannotJump()
{
    return IsInTotsugeki();
}

function bool CannotAttack()
{
    return IsInTotsugeki();
}

function bool OnDuck()
{
	return IsInTotsugeki();
}

defaultproperties
{
	Infinite=true
}