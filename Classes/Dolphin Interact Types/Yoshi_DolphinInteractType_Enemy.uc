class Yoshi_DolphinInteractType_Enemy extends Yoshi_DolphinInteractType;

static function EDolphinInteractType OnTouch(Yoshi_Dolphin Dolphin, Hat_Player AttachedPlayer, Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	Dolphin.static.Print("OnTouch[Enemy]" @ `ShowVar(Other));
	if(Hat_Enemy(Other) != None && Other.bCanBeDamaged)
	{
		Hat_Enemy(Other).TakeDamage(Dolphin.Damage, AttachedPlayer.Controller, Dolphin.Location, Dolphin.Velocity, Dolphin.DamageType);
	}

	return DI_Bonk;
}

defaultproperties
{
	WhitelistedClasses.Add("Hat_Enemy")
}