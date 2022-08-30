/*
* Totsugeki!!!11!111!1111!!!11!11!1one!111!11!!
*
*/

class Yoshi_StatusEffect_Totsugeki extends Hat_StatusEffect;

/*

var Yoshi_Dolphin Totsugeki;

var SkeletalMesh DolphinMesh;
var AnimSet DolphinAnimations;
var Vector DolphinScale;
var Rotator DolphinRotation;
var Vector DolphinTranslation;

var SoundCue StartupSound;

var float TotsugekiSpeed;

var SkeletalMeshComponent DolphinMeshComp;

var Vector InitialDirection;

function SkeletalMeshComponent CreateDolphinMesh(Actor InActor, SkeletalMeshComponent InComponent)
{
	local SkeletalMeshComponent SkeletalMeshComponent;
	
	SkeletalMeshComponent = new class'SkeletalMeshComponent';
	SkeletalMeshComponent.SetSkeletalMesh(DolphinMesh);
	SkeletalMeshComponent.AnimSets.Length = 0;
	SkeletalMeshComponent.AnimSets.AddItem(DolphinAnimations);
	SkeletalMeshComponent.SetScale3D(DolphinScale);
	SkeletalMeshComponent.SetRotation(DolphinRotation);
	SkeletalMeshComponent.SetTranslation(DolphinTranslation);
	SkeletalMeshComponent.SetLightEnvironment(InComponent.LightEnvironment);
	InActor.AttachComponent(SkeletalMeshComponent);
	//SkeletalMeshComponent.AttachComponentToSocket(InComponent, 'Driver');

	return SkeletalMeshComponent;
}

function OnAdded(Actor a)
{
	local Hat_Player ply;
	Super.OnAdded(a);

	ply = Hat_Player(a);
	if(ply != None) 
	{
		Totsugeki = ply.Spawn(class'Yoshi_Dolphin', ply,,ply.Location,ply.Rotation,,true);
		Totsugeki.MountDolphin(ply);

		
		DolphinMeshComp = CreateDolphinMesh(a, ply.Mesh);
		ply.PlayVoice(StartupSound);

		ply.SetPhysics(PHYS_Falling);
		InitialDirection = Vector(ply.Rotation);
		InitialDirection.Z = 0;
		ply.Velocity = InitialDirection * GetSpeed();
		ply.CustomGravityScaling = 0.0;
		//Play Animation
	}
}

function simulated OnRemoved(Actor a)
{
	local Hat_Player ply;
	Super.OnRemoved(a);

	ply = Hat_Player(a);
	if(ply != None) 
	{
		ply.CustomGravityScaling = ply.default.CustomGravityScaling;
		//Play Animation

		if (DolphinMeshComp != None)
		{
			//ply.AttachComponent(ply.Mesh);
			DolphinMeshComp.DetachFromAny();
		}
	}
}

function float GetSpeed()
{
	return TotsugekiSpeed;
}

function bool CannotJump()
{
    return true;
}

function bool CannotAttack()
{
    return true;
}

function bool OnDuck()
{
	return true;
}

function OnHitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp) 
{
	RemoveStatusEffect(Owner, self.class);
}

defaultproperties
{
	Duration=2.0
	TotsugekiSpeed=1200

	DolphinMesh=SkeletalMesh'Ctm_TOTSUGEKI_Content.models.Totsugeki'
	DolphinAnimations=AnimSet'Ctm_TOTSUGEKI_Content.AnimSets.Totsugeki_Anims'
	DolphinTranslation=(X=10,Y=0,Z=-30)
	DolphinRotation=(Pitch=0,Roll=0,Yaw=`QuarterRot)
	DolphinScale=(X=1, Y=1, Z=1)
	StartupSound=SoundCue'Yoshi_TotsugekiMod_Content.SoundCues.Totsugeki_May'

	ClearFlags[Hat_Ability.AbilityClearFlag_Hookshot] = true;
	ClearFlags[Hat_Ability.AbilityClearFlag_WallClimb] = true;
	ClearFlags[Hat_Ability.AbilityClearFlag_SpringJump] = true;
} */