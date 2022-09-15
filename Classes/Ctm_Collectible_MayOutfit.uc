class Ctm_Collectible_MayOutfit extends Hat_Collectible_Skin;

defaultproperties
{
	ItemName = "TotsuName"
	ItemDescription(0) = "TotsuDesc"
	HUDIcon = Texture2D'Yoshi_TotsugekiMod_Content.Textures.GGST_MayCostumeIcon'
	SupportsRoulette = false
    ItemQuality = class'Hat_ItemQuality_Legendary'

	SkinBodyMesh = SkeletalMesh'Ctm_TOTSUGEKI_Content.models.MayBody'
	SkinLegsMesh = SkeletalMesh'Ctm_TOTSUGEKI_Content.models.MayLegs'

	SkinColor[SkinColor_Dress] = (R=105, G=130, B=194)
	SkinColor[SkinColor_Cape] = (R=197, G=228, B=240)
	SkinColor[SkinColor_ShoesBottom] = (R=22, G=26, B=60)
	SkinColor[SkinColor_Shoes] = (R=216, G=245, B=251)
	SkinColor[SkinColor_Pants] = (R=192, G=243, B=247)
	SkinColor[SkinColor_Orange] = (R=255, G=255, B=255)
}