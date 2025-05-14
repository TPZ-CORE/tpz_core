RegisterNetEvent('tpz_core:setInstancePlayer', function(instance)
    if instance then
        NetworkStartSoloTutorialSession()
    else
        NetworkEndTutorialSession()
    end
end)
