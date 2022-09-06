/*
* Classes which define the various ways Mr. Dolphin interacts with other objects in the world
*
*/
class Yoshi_DolphinInteractType extends Object;

var array<Name> WhitelistedClasses;

enum EDolphinInteractType {
	DI_None, // Invalid actor class for this interact type
	DI_Ignore, // Do nothing but stop checking for any more valid Interact Types
	DI_Unmount, // Trigger UnmountDolphin(false)
	DI_Bonk // Trigger UnmountDolphin(true)
};

static function bool IsActorOfInteractType(Actor InteractActor)
{
	local int i;

	for(i = 0; i < default.WhitelistedClasses.length; i++)
	{
		if(InteractActor.IsA(default.WhitelistedClasses[i]))
		{
			return true;
		}
	}

	return false;
}

static function EDolphinInteractType OnTouch(Yoshi_Dolphin Dolphin, Hat_Player AttachedPlayer, Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	return DI_None;
}

static function EDolphinInteractType OnUnTouch(Yoshi_Dolphin Dolphin, Hat_Player AttachedPlayer, Actor Other)
{
	return DI_None;
}