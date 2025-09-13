CRUSADER_STRIKE_TICKS = 3
CRUSADER_STRIKE_CURRENT_TICKS = 0
CRUSADER_STRIKE_VERBOSE = false
CRUSADER_STRIKE_MAX_TIME = 30
CRUSADER_STRIKE_TIME_LEFT = 0
CRUSADER_STRIKE_STATUS_BAR_REFRESH_TIME_IN_SEC = .1
CRUSADER_STRIKE_STATUS_BAR_ELAPSED_TIME = 0
CRUSADER_STRIKE_STATUS_BAR = nil
CRUSADER_STRIKE_CHAT_MSG_PREFIX = "Your Crusader Strike hits "

function crusader_strike_status_bar_OnUpdate()
    CRUSADER_STRIKE_STATUS_BAR_ELAPSED_TIME = CRUSADER_STRIKE_STATUS_BAR_ELAPSED_TIME + arg1
    if CRUSADER_STRIKE_STATUS_BAR_ELAPSED_TIME > CRUSADER_STRIKE_STATUS_BAR_REFRESH_TIME_IN_SEC then
        if CRUSADER_STRIKE_TIME_LEFT >= 0 then
            CRUSADER_STRIKE_TIME_LEFT = CRUSADER_STRIKE_TIME_LEFT - CRUSADER_STRIKE_STATUS_BAR_ELAPSED_TIME
            -- PallyAddonLog("Time left on crusader_strike = ".. CRUSADER_STRIKE_TIME_LEFT, CRUSADER_STRIKE_VERBOSE)
            crusader_strike_update_status_bar()
        end
        CRUSADER_STRIKE_STATUS_BAR_ELAPSED_TIME = 0
    end
end

function crusader_strike_counter_initialize()
    if PALLY_ADDON_IS_PALADIN ==  false then
        --Auto hides if Player is not a Paladin
        PallyAddonLog("Hiding Crusader Strike", CRUSADER_STRIKE_VERBOSE)
        crusader_strike_counter_core:Hide();
    end

    update_crusader_strike_counter(0);
    PallyAddonLog("Registering events for crusader strike", CRUSADER_STRIKE_VERBOSE);
    crusader_strike_counter_core:RegisterForDrag("LeftButton");
    crusader_strike_counter_core:RegisterEvent("UNIT_AURA"); -- Watch for aura changes
    crusader_strike_counter_core:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE"); -- Watch for spell cast success

    -- Create a status bar as a child of the main frame
    local frame = crusader_strike_timer
    frame:SetFrameStrata("HIGH")
    CRUSADER_STRIKE_STATUS_BAR = CreateFrame("StatusBar", nil, frame)
    CRUSADER_STRIKE_STATUS_BAR:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar") -- Use a default texture
    CRUSADER_STRIKE_STATUS_BAR:SetAllPoints(true)
    CRUSADER_STRIKE_STATUS_BAR:SetStatusBarColor(0.9608, 0.8510, 0.0078)
    CRUSADER_STRIKE_STATUS_BAR:SetMinMaxValues(0, CRUSADER_STRIKE_MAX_TIME)
    CRUSADER_STRIKE_STATUS_BAR_text = CRUSADER_STRIKE_STATUS_BAR:CreateFontString(nil, "OVERLAY")
    CRUSADER_STRIKE_STATUS_BAR_text:SetPoint("CENTER", 0, 0)
    CRUSADER_STRIKE_STATUS_BAR_text:SetFontObject("GameFontNormal") -- Use a standard font
    crusader_strike_update_status_bar()
    crusader_strike_counter_core:Show();

    PallyAddonLog("PallyAddon - crusader_strike Loaded", CRUSADER_STRIKE_VERBOSE)
end 

function update_crusader_strike_counter(crusader_strike)
    --Updates GUI to reflect crusader_strikeonings stored
    --Shamelessly cut from ComboFrame.lua
    for i=1, CRUSADER_STRIKE_TICKS do
        textureObjectName = "crusader_strike_Counter"..i
	    local texture = getglobal(textureObjectName)
        PallyAddonLog("Texture name: ".. textureObjectName, CRUSADER_STRIKE_VERBOSE)
	    if ( i <= crusader_strike ) then
            PallyAddonLog("Need to highlight ".. i, CRUSADER_STRIKE_VERBOSE)
            texture:Show()
	    else
            PallyAddonLog("Need to un-highlight ".. i, CRUSADER_STRIKE_VERBOSE)
            texture:Hide()
	    end
    end
end

function crusader_strike_update_status_bar()
    if CRUSADER_STRIKE_TIME_LEFT > 0 then
        CRUSADER_STRIKE_STATUS_BAR:Show()
        CRUSADER_STRIKE_STATUS_BAR:SetValue(CRUSADER_STRIKE_TIME_LEFT)
        CRUSADER_STRIKE_STATUS_BAR_text:SetText(string.format("%.0f", CRUSADER_STRIKE_TIME_LEFT))
    else
        CRUSADER_STRIKE_STATUS_BAR:Hide()
    end
end

function check_crusader_strike()
    local index = 1
    while true do
        local name, count = UnitBuff("player", index)
        if not name then
            update_crusader_strike_counter(0)
            break -- No more buffs to check
        end
        PallyAddonLog("Found buff ".. name, CRUSADER_STRIKE_VERBOSE)
        if name == "Interface\\Icons\\Spell_Holy_CrusaderStrike" then
            --
            -- THere is a bug here if count == 3 for a second time we aren't refreshing the timer!
            -- See if we can catch the cast on some kind of 'spell casted" trigger
            if count ~= CRUSADER_STRIKE_CURRENT_TICKS then
                CRUSADER_STRIKE_CURRENT_TICKS = count
                PallyAddonLog("Found crusader_strike with " .. count .." charges", CRUSADER_STRIKE_VERBOSE)
                update_crusader_strike_counter(count)
            end
            break
        end
        index = index + 1
    end
end

function crusader_strike_counter_OnEvent()
    if(event == "CHAT_MSG_SPELL_SELF_DAMAGE" and string.find(arg1, CRUSADER_STRIKE_CHAT_MSG_PREFIX) ~= nil) then
        CRUSADER_STRIKE_TIME_LEFT = CRUSADER_STRIKE_MAX_TIME
        crusader_strike_update_status_bar()
    end
    if(event == "UNIT_AURA" and arg1 == "player") then
        check_crusader_strike()
        return
    end
end