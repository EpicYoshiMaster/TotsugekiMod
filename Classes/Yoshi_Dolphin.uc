/*
* Totsugeki!!!!!
* This is Mr. Dolphin, he arises from the ground seas, flies for a distance, then either returns into the ground or gracefully spirals upon bonking into something
*/
class Yoshi_Dolphin extends Actor
	dependsOn(Yoshi_DolphinInteractType);

var(Effects) SoundCue TotsugekiVoiceline;
var(Effects) SoundCue ExitWaterSound;
var(Effects) SoundCue EnterWaterSound;
var(Effects) ParticleSystem SplashParticle;
var(Effects) ParticleSystemComponent BubbleTrail;

var(Gameplay) int Damage;
var(Gameplay) float Duration;
var(Gameplay) float TotsugekiSpeed;
var(Gameplay) Vector BonkPushback; //apply X velocity in reverse of start direction, and Z velocity upwards
var(Gameplay) class<Hat_DamageType> DamageType;

var(Meshes) SkeletalMeshComponent DolphinMesh;
var(Meshes) array<CylinderComponent> CollisionCylinders;

// Temporary Testing Variables
var(Temporary) Vector SplashMountOffset;
var(Temporary) Vector SplashUnmountOffset;
var(Temporary) Vector SplashUnmountBonkOffset;
var(Temporary) Vector BubbleOffset;
var(Temporary) float SplashScale;
var(Temporary) float CosmeticEffectsDelay;
var(Temporary) float UnhideDelayTime;
var(Temporary) float EndAnimationTime;
var(Temporary) float EndAnimationBonkTime;
var(Temporary) float DestroyTime;

var Vector InitialDirection;
var bool IsBonking;
var float CurrentDuration;
var bool InTotsugekiMode; //This is when we're flying horizontally, we can attack enemies in this state

var Hat_Player AttachedPlayer;
var AnimSet PlayerDolphinAnims;

var transient MaterialInstanceTimeVarying MatInstance;

var array< class<Yoshi_DolphinInteractType> > InteractTypes; //These will be passed in by the Listener status effect, don't want to grab them over and over

simulated event PostBeginPlay()
{
	MatInstance = DolphinMesh.CreateAndSetMaterialInstanceTimeVarying(0);
	DolphinMesh.SetHidden(true);
	Super.PostBeginPlay();
}

/**
* Mounts the player onto Mr. Dolphin
* Plays a startup animation with special effects
*/
function MountDolphin(Hat_Player ply)
{
	local ParticleSystemComponent SplashComp;
	local Vector PositionOffset;
	if(AttachedPlayer != None)
	{
		UnmountDolphin(); //This should never occur but just in case!
	}

	// Handle player attachment
	AttachedPlayer = ply;
	ply.SetCollision(false, false);
	ply.bCollideWorld = false;
	ply.SetPhysics(PHYS_Falling);
	ply.CustomGravityScaling = 0.0;
	ply.SetBase(self);
	ply.SetHardAttach(true);
	GivePlayerAnimSet(true);

	// Set dolphin initial state
	InTotsugekiMode = true;
	CurrentDuration = 0.0;
	InitialDirection = Vector(ply.Rotation);
	InitialDirection.Z = 0;
	SetPhysics(PHYS_Falling);
	DolphinMesh.SetLightEnvironment(ply.Mesh.LightEnvironment);
	class'Hat_Pawn'.static.ReTouchAllActors_Static(self, true); //In-case we're starting in a wall

	// Play cosmetic effects
	ply.PlayVoice(TotsugekiVoiceline); //Totsugeki!!!
	PlaySound(ExitWaterSound);
	PositionOffset = InitialDirection * SplashMountOffset.X;
	PositionOffset.Z = SplashMountOffset.Z;
	SplashComp = WorldInfo.MyEmitterPool.SpawnEmitter(SplashParticle, Location + PositionOffset, Rotator(InitialDirection));
	//SplashComp.SetTranslation(SplashMountOffset);
	SplashComp.SetScale(SplashScale);
	SetTimer(UnhideDelayTime, false, NameOf(UnHideDolphin));

	BubbleTrail.SetActive(true);
	SetDolphinAnim('GetOn');
	AttachedPlayer.PlayCustomAnimation('HK_GetOnTotsu');
}

