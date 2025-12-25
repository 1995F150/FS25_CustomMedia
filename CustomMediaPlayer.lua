-- CustomMediaPlayer.lua
-- Starter mod for FS25: in-game media player

CustomMediaPlayer = {}
CustomMediaPlayer.MOD_NAME = "Custom Media Player"

-- Load mod when map loads
function CustomMediaPlayer:loadMap(name)
    print(self.MOD_NAME .. " loaded on map: " .. name)
end

-- Register event for radio change
function CustomMediaPlayer:onUpdate(dt)
    -- This is called every frame
    -- Here you can check which radio channel is active
    -- Example: if player switches to "Media Player" channel
    -- Then display UI
end

-- Example function to show a small UI
function CustomMediaPlayer:draw()
    -- Display a small rectangle in top-left corner
    if self.showUI then
        setTextBold(true)
        setTextColor(1, 1, 1, 1) -- white
        renderText(0.01, 0.95, 0.02, "Media Player Active")
        setTextBold(false)
    end
end

-- Register events
addModEventListener(CustomMediaPlayer)
