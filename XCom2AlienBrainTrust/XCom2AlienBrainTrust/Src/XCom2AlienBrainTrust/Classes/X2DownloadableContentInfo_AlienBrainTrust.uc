class X2DownloadableContentInfo_AlienBrainTrust extends X2DownloadableContentInfo;

static event OnLoadedSavedGame()
{
    UpdateResearch();
}

static event InstallNewCampaign(XComGameState StartState)
{
}

static function bool IsResearchInHistory(name TechName)
{
    local XComGameState_Tech TechState;

    foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Tech', TechState)
    {
        if (TechState.GetMyTemplate().name == TechName)
        {
            return true;
        }
    }
    return false;
}

static function UpdateResearch()
{
    local XComGameStateHistory History;
    local XComGameState NewGameState;
    local X2TechTemplate TechTemplate;
    local XComGameState_Tech TechState;
    local X2StrategyElementTemplateManager StratMgr;
    local int Added;

    StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
    History = `XCOMHISTORY;

    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Research Templates");

    if (!IsResearchInHistory('Tech_AlienBrainTrust_CrackBrain'))
    {
        TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('Tech_AlienBrainTrust_CrackBrain'));
        TechState = XComGameState_Tech(NewGameState.CreateStateObject(class'XComGameState_Tech'));
        TechState.OnCreation(TechTemplate);
        NewGameState.AddStateObject(TechState);
        Added += 1;
    }

    if (Added == 0)
    {
        History.CleanupPendingGameState(NewGameState);
    }
    else
    {
        History.AddGameStateToHistory(NewGameState);
    }
}
