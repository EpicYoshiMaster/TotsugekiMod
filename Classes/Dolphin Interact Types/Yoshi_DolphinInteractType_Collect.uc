// For collectibles to pass through to the player
class Yoshi_DolphinInteractType_Collect extends Yoshi_DolphinInteractType;

static function EDolphinInteractType OnTouch(Yoshi_Dolphin Dolphin, Hat_Player AttachedPlayer, Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	Dolphin.static.Print("OnTouch[Collect]" @ `ShowVar(Other));
	if(Hat_Collectible(Other) != None)
	{
		Other.Touch(AttachedPlayer, OtherComp, HitLocation, HitNormal);
	}

	return DI_Ignore;
}

defaultproperties
{
	WhitelistedClasses.Add("Hat_Collectible")
}