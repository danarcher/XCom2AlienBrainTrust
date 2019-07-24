class UIScreenListener_UIArmory_MainMenu_FieldSurvivalUniforms extends UIScreenListener;

var UIButton UniformButton;
var UIArmory_MainMenu ParentScreen;

event OnInit(UIScreen Screen)
{
    ParentScreen = UIArmory_MainMenu(Screen);
    AddFloatingButton();
}

event OnReceiveFocus(UIScreen Screen)
{
    ParentScreen = UIArmory_MainMenu(Screen);
    AddFloatingButton();
}

event OnRemoved(UIScreen Screen)
{
    ParentScreen = none;
}

function AddFloatingButton()
{
    UniformButton = ParentScreen.Spawn(class'UIButton', ParentScreen);
    UniformButton.InitButton('', "Set All Uniforms", OnButtonCallback, eUIButtonStyle_HOTLINK_BUTTON);
    UniformButton.SetResizeToText(false);
    UniformButton.SetFontSize(24);
    UniformButton.SetPosition(140, 80);
    UniformButton.SetSize(260, 36);
    UniformButton.Show();
}

simulated function SetAppearanceForArmor(XComGameState_Unit Unit, name ArmorName, bool Female)
{
    if (ArmorName == 'KevlarArmor')
    {
        if (Female)
        {
            Unit.kAppearance.nmTorso = 'CnvMed_Std_A_F';
            Unit.kAppearance.nmLegs = 'CnvMed_Std_A_F';
            Unit.kAppearance.nmArms = 'CnvMed_Std_A_F';
            Unit.kAppearance.nmLeftArm = 'CnvMed_Std_A_F';
            Unit.kAppearance.nmRightArm = 'CnvMed_Std_A_F';
        }
        else
        {
            Unit.kAppearance.nmTorso = 'CnvMed_Std_A_M';
            Unit.kAppearance.nmLegs = 'CnvMed_Std_A_M';
            Unit.kAppearance.nmArms = 'CnvMed_Std_A_M';
            Unit.kAppearance.nmLeftArm = 'CnvMed_Std_A_M';
            Unit.kAppearance.nmRightArm = 'CnvMed_Std_A_M';
        }
    }
    else if (ArmorName == 'MediumPlatedArmor')
    {
        // PltMed_Std_A_M
        if (Female)
        {
            Unit.kAppearance.nmTorso = 'PltMed_Std_A_F';
            Unit.kAppearance.nmLegs = 'PltMed_Std_A_F';
            Unit.kAppearance.nmArms = 'PltMed_Std_A_F';
            Unit.kAppearance.nmLeftArm = 'PltMed_Std_A_F';
            Unit.kAppearance.nmRightArm = 'PltMed_Std_A_F';
        }
        else
        {
            Unit.kAppearance.nmTorso = 'PltMed_Std_A_M';
            Unit.kAppearance.nmLegs = 'PltMed_Std_A_M';
            Unit.kAppearance.nmArms = 'PltMed_Std_A_M';
            Unit.kAppearance.nmLeftArm = 'PltMed_Std_A_M';
            Unit.kAppearance.nmRightArm = 'PltMed_Std_A_M';
        }
    }
    else if (ArmorName == 'MediumPoweredArmor')
    {
        // PwrMed_Std_A_M
        if (Female)
        {
            Unit.kAppearance.nmTorso = 'PwrMed_Std_A_F';
            Unit.kAppearance.nmLegs = 'PwrMed_Std_A_F';
            Unit.kAppearance.nmArms = 'PwrMed_Std_A_F';
            Unit.kAppearance.nmLeftArm = 'PwrMed_Std_A_F';
            Unit.kAppearance.nmRightArm = 'PwrMed_Std_A_F';
        }
        else
        {
            Unit.kAppearance.nmTorso = 'PwrMed_Std_A_M';
            Unit.kAppearance.nmLegs = 'PwrMed_Std_A_M';
            Unit.kAppearance.nmArms = 'PwrMed_Std_A_M';
            Unit.kAppearance.nmLeftArm = 'PwrMed_Std_A_M';
            Unit.kAppearance.nmRightArm = 'PwrMed_Std_A_M';
        }
    }
    else
    {
        // Do not mess with special armors.
        return;
    }

    //Unit.kAppearance.nmHelmet = 'Helmet_0_NoHelmet_M';

    Unit.kAppearance.nmLeftArmDeco = '';
    Unit.kAppearance.nmRightArmDeco = '';

    Unit.kAppearance.iArmorDeco = 0;
    Unit.kAppearance.iArmorTint = 0;
    Unit.kAppearance.iArmorTintSecondary = 0;
    Unit.kAppearance.nmPatterns = 'Camo_B';
}

