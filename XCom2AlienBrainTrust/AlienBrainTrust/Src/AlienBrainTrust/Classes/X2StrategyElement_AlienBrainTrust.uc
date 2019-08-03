class X2StrategyElement_AlienBrainTrust extends X2StrategyElement config(AlienBrainTrust);

var config int CRACK_BRAIN_COST;
var config int CRACK_BRAIN_COST_INCREASE;
var config bool CRACK_BRAIN_INSTANT;

var config int CRACK_BRAIN_DOOM;

var localized String m_strCrackBrainDoomRemoval;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(CreateCrackBrain());

    return Templates;
}

static function X2DataTemplate CreateCrackBrain()
{
    local X2TechTemplate Template;
    local ArtifactCost ArtifactReq;

    `CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'Tech_AlienBrainTrust_CrackBrain');
    Template.PointsToComplete = default.CRACK_BRAIN_COST;
    Template.RepeatPointsIncrease = default.CRACK_BRAIN_COST_INCREASE;
    Template.bRepeatable = true;
    Template.bCheckForceInstant = default.CRACK_BRAIN_INSTANT;
    Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.GOLDTECH_Codex_Brain_Pt1";
    Template.bShadowProject = true;
    Template.SortingTier = 1;
    Template.ResearchCompletedFn = CrackBrainCompleted;
    Template.IsPriorityFn = AlwaysPriority;

    Template.Requirements.RequiredTechs.AddItem('AlienBiotech');
    Template.Requirements.RequiredTechs.AddItem('CodexBrainPt1');
    Template.Requirements.RequiredItems.AddItem('CorpseCyberus');
    Template.Requirements.RequiredFacilities.AddItem('ShadowChamber');

    ArtifactReq.ItemTemplateName = 'CorpseCyberus';
    ArtifactReq.Quantity = 1;
    Template.Cost.ArtifactCosts.AddItem(ArtifactReq);

    return Template;
}

function bool AlwaysPriority()
{
    return true;
}

function CrackBrainCompleted(XComGameState NewGameState, XComGameState_Tech TechState)
{
    local XComGameStateHistory History;
    //local XComGameState NewGameState;
    local XComGameState_HeadquartersAlien AlienHQ;

    History = `XCOMHISTORY;
    AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));

    //NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Crack Brain Doom Removal");
    AlienHQ = XComGameState_HeadquartersAlien(NewGameState.CreateStateObject(class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));
    NewGameState.AddStateObject(AlienHQ);
    AlienHQ.RemoveDoomFromFortress(NewGameState, CRACK_BRAIN_DOOM, m_strCrackBrainDoomRemoval);
    //`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}
