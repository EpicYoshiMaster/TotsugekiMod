/*
* Used for actors that should take damage on contact.
* Ex. Running into an enemy.
*/
class Yoshi_DolphinInteractType_TakeDamage extends Yoshi_DolphinInteractType;

static function EDolphinInteractType HitWall(Yoshi_Dolphin Dolphin, Hat_Player AttachedPlayer, Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
	if(!Wall.bHidden && WallComp.BlockActors)
	{
		Wall.TakeDamage(Dolphin.Damage, AttachedPlayer.Controller, Dolphin.Location, Dolphin.Velocity, Dolphin.DamageType);
		return DI_Bonk;
	}
	
	return DI_Ignore;
}

static function EDolphinInteractType OnTouch(Yoshi_Dolphin Dolphin, Hat_Player AttachedPlayer, Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	if(!Other.bHidden && OtherComp.BlockActors)
	{
		Other.TakeDamage(Dolphin.Damage, AttachedPlayer.Controller, Dolphin.Location, Dolphin.Velocity, Dolphin.DamageType);
		return DI_Bonk;
	}
	
	return DI_Ignore;
}

defaultproperties
{
	WhitelistedClasses.Add("Hat_Enemy")
	WhitelistedClasses.Add("Hat_Lever_Base")
	WhitelistedClasses.Add("Hat_GiantFaucetHandle")
}