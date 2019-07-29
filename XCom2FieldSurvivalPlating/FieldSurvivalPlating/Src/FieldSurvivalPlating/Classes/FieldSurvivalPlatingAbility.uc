class FieldSurvivalPlatingAbility extends X2Ability
    dependson (XComGameStateContext_Ability) config(GameCore);

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(CreatePlatingAbility('FSPCeramicPlatingBonus', class'FieldSurvivalPlating'.default.CERAMIC_HP, class'FieldSurvivalPlating'.default.CERAMIC_SHIELD));

    return Templates;
}

static function X2AbilityTemplate CreatePlatingAbility(name AbilityName, int HP, int Shield)
{
    local X2AbilityTemplate Template;
    local X2Effect_PersistentStatChange StatChange;

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

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    return Template;
}