simulated function OnButtonCallback(UIButton kButton)
{
    local XComGameStateHistory History;
    local XComGameState_HeadquartersXCom XComHQ;

    local array<XComGameState_Unit> Soldiers;
    local int iSoldier;

    local XComGameState NewGameState;

	local XComGameState_Unit Unit;
    local name ClassName;

    local XComGameState_Item ItemState;
    local X2ArmorTemplate ArmorTemplate;
    local name ArmorName;

    local XComGameState_Item PrimaryWeapon;
    local XComGameState_Item SecondaryWeapon;

    History = `XCOMHISTORY;
    XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
    Soldiers = XComHQ.GetSoldiers();

    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Apply Uniforms");

    for (iSoldier = 0; iSoldier < Soldiers.Length; iSoldier++)
    {
        Unit = Soldiers[iSoldier];
        ClassName = Unit.GetSoldierClassTemplateName();

        if (Unit.IsASoldier() &&
            Unit.IsAlive() &&
            ClassName != 'Reaper' &&
            ClassName != 'Skirmisher' &&
            ClassName != 'Templar')
        {
            Unit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', Unit.ObjectID));
            NewGameState.AddStateObject(Unit);

            if (ClassName != 'Spark')
            {
                ItemState = Unit.GetItemInSlot(eInvSlot_Armor);
                if (ItemState != none)
                {
                    ArmorTemplate = X2ArmorTemplate(ItemState.GetMyTemplate());
                    ArmorName = ArmorTemplate.DataName;
                }
                else
                {
                    ArmorName = '';
                }

                if (Unit.kAppearance.iGender == eGender_Female)
                {
                    Unit.kAppearance.nmHaircut = 'FemHair_Buzzcut';
                }
                else
                {
                    Unit.kAppearance.nmHaircut = 'MaleHair_Buzzcut';
                }

                SetAppearanceForArmor(Unit, ArmorName, Unit.kAppearance.iGender == eGender_Female);

				if (Unit.kAppearance.nmFacePropLower != 'Cigarette' &&
				    Unit.kAppearance.nmFacePropLower != 'Cigar')
				{
					Unit.kAppearance.nmFacePropLower = 'Prop_FaceLower_Blank';
				}

                if (Unit.kAppearance.nmFacePropUpper != 'Aviators_M' &&
                    Unit.kAppearance.nmFacePropUpper != 'Aviators_F' &&
                    Unit.kAppearance.nmFacePropUpper != 'PlainGlasses_M' &&
                    Unit.kAppearance.nmFacePropUpper != 'PlainGlasses_F' &&
                    Unit.kAppearance.nmFacePropUpper != 'Eyepatch_M' &&
                    Unit.kAppearance.nmFacePropUpper != 'Eyepatch_F')
                {
                    Unit.kAppearance.nmFacePropUpper = 'Prop_FaceUpper_Blank';
                }

                Unit.kAppearance.nmFacePaint = '';

                if (Unit.kAppearance.iAttitude == 3) // Twitchy
                {
                    Unit.kAppearance.iAttitude = 0; // By The Book
                }
            }

            Unit.kAppearance.iTattooTint = 36; // dark blue

            Unit.kAppearance.iWeaponTint = 94; // black
            Unit.kAppearance.nmWeaponPattern = 'Pat_Nothing';

            PrimaryWeapon = Unit.GetItemInSlot(eInvSlot_PrimaryWeapon);
            if (PrimaryWeapon != none)
            {
                PrimaryWeapon = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', PrimaryWeapon.ObjectID));
                PrimaryWeapon.WeaponAppearance.iWeaponTint = Unit.kAppearance.iWeaponTint;
                PrimaryWeapon.WeaponAppearance.nmWeaponPattern = Unit.kAppearance.nmWeaponPattern;
                NewGameState.AddStateObject(PrimaryWeapon);
            }

            SecondaryWeapon = Unit.GetItemInSlot(eInvSlot_SecondaryWeapon);
            if (SecondaryWeapon != none)
            {
                SecondaryWeapon = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', SecondaryWeapon.ObjectID));
                SecondaryWeapon.WeaponAppearance.iWeaponTint = Unit.kAppearance.iWeaponTint;
                SecondaryWeapon.WeaponAppearance.nmWeaponPattern = Unit.kAppearance.nmWeaponPattern;
                NewGameState.AddStateObject(SecondaryWeapon);
            }

            Unit.UpdatePersonalityTemplate();
            Unit.StoreAppearance();
        }
    }
    `XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

    ParentScreen.ReleasePawn(true);
    ParentScreen.CreateSoldierPawn();
}

defaultproperties
{
    ScreenClass = UIArmory_MainMenu;
}
