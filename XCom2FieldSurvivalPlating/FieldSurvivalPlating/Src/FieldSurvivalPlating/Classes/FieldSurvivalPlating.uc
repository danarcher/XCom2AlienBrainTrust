class FieldSurvivalPlating extends X2Item config(FieldSurvivalPlating);

var config int CERAMIC_HP;
var config int CERAMIC_SHIELD;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(CreatePlating('FSPCeramicPlating', 'FSPCeramicPlatingBonus', default.CERAMIC_HP, default.CERAMIC_SHIELD));

    return Templates;
}

static function X2DataTemplate CreatePlating(name ItemName, name AbilityName, int HP, int Shield)
{
    local X2EquipmentTemplate Template;

    `CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, ItemName);
    Template.ItemCat = 'defense';
    Template.InventorySlot = eInvSlot_Utility;
    Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Nano_Fiber_Vest";
    Template.EquipSound = "StrategyUI_Vest_Equip";

    Template.Abilities.AddItem(AbilityName);

    Template.bInfiniteItem = true;
    Template.StartingItem = true;
    Template.CanBeBuilt = false;
    Template.TradingPostValue = 0;
    Template.PointsToComplete = 0;
    Template.Tier = 0;

    Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, HP);
    Template.SetUIStatMarkup("Ablative HP", eStat_ShieldHP, Shield);

    return Template;
}
