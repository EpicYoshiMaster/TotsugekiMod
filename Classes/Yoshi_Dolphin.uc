/*
* Totsugeki!!!!!
* This is Mr. Dolphin, he arises from the ground seas, flies for a distance, then either returns into the ground or gracefully spirals upon bonking into something
*/
class Yoshi_Dolphin extends Actor
	dependsOn(Yoshi_DolphinInteractType);

const FLOOR_OFFSET_Z = -60;

var(Effects) SoundCue TotsugekiVoiceline;
var(Effects) SoundCue ExitWaterSound;
var(Effects) SoundCue EnterWaterSound;
var(Effects) ParticleSystem SplashParticle;
var(Effects) float SplashParticleScale;
var(Effects) float GetOnOffset;
var(Effects) float GetOffOffset;
var(Effects) float HurtOffset;
var(Effects) ParticleSystemComponent BubbleTrail;

var(Gameplay) int Damage;
var(Gameplay) float TotsugekiSpeed;
var(Gameplay) Vector BonkPushback; //apply X velocity in reverse of start direction, and Z velocity upwards
var(Gameplay) class<Hat_DamageType> DamageType;

var(Meshes) SkeletalMeshComponent DolphinMesh;
var(Meshes) CylinderComponent FrontCollisionCylinder;

var(Timers) float UnhideDelayTime;
var(Timers) float StartAnimTime;
var(Timers) float EndEffectsTime;
var(Timers) float EndAnimationTime;
var(Timers) float EndAnimationBonkTime;
var(Timers) float DestroyTime;

var Vector InitialDirection;
var bool InTotsugekiMode; //This is when we're flying horizontally, we can attack enemies in this state

var Hat_Player AttachedPlayer;
var Name CurrentAnim;
var AnimSet PlayerDolphinAnims;
var Hat_Path2D Path2D;
var int Path2DLink;

var transient MaterialInstanceTimeVarying MatInstance;

var Yoshi_Hat_Ability_Totsugeki AbilityHandler;
var array< class<Yoshi_DolphinInteractType> > InteractTypes; //These will be passed in by the Listener status effect, don't want to grab them over and over

struct TouchStruct
{
	var Actor Other;
	var PrimitiveComponent OtherComp;
	var Vector HitLocation;
	var Vector HitNormal;
};

