CHECK_BUFFS_MOVABLE = true
CHECK_BUFFS_VERBOSE = false

AURAS = {
    ['Interface\\Icons\\Spell_Holy_DevotionAura'] = true,
    ['Interface\\Icons\\Spell_Holy_AuraOfLight'] = true
}
RF = 'Interface\\Icons\\Spell_Holy_SealOfFury'

function Check_Buffs_OnLoad()
    this:RegisterForDrag("LeftButton");
    this:RegisterEvent("VARIABLES_LOADED"); --Watch for initialization
    this:RegisterEvent("UNIT_AURA"); -- Watch for aura changes

    PallyAddonLog("PallyAddon - check_buffs Loaded", CHECK_BUFFS_VERBOSE)
end

function Check_Buffs_Initialize()
    if (UnitClass("player") ~= "Paladin") then
        --Auto hides if Player is not a Paladin
        check_buffs_core:Hide();
    else
        Check_Buffs()
    end
end 

function Check_Buffs()
    local index = 1
    local has_rf = false
    local has_aura = false
    while true do
        local name, count = UnitBuff("player", index)
        if not name then
            PallyAddonLog("There were no auras", CHECK_BUFFS_VERBOSE)
            break -- No more buffs to check
        end
        PallyAddonLog("Found Aura ".. name, CHECK_BUFFS_VERBOSE)
        if name == RF then
            has_rf = true
        elseif AURAS[name] then
            has_aura = true
        end
        index = index + 1
    end
    if has_rf then
        PallyAddonLog("Player has RF", CHECK_BUFFS_VERBOSE)
        check_buffs_rf:Hide()
    else
        PallyAddonLog("Player nissing RF", CHECK_BUFFS_VERBOSE)
        check_buffs_rf:Show()
    end
    if has_aura then
        PallyAddonLog("Player has aura", CHECK_BUFFS_VERBOSE)
        check_buffs_aura:Hide()
    else
        PallyAddonLog("Player missing aura", CHECK_BUFFS_VERBOSE)
        check_buffs_aura:Show()
    end
end

function Check_Buffs_OnEvent()
    if(event == "UNIT_AURA" and arg1 == "player") then
        Check_Buffs()
    end

    if(event == "VARIABLES_LOADED" ) then
        Check_Buffs_Initialize()
    end
end


function Check_Buffs_OnDragStart()
    if (CHECK_BUFFS_MOVABLE == true ) then
        this:StartMoving();
        this.isMoving = true;
    end
end

function Check_Buffs_OnDragStop()
    this:StopMovingOrSizing();
    this.isMoving = false;
end