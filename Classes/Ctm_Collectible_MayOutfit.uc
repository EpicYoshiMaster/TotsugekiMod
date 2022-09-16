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

  SkinColor[SkinColor_Dress] = (R=246, G=154, B=71)
  SkinColor[SkinColor_Cape] = (R=53, G=55, B=58)
  SkinColor[SkinColor_Pants] = (R=193, G=113, B=32)
  SkinColor[SkinColor_Shoes] = (R=83, G=38, B=13)
  SkinColor[SkinColor_ShoesBottom] = (R=255, G=249, B=185)
  SkinColor[SkinColor_Zipper] = (R=204, G=204, B=204)
  SkinColor[SkinColor_Orange] = (R=245, G=94, B=70)
  SkinColor[SkinColor_Hat] = (R=207, G=88, B=27)
  SkinColor[SkinColor_HatAlt] = (R=94, G=135, B=175)
  SkinColor[SkinColor_HatBand] = (R=240, G=240, B=240)
}