var array<TouchStruct> PreInitializeTouches;

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
	local int i;
	Print("MountDolphin" @ `ShowVar(ply));

	// Handle player attachment
	AttachedPlayer = ply;
	ply.SetCollision(true, false);
	ply.bCollideWorld = false;
	ply.SetPhysics(PHYS_Falling);
	ply.CustomGravityScaling = 0.0;
	ply.SetBase(self);
	ply.SetHardAttach(true);
	GivePlayerAnimSet(true);

	// Set dolphin initial state
	InitialDirection = Vector(ply.Rotation);
	InitialDirection.Z = 0;
	Velocity = InitialDirection * TotsugekiSpeed;
	AttachedPlayer.Velocity = Velocity;
	SetPhysics(PHYS_Falling);
	DolphinMesh.SetLightEnvironment(ply.Mesh.LightEnvironment);
	Path2D = ply.Path2D;

	// Play cosmetic effects
	SetDolphinAnim('GetOn');
	AttachedPlayer.PlayCustomAnimation('HK_GetOnTotsu');
	ply.PlayVoice(TotsugekiVoiceline); //Totsugeki!!!
	PlaySound(ExitWaterSound);
	SpawnSplashParticle(Location);
	SetTimer(UnhideDelayTime, false, NameOf(UnHideDolphin));
	SetTimer(StartAnimTime, false, NameOf(RideDolphin));

	BubbleTrail.SetActive(true);

	for(i = 0; i < PreInitializeTouches.length; i++)
	{
		Touch(PreInitializeTouches[i].Other, PreInitializeTouches[i].OtherComp, PreInitializeTouches[i].HitLocation, PreInitializeTouches[i].HitNormal);
	}

	PreInitializeTouches.Length = 0;
}

/**
* Unmounts the player from Mr. Dolphin
* Plays an end animation with special effects
*/
function UnmountDolphin(bool IsBonk = false)
{
	local Hat_Player ply;
	Print("UnmountDolphin" @ IsBonk);

	if(!InTotsugekiMode) return;

	// Play cosmetic effects
	SetDolphinAnim((IsBonk) ? 'Hurt' : 'GetOff');
	if(IsBonk && MatInstance != None)
	{
		MatInstance.SetScalarParameterValue('IsHurt', 1.0); //Set expression to Hurt (ouch! X - X)
	}

	ClearAllTimers(); //prevent weird startup things delaying if we bonk super early
	UnhideDolphin();

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
		ply.PlayCustomAnimation(''); //Set them back to normal

		// For a bonk, give the player some pushback, otherwise keep their speed
		ply.Velocity = (IsBonk) ? (-InitialDirection * BonkPushback.X + vect(0,0,1) * BonkPushback.Z) : InitialDirection * TotsugekiSpeed;
	}

	// Set dolphin end state
	InTotsugekiMode = false;
	SetPhysics(PHYS_None);
	Velocity = vect(0,0,0);
	Path2D = None;
	SetTimer(IsBonk ? EndAnimationBonkTime : EndAnimationTime, false, NameOf(HideDolphin));
	SetTimer(EndEffectsTime, false, NameOf(PlayUnmountCosmeticEffects));
}

/*
* Wrapper for the internals of Yoshi_Dolphin
* Administrates signalling to the ability that we're de-activating the hat ability in here
*/
function CallUnmountDolphin(bool IsBonk = false)
{
	if(!InTotsugekiMode) return;

	if(AbilityHandler != None)
	{
		AbilityHandler.Activated = false;
		AbilityHandler = None;
	}

	UnmountDolphin(IsBonk);
}

function PlayUnmountCosmeticEffects()
{
	Print("PlayUnmountCosmeticEffects");

	// Play cosmetic effects
	PlaySound(EnterWaterSound);
	SpawnSplashParticle(Location);
	BubbleTrail.SetActive(false);
}

function UnHideDolphin()
{
	Print("UnHideDolphin");
	DolphinMesh.SetHidden(false);
}

function RideDolphin()
{
	Print("RideDolphin");
	AttachedPlayer.PlayCustomAnimation('HK_RideTotsu', true);
}

function HideDolphin()
{
	Print("HideDolphin");
	DolphinMesh.SetHidden(true);
	SetTimer(DestroyTime, false, NameOf(DestroyDolphin));
}

function DestroyDolphin()
{
	Print("DestroyDolphin");
	AttachedPlayer = None;
	AbilityHandler = None;
	GivePlayerAnimSet(false);

	Destroy();
}

function bool UsingTotsugeki()
{
	return InTotsugekiMode;
}

simulated event Tick(float d)
{
	local Vector DesiredLocation;

	Super.Tick(d);

	if(InTotsugekiMode)
	{
		SetPhysics(PHYS_Falling);
		
		Velocity.Z = 0;
		
		if(Path2D != None)
		{
			class'Hat_Pawn2D'.static.UpdatePath2D(Location, Path2D, Path2DLink);
			Velocity = class'Hat_Pawn2D'.static.Update2DVelocity(Velocity, Path2D, Path2DLink, Location);
			DesiredLocation = class'Hat_Pawn2D'.static.Desired2DLocation(Location, Path2D, Path2DLink);
			Move((DesiredLocation - Location)*FMin(d*10.0,1.0));
			SetRotation(Rotator(Velocity));
		}
		else
		{
			Velocity = InitialDirection * TotsugekiSpeed;
		}

		AttachedPlayer.Velocity = Velocity; //Apply to the player too
	}
}

event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
{
	Print("Bump" @ `ShowVar(Other) @ `ShowVar(OtherComp) @ `ShowVar(HitNormal));

	Super.Bump(Other, OtherComp, HitNormal);
}

