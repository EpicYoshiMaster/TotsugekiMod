/*
* Totsugeki into tasks to pick them up! (Why?? I don't know!)
* 
*/
class Yoshi_DolphinInteractType_CarryObjectStackable extends Yoshi_DolphinInteractType;

static function EDolphinInteractType HitWall(Yoshi_Dolphin Dolphin, Hat_Player AttachedPlayer, Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
	if(!Wall.bHidden && Hat_CarryObject_Stackable(Wall).CanBeCarried)
	{
		AttachedPlayer.BeginCarry(Wall, true);
		return DI_Bonk;
	}
	
	return DI_Ignore;
}

static function EDolphinInteractType OnTouch(Yoshi_Dolphin Dolphin, Hat_Player AttachedPlayer, Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	if(!Other.bHidden && Hat_CarryObject_Stackable(Other).CanBeCarried)
	{
		AttachedPlayer.BeginCarry(Other, true);
		return DI_Bonk;
	}
	
	return DI_Ignore;
}

defaultproperties
{
	WhitelistedClasses.Add("Hat_CarryObject_Stackable")
}