CHECK_BUFFS_MOVABLE = true
CHECK_BUFFS_VERBOSE = false

AURAS = {
    ['Interface\\Icons\\Spell_Holy_DevotionAura'] = true,
    ['Interface\\Icons\\Spell_Holy_AuraOfLight'] = true
}
RF = 'Interface\\Icons\\Spell_Holy_SealOfFury'

function Check_Buffs_Initialize()
    if PALLY_ADDON_IS_PALADIN then
        PallyAddonLog("PallyAddon - check_buffs Loaded", CHECK_BUFFS_VERBOSE)
        Check_Buffs()
        PallyAddonLog("Registering events")
        check_buffs_core:RegisterForDrag("LeftButton");
        check_buffs_core:RegisterEvent("UNIT_AURA"); -- Watch for aura changes
    else
        --Auto hides if Player is not a Paladin
        PallyAddonLog("Player is not pally", CHECK_BUFFS_VERBOSE)
        check_buffs_core:Hide();
    end
end

function Check_Buffs()
    PallyAddonLog("Checking Buffs", CHECK_BUFFS_VERBOSE)
    if PALLY_ADDON_IS_PALADIN == false then
        return
    end
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
end