simulated event HitWall( Vector HitNormal, Actor Wall, PrimitiveComponent WallComp )
{
	local int i;
	local EDolphinInteractType Result;
	local bool FoundInteractType;

	if(InTotsugekiMode)
	{
		for(i = 0; i < InteractTypes.length; i++)
		{
			if(InteractTypes[i].static.IsActorOfInteractType(Wall))
			{
				FoundInteractType = true;

				Print("HitWall[" $ InteractTypes[i] $ "]" @ `ShowVar(Wall) @ `ShowVar(WallComp));

				Result = InteractTypes[i].static.HitWall(self, AttachedPlayer, HitNormal, Wall, WallComp);

				if(Result == DI_None) continue;

				if(Result == DI_Unmount)
				{
					CallUnmountDolphin(false);
				}
				else if(Result == DI_Bonk)
				{
					CallUnmountDolphin(true);
				}

				break;
			}
		}

		if(!FoundInteractType)
		{
			//Print("NO TOUCH HANDLER FOUND FOR" @ `ShowVar(Other));
		}
	}

	Super.HitWall(HitNormal, Wall, WallComp);
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	local int i;
	local EDolphinInteractType Result;
	local bool FoundInteractType;
	local TouchStruct PreTouch;

	//This is a pre-initialize touch
	if(InTotsugekiMode && AttachedPlayer == None)
	{
		PreTouch.Other = Other;
		PreTouch.OtherComp = OtherComp;
		PreTouch.HitLocation = HitLocation;
		PreTouch.HitNormal = HitNormal;

		PreInitializeTouches.AddItem(PreTouch);
		return;
	}

	if(Hat_Player(Other) != None && Hat_Player(Other) == AttachedPlayer) return;
	if(Yoshi_Dolphin(Other) != None && Yoshi_Dolphin(Other) == self) return;

	if(InTotsugekiMode)
	{
		for(i = 0; i < InteractTypes.length; i++)
		{
			if(InteractTypes[i].static.IsActorOfInteractType(Other))
			{
				Print("Touch[" $ InteractTypes[i] $ "]" @ `ShowVar(Other) @ `ShowVar(OtherComp));
				FoundInteractType = true;

				Result = InteractTypes[i].static.OnTouch(self, AttachedPlayer, Other, OtherComp, HitLocation, HitNormal);

				if(Result == DI_None) continue;

				if(Result == DI_Unmount)
				{
					CallUnmountDolphin(false);
				}
				else if(Result == DI_Bonk)
				{
					CallUnmountDolphin(true);
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
				Print("UnTouch[" $ InteractTypes[i] $ "]" @ `ShowVar(Other));
				FoundInteractType = true;

				Result = InteractTypes[i].static.OnUnTouch(self, AttachedPlayer, Other);

				if(Result == DI_None) continue;

				if(Result == DI_Unmount)
				{
					CallUnmountDolphin(false);
				}
				else if(Result == DI_Bonk)
				{
					CallUnmountDolphin(true);
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
		CallUnmountDolphin(false);
	}

	Super.Landed(HitNormal, FloorActor, ImpactVelocity);
}

function SpawnSplashParticle(Vector BaseLocation)
{
	local Vector Offset;
	local ParticleSystemComponent SplashComp;

	switch(CurrentAnim)
	{
		case 'GetOn': Offset = InitialDirection * (TotsugekiSpeed * UnhideDelayTime + GetOnOffset); break;
		case 'GetOff': Offset = InitialDirection * GetOffOffset; break;
		case 'Hurt': Offset = InitialDirection * HurtOffset; break;
	}

	Offset.Z = FLOOR_OFFSET_Z;

	SplashComp = WorldInfo.MyEmitterPool.SpawnEmitter(SplashParticle, BaseLocation + Offset, Rotator(InitialDirection));
	SplashComp.SetScale(SplashParticleScale);
}

function SetDolphinAnim(Name AnimName, optional bool instant)
{
	local int indx;
	Print("SetDolpinAnim" @ `ShowVar(AnimName));

	CurrentAnim = AnimName;

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
	/*
    local WorldInfo wi;

	msg = "[Totsugeki] " $ msg;

    wi = class'WorldInfo'.static.GetWorldInfo();
    if (wi != None)
    {
        if (wi.GetALocalPlayerController() != None)
            wi.GetALocalPlayerController().TeamMessage(None, msg, 'Event', 6);
        else
            wi.Game.Broadcast(wi, msg);
    }*/
}

defaultproperties
{
	TotsugekiVoiceline=SoundCue'Yoshi_TotsugekiMod_Content.SoundCues.Totsugeki_May'
	Damage=5
	TotsugekiSpeed=1200.0
	BonkPushback=(X=600,Y=0,Z=300)
	DamageType=class'Hat_DamageType_HomingAttack'
	InTotsugekiMode=true

	Begin Object Class=SkeletalMeshComponent Name=Model0
		SkeletalMesh=SkeletalMesh'Ctm_TOTSUGEKI_Content.models.Totsugeki'
		AnimTreeTemplate=AnimTree'Ctm_TOTSUGEKI_Content.Dolphin_AnimTree'
		AnimSets(0)=AnimSet'Ctm_TOTSUGEKI_Content.AnimSets.Totsugeki_Anims'
		CollideActors=false
		BlockActors=false
		CanBlockCamera = false
		Translation=(X=-3.5,Y=0,Z=-36)
	End Object
	DolphinMesh=Model0
	Components.Add(Model0)
	
	Begin Object Class=CylinderComponent Name=FrontCylinder
		CollisionRadius=30
		CollisionHeight=20
		CanBlockCamera = false
		Translation=(X=25);

		CollideActors=true
		BlockActors=false
		bAlwaysRenderIfSelected=true
		bDrawBoundingBox=false
		HiddenGame=false
	End Object
	Components.Add(FrontCylinder)
	CollisionComponent=FrontCylinder

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

	//Splash placement adjusting
	GetOnOffset=-5
	GetOffOffset=60
	HurtOffset=-70

	UnhideDelayTime=0.11
	StartAnimTime=0.333
	EndEffectsTime=0.1
	EndAnimationTime=0.2
	EndAnimationBonkTime=0.425
	DestroyTime=1.0

	SplashParticleScale=0.75
	SplashParticle=ParticleSystem'HatInTime_PlayerAssets.watersplash.watersplash'
	ExitWaterSound=SoundCue'HatinTime_SFX_Player.WaterJumpOut_cue'
	EnterWaterSound=SoundCue'HatInTime_PlayerAssets.SoundCues.splash'

	PlayerDolphinAnims=AnimSet'Ctm_TOTSUGEKI_Content.AnimSets.HK_Totsugeki_Ride'
}