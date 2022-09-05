// Mainly for gameplay actors that should drop the dolphin on contact to allow proper interaction
class Yoshi_DolphinInteractType_Cancel extends Yoshi_DolphinInteractType;

static function EDolphinInteractType OnTouch(Yoshi_Dolphin Dolphin, Hat_Player AttachedPlayer, Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	Dolphin.static.Print("OnTouch[Cancel]" @ `ShowVar(Other));
	return DI_Unmount;
}

defaultproperties
{
	WhitelistedClasses.Add("Hat_Balloon")
	WhitelistedClasses.Add("Hat_Rope_Base")
}