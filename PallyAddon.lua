function PallyAddonLog(message, verbose_arg)
    local verbose = verbose_arg or false
    if verbose then
        DEFAULT_CHAT_FRAME:AddMessage(message , 1, .4, 1);
    end
end