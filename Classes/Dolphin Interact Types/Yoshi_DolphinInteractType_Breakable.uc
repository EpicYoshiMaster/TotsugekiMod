/*
* Used for breakable boxes, I thought this would be fun to just bust right through them
* (Also easy early Gallery)
*/
class Yoshi_DolphinInteractType_Breakable extends Yoshi_DolphinInteractType;

var const class<Hat_DamageType> BreakableDamageType;

static function EDolphinInteractType HitWall(Yoshi_Dolphin Dolphin, Hat_Player AttachedPlayer, Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
	if(!Wall.bHidden)
	{
		Wall.TakeDamage(Dolphin.Damage, AttachedPlayer.Controller, Dolphin.Location, Dolphin.Velocity, default.BreakableDamageType);
		
		if(!Wall.IsA('Hat_ImpactInteract_Breakable'))
		{
			return DI_Bonk; //We don't break other things so in this case we just bonk
		}
	}

	return DI_Ignore;
}


static function EDolphinInteractType OnTouch(Yoshi_Dolphin Dolphin, Hat_Player AttachedPlayer, Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	if(!Other.bHidden)
	{
		Other.TakeDamage(Dolphin.Damage, AttachedPlayer.Controller, Dolphin.Location, Dolphin.Velocity, default.BreakableDamageType);

		if(!Other.IsA('Hat_ImpactInteract_Breakable'))
		{
			return DI_Bonk; //We don't break other things so in this case we just bonk
		}
	}

	return DI_Ignore;
}

defaultproperties
{
	WhitelistedClasses.Add("Hat_ImpactInteract_Base")

	BreakableDamageType=class'Hat_DamageType_ChemicalBadge'
}