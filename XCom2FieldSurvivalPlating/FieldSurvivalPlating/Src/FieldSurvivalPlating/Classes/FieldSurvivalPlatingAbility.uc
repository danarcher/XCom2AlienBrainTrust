class FieldSurvivalPlatingAbility extends X2Ability
    dependson (XComGameStateContext_Ability) config(GameCore);

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(
        CreatePlatingAbility(
            'FSPCeramicPlatingBonus',
            class'FieldSurvivalPlating'.default.CERAMIC_HP,
            class'FieldSurvivalPlating'.default.CERAMIC_HP_REGEN,
            class'FieldSurvivalPlating'.default.CERAMIC_HP_REGEN_MAX,
            class'FieldSurvivalPlating'.default.CERAMIC_SHIELD,
            class'FieldSurvivalPlating'.default.CERAMIC_SHIELD_REGEN,
            class'FieldSurvivalPlating'.default.CERAMIC_SHIELD_REGEN_MAX));

    return Templates;
}

static function X2AbilityTemplate CreatePlatingAbility(name AbilityName, int HP, int HPRegen, int HPRegenMax, int Shield, int ShieldRegen, int ShieldRegenMax)
{
    local X2AbilityTemplate Template;
    local X2Effect_PersistentStatChange StatChange;
    local X2Effect_Regeneration RegenEffect;
    local FieldSurvivalPlatingRegenEffect ShieldRegenEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_item_nanofibervest";

    Template.AbilitySourceName = 'eAbilitySource_Item';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bDisplayInUITacticalText = false;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

    StatChange = new class'X2Effect_PersistentStatChange';
    StatChange.BuildPersistentEffect(1, true, false, false);
    StatChange.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
    StatChange.AddPersistentStatChange(eStat_HP, HP);
    StatChange.AddPersistentStatChange(eStat_ShieldHP, Shield);
    Template.AddTargetEffect(StatChange);

    RegenEffect = new class'X2Effect_Regeneration';
    RegenEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnBegin);
    RegenEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
    RegenEffect.HealAmount = HPRegen;
    RegenEffect.MaxHealAmount = HPRegenMax;
    RegenEffect.HealthRegeneratedName = 'FieldSurvivalPlatingHPRegenerated';
    Template.AddTargetEffect(RegenEffect);

    ShieldRegenEffect = new class'FieldSurvivalPlatingRegenEffect';
    ShieldRegenEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnBegin);
    ShieldRegenEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
    ShieldRegenEffect.HealAmount = ShieldRegen;
    ShieldRegenEffect.MaxHealAmount = ShieldRegenMax;
    ShieldRegenEffect.HealthRegeneratedName = 'FieldSurvivalPlatingShieldRegenerated';
    Template.AddTargetEffect(ShieldRegenEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    return Template;
}
