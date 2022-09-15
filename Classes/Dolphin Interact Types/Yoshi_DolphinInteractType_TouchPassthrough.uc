/*
* Used for actors who the player should still get a touch interaction with even while riding Mr. Dolphin
* Ex. The player grabbing a ticket in Mafia Town while in Totsugeki mode
*/
class Yoshi_DolphinInteractType_TouchPassthrough extends Yoshi_DolphinInteractType;

static function EDolphinInteractType OnTouch(Yoshi_Dolphin Dolphin, Hat_Player AttachedPlayer, Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	if(!Other.bHidden || Volume(Other) != None)
	{
		Other.Touch(AttachedPlayer, OtherComp, HitLocation, HitNormal);
	}

	return DI_Ignore;
}

static function EDolphinInteractType OnUnTouch(Yoshi_Dolphin Dolphin, Hat_Player AttachedPlayer, Actor Other)
{
	if(!Other.bHidden || Volume(Other) != None)
	{
		Other.UnTouch(AttachedPlayer);
	}

	return DI_Ignore;
}

defaultproperties
{
	WhitelistedClasses.Add("Hat_Collectible")
	WhitelistedClasses.Add("Hat_TimeObject_Base")
	WhitelistedClasses.Add("Hat_DivaGreetSpot")
	WhitelistedClasses.Add("Hat_TimeRiftPortal")
}