/**
* Unmounts the player from Mr. Dolphin
* Plays an end animation with special effects
*/
function UnmountDolphin(bool IsBonk = false)
{
	local Hat_Player ply;

	IsBonking = IsBonk;

	//Handle Player Detachment
	ply = AttachedPlayer;
	if(ply != None)
	{
		ply.SetPhysics(PHYS_Falling);
		ply.SetCollision(true, true);
		ply.bCollideWorld = true;
		ply.CustomGravityScaling = ply.default.CustomGravityScaling;
		ply.SetBase(None);
		ply.SetHardAttach(ply.default.bHardAttach);

		// For a bonk, give the player some pushback, otherwise keep their speed
		AttachedPlayer.Velocity = (IsBonk) ? (-InitialDirection * BonkPushback.X + vect(0,0,1) * BonkPushback.Z) : InitialDirection * TotsugekiSpeed;
	}

	// Set dolphin end state
	InTotsugekiMode = false;
	SetPhysics(PHYS_None);
	Velocity = vect(0,0,0);
	SetTimer(IsBonk ? EndAnimationBonkTime : EndAnimationTime, false, NameOf(HideDolphin));

	// Play cosmetic effects
	SetDolphinAnim((IsBonk) ? 'Hurt' : 'GetOff');
	AttachedPlayer.PlayCustomAnimation('');
	if(IsBonk && MatInstance != None)
	{
		MatInstance.SetScalarParameterValue('IsHurt', 1.0); //Set expression to Hurt (ouch! X - X)
	}

	SetTimer(CosmeticEffectsDelay, false, NameOf(PlayUnmountCosmeticEffects));
}

function PlayUnmountCosmeticEffects()
{
	local ParticleSystemComponent SplashComp;
	local Vector PositionOffset;

	// Play cosmetic effects
	PlaySound(EnterWaterSound);

	PositionOffset = InitialDirection * ((IsBonking) ? SplashUnmountBonkOffset.X : SplashUnmountOffset.X);
	PositionOffset.Z = IsBonking ? SplashUnmountBonkOffset.Z : SplashUnMountOffset.Z;
	SplashComp = WorldInfo.MyEmitterPool.SpawnEmitter(SplashParticle, Location + PositionOffset, Rotator(InitialDirection));
	SplashComp.SetScale(SplashScale);
	BubbleTrail.SetActive(false);
}

function UnHideDolphin()
{
	DolphinMesh.SetHidden(false);
}

function HideDolphin()
{
	DolphinMesh.SetHidden(true);
	SetTimer(DestroyTime, false, NameOf(DestroyDolphin));
}

function DestroyDolphin()
{
	AttachedPlayer = None;
	GivePlayerAnimSet(false);

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

		SetPhysics(PHYS_Falling);
		Velocity = InitialDirection * TotsugekiSpeed;
		AttachedPlayer.Velocity = Velocity; //Apply to the player too

		if(CurrentDuration >= Duration)
		{
			Print("End Totsugeki Mode");
			UnmountDolphin(false);
		}
	}
}

event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
{
	Print("Bump" @ `ShowVar(Other) @ `ShowVar(OtherComp) @ `ShowVar(HitNormal));

	Super.Bump(Other, OtherComp, HitNormal);
}

simulated event HitWall( Vector HitNormal, Actor Wall, PrimitiveComponent WallComp )
{
	Print("HitWall" @ `ShowVar(HitNormal) @ `ShowVar(Wall) @ `ShowVar(WallComp));
	if(InTotsugekiMode)
	{
		UnmountDolphin(true);
	}

	Super.HitWall(HitNormal, Wall, WallComp);
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	local int i;
	local EDolphinInteractType Result;
	local bool FoundInteractType;

	if(Hat_Player(Other) != None && Hat_Player(Other) == AttachedPlayer) return;
	if(Yoshi_Dolphin(Other) != None && Yoshi_Dolphin(Other) == self) return;

	if(InTotsugekiMode)
	{
		for(i = 0; i < InteractTypes.length; i++)
		{
			if(InteractTypes[i].static.IsActorOfInteractType(Other))
			{
				FoundInteractType = true;

				Result = InteractTypes[i].static.OnTouch(self, AttachedPlayer, Other, OtherComp, HitLocation, HitNormal);

				if(Result == DI_None) continue;

				if(Result == DI_Unmount)
				{
					UnmountDolphin(false);
				}
				else if(Result == DI_Bonk)
				{
					UnmountDolphin(true);
				}

				break;
			}
		}

		if(!FoundInteractType)
		{
			Print("NO TOUCH HANDLER FOUND FOR" @ `ShowVar(Other));
		}
	}

	Super.Touch(Other, OtherComp, HitLocation, HitNormal);
}

event UnTouch( Actor Other )
{
	local int i;
	local EDolphinInteractType Result;
	local bool FoundInteractType;

	if(Hat_Player(Other) != None && Hat_Player(Other) == AttachedPlayer) return;
	if(Yoshi_Dolphin(Other) != None && Yoshi_Dolphin(Other) == self) return;

	if(InTotsugekiMode)
	{
		for(i = 0; i < InteractTypes.length; i++)
		{
			if(InteractTypes[i].static.IsActorOfInteractType(Other))
			{
				FoundInteractType = true;

				Result = InteractTypes[i].static.OnUnTouch(self, AttachedPlayer, Other);

				if(Result == DI_None) continue;

				if(Result == DI_Unmount)
				{
					UnmountDolphin(false);
				}
				else if(Result == DI_Bonk)
				{
					UnmountDolphin(true);
				}

				break;
			}
		}

		if(!FoundInteractType)
		{
			//Print("NO UNTOUCH HANDLER FOUND FOR" @ `ShowVar(Other));
		}
	}

	Super.UnTouch(Other);
}

