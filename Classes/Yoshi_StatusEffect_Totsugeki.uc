/*
* Totsugeki!!!11!111!1111!!!11!11!1one!111!11!!
*
*/
class Yoshi_StatusEffect_Totsugeki extends Hat_StatusEffect;

var SkeletalMesh DolphinMesh;
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
		DolphinMeshComp = CreateDolphinMesh(a, ply.Mesh);
		ply.PlayVoice(StartupSound);

		ply.SetPhysics(PHYS_Falling);;
		InitialDirection = Vector(ply.Rotation);
		InitialDirection.Z = 0;
		ply.Velocity = InitialDirection * GetSpeed();
		ply.CustomGravityScaling = 0.0;
		//Play Animation
	}
}

function bool Update(float delta) 
{
	if(!Super.Update(delta)) return false;

	Hat_Player(Owner).Velocity = InitialDirection * GetSpeed();

	return true;
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

defaultproperties
{
	Duration=2.0
	TotsugekiSpeed=1200

	DolphinMesh=SkeletalMesh'HatInTime_Weapons.models.umbrella_closed'
	DolphinTranslation=(X=-10,Y=0,Z=-25)
	DolphinRotation=(Pitch=-`QuarterRot)
	DolphinScale=(X=1.5, Y=1.5, Z=2.0)
	StartupSound=SoundCue'Yoshi_TotsugekiMod_Content.SoundCues.Totsugeki_May'

	ClearFlags[Hat_Ability.AbilityClearFlag_Hookshot] = true;
	ClearFlags[Hat_Ability.AbilityClearFlag_WallClimb] = true;
	ClearFlags[Hat_Ability.AbilityClearFlag_SpringJump] = true;
}