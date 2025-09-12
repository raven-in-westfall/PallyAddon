PALLY_ADDON_VERBOSE = false
PALLY_ADDON_LOCKED = false

_G.PallyAddonLog = function(message, verbose_arg)
    local verbose = verbose_arg or false
    if verbose then
        DEFAULT_CHAT_FRAME:AddMessage(message , 1, .4, 1);
    end
end

_G.PALLY_ADDON_IS_PALADIN = nil
_G.PallyAddonIsPaladin = function()
    if PALLY_ADDON_IS_PALADIN == nil then
        PALLY_ADDON_IS_PALADIN = false
        if (UnitClass("player") == "Paladin") then
            PALLY_ADDON_IS_PALADIN = true
        end
    end
    return PALLY_ADDON_IS_PALADIN
end

function pally_addon_OnLoad()
    this:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function pally_addmin_OnEvent()
    PallyAddonLog("got event for PallyAddon! ".. event, PALLY_ADDON_VERBOSE);
    if(event == "PLAYER_ENTERING_WORLD") then
        PallyAddonLog("Processing login event for PallyAddon", PALLY_ADDON_VERBOSE);
        PallyAddonIsPaladin()
        Check_Buffs_Initialize()
    end
end

_G.PallyAddonOnDragStart = function(element_name)
    if (CHECK_BUFFS_MOVABLE == true ) then
        element_name:StartMoving();
        element_name.isMoving = true;
    end
end

_G.PallyAddonOnDragStop = function(element_name)
    element_name:StopMovingOrSizing();
    element_name.isMoving = false;
end