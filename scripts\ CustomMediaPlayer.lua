-- FFA Themed Media Player Mod for FS25
-- Author: Jessie Crider
-- Description: In-game window to browse Spotify Web and CriderGPT

MediaWindow = {}
MediaWindow.isVisible = false

-- FFA Theme Colors (RGBA)
FFATheme = {
    bgColor     = {0.1,  0.1,  0.11, 1.0},
    spotify     = {0.11, 0.73, 0.33, 1.0},  -- Spotify green
    cridergpt   = {0.94, 0.65, 0.00, 1.0},  -- CriderGPT orange
    closeBtn    = {1.0,  0.0,  0.0,  1.0},  -- Red close button
    textColor   = {1.0,  1.0,  1.0,  1.0}
}

function MediaWindow:init()
    if self.window ~= nil then
        return -- Already initialized
    end

    -- Load the GUI layout (make sure mediaUI.xml is in the correct folder)
    self.window = g_gui:loadGui("mediaUI.xml", "MediaWindow", self, true)

    if self.window == nil then
        print("Error: Could not load mediaUI.xml!")
        return
    end

    self.window:setVisible(false)

    -- Apply FFA background color
    local bg = self.window:find("MediaBackground")
    if bg ~= nil then
        bg:setColor(unpack(FFATheme.bgColor))
    end

    -- Find UI elements
    self.webView     = self.window:find("MediaWebView")
    self.spotifyBtn  = self.window:find("SpotifyButton")
    self.criderBtn   = self.window:find("CriderGPTButton")
    self.closeBtn    = self.window:find("CloseButton")

    -- Button actions
    if self.spotifyBtn ~= nil then
        self.spotifyBtn.onClick = function()
            if self.webView ~= nil then
                self.webView:setUrl("https://open.spotify.com/")
            end
            -- Optional: highlight active button
            self.spotifyBtn:setColor(unpack(FFATheme.spotify))
            if self.criderBtn then self.criderBtn:setColor(1,1,1,1) end
        end
    end

    if self.criderBtn ~= nil then
        self.criderBtn.onClick = function()
            if self.webView ~= nil then
                self.webView:setUrl("https://cridergpt.lovable.app/")
            end
            self.criderBtn:setColor(unpack(FFATheme.cridergpt))
            if self.spotifyBtn then self.spotifyBtn:setColor(1,1,1,1) end
        end
    end

    if self.closeBtn ~= nil then
        self.closeBtn.onClick = function()
            self:setVisible(false)
        end
        self.closeBtn:setColor(unpack(FFATheme.closeBtn))
    end

    -- Default to Spotify on open
    if self.webView ~= nil then
        self.webView:setUrl("https://open.spotify.com/")
    end

    print("FFA Media Player initialized successfully!")
end

function MediaWindow:toggle()
    self.isVisible = not self.isVisible
    self:setVisible(self.isVisible)
end

function MediaWindow:setVisible(state)
    self.isVisible = state
    if self.window ~= nil then
        self.window:setVisible(state)
    end
end

-- Key binding (F9 by default)
function MediaWindow:keyEvent(unicode, key, down, shift, ctrl, alt)
    if down and key == Input.KEY_F9 then
        self:toggle()
    end
end

-- Initialize when the mod is loaded
MediaWindow:init()

-- Register the key event (better than global onKeyDown)
g_inputBinding:registerActionEvent(InputAction.MENU, MediaWindow, MediaWindow.keyEvent, false, true, false, true)
