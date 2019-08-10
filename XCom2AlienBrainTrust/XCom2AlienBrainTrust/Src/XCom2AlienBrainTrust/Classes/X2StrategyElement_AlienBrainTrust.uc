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
    local Object ThisObj;

    `log("AlienBrainTrust CrackBrainCompleted START");
    `log("AlienBrainTrust Removing doom");
    RemoveDoom(NewGameState, CRACK_BRAIN_DOOM, default.m_strCrackBrainDoomRemoval);

    class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, 'ResAct_AvatarProgressReduced', CRACK_BRAIN_DOOM);

    // We have to undo the Geoscape pause caused by our being a shadow project:
    // The game thinks all shadow projects cause a cutscene, which we don't.
    //
    // Only when the Geoscape is not paused will our Avatar Project reduction
    // be shown to the player.
    //
    // Thanks to this call stack:
    //  XComGameState_HeadquartersProjectResearch.OnProjectCompleted
    //      XComGameStateContext_HeadquartersOrder.IssueHeadquartersOrder(eHeadquartersOrderType_ResearchCompleted,ProjectFocus)
    //          XComGameStateContext_HeadquartersOrder.CompleteResearch
    //              XComGameState_Tech.OnResearchCompleted.ResearchCompletedFn
    //                  CrackBrainCompleted
    //              `XEVENTMGR.TriggerEvent('ResearchCompleted', TechState, TechState, AddToGameState);
    //      `GAME.GetGeoscape().Pause();
    //      `HQPRES.UIResearchComplete
    //          StrategyMap2D.ToggleScan();
    //          `GAME.GetGeoscape().Pause();
    //
    `log("AlienBrainTrust Setting callback");
    ThisObj = self;
    `HQPRES.SetTimer(0.5, false, nameof(ResumeGeoscape), ThisObj);

    `log("AlienBrainTrust CrackBrainCompleted END");
}

function RemoveDoom(XComGameState NewGameState, int DoomToRemove, optional string DoomMessage, optional bool bCreatePendingDoom = true)
{
    local XComGameStateHistory History;
    local XComGameState_HeadquartersAlien AlienHQ;
    local XComGameState_MissionSite FortressMission, Facility;
    local array<XComGameState_MissionSite> Facilities;
    local PendingDoom DoomPending;
    local int TotalDoomToRemove, i;

    History = `XCOMHISTORY;

    AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
    AlienHQ = XComGameState_HeadquartersAlien(NewGameState.CreateStateObject(class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));
    NewGameState.AddStateObject(AlienHQ);

    FortressMission = AlienHQ.GetFortressMission();
    Facilities = AlienHQ.GetValidFacilityDoomMissions();

    TotalDoomToRemove = DoomToRemove;
    `log("AlienBrainTrust Checking fortress doom");
    DoomToRemove = RemoveDoomFromMission(NewGameState, FortressMission, DoomToRemove);
    for (i = 0; i < Facilities.Length; ++i)
    {
        Facility = Facilities[i];
        `log("AlienBrainTrust Checking facility " @ i @ " (0-" @ Facilities.Length @") doom");
        DoomToRemove = RemoveDoomFromMission(NewGameState, Facility, DoomToRemove);
    }

    TotalDoomToRemove -= DoomToRemove;
    `log("AlienBrainTrust Overall removed " @ TotalDoomToRemove @ " doom, couldn't remove " @ DoomToRemove @ ".");

    if (bCreatePendingDoom && TotalDoomToRemove > 0)
    {
        DoomPending.Doom = -TotalDoomToRemove;
        if(DoomMessage != "")
        {
            DoomPending.DoomMessage = DoomMessage;
        }
        else
        {
            DoomPending.DoomMessage = class'XComGameState_HeadquartersAlien'.default.HiddenDoomLabel;
        }
        AlienHQ.PendingDoomData.AddItem(DoomPending);
        AlienHQ.PendingDoomEntity = FortressMission.GetReference();
        AlienHQ.PendingDoomEvent = '';
    }

    if (AlienHQ.bAcceleratingDoom)
    {
        `log("AlienBrainTrust Stopped doom acceleration");
        AlienHQ.StopAcceleratingDoom();
    }
}

function int RemoveDoomFromMission(XComGameState NewGameState, XComGameState_MissionSite Mission, int DoomToRemove)
{
    local int Doom;

    `log("AlienBrainTrust Facility has " @ Mission.Doom @ " doom");
    Doom = Min(Mission.Doom, DoomToRemove);
    if (Doom > 0)
    {
        Mission = XComGameState_MissionSite(NewGameState.CreateStateObject(class'XComGameState_MissionSite', Mission.ObjectID));
        NewGameState.AddStateObject(Mission);

        Mission.Doom -= Doom;
    }
    DoomToRemove -= Doom;
    `log("AlienBrainTrust Removed " @ Doom @ " doom, leaving " @ Mission.Doom @ " doom, " @ DoomToRemove @ " left to remove");
    return DoomToRemove;
}

function ResumeGeoscape()
{
    `log("AlienBrainTrust Callback START");
    if (`SCREENSTACK.IsCurrentScreen('UIStrategyMap'))
    {
        `log("AlienBrainTrust Resuming Geoscape clock");
        `GAME.GetGeoscape().Resume();
    }
    `log("AlienBrainTrust Callback END");
}
