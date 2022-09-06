/*
* For use when interacting with gameplay actors that lack blocking collision that should disable the Dolphin immediately.
* Ex. If Mr. Dolphin touches a balloon, we want the player to still have this interaction.
*/
class Yoshi_DolphinInteractType_CancelOnContact extends Yoshi_DolphinInteractType;

static function EDolphinInteractType OnTouch(Yoshi_Dolphin Dolphin, Hat_Player AttachedPlayer, Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	Dolphin.static.Print("OnTouch[CancelOnContact]" @ `ShowVar(Other));

	return (!Other.bHidden) ? DI_Unmount : DI_Ignore;
}

defaultproperties
{
	WhitelistedClasses.Add("Hat_Balloon")
	WhitelistedClasses.Add("Hat_Rope_Base")
	WhitelistedClasses.Add("Hat_MetroVacuum_Base")
}