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
	HUDIcon = Texture2D'HatInTime_Hud.Textures.Badges.powerpin_robot'
	CosmeticItemName="Yoshi_TotsugekiHatName"
    Description(0) = "Yoshi_TotsugekiHatDesc";
	AttachmentSocket = "SprintHat";

	HatSectionGroup = "SprintHat";
	
    Begin Object Name=Mesh0
        SkeletalMesh = SkeletalMesh'HatInTime_Costumes.models.sprint_hat_2017'
        PhysicsAsset = PhysicsAsset'HatInTime_Costumes.Physics.sprint_hat_2017_Physics'
		bHasPhysicsAssetInstance = true;
		bNoSkeletonUpdate = false;
    End Object
	
    Begin Object Name=Mesh1
        SkeletalMesh = SkeletalMesh'HatInTime_Costumes.models.sprint_hat_2017'
        PhysicsAsset = PhysicsAsset'HatInTime_Costumes.Physics.sprint_hat_2017_Physics'
		bNoSkeletonUpdate = false;
    End Object
	
	TriggerMethod = AbilityTrigger_DoubleTap;
	RequiresAHandFree = true;
	CanBeActivatedOnVehicle = false;
	CanBeActivatedInAir = true;
	
	RemoteRole=ROLE_SimulatedProxy
	CollectPieces = -1

	MaxActivationDuration=2.0

	TotsugekiListener=class'Yoshi_StatusEffect_TotsugekiListener'
}