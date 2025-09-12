function PallyAddonLog(message, verbose_arg)
    local verbose = verbose_arg or false
    if verbose then
        DEFAULT_CHAT_FRAME:AddMessage(message , 1, .4, 1);
    end
end

PALLY_ADDON_IS_PALADIN = nil
function PallyAddonIsPaladin()
    if PALLY_ADDON_IS_PALADIN == nil then
        PALLY_ADDON_IS_PALADIN = false
        if (UnitClass("player") == "Paladin") then
            PALLY_ADDON_IS_PALADIN = true
        end
    end
    return PALLY_ADDON_IS_PALADIN
end