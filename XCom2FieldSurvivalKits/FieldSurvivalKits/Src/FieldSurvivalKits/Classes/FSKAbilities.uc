class FSKAbilities extends X2Ability config(FieldSurvivalKits) dependson(FSKTemporaryItemEffect);

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(AddSmoker());
    Templates.AddItem(AddMedic());

    return Templates;
}

static function X2AbilityTemplate AddSmoker()
{
	local X2AbilityTemplate Template;
	local FSKTemporaryItemEffect SmokeEffect;
	local ResearchConditional SmokeConditional;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'FSKSmokeGrenade');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_grenade_smoke";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.bCrossClassEligible = true;

	SmokeEffect = new class'FSKTemporaryItemEffect';
	SmokeEffect.EffectName = 'FSKSmokeGrenadeEffect';
	SmokeEffect.ItemName = 'SmokeGrenade';
	SmokeConditional.ResearchProjectName = 'AdvancedGrenades';
	SmokeConditional.ItemName = 'SmokeGrenadeMk2';
	SmokeEffect.ResearchOptionalItems.AddItem(SmokeConditional);
	SmokeEffect.AlternativeItemNames.AddItem('DenseSmokeGrenade');
	SmokeEffect.AlternativeItemNames.AddItem('DenseSmokeGrenadeMk2');
	SmokeEffect.ForceCheckAbilities.AddItem('LaunchGrenade');
	SmokeEffect.bIgnoreItemEquipRestrictions = true;
	SmokeEffect.BuildPersistentEffect(1, true, false);
	SmokeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	SmokeEffect.DuplicateResponse = eDupe_Ignore;

	Template.AddTargetEffect(SmokeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddMedic()
{
	local X2AbilityTemplate Template;
	local FSKTemporaryItemEffect MedkitEffect;
	local ResearchConditional MedkitConditional;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'FSKMedkit');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_medkit";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.bCrossClassEligible = true;

	MedkitEffect = new class'FSKTemporaryItemEffect';
	MedkitEffect.EffectName = 'FSKMedkitEffect';
	MedkitEffect.ItemName = 'Medikit';
	MedkitConditional.ResearchProjectName = 'BattlefieldMedicine';
	MedkitConditional.ItemName = 'NanoMedikit';
	MedkitEffect.ResearchOptionalItems.AddItem(MedkitConditional);
	//MedkitEffect.ForceCheckAbilities.AddItem('MedikitHeal');
	//MedkitEffect.ForceCheckAbilities.AddItem('NanoMedikitHeal');
	//MedkitEffect.ForceCheckAbilities.AddItem('MedikitStabilize');
	//MedkitEffect.ForceCheckAbilities.AddItem('MedikitBonus'); // immune to poison
	//MedkitEffect.ForceCheckAbilities.AddItem('NanoMedikitBonus'); // immune to poison
	MedkitEffect.bIgnoreItemEquipRestrictions = true;
	MedkitEffect.BuildPersistentEffect(1, true, false);
	MedkitEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	MedkitEffect.DuplicateResponse = eDupe_Ignore;

	Template.AddTargetEffect(MedkitEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}
