REDOUBT_GAIN = "You gain Redoubt.";
REDOUBT_LOSE = "Redoubt fades from you.";
REDOUBT_BLOCKED = "blocked";
REDOUBT_BLOCKS = 5

function redoubtcounter_initialize()
    if PALLY_ADDON_IS_PALADIN then
        --Sets redoubtcounter text above combo gauge (might remove ifv) 
        --redoubtcounter_display:SetText("redoubtCounter");
        update_redoubtcounter(0);
        redoubtcounter_core:RegisterForDrag("LeftButton");
        redoubtcounter_core:RegisterEvent("UNIT_AURA"); -- Watch for redoubr procs
        PallyAddonLog("PallyAddon - Redoubt Loaded")
    else
        --Auto hides if Player is not a Paladin
        redoubtcounter_core:Hide();
    end
end 

function update_redoubtcounter(redoubt)
    --Updates GUI to reflect redoubtonings stored
    --Shamelessly cut from ComboFrame.lua
    if ( redoubt > 0 ) then		
        redoubtcounter_core:Show()
        for i=1, REDOUBT_BLOCKS do
	    comboPointHighlight = getglobal("RedoubtCounter"..i.."Highlight");
	    comboPointShine = getglobal("RedoubtCounter"..i.."Shine");
	    if ( i <= redoubt ) then
	        if ( comboPointHighlight:GetAlpha() == 0 or redoubt == 5) then
		    -- Fade in the highlight and set a function that triggers when it is done fading
		    fadeInfo = {};
            fadeInfo.mode = "IN";
		    fadeInfo.timeToFade = .4;
		    fadeInfo.finishedFunc = ComboPointShineFadeIn;
		    fadeInfo.finishedArg1 = comboPointShine;
		    UIFrameFade(comboPointHighlight, fadeInfo);
		end
	    else
	        comboPointHighlight:SetAlpha(0);
		    comboPointShine:SetAlpha(0);
	    end
	end
    else
        if UnitAffectingCombat("player") == nil then
            redoubtcounter_core:Hide()
        else
            RedoubtCounter1Highlight:SetAlpha(0);
	        RedoubtCounter1Shine:SetAlpha(0);
	        RedoubtCounter2Highlight:SetAlpha(0);
	        RedoubtCounter2Shine:SetAlpha(0);
	        RedoubtCounter3Highlight:SetAlpha(0);
	        RedoubtCounter3Shine:SetAlpha(0);
	        RedoubtCounter4Highlight:SetAlpha(0);
	        RedoubtCounter4Shine:SetAlpha(0);
	        RedoubtCounter5Highlight:SetAlpha(0);
	        RedoubtCounter5Shine:SetAlpha(0);
        end
    end
end

function checkRedoubt()
    local index = 1
    while true do
        local name, count = UnitBuff("player", index)
        if not name then
            update_redoubtcounter(0)
            break -- No more buffs to check
        end
        if name == "Interface\\Icons\\Ability_Defend" then
            local _, remaining_time = GetPlayerBuff(index)
            PallyAddonLog("Found redoubt with " .. count .." charges ".. " reamining time ".. remaining_time)
            update_redoubtcounter(count)
            break
        end
        index = index + 1
    end
end

function redoubtcounter_OnEvent()
    if(event == "UNIT_AURA" and arg1 == "player") then
        checkRedoubt()
    end
end



function ComboPointShineFadeIn(frame)
        -- Shamelessly cut from ComboFrame.lua
	-- Fade in the shine and then fade it out with the ComboPointShineFadeOut function
	local fadeInfo = {};
	fadeInfo.mode = "IN";
	fadeInfo.timeToFade = .6;
	fadeInfo.finishedFunc = ComboPointShineFadeOut;
	fadeInfo.finishedArg1 = frame:GetName();
	UIFrameFade(frame, fadeInfo);
end


function ComboPointShineFadeOut(frameName)
	UIFrameFadeOut(getglobal(frameName), .8);
end