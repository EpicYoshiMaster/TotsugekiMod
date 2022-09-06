/*
* Used for breakable boxes, I thought this would be fun to just bust right through them
* (Also easy early Gallery)
*/
class Yoshi_DolphinInteractType_Breakable extends Yoshi_DolphinInteractType;

var const class<Hat_DamageType> BreakableDamageType;

static function EDolphinInteractType OnTouch(Yoshi_Dolphin Dolphin, Hat_Player AttachedPlayer, Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	Dolphin.static.Print("OnTouch[Breakable]" @ `ShowVar(Other));

	if(!Other.bHidden)
	{
		Other.TakeDamage(Dolphin.Damage, AttachedPlayer.Controller, Dolphin.Location, Dolphin.Velocity, default.BreakableDamageType);
	}

	return DI_Ignore;
}

defaultproperties
{
	WhitelistedClasses.Add("Hat_ImpactInteract_Breakable")

	BreakableDamageType=class'Hat_DamageType_ChemicalBadge'
}