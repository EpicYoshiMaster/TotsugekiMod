/*
* The true power of Dolphin lies within your heart.
*
*/
class Yoshi_Hat_Ability_Totsugeki extends Hat_Ability_Trigger;

var Yoshi_StatusEffect_TotsugekiListener StatusEffect;
var Yoshi_Hat_Ability_Totsugeki AbilityHandler;

var class<Hat_StatusEffect> TotsugekiListener;

function GivenTo( Pawn NewOwner, optional bool bDoNotActivate )
{
	Super.GivenTo(NewOwner, bDoNotActivate);
	
	StatusEffect = Yoshi_StatusEffect_TotsugekiListener(Hat_Player(NewOwner).GiveStatusEffect(TotsugekiListener));
	StatusEffect.AbilityHandler = self;
}

simulated function bool DoActivate()
{
	local bool DidTotsugeki;

	class'Yoshi_Dolphin'.static.Print("Ability - DoActivate (Pre)");

	if (!Super.DoActivate()) return false;

	class'Yoshi_Dolphin'.static.Print("Ability - DoActivate (Yes)");

	DidTotsugeki = StatusEffect.Totsugeki();
	
	return DidTotsugeki;
}

simulated function bool DoDeactivate(optional bool UserInflicted, optional bool Force)
{
	class'Yoshi_Dolphin'.static.Print("Ability - DoDeactivate (Pre) " @ `ShowVar(UserInflicted) @ `ShowVar(Force));
	if (!Super.DoDeactivate(UserInflicted, Force)) return false;

	class'Yoshi_Dolphin'.static.Print("Ability - DoDeactivate (Yes)");
	
	StatusEffect.UnTotsugeki();
	
	return true;
}

function ItemRemovedFromInvManager()
{
	StatusEffect = None;

	if(Hat_Player(Instigator) != None)
	{
		Hat_Player(Instigator).RemoveStatusEffect(TotsugekiListener);
	}

	Super.ItemRemovedFromInvManager();
}

defaultproperties
{
	HUDIcon=Texture2D'Yoshi_TotsugekiMod_Content.Textures.GGST_MayHatIcon'
	CosmeticItemName="Yoshi_TotsugekiHatName"
    Description(0) = "Yoshi_TotsugekiHatDesc";
	AttachmentSocket = "HyperlightHat";

	HatSectionGroup = "icehat";
	
    Begin Object Name=Mesh0
        SkeletalMesh = SkeletalMesh'Ctm_TOTSUGEKI_Content.models.MayHat'
        PhysicsAsset = None;
		bHasPhysicsAssetInstance = true;
		bNoSkeletonUpdate = false;
    End Object

	HidePonytail = true;

	TriggerMethod = AbilityTrigger_DoubleTap;
	RequiresAHandFree = true;
	CanBeActivatedOnVehicle = false;
	CanBeActivatedInAir = true;
	
	RemoteRole=ROLE_SimulatedProxy
	CollectPieces = -1

	MaxActivationDuration=2.0

	TotsugekiListener=class'Yoshi_StatusEffect_TotsugekiListener'
}