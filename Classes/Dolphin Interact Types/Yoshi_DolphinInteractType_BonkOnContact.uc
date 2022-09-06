/*
* For use when interacting with gameplay actors that lack blocking collision that should bonk the Dolphin immediately.
* Ex. If Mr. Dolphin runs into the Mafia Ball.
*/
class Yoshi_DolphinInteractType_BonkOnContact extends Yoshi_DolphinInteractType;

static function EDolphinInteractType OnTouch(Yoshi_Dolphin Dolphin, Hat_Player AttachedPlayer, Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	Dolphin.static.Print("OnTouch[CancelOnContact]" @ `ShowVar(Other));

	return (!Other.bHidden) ? DI_Bonk : DI_Ignore;
}

defaultproperties
{
	WhitelistedClasses.Add("Hat_Hazard_MafiaBall")
}