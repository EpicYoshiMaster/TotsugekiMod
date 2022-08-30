/*
* Totsugeki!!!!!
* This is Mr. Dolphin, he arises from the ground seas, flies for a distance, then either returns into the ground or gracefully spirals upon bonking into something
*/
class Yoshi_Dolphin extends Actor;

var() SoundCue StartupSound;
var() int Damage;
var() float Duration;
var() float TotsugekiSpeed;

var() SkeletalMeshComponent DolphinMesh;

var Vector InitialDirection;
var float CurrentDuration;
var bool InTotsugekiMode; //This is when we're flying horizontally, we can attack enemies in this state

var Hat_Player AttachedPlayer;

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
}

function MountDolphin(Hat_Player ply)
{
	if(AttachedPlayer != None)
	{
		UnmountDolphin(); //This should never occur but just in case!
	}

	AttachedPlayer = ply;
	ply.PlayVoice(StartupSound);

	ply.SetPhysics(PHYS_Falling);
	InitialDirection = Vector(ply.Rotation);
	InitialDirection.Z = 0;
	ply.CustomGravityScaling = 0.0;

	DolphinMesh.SetLightEnvironment(ply.Mesh.LightEnvironment);
	ply.AttachComponent(DolphinMesh);

	SetDolphinAnim('GetOn');
	InTotsugekiMode = true;
	CurrentDuration = 0.0;
}

function UnmountDolphin(bool IsBonk = false)
{
	InTotsugekiMode = false;
	
	if(AttachedPlayer != None)
	{
		AttachedPlayer.CustomGravityScaling = AttachedPlayer.default.CustomGravityScaling;
	}
	
	SetDolphinAnim((IsBonk) ? 'Hurt' : 'GetOff');
	SetTimer(1.5, false, NameOf(DestroyDolphin));
}

function DestroyDolphin()
{
	if(AttachedPlayer != None)
	{
		AttachedPlayer.DetachComponent(DolphinMesh);
		AttachedPlayer = None;
	}

	Destroy();
}

function bool UsingTotsugeki()
{
	return InTotsugekiMode;
}

simulated event Tick(float d)
{
	Super.Tick(d);

	if(InTotsugekiMode)
	{
		CurrentDuration += d;

		AttachedPlayer.SetPhysics(PHYS_Falling);
		AttachedPlayer.Velocity = InitialDirection * TotsugekiSpeed;
		AttachedPlayer.CustomGravityScaling = 0.0;

		if(CurrentDuration >= Duration)
		{
			Print("End Totsugeki Mode");
			UnmountDolphin(false);
		}
	}
}

event HitWall( Vector HitNormal, Actor Wall, PrimitiveComponent WallComp )
{
	if(InTotsugekiMode)
	{
		UnmountDolphin(true);
	}

	Super.HitWall(HitNormal, Wall, WallComp);
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	//If it's an enemy bonk them
	if(InTotsugekiMode && Hat_Enemy(Other) != None && AttachedPlayer != None)
	{
		Hat_Enemy(Other).TakeDamage(Damage, AttachedPlayer.Controller, Location, Velocity, class'Hat_DamageType_HomingAttack');
		UnmountDolphin(true);
	}

	Super.Touch(Other, OtherComp, HitLocation, HitNormal);
}

event Landed(Vector HitNormal, Actor FloorActor, Vector ImpactVelocity )
{
	//If we're in totsugeki mode that's kinda weird, if we're not this is when to use the splash animation upon leaving

	Super.Landed(HitNormal, FloorActor, ImpactVelocity);
}

simulated event Destroyed()
{
	Print("Destroying Totsugeki");
	Super.Destroyed();
}

function SetDolphinAnim(Name AnimName, optional bool instant)
{
	local int indx;

	switch(AnimName)
	{
		case 'Ride': indx = 0; break;
		case 'GetOn': indx = 1; break;
		case 'GetOff': indx = 2; break;
 		case 'Hurt': indx = 3; break;
		default: indx = 0; break;
	}

	SetDolphinAnimationIndex(indx, instant);
}

function SetDolphinAnimationIndex(int indx, optional bool instant)
{
    local Hat_AnimBlendBase n;
    n = Hat_AnimBlendBase(DolphinMesh.FindAnimNode('DolphinAnims'));
    if (n != None)
        n.SetActiveChild(indx, instant ? 0.0f : n.GetBlendTime(indx));
    else
        `broadcast("Node" @ string(n) @ "not found");
}

static final function Print(coerce string msg)
{
    local WorldInfo wi;

	msg = "[Totsugeki] " $ msg;

    wi = class'WorldInfo'.static.GetWorldInfo();
    if (wi != None)
    {
        if (wi.GetALocalPlayerController() != None)
            wi.GetALocalPlayerController().TeamMessage(None, msg, 'Event', 6);
        else
            wi.Game.Broadcast(wi, msg);
    }
}

defaultproperties
{
	StartupSound=SoundCue'Yoshi_TotsugekiMod_Content.SoundCues.Totsugeki_May'
	Damage=5
	Duration=2.0
	TotsugekiSpeed=1200.0

	Begin Object Class=SkeletalMeshComponent Name=Model0
		SkeletalMesh=SkeletalMesh'Ctm_TOTSUGEKI_Content.models.Totsugeki'
		AnimTreeTemplate=AnimTree'Ctm_TOTSUGEKI_Content.Dolphin_AnimTree'
		AnimSets(0)=AnimSet'Ctm_TOTSUGEKI_Content.AnimSets.Totsugeki_Anims'
		CanBlockCamera = false
		Translation=(X=10,Y=0,Z=-30)
	End Object
	DolphinMesh=Model0
	CollisionComponent=Model0
	Components.Add(Model0)
}

//ParticleSystem'HatInTime_PlayerAssets.watersplash.watersplash'
//ParticleSystem'HatInTime_PlayerAssets.Particles.WaterPlayerBubbleParticle' or ParticleSystem'HatInTime_Aku_Aquarium.Particles.undersea_bubble_stream_directional'