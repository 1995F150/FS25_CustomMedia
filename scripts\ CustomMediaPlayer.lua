-- FFA Themed Media Player Mod for FS25
-- Author: Jessie Crider
-- Plays Spotify Web and CriderGPT inside game

MediaWindow = {}
MediaWindow.isVisible = false

-- FFA Theme Colors (RGBA)
FFATheme = {
    bgColor    = {0.1, 0.1, 0.11, 1},
    spotify    = {0.11, 0.73, 0.33, 1},  -- Spotify green
    cridergpt  = {0.94, 0.65, 0.0, 1},   -- CriderGPT orange
    closeBtn   = {1, 0, 0, 1}            -- Red close button
}

-- Initialize the UI
function MediaWindow:init()
    -- Load GUI layout
    self.window = g_gui:loadGui("mediaUI.xml")
    self.window:setVisible(self.isVisible)

    -- Apply FFA background color
    local bg = self.window:find("MediaBackground")
    if bg ~= nil then
        bg:setColor(unpack(FFATheme.bgColor))
    end

    -- Find elements
    self.webView   = self.window:find("MediaWebView")
    self.spotifyBtn= self.window:find("SpotifyButton")
    self.criderBtn = self.window:find("CriderGPTButton")
    self.closeBtn  = self.window:find("CloseButton")

    -- Set button actions
    if self.spotifyBtn ~= nil then
        self.spotifyBtn.onClick = function()
            if self.webView ~= nil then
                self.webView:setUrl("https://open.spotify.com/")
                self.spotifyBtn:setColor(unpack(FFATheme.spotify))
            end
        end
    end

    if self.criderBtn ~= nil then
        self.criderBtn.onClick = function()
            if self.webView ~= nil then
                self.webView:setUrl("https://cridergpt.lovable.app/")
                self.criderBtn:setColor(unpack(FFATheme.cridergpt))
            end
        end
    end

    if self.closeBtn ~= nil then
        self.closeBtn.onClick = function()
            self:setVisible(false)
        end
        self.closeBtn:setColor(unpack(FFATheme.closeBtn))
    end

    -- Start on Spotify by default
    if self.webView ~= nil then
        self.webView:setUrl("https://open.spotify.com/")
    end
end

-- Toggle visibility of the media window
function MediaWindow:toggle()
    self.isVisible = not self.isVisible
    if self.window ~= nil then
        self.window:setVisible(self.isVisible)
    end
end

-- Explicitly set visibility
function MediaWindow:setVisible(state)
    self.isVisible = state
    if self.window ~= nil then
        self.window:setVisible(state)
    end
end

-- Initialize media window when game loads
MediaWindow:init()

-- Optional: bind to a key (example: F9)
function onKeyDown(key)
    if key == Input.KEY_F9 then
        MediaWindow:toggle()
    end
end
