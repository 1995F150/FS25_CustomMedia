-- FFA Themed Media Player Mod for FS25
-- Author: Jessie Crider
-- Features: Spotify + CriderGPT + Draggable + Minimize

MediaWindow = {}
MediaWindow.isVisible = false
MediaWindow.isMinimized = false
MediaWindow.lastPosition = {x = nil, y = nil}

-- FFA Theme Colors
FFATheme = {
    bgColor         = {0.10, 0.10, 0.11, 1.0},
    spotify         = {0.11, 0.73, 0.33, 1.0},
    cridergpt       = {0.94, 0.65, 0.00, 1.0},
    closeBtn        = {1.00, 0.30, 0.30, 1.0},
    minimizeBtn     = {1.00, 0.80, 0.40, 1.0},
    inactiveBtn     = {0.65, 0.65, 0.70, 1.0},
    hoverBright     = {1.0, 1.0, 1.0, 1.0}
}

function MediaWindow:init()
    if self.window ~= nil then return end

    self.window = g_gui:loadGui("customMediaPlayer.xml", "CustomMediaPlayer", self)

    if self.window == nil then
        print("Error: Could not load customMediaPlayer.xml")
        return
    end

    self.window:setVisible(false)

    -- Find elements
    self.mainFrame     = self.window:find("MainFrame")
    self.bg            = self.window:find("MediaBackground")
    self.webView       = self.window:find("MediaWebView")
    self.spotifyBtn    = self.window:find("SpotifyButton")
    self.criderBtn     = self.window:find("CriderGPTButton")
    self.closeBtn      = self.window:find("CloseButton")
    self.minimizeBtn   = self.window:find("MinimizeButton")
    self.titleBar      = self.window:find("TitleBar")

    if self.bg then
        self.bg:setColor(unpack(FFATheme.bgColor))
    end

    -- Button actions
    if self.spotifyBtn then
        self.spotifyBtn.onClick = function()
            if self.webView then self.webView:setUrl("https://open.spotify.com/") end
            self:highlightButton("spotify")
        end
    end

    if self.criderBtn then
        self.criderBtn.onClick = function()
            if self.webView then self.webView:setUrl("https://cridergpt.lovable.app/") end
            self:highlightButton("cridergpt")
        end
    end

    if self.closeBtn then
        self.closeBtn.onClick = function() self:setVisible(false) end
        self.closeBtn:setColor(unpack(FFATheme.closeBtn))
    end

    if self.minimizeBtn then
        self.minimizeBtn.onClick = function() self:minimize() end
        self.minimizeBtn:setColor(unpack(FFATheme.minimizeBtn))
    end

    -- Default to Spotify
    if self.webView then
        self.webView:setUrl("https://open.spotify.com/")
        self:highlightButton("spotify")
    end

    print("FFA Media Player ready! Press F9 to open.")
end

function MediaWindow:highlightButton(active)
    if self.spotifyBtn then
        self.spotifyBtn:setColor(active == "spotify" and unpack(FFATheme.spotify) or unpack(FFATheme.inactiveBtn))
    end
    if self.criderBtn then
        self.criderBtn:setColor(active == "cridergpt" and unpack(FFATheme.cridergpt) or unpack(FFATheme.inactiveBtn))
    end
end

function MediaWindow:minimize()
    if self.mainFrame and self.isVisible then
        self.isMinimized = true
        self.lastPosition = {x = self.mainFrame:getPositionX(), y = self.mainFrame:getPositionY()}
        self:setVisible(false)
    end
end

function MediaWindow:toggle()
    if self.isMinimized then
        self.isMinimized = false
        self:setVisible(true)
        if self.lastPosition.x then
            self.mainFrame:setPosition(self.lastPosition.x, self.lastPosition.y)
        end
    else
        self.isVisible = not self.isVisible
        self:setVisible(self.isVisible)
    end
end

function MediaWindow:setVisible(state)
    self.isVisible = state
    if self.window then
        self.window:setVisible(state)
    end
end

-- Key handling
function MediaWindow:keyEvent(unicode, key, down, shift, ctrl, alt)
    if down and key == Input.KEY_F9 then
        self:toggle()
    end
end

-- Initialize
MediaWindow:init()

-- Register key
if g_inputBinding then
    g_inputBinding:registerActionEvent(InputAction.MENU, MediaWindow, MediaWindow.keyEvent, false, true, false, true)
end
