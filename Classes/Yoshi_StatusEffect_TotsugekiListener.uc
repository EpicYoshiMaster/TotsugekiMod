/*
* TOTSUGEKI!!!!!!!! (This class is for administrating cooldowns / player events for totsugeki'ing)
*
*/
class Yoshi_StatusEffect_TotsugekiListener extends Hat_StatusEffect
	dependsOn(Yoshi_InputPack);

var Yoshi_Dolphin Dolphin;
var Yoshi_Hat_Ability_Totsugeki AbilityHandler;

var bool OnCooldown;
var bool WasHookshotSwinging;

var InputPack InputPack;

var array< class<Yoshi_DolphinInteractType> > AllInteractClasses; //Passed into Yoshi_Dolphin on spawn

function OnAdded(Actor a) 
{
    Super.OnAdded(a);

	AllInteractClasses = GetAllInteractClasses();
}

simulated function OnRemoved(Actor a) 
{
	AbilityHandler = None;

	Super.OnRemoved(a);
}

function bool Update(float delta) 
{
	CheckHookshotRefresh();

	if(!IsInTotsugeki() && OnCooldown && Owner.Physics == Phys_Walking)
	{
		SetCooldown(false);
	}

	return true;
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
	Dolphin.InteractTypes = AllInteractClasses;
	Dolphin.AbilityHandler = AbilityHandler;
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

//Call it once then never again...
function array< class<Yoshi_DolphinInteractType> > GetAllInteractClasses() {
	local array< class<Object> > AllClasses;
    local int i;

	if(AllInteractClasses.length > 0) return AllInteractClasses;

    AllClasses = class'Hat_ClassHelper'.static.GetAllScriptClasses("Yoshi_DolphinInteractType");
    for(i = 0; i < AllClasses.length; i++) {
        if(class<Yoshi_DolphinInteractType>(AllClasses[i]) != None) {
            AllInteractClasses.AddItem(class<Yoshi_DolphinInteractType>(AllClasses[i]));
        }
    }

    return AllInteractClasses;
}

defaultproperties
{
	Infinite=true
}