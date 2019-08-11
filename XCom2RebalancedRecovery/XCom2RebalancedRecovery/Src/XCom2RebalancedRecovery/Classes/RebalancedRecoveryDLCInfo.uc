class RebalancedRecoveryDLCInfo extends X2DownloadableContentInfo;

`define OUT(message) class'Helpers'.static.OutputMsg(`message)

//struct native WoundSeverity
//{
//    var float MinHealthPercent;
//    var float MaxHealthPercent;
//    var int   MinPointsToHeal;
//    var int   MaxPointsToHeal;
//    var int   Difficulty;
//};

//struct native WoundLengths
//{
//    var array<int> WoundStateLengths;
//};

exec function RebalancedRecoveryDump()
{
    local array<WoundSeverity> WoundSeverities;
    local array<WoundLengths> WoundStates;
    local array<float> HealSoldierProject_TimeScalar;
    local WoundSeverity WoundSeverity;
    local WoundLengths WoundState;
    local int i, j;
    local string s;

    WoundSeverities = class'X2StrategyGameRulesetDataStructures'.default.WoundSeverities;
    WoundStates = class'X2StrategyGameRulesetDataStructures'.default.WoundStates;
    HealSoldierProject_TimeScalar = class'X2StrategyGameRulesetDataStructures'.default.HealSoldierProject_TimeScalar;

    `OUT("Wound Severities:");
    for (i = 0; i < WoundSeverities.Length; ++i)
    {
        WoundSeverity = WoundSeverities[i];
        `OUT("" $ i $ ": " $ WoundSeverity.MinHealthPercent $ "%-" $ WoundSeverity.MaxHealthPercent $ "% = " $ WoundSeverity.MinPointsToHeal $ "-" $ WoundSeverity.MaxPointsToHeal $ " (" $ WoundSeverity.Difficulty $ ")");
    }
    `OUT("Wound States:");
    for (i = 0; i < WoundStates.Length; ++i)
    {
        WoundState = WoundStates[i];
        s = "" $ i $ ":";
        for (j = 0; j < WoundState.WoundStateLengths.Length; ++j)
        {
            s = s $ j $ "=" $ WoundState.WoundStateLengths[j] $ " ";
        }
        `OUT(s);
    }
    `OUT("HealSoldierProject_TimeScalar:");
    s = "";
    for (i = 0; i < HealSoldierProject_TimeScalar.Length; ++i)
    {
        s = s $ i $ ":" $ HealSoldierProject_TimeScalar[i] $ " ";
    }
    `OUT(s);
}
