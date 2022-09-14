/*
* Used for actors who should basically just be considered a generic wall and bonk into
*/
class Yoshi_DolphinInteractType_Blockable extends Yoshi_DolphinInteractType;

static function EDolphinInteractType HitWall(Yoshi_Dolphin Dolphin, Hat_Player AttachedPlayer, Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
	if(Wall.bBlockActors && WallComp.BlockActors)
	{
		return DI_Bonk;
	}

	return DI_Ignore;
}

static function EDolphinInteractType OnTouch(Yoshi_Dolphin Dolphin, Hat_Player AttachedPlayer, Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	if(Other.bBlockActors && OtherComp.BlockActors)
	{
		return DI_Bonk;
	}

	return DI_Ignore;
}

defaultproperties
{
	WhitelistedClasses.Add("Actor")
}