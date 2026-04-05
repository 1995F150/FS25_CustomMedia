-- FFA Themed Media Player Mod for FS25
-- Author: Jessie Crider
-- Description: In-game window to browse Spotify Web and CriderGPT

MediaWindow = {}
MediaWindow.isVisible = false

-- FFA Theme Colors (RGBA)
FFATheme = {
    bgColor     = {0.1,  0.1,  0.11, 1.0},
    spotify     = {0.11, 0.73, 0.33, 1.0},   -- Spotify green
    cridergpt   = {0.94, 0.65, 0.00, 1.0},   -- CriderGPT orange
    closeBtn    = {1.00, 0.00, 0.00, 1.0},   -- Red close button
    inactiveBtn = {0.7,  0.7,  0.7,  1.0}    -- Gray for inactive button
}

function MediaWindow:init()
    if self.window ~= nil then
        return -- Prevent double initialization
    end

    -- Load GUI (correct way for FS25)
    self.window = g_gui:loadGui("customMediaPlayer.xml", "MediaWindow", self)

    if self.window == nil then
        print("Error: Failed to load customMediaPlayer.xml!")
        return
    end

    self.window:setVisible(false)

    -- Apply background color
    local bg = self.window:find("MediaBackground")
    if bg then
        bg:setColor(unpack(FFATheme.bgColor))
    end

    -- Find UI elements
    self.webView     = self.window:find("MediaWebView")
    self.spotifyBtn  = self.window:find("SpotifyButton")
    self.criderBtn   = self.window:find("CriderGPTButton")
    self.closeBtn    = self.window:find("CloseButton")

    -- Spotify Button
    if self.spotifyBtn then
        self.spotifyBtn.onClick = function()
            if self.webView then
                self.webView:setUrl("https://open.spotify.com/")
            end
            self:highlightButton("spotify")
        end
    end

    -- CriderGPT Button
    if self.criderBtn then
        self.criderBtn.onClick = function()
            if self.webView then
                self.webView:setUrl("https://cridergpt.lovable.app/")
            end
            self:highlightButton("cridergpt")
        end
    end

    -- Close Button
    if self.closeBtn then
        self.closeBtn.onClick = function()
            self:setVisible(false)
        end
        self.closeBtn:setColor(unpack(FFATheme.closeBtn))
    end

    -- Default to Spotify
    if self.webView then
        self.webView:setUrl("https://open.spotify.com/")
        self:highlightButton("spotify")
    end

    print("FFA Media Player loaded successfully! Press F9 to open.")
end

function MediaWindow:highlightButton(active)
    if self.spotifyBtn then
        if active == "spotify" then
            self.spotifyBtn:setColor(unpack(FFATheme.spotify))
        else
            self.spotifyBtn:setColor(unpack(FFATheme.inactiveBtn))
        end
    end

    if self.criderBtn then
        if active == "cridergpt" then
            self.criderBtn:setColor(unpack(FFATheme.cridergpt))
        else
            self.criderBtn:setColor(unpack(FFATheme.inactiveBtn))
        end
    end
end

function MediaWindow:toggle()
    self.isVisible = not self.isVisible
    self:setVisible(self.isVisible)
end

function MediaWindow:setVisible(state)
    self.isVisible = state
    if self.window then
        self.window:setVisible(state)
    end
end

-- Key handling for FS25
function MediaWindow:keyEvent(unicode, key, down, shift, ctrl, alt)
    if down and key == Input.KEY_F9 then
        self:toggle()
    end
end

-- Initialize the mod
MediaWindow:init()

-- Register key event properly
if g_inputBinding then
    g_inputBinding:registerActionEvent(InputAction.MENU, MediaWindow, MediaWindow.keyEvent, false, true, false, true)
end
