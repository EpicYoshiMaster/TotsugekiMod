/*
* The true power of Dolphin lies within your heart.
*
*/
class Yoshi_Hat_Ability_Totsugeki extends Hat_Ability_Trigger;

var class<Hat_StatusEffect> TotsugekiListener;

function GivenTo( Pawn NewOwner, optional bool bDoNotActivate )
{
	Super.GivenTo(NewOwner, bDoNotActivate);
	
	Hat_Player(NewOwner).GiveStatusEffect(TotsugekiListener);
}

function ItemRemovedFromInvManager()
{
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

	TotsugekiListener=class'Yoshi_StatusEffect_TotsugekiListener'
}