event Landed(Vector HitNormal, Actor FloorActor, Vector ImpactVelocity )
{
	Print("Landed");
	if(InTotsugekiMode)
	{
		UnmountDolphin(false);
	}

	Super.Landed(HitNormal, FloorActor, ImpactVelocity);
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

function SetPlayerAnim(Name AnimName)
{
	AttachedPlayer.PlayCustomAnimation(AnimName, true);
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

function GivePlayerAnimSet(bool give)
{
	if(AttachedPlayer == None) return;

	if (give)
	{
		if (AttachedPlayer.Mesh.AnimSets.Find(PlayerDolphinAnims) == INDEX_NONE)
		{
			AttachedPlayer.Mesh.AnimSets.AddItem(PlayerDolphinAnims);
		}
	}
	else
	{
		if (AttachedPlayer.Mesh.AnimSets.Find(PlayerDolphinAnims) != INDEX_NONE)
		{
			AttachedPlayer.Mesh.AnimSets.RemoveItem(PlayerDolphinAnims);
		}
	}
	AttachedPlayer.Mesh.UpdateAnimations();
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
	TotsugekiVoiceline=SoundCue'Yoshi_TotsugekiMod_Content.SoundCues.Totsugeki_May'
	Damage=5
	Duration=2.0
	TotsugekiSpeed=1200.0
	BonkPushback=(X=600,Y=0,Z=300)
	DamageType=class'Hat_DamageType_HomingAttack'

	Begin Object Class=SkeletalMeshComponent Name=Model0
		SkeletalMesh=SkeletalMesh'Ctm_TOTSUGEKI_Content.models.Totsugeki'
		AnimTreeTemplate=AnimTree'Ctm_TOTSUGEKI_Content.Dolphin_AnimTree'
		AnimSets(0)=AnimSet'Ctm_TOTSUGEKI_Content.AnimSets.Totsugeki_Anims'
		CollideActors=false
		BlockActors=false
		CanBlockCamera = false
		Translation=(X=10,Y=0,Z=-30)
	End Object
	DolphinMesh=Model0
	Components.Add(Model0)

	// Collision (3 cylinders arranged together)
	Begin Object Class=CylinderComponent Name=CenterCylinder
		CollisionRadius=30
		CollisionHeight=20
		CanBlockCamera = false

		CollideActors=true
		BlockActors=false
		bAlwaysRenderIfSelected=true
		bDrawBoundingBox=false
		HiddenGame=false
	End Object
	Components.Add(CenterCylinder)
	CollisionCylinders.Add(CenterCylinder)

	Begin Object Class=CylinderComponent Name=FrontCylinder
		CollisionRadius=30
		CollisionHeight=20
		CanBlockCamera = false
		Translation=(X=35);

		CollideActors=true
		BlockActors=false
		bAlwaysRenderIfSelected=true
		bDrawBoundingBox=false
		HiddenGame=false
	End Object
	Components.Add(FrontCylinder)
	CollisionCylinders.Add(FrontCylinder)
	CollisionComponent=FrontCylinder

	Begin Object Class=CylinderComponent Name=BackCylinder
		CollisionRadius=30
		CollisionHeight=20
		CanBlockCamera = false
		Translation=(X=-35);

		CollideActors=true
		BlockActors=false
		bAlwaysRenderIfSelected=true
		bDrawBoundingBox=false
		HiddenGame=false
	End Object
	Components.Add(BackCylinder)
	CollisionCylinders.Add(BackCylinder)

	// Effects
	Begin Object Class=ParticleSystemComponent Name=BubbleTrailParticle
		Template=ParticleSystem'HatInTime_Levels_LondonSecret.ParticleSystems.Env.PlayerMovementBubbles'
		bAutoActivate=false
		MaxDrawDistance = 6000;
	End Object
	Components.Add(BubbleTrailParticle);
	BubbleTrail=BubbleTrailParticle;

	bCollideActors=true
	bBlockActors=false
	bCollideWorld=true

	//Temporary Variables
	SplashMountOffset=(X=100,Y=0,Z=-60)
	SplashUnmountOffset=(X=60,Y=0,Z=-60)
	SplashUnmountBonkOffset=(X=-70,Y=0,Z=-60)
	BubbleOffset=(X=0,Y=0,Z=0)
	UnhideDelayTime=0.1
	CosmeticEffectsDelay=0.1
	EndAnimationTime=0.2
	EndAnimationBonkTime=0.6
	DestroyTime=1.0

	SplashScale=0.75
	SplashParticle=ParticleSystem'HatInTime_PlayerAssets.watersplash.watersplash'
	ExitWaterSound=SoundCue'HatinTime_SFX_Player.WaterJumpOut_cue'
	EnterWaterSound=SoundCue'HatInTime_PlayerAssets.SoundCues.splash'

	PlayerDolphinAnims=AnimSet'Ctm_TOTSUGEKI_Content.AnimSets.HK_Totsugeki_Ride'
}