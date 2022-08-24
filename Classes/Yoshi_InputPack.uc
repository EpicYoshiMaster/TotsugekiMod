/*
* Code by EpicYoshiMaster
*
* Encapsulates the general player input attachment procedure into a struct.
* Provides static helper functions to manage and use the struct
*/
class Yoshi_InputPack extends Object
	abstract;

struct InputPack {
	var PlayerController PlyCon;
	var Interaction KeyCaptureInteraction;
};

static function AttachController(delegate<Interaction.OnReceivedNativeInputKey> InputDelegate, PlayerController Controller, out InputPack pack) {
	local int iInput;

	if(pack.KeyCaptureInteraction != None) {
		DetachController(pack);
	}

	//Attach player to capture key interactions
	if(Controller != None) {
		pack.PlyCon = Controller;
		pack.KeyCaptureInteraction = new(pack.PlyCon) class'Interaction';
	
		pack.KeyCaptureInteraction.OnReceivedNativeInputKey = InputDelegate;
		iInput = pack.PlyCon.Interactions.Find(pack.PlyCon.PlayerInput);
		pack.PlyCon.Interactions.InsertItem(Max(iInput, 0), pack.KeyCaptureInteraction);
	}
}

static function DetachController(out InputPack pack)
{
	if(pack.PlyCon != None) {
		pack.PlyCon.Interactions.RemoveItem(pack.KeyCaptureInteraction);
    	pack.KeyCaptureInteraction = None;
		pack.PlyCon = None;
	}
}