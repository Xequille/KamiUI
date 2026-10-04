--[[
    KAMI UI - v1.0.0
    Luxury Dark & Gold Edition (Sharp Editorial Minimalist)
    Features:
      - Full Config Management (Save, Load, Delete, Auto-Load)
      - Keybind Selector for Toggle Key
      - Built-in Live Themes (Obsidian Gold, Pitch Dark, Cyber Gold, Midnight Gold)
      - Customizable Icons per Tab via Lucide ID / Image Asset
      - Live Stats Telemetry (FPS, Ping, Uptime, Memory)
      - Smooth Micro-interactions & Zero-Corner Styling
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local StatsService = game:GetService("Stats")

local Kami = {
    Version = "1.0.0"
}

-- Folder Penyimpanan Konfigurasi
local CONFIG_FOLDER = "KamiUI_Configs"
local AUTO_LOAD_FILE = "kamiui_autoload.json"

local Themes = {
    ["Obsidian Gold"] = {
        Bg          = Color3.fromRGB(8, 8, 9),
        Sidebar     = Color3.fromRGB(11, 11, 13),
        Card        = Color3.fromRGB(14, 14, 16),
        CardHover   = Color3.fromRGB(20, 20, 23),
        Border      = Color3.fromRGB(30, 28, 24),
        BorderHover = Color3.fromRGB(75, 68, 48),
        Gold        = Color3.fromRGB(212, 175, 55),
        GoldMuted   = Color3.fromRGB(135, 110, 42),
        Text        = Color3.fromRGB(245, 243, 238),
        TextMuted   = Color3.fromRGB(145, 140, 130),
        TextDull    = Color3.fromRGB(85, 82, 75),
    },
    ["Pitch Dark"] = {
        Bg          = Color3.fromRGB(5, 5, 5),
        Sidebar     = Color3.fromRGB(8, 8, 8),
        Card        = Color3.fromRGB(11, 11, 11),
        CardHover   = Color3.fromRGB(16, 16, 16),
        Border      = Color3.fromRGB(24, 24, 24),
        BorderHover = Color3.fromRGB(50, 50, 50),
        Gold        = Color3.fromRGB(190, 190, 190),
        GoldMuted   = Color3.fromRGB(110, 110, 110),
        Text        = Color3.fromRGB(240, 240, 240),
        TextMuted   = Color3.fromRGB(130, 130, 130),
        TextDull    = Color3.fromRGB(70, 70, 70),
    },
    ["Cyber Gold"] = {
        Bg          = Color3.fromRGB(10, 11, 14),
        Sidebar     = Color3.fromRGB(13, 14, 18),
        Card        = Color3.fromRGB(16, 18, 22),
        CardHover   = Color3.fromRGB(22, 25, 32),
        Border      = Color3.fromRGB(35, 40, 45),
        BorderHover = Color3.fromRGB(85, 80, 55),
        Gold        = Color3.fromRGB(245, 195, 65),
        GoldMuted   = Color3.fromRGB(150, 125, 45),
        Text        = Color3.fromRGB(240, 244, 248),
        TextMuted   = Color3.fromRGB(140, 145, 155),
        TextDull    = Color3.fromRGB(80, 85, 95),
    },
    ["Midnight Gold"] = {
        Bg          = Color3.fromRGB(6, 8, 12),
        Sidebar     = Color3.fromRGB(9, 11, 16),
        Card        = Color3.fromRGB(12, 15, 22),
        CardHover   = Color3.fromRGB(17, 21, 30),
        Border      = Color3.fromRGB(25, 32, 45),
        BorderHover = Color3.fromRGB(60, 65, 55),
        Gold        = Color3.fromRGB(220, 180, 70),
        GoldMuted   = Color3.fromRGB(130, 110, 50),
        Text        = Color3.fromRGB(235, 240, 245),
        TextMuted   = Color3.fromRGB(130, 138, 150),
        TextDull    = Color3.fromRGB(75, 82, 92),
    }
}

local CurrentTheme = Themes["Obsidian Gold"]

local Lucide = {
    home = "rbxassetid://93110857987859",
    settings = "rbxassetid://85241284670779",
    info = "rbxassetid://92425452073561",
    chevron = "rbxassetid://134243273101015",
    zap = "rbxassetid://130551565616516",
    user = "rbxassetid://81589895647169",
    terminal = "rbxassetid://106783148545356",
    sliders = "rbxassetid://132977703952271",
    shield = "rbxassetid://77608084747459",
    folder = "rbxassetid://122945524502470",
    check = "rbxassetid://93898873302694",
}

local function ResolveIcon(icon)
    if not icon then return nil end
    if type(icon) == "string" then
        if Lucide[icon:lower()] then
            return Lucide[icon:lower()]
        elseif icon:match("^rbxassetid://") then
            return icon
        elseif tonumber(icon) then
            return "rbxassetid://" .. icon
        end
    elseif type(icon) == "number" then
        return "rbxassetid://" .. tostring(icon)
    end
    return nil
end

local function GetParent()
    if gethui then return gethui() end
    return CoreGui
end

if getgenv and getgenv().KamiUIInstance then
    pcall(function() getgenv().KamiUIInstance:Destroy() end)
end

local Screen = Instance.new("ScreenGui")
Screen.Name = "KamiUI_" .. tostring(math.random(10000, 99999))
Screen.ResetOnSpawn = false
Screen.IgnoreGuiInset = true
Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Screen.Parent = GetParent()

if getgenv then getgenv().KamiUIInstance = Screen end

-- Theme Repainter Subsystem
local Repainters = {}
local function RegisterPaint(fn)
    table.insert(Repainters, fn)
    pcall(fn)
end

local function ApplyTheme(themeName)
    local t = Themes[themeName]
    if not t then return end
    CurrentTheme = t
    for i = #Repainters, 1, -1 do
        local ok = pcall(Repainters[i])
        if not ok then table.remove(Repainters, i) end
    end
end

-- Loading Screen Animation
function Kami:ShowLoadingScreen(cfg)
    cfg = cfg or {}
    local steps = cfg.Steps or {
        "Initializing environment...",
        "Validating client profile...",
        "Rendering UI elements...",
        "Done."
    }
    local duration = cfg.Duration or 2.2

    local LoadGui = Instance.new("ScreenGui")
    LoadGui.Name = "Kami_Loading"
    LoadGui.ResetOnSpawn = false
    LoadGui.IgnoreGuiInset = true
    LoadGui.DisplayOrder = 999
    LoadGui.Parent = GetParent()

    local Bg = Instance.new("Frame")
    Bg.Size = UDim2.new(1, 0, 1, 0)
    Bg.BackgroundColor3 = CurrentTheme.Bg
    Bg.BorderSizePixel = 0
    Bg.Parent = LoadGui

    local Center = Instance.new("Frame")
    Center.AnchorPoint = Vector2.new(0.5, 0.5)
    Center.Position = UDim2.new(0.5, 0, 0.5, 0)
    Center.Size = UDim2.fromOffset(300, 180)
    Center.BackgroundTransparency = 1
    Center.Parent = Bg

    local KLogo = Instance.new("TextLabel")
    KLogo.AnchorPoint = Vector2.new(0.5, 0.5)
    KLogo.Position = UDim2.new(0.5, 0, 0.25, 0)
    KLogo.Size = UDim2.fromOffset(50, 50)
    KLogo.BackgroundTransparency = 1
    KLogo.Text = "K"
    KLogo.Font = Enum.Font.GothamBold
    KLogo.TextSize = 42
    KLogo.TextColor3 = CurrentTheme.Gold
    KLogo.TextTransparency = 1
    KLogo.Parent = Center

    local Title = Instance.new("TextLabel")
    Title.Position = UDim2.new(0, 0, 0.52, 0)
    Title.Size = UDim2.new(1, 0, 0, 16)
    Title.BackgroundTransparency = 1
    Title.Text = (cfg.Title or "KAMI UI"):upper()
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 11
    Title.TextColor3 = CurrentTheme.Text
    Title.TextTransparency = 1
    Title.Parent = Center

    local Status = Instance.new("TextLabel")
    Status.Position = UDim2.new(0, 0, 0.65, 0)
    Status.Size = UDim2.new(1, 0, 0, 14)
    Status.BackgroundTransparency = 1
    Status.Text = steps[1] or "Loading..."
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 10
    Status.TextColor3 = CurrentTheme.GoldMuted
    Status.TextTransparency = 1
    Status.Parent = Center

    local BarBg = Instance.new("Frame")
    BarBg.Position = UDim2.new(0.1, 0, 0.85, 0)
    BarBg.Size = UDim2.new(0.8, 0, 0, 2)
    BarBg.BackgroundColor3 = CurrentTheme.Border
    BarBg.BorderSizePixel = 0
    BarBg.Parent = Center

    local BarFill = Instance.new("Frame")
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = CurrentTheme.Gold
    BarFill.BorderSizePixel = 0
    BarFill.Parent = BarBg

    TweenService:Create(KLogo, TweenInfo.new(0.35), { TextTransparency = 0 }):Play()
    TweenService:Create(Title, TweenInfo.new(0.35), { TextTransparency = 0 }):Play()
    TweenService:Create(Status, TweenInfo.new(0.35), { TextTransparency = 0 }):Play()

    local pulsing = true
    task.spawn(function()
        while pulsing and KLogo.Parent do
            TweenService:Create(KLogo, TweenInfo.new(0.55, Enum.EasingStyle.Sine), { TextColor3 = CurrentTheme.Text }):Play()
            task.wait(0.55)
            if not pulsing then break end
            TweenService:Create(KLogo, TweenInfo.new(0.55, Enum.EasingStyle.Sine), { TextColor3 = CurrentTheme.Gold }):Play()
            task.wait(0.55)
        end
    end)

    local delayPerStep = duration / #steps
    for i, stepText in ipairs(steps) do
        Status.Text = stepText
        local targetRatio = i / #steps
        TweenService:Create(BarFill, TweenInfo.new(delayPerStep * 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(targetRatio, 0, 1, 0)
        }):Play()
        task.wait(delayPerStep)
    end

    pulsing = false

    TweenService:Create(Bg, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(KLogo, TweenInfo.new(0.2), { TextTransparency = 1 }):Play()
    TweenService:Create(Title, TweenInfo.new(0.2), { TextTransparency = 1 }):Play()
    TweenService:Create(Status, TweenInfo.new(0.2), { TextTransparency = 1 }):Play()
    TweenService:Create(BarBg, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(BarFill, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()

    task.wait(0.32)
    LoadGui:Destroy()
end

-- Global Dropdown Overlay
local GlobalDropdown = Instance.new("Frame")
GlobalDropdown.Size = UDim2.fromOffset(130, 0)
GlobalDropdown.BackgroundColor3 = CurrentTheme.Card
GlobalDropdown.BorderSizePixel = 0
GlobalDropdown.ZIndex = 100
GlobalDropdown.Visible = false
GlobalDropdown.ClipsDescendants = true
GlobalDropdown.Parent = Screen

local DropStroke = Instance.new("UIStroke")
DropStroke.Color = CurrentTheme.GoldMuted
DropStroke.Thickness = 1
DropStroke.Parent = GlobalDropdown

RegisterPaint(function()
    GlobalDropdown.BackgroundColor3 = CurrentTheme.Card
    DropStroke.Color = CurrentTheme.GoldMuted
end)

local DropScroll = Instance.new("ScrollingFrame")
DropScroll.Size = UDim2.new(1, 0, 1, 0)
DropScroll.BackgroundTransparency = 1
DropScroll.BorderSizePixel = 0
DropScroll.ScrollBarThickness = 2
DropScroll.ScrollBarImageColor3 = CurrentTheme.Gold
DropScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
DropScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
DropScroll.Parent = GlobalDropdown

local DropLayout = Instance.new("UIListLayout")
DropLayout.Padding = UDim.new(0, 0)
DropLayout.Parent = DropScroll

local CurrentDropdown = nil
local function CloseDropdown()
    if not CurrentDropdown then return end
    CurrentDropdown = nil
    TweenService:Create(GlobalDropdown, TweenInfo.new(0.12, Enum.EasingStyle.Quad), { Size = UDim2.fromOffset(GlobalDropdown.Size.X.Offset, 0) }):Play()
    task.delay(0.13, function()
        if not CurrentDropdown then GlobalDropdown.Visible = false end
    end)
end

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and CurrentDropdown then
        local mousePos = input.Position
        local dropPos = GlobalDropdown.AbsolutePosition
        local dropSize = GlobalDropdown.AbsoluteSize
        if mousePos.X < dropPos.X or mousePos.X > dropPos.X + dropSize.X or mousePos.Y < dropPos.Y or mousePos.Y > dropPos.Y + dropSize.Y then
            CloseDropdown()
        end
    end
end)

function Kami:Notify(cfg)
    cfg = cfg or {}
    local nTitle = cfg.Title or "Notification"
    local nDesc = cfg.Content or ""
    local nDur = cfg.Duration or 3

    local notifyHolder = Screen:FindFirstChild("NotifyHolder")
    if not notifyHolder then
        notifyHolder = Instance.new("Frame")
        notifyHolder.Name = "NotifyHolder"
        notifyHolder.Size = UDim2.new(0, 270, 1, -20)
        notifyHolder.Position = UDim2.new(1, -280, 0, 10)
        notifyHolder.BackgroundTransparency = 1
        notifyHolder.Parent = Screen

        local nLayout = Instance.new("UIListLayout")
        nLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        nLayout.Padding = UDim.new(0, 6)
        nLayout.Parent = notifyHolder
    end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = CurrentTheme.Card
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.Parent = notifyHolder

    local cStroke = Instance.new("UIStroke")
    cStroke.Color = CurrentTheme.GoldMuted
    cStroke.Thickness = 1
    cStroke.Parent = card

    local cPad = Instance.new("UIPadding")
    cPad.PaddingTop = UDim.new(0, 8); cPad.PaddingBottom = UDim.new(0, 8)
    cPad.PaddingLeft = UDim.new(0, 12); cPad.PaddingRight = UDim.new(0, 12)
    cPad.Parent = card

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, 0, 0, 14)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = nTitle:upper()
    titleLbl.Font = Enum.Font.GothamMedium
    titleLbl.TextSize = 10
    titleLbl.TextColor3 = CurrentTheme.Gold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = card

    local descLbl = Instance.new("TextLabel")
    descLbl.Position = UDim2.fromOffset(0, 16)
    descLbl.Size = UDim2.new(1, 0, 0, 0)
    descLbl.AutomaticSize = Enum.AutomaticSize.Y
    descLbl.BackgroundTransparency = 1
    descLbl.Text = nDesc
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 11
    descLbl.TextColor3 = CurrentTheme.Text
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.TextWrapped = true
    descLbl.Parent = card

    task.delay(nDur, function()
        if card and card.Parent then
            local tw = TweenService:Create(card, TweenInfo.new(0.2), { BackgroundTransparency = 1 })
            tw:Play()
            tw.Completed:Connect(function() card:Destroy() end)
        end
    end)
end

function Kami:CreateWindow(cfg)
    cfg = cfg or {}
    local winName = cfg.Name or "KAMI"
    local winSub = cfg.SubTitle or "menu"
    local winSize = cfg.Size or UDim2.fromOffset(620, 430)
    local minKey = cfg.MinimizeKey or Enum.KeyCode.RightControl

    if cfg.Loading and cfg.Loading.Enabled ~= false then
        Kami:ShowLoadingScreen(cfg.Loading)
    end

    local Window = {
        Tabs = {},
        CurrentTab = nil,
        Flags = {},
        ActiveConfig = "default",
        ToggleKey = minKey,
        AutoLoad = false
    }

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Kami_Main"
    MainFrame.Size = winSize
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundColor3 = CurrentTheme.Bg
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = Screen

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = CurrentTheme.Border
    MainStroke.Thickness = 1
    MainStroke.Parent = MainFrame

    RegisterPaint(function()
        MainFrame.BackgroundColor3 = CurrentTheme.Bg
        MainStroke.Color = CurrentTheme.Border
    end)

    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 36)
    Header.BackgroundColor3 = CurrentTheme.Sidebar
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local HeaderLine = Instance.new("Frame")
    HeaderLine.Size = UDim2.new(1, 0, 0, 1)
    HeaderLine.Position = UDim2.new(0, 0, 1, -1)
    HeaderLine.BackgroundColor3 = CurrentTheme.Border
    HeaderLine.BorderSizePixel = 0
    HeaderLine.Parent = Header

    local LogoDiamond = Instance.new("TextLabel")
    LogoDiamond.Size = UDim2.fromOffset(36, 36)
    LogoDiamond.BackgroundTransparency = 1
    LogoDiamond.Text = "◆"
    LogoDiamond.Font = Enum.Font.GothamMedium
    LogoDiamond.TextSize = 10
    LogoDiamond.TextColor3 = CurrentTheme.Gold
    LogoDiamond.Parent = Header

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Position = UDim2.fromOffset(34, 0)
    TitleLabel.Size = UDim2.new(1, -90, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = string.format("<b>%s</b>  <font color=\"#48453E\">/  %s</font>", winName:upper(), winSub)
    TitleLabel.RichText = true
    TitleLabel.Font = Enum.Font.Gotham
    TitleLabel.TextSize = 11
    TitleLabel.TextColor3 = CurrentTheme.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.fromOffset(36, 36)
    MinBtn.Position = UDim2.new(1, -36, 0, 0)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "—"
    MinBtn.Font = Enum.Font.Gotham
    MinBtn.TextSize = 11
    MinBtn.TextColor3 = CurrentTheme.TextMuted
    MinBtn.Parent = Header

    RegisterPaint(function()
        Header.BackgroundColor3 = CurrentTheme.Sidebar
        HeaderLine.BackgroundColor3 = CurrentTheme.Border
        LogoDiamond.TextColor3 = CurrentTheme.Gold
        TitleLabel.TextColor3 = CurrentTheme.Text
        MinBtn.TextColor3 = CurrentTheme.TextMuted
    end)

    local isMinimized = false
    local function ToggleMin()
        isMinimized = not isMinimized
        CloseDropdown()
        MainFrame.Visible = not isMinimized
    end
    MinBtn.MouseButton1Click:Connect(ToggleMin)
    UserInputService.InputBegan:Connect(function(inp, proc)
        if not proc and inp.KeyCode == Window.ToggleKey then ToggleMin() end
    end)

    -- Window Draggable
    local dragging, dragStart, startPos = false, nil, nil
    Header.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = inp.Position; startPos = MainFrame.Position
        end
    end)
    Header.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local delta = inp.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 140, 1, -36)
    Sidebar.Position = UDim2.new(0, 0, 0, 36)
    Sidebar.BackgroundColor3 = CurrentTheme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SidebarBorder = Instance.new("Frame")
    SidebarBorder.Size = UDim2.new(0, 1, 1, 0)
    SidebarBorder.Position = UDim2.new(1, -1, 0, 0)
    SidebarBorder.BackgroundColor3 = CurrentTheme.Border
    SidebarBorder.BorderSizePixel = 0
    SidebarBorder.Parent = Sidebar

    local NavScroll = Instance.new("ScrollingFrame")
    NavScroll.Size = UDim2.new(1, 0, 1, -26)
    NavScroll.BackgroundTransparency = 1
    NavScroll.BorderSizePixel = 0
    NavScroll.ScrollBarThickness = 0
    NavScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    NavScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    NavScroll.Parent = Sidebar

    local NavLayout = Instance.new("UIListLayout")
    NavLayout.Padding = UDim.new(0, 2)
    NavLayout.Parent = NavScroll

    local NavPad = Instance.new("UIPadding")
    NavPad.PaddingTop = UDim.new(0, 8); NavPad.PaddingLeft = UDim.new(0, 6); NavPad.PaddingRight = UDim.new(0, 6)
    NavPad.Parent = NavScroll

    local Footer = Instance.new("TextLabel")
    Footer.Size = UDim2.new(1, -14, 0, 22)
    Footer.Position = UDim2.new(0, 10, 1, -22)
    Footer.BackgroundTransparency = 1
    Footer.Text = "KAMI · v" .. Kami.Version
    Footer.Font = Enum.Font.Gotham
    Footer.TextSize = 9
    Footer.TextColor3 = CurrentTheme.TextDull
    Footer.TextXAlignment = Enum.TextXAlignment.Left
    Footer.Parent = Sidebar

    RegisterPaint(function()
        Sidebar.BackgroundColor3 = CurrentTheme.Sidebar
        SidebarBorder.BackgroundColor3 = CurrentTheme.Border
        Footer.TextColor3 = CurrentTheme.TextDull
    end)

    local ContentHolder = Instance.new("Frame")
    ContentHolder.Size = UDim2.new(1, -140, 1, -36)
    ContentHolder.Position = UDim2.new(0, 140, 0, 36)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.ClipsDescendants = true
    ContentHolder.Parent = MainFrame

    -- Config Management Core Logic
    local function GetConfigList()
        if not listfiles or not isfolder then return { "default" } end
        if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
        local list = {}
        for _, f in ipairs(listfiles(CONFIG_FOLDER)) do
            local clean = f:match("([^/\\]+)%.json$")
            if clean then table.insert(list, clean) end
        end
        if #list == 0 then table.insert(list, "default") end
        return list
    end

    function Window:SaveConfig(name)
        if not writefile then return false end
        if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
        name = name or Window.ActiveConfig or "default"
        local data = {}
        for flag, item in pairs(Window.Flags) do
            data[flag] = item.Value
        end
        local encoded = HttpService:JSONEncode(data)
        writefile(CONFIG_FOLDER .. "/" .. name .. ".json", encoded)
        Window.ActiveConfig = name
        return true
    end

    function Window:LoadConfig(name)
        if not readfile or not isfile then return false end
        name = name or Window.ActiveConfig or "default"
        local path = CONFIG_FOLDER .. "/" .. name .. ".json"
        if not isfile(path) then return false end
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
        if not ok or not data then return false end
        for flag, val in pairs(data) do
            if Window.Flags[flag] and Window.Flags[flag].Set then
                Window.Flags[flag].Set(val)
            end
        end
        Window.ActiveConfig = name
        return true
    end

    function Window:DeleteConfig(name)
        if not delfile or not isfile then return false end
        local path = CONFIG_FOLDER .. "/" .. name .. ".json"
        if isfile(path) then
            delfile(path)
            return true
        end
        return false
    end

    -- Tab Builder
    function Window:AddTab(opt)
        opt = opt or {}
        local tabTitle = opt.Title or "Tab"
        local tabIcon = ResolveIcon(opt.Icon)

        local Tab = {}
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 28)
        TabBtn.BackgroundColor3 = CurrentTheme.Card
        TabBtn.BackgroundTransparency = 1
        TabBtn.BorderSizePixel = 0
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = NavScroll

        local TabIndicator = Instance.new("Frame")
        TabIndicator.Size = UDim2.new(0, 2, 0, 12)
        TabIndicator.Position = UDim2.new(0, 2, 0.5, -6)
        TabIndicator.BackgroundColor3 = CurrentTheme.Gold
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Visible = false
        TabIndicator.Parent = TabBtn

        local textOffset = 12
        local iconImg = nil
        if tabIcon then
            iconImg = Instance.new("ImageLabel")
            iconImg.Size = UDim2.fromOffset(13, 13)
            iconImg.Position = UDim2.new(0, 10, 0.5, -6)
            iconImg.BackgroundTransparency = 1
            iconImg.Image = tabIcon
            iconImg.ImageColor3 = CurrentTheme.TextMuted
            iconImg.Parent = TabBtn
            textOffset = 28
        end

        local TabLbl = Instance.new("TextLabel")
        TabLbl.Size = UDim2.new(1, -textOffset, 1, 0)
        TabLbl.Position = UDim2.fromOffset(textOffset, 0)
        TabLbl.BackgroundTransparency = 1
        TabLbl.Text = tabTitle
        TabLbl.Font = Enum.Font.GothamMedium
        TabLbl.TextSize = 11
        TabLbl.TextColor3 = CurrentTheme.TextMuted
        TabLbl.TextXAlignment = Enum.TextXAlignment.Left
        TabLbl.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = CurrentTheme.BorderHover
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Visible = false
        Page.Parent = ContentHolder

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 6)
        PageLayout.Parent = Page

        local PagePad = Instance.new("UIPadding")
        PagePad.PaddingTop = UDim.new(0, 12); PagePad.PaddingBottom = UDim.new(0, 12)
        PagePad.PaddingLeft = UDim.new(0, 14); PagePad.PaddingRight = UDim.new(0, 14)
        PagePad.Parent = Page

        local function SetActive()
            CloseDropdown()
            for _, t in ipairs(Window.Tabs) do
                t.Page.Visible = false
                t.Indicator.Visible = false
                t.Label.TextColor3 = CurrentTheme.TextMuted
                t.Button.BackgroundTransparency = 1
                if t.Icon then t.Icon.ImageColor3 = CurrentTheme.TextMuted end
            end
            Page.Visible = true
            TabIndicator.Visible = true
            TabLbl.TextColor3 = CurrentTheme.Text
            TabBtn.BackgroundTransparency = 0
            if iconImg then iconImg.ImageColor3 = CurrentTheme.Gold end
            Window.CurrentTab = Tab
        end

        TabBtn.MouseButton1Click:Connect(SetActive)
        table.insert(Window.Tabs, { Button = TabBtn, Label = TabLbl, Indicator = TabIndicator, Page = Page, Icon = iconImg })
        if #Window.Tabs == 1 then SetActive() end

        RegisterPaint(function()
            TabBtn.BackgroundColor3 = CurrentTheme.Card
            TabIndicator.BackgroundColor3 = CurrentTheme.Gold
            Page.ScrollBarImageColor3 = CurrentTheme.BorderHover
            if Window.CurrentTab == Tab then
                TabLbl.TextColor3 = CurrentTheme.Text
                if iconImg then iconImg.ImageColor3 = CurrentTheme.Gold end
            else
                TabLbl.TextColor3 = CurrentTheme.TextMuted
                if iconImg then iconImg.ImageColor3 = CurrentTheme.TextMuted end
            end
        end)

        local function CreateRow(h)
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, h or 42)
            row.BackgroundColor3 = CurrentTheme.Card
            row.BorderSizePixel = 0
            row.Parent = Page

            local st = Instance.new("UIStroke")
            st.Color = CurrentTheme.Border
            st.Thickness = 1
            st.Parent = row

            RegisterPaint(function()
                row.BackgroundColor3 = CurrentTheme.Card
                st.Color = CurrentTheme.Border
            end)

            row.MouseEnter:Connect(function()
                TweenService:Create(st, TweenInfo.new(0.15), { Color = CurrentTheme.BorderHover }):Play()
                TweenService:Create(row, TweenInfo.new(0.15), { BackgroundColor3 = CurrentTheme.CardHover }):Play()
            end)
            row.MouseLeave:Connect(function()
                TweenService:Create(st, TweenInfo.new(0.15), { Color = CurrentTheme.Border }):Play()
                TweenService:Create(row, TweenInfo.new(0.15), { BackgroundColor3 = CurrentTheme.Card }):Play()
            end)

            return row, st
        end

        local function AddHeaderLabels(row, title, desc)
            local t = Instance.new("TextLabel")
            t.Position = UDim2.fromOffset(12, desc and 6 or 0)
            t.Size = UDim2.new(1, -120, 0, desc and 16 or row.Size.Y.Offset)
            t.BackgroundTransparency = 1
            t.Text = title or ""
            t.Font = Enum.Font.GothamMedium
            t.TextSize = 12
            t.TextColor3 = CurrentTheme.Text
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.Parent = row

            local d = nil
            if desc and desc ~= "" then
                d = Instance.new("TextLabel")
                d.Position = UDim2.fromOffset(12, 22)
                d.Size = UDim2.new(1, -120, 0, 14)
                d.BackgroundTransparency = 1
                d.Text = desc
                d.Font = Enum.Font.Gotham
                d.TextSize = 10
                d.TextColor3 = CurrentTheme.TextMuted
                d.TextXAlignment = Enum.TextXAlignment.Left
                d.Parent = row
            end

            RegisterPaint(function()
                t.TextColor3 = CurrentTheme.Text
                if d then d.TextColor3 = CurrentTheme.TextMuted end
            end)
        end

        -- Method Profile Card
        function Tab:AddProfileCard(c)
            c = c or {}
            local card = Instance.new("Frame")
            card.Size = UDim2.new(1, 0, 0, 68)
            card.BackgroundColor3 = CurrentTheme.Card
            card.BorderSizePixel = 0
            card.Parent = Page

            local cStroke = Instance.new("UIStroke")
            cStroke.Color = CurrentTheme.BorderHover
            cStroke.Thickness = 1
            cStroke.Parent = card

            local avatarImg = Instance.new("ImageLabel")
            avatarImg.Size = UDim2.fromOffset(48, 48)
            avatarImg.Position = UDim2.fromOffset(10, 10)
            avatarImg.BackgroundColor3 = CurrentTheme.Bg
            avatarImg.BorderSizePixel = 0
            avatarImg.Image = c.Image or ""
            avatarImg.Parent = card

            local aStroke = Instance.new("UIStroke")
            aStroke.Color = CurrentTheme.GoldMuted
            aStroke.Thickness = 1
            aStroke.Parent = avatarImg

            local dName = Instance.new("TextLabel")
            dName.Position = UDim2.fromOffset(68, 12)
            dName.Size = UDim2.new(1, -180, 0, 16)
            dName.BackgroundTransparency = 1
            dName.Text = c.DisplayName or "User"
            dName.Font = Enum.Font.GothamBold
            dName.TextSize = 13
            dName.TextColor3 = CurrentTheme.Gold
            dName.TextXAlignment = Enum.TextXAlignment.Left
            dName.Parent = card

            local uName = Instance.new("TextLabel")
            uName.Position = UDim2.fromOffset(68, 28)
            uName.Size = UDim2.new(1, -180, 0, 14)
            uName.BackgroundTransparency = 1
            uName.Text = "@" .. (c.Username or "username")
            uName.Font = Enum.Font.Gotham
            uName.TextSize = 10
            uName.TextColor3 = CurrentTheme.TextMuted
            uName.TextXAlignment = Enum.TextXAlignment.Left
            uName.Parent = card

            local statusSub = Instance.new("TextLabel")
            statusSub.Position = UDim2.fromOffset(68, 42)
            statusSub.Size = UDim2.new(1, -180, 0, 14)
            statusSub.BackgroundTransparency = 1
            statusSub.Text = c.Subtitle or "Active Client"
            statusSub.Font = Enum.Font.Gotham
            statusSub.TextSize = 9
            statusSub.TextColor3 = CurrentTheme.TextDull
            statusSub.TextXAlignment = Enum.TextXAlignment.Left
            statusSub.Parent = card

            local badge = Instance.new("Frame")
            badge.Size = UDim2.fromOffset(100, 24)
            badge.Position = UDim2.new(1, -110, 0.5, -12)
            badge.BackgroundColor3 = CurrentTheme.Bg
            badge.BorderSizePixel = 0
            badge.Parent = card

            local bStroke = Instance.new("UIStroke")
            bStroke.Color = CurrentTheme.Border
            bStroke.Thickness = 1
            bStroke.Parent = badge

            local badgeText = Instance.new("TextLabel")
            badgeText.Size = UDim2.new(1, 0, 1, 0)
            badgeText.BackgroundTransparency = 1
            badgeText.Text = c.Badge or "ONLINE"
            badgeText.Font = Enum.Font.GothamMedium
            badgeText.TextSize = 9
            badgeText.TextColor3 = CurrentTheme.Gold
            badgeText.Parent = badge

            RegisterPaint(function()
                card.BackgroundColor3 = CurrentTheme.Card
                cStroke.Color = CurrentTheme.BorderHover
                avatarImg.BackgroundColor3 = CurrentTheme.Bg
                aStroke.Color = CurrentTheme.GoldMuted
                dName.TextColor3 = CurrentTheme.Gold
                uName.TextColor3 = CurrentTheme.TextMuted
                statusSub.TextColor3 = CurrentTheme.TextDull
                badge.BackgroundColor3 = CurrentTheme.Bg
                bStroke.Color = CurrentTheme.Border
                badgeText.TextColor3 = CurrentTheme.Gold
            end)
        end

        -- Method Stat Grid
        function Tab:AddStatGrid(items)
            items = items or {}
            local gridH = math.ceil(#items / 2) * 44 + ((math.ceil(#items / 2) - 1) * 6)
            local gridHolder = Instance.new("Frame")
            gridHolder.Size = UDim2.new(1, 0, 0, gridH)
            gridHolder.BackgroundTransparency = 1
            gridHolder.Parent = Page

            local gLay = Instance.new("UIGridLayout")
            gLay.CellSize = UDim2.new(0.5, -3, 0, 44)
            gLay.CellPadding = UDim2.fromOffset(6, 6)
            gLay.Parent = gridHolder

            local statRefs = {}
            for _, stat in ipairs(items) do
                local sCard = Instance.new("Frame")
                sCard.BackgroundColor3 = CurrentTheme.Card
                sCard.BorderSizePixel = 0
                sCard.Parent = gridHolder

                local sStroke = Instance.new("UIStroke")
                sStroke.Color = CurrentTheme.Border
                sStroke.Thickness = 1
                sStroke.Parent = sCard

                local sKey = Instance.new("TextLabel")
                sKey.Position = UDim2.fromOffset(10, 6)
                sKey.Size = UDim2.new(1, -20, 0, 12)
                sKey.BackgroundTransparency = 1
                sKey.Text = string.upper(stat.Title or "")
                sKey.Font = Enum.Font.GothamMedium
                sKey.TextSize = 9
                sKey.TextColor3 = CurrentTheme.GoldMuted
                sKey.TextXAlignment = Enum.TextXAlignment.Left
                sKey.Parent = sCard

                local sVal = Instance.new("TextLabel")
                sVal.Position = UDim2.fromOffset(10, 20)
                sVal.Size = UDim2.new(1, -20, 0, 18)
                sVal.BackgroundTransparency = 1
                sVal.Text = stat.Value or "-"
                sVal.Font = Enum.Font.Gotham
                sVal.TextSize = 11
                sVal.TextColor3 = CurrentTheme.Text
                sVal.TextXAlignment = Enum.TextXAlignment.Left
                sVal.TextTruncate = Enum.TextTruncate.AtEnd
                sVal.Parent = sCard

                statRefs[stat.Title or ""] = sVal

                RegisterPaint(function()
                    sCard.BackgroundColor3 = CurrentTheme.Card
                    sStroke.Color = CurrentTheme.Border
                    sKey.TextColor3 = CurrentTheme.GoldMuted
                    sVal.TextColor3 = CurrentTheme.Text
                end)
            end

            local gridObj = {}
            function gridObj:Update(key, newVal)
                if statRefs[key] then statRefs[key].Text = tostring(newVal) end
            end
            return gridObj
        end

        -- Method Section Header dengan Fade Gradient
        function Tab:AddSection(c)
            local sHolder = Instance.new("Frame")
            sHolder.Size = UDim2.new(1, 0, 0, 20)
            sHolder.BackgroundTransparency = 1
            sHolder.Parent = Page

            local sText = Instance.new("TextLabel")
            sText.Position = UDim2.fromOffset(0, 0)
            sText.Size = UDim2.new(0, 0, 1, 0)
            sText.AutomaticSize = Enum.AutomaticSize.X
            sText.BackgroundTransparency = 1
            sText.Text = string.upper(c.Title or "")
            sText.Font = Enum.Font.GothamMedium
            sText.TextSize = 9
            sText.TextColor3 = CurrentTheme.GoldMuted
            sText.TextXAlignment = Enum.TextXAlignment.Left
            sText.Parent = sHolder

            local sLine = Instance.new("Frame")
            sLine.Position = UDim2.new(0, sText.AbsoluteSize.X + 8, 0.5, 0)
            sLine.Size = UDim2.new(1, -(sText.AbsoluteSize.X + 8), 0, 1)
            sLine.BackgroundColor3 = CurrentTheme.Border
            sLine.BorderSizePixel = 0
            sLine.Parent = sHolder

            local grad = Instance.new("UIGradient")
            grad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1)
            })
            grad.Parent = sLine

            sText:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                sLine.Position = UDim2.new(0, sText.AbsoluteSize.X + 8, 0.5, 0)
                sLine.Size = UDim2.new(1, -(sText.AbsoluteSize.X + 8), 0, 1)
            end)

            RegisterPaint(function()
                sText.TextColor3 = CurrentTheme.GoldMuted
                sLine.BackgroundColor3 = CurrentTheme.Border
            end)
        end

        -- Method Paragraph
        function Tab:AddParagraph(c)
            local pRow = Instance.new("Frame")
            pRow.Size = UDim2.new(1, 0, 0, 0)
            pRow.AutomaticSize = Enum.AutomaticSize.Y
            pRow.BackgroundColor3 = CurrentTheme.Card
            pRow.BorderSizePixel = 0
            pRow.Parent = Page

            local pStroke = Instance.new("UIStroke")
            pStroke.Color = CurrentTheme.Border
            pStroke.Thickness = 1
            pStroke.Parent = pRow

            local pPad = Instance.new("UIPadding")
            pPad.PaddingTop = UDim.new(0, 8); pPad.PaddingBottom = UDim.new(0, 8)
            pPad.PaddingLeft = UDim.new(0, 12); pPad.PaddingRight = UDim.new(0, 12)
            pPad.Parent = pRow

            local pLay = Instance.new("UIListLayout")
            pLay.Padding = UDim.new(0, 3)
            pLay.Parent = pRow

            local pt, pc = nil, nil
            if c.Title and c.Title ~= "" then
                pt = Instance.new("TextLabel")
                pt.Size = UDim2.new(1, 0, 0, 0); pt.AutomaticSize = Enum.AutomaticSize.Y
                pt.BackgroundTransparency = 1
                pt.Text = c.Title
                pt.Font = Enum.Font.GothamMedium
                pt.TextSize = 11
                pt.TextColor3 = CurrentTheme.Gold
                pt.TextXAlignment = Enum.TextXAlignment.Left
                pt.Parent = pRow
            end

            if c.Content and c.Content ~= "" then
                pc = Instance.new("TextLabel")
                pc.Size = UDim2.new(1, 0, 0, 0); pc.AutomaticSize = Enum.AutomaticSize.Y
                pc.BackgroundTransparency = 1
                pc.Text = c.Content
                pc.Font = Enum.Font.Gotham
                pc.TextSize = 10
                pc.TextColor3 = CurrentTheme.TextMuted
                pc.TextXAlignment = Enum.TextXAlignment.Left
                pc.TextWrapped = true
                pc.Parent = pRow
            end

            RegisterPaint(function()
                pRow.BackgroundColor3 = CurrentTheme.Card
                pStroke.Color = CurrentTheme.Border
                if pt then pt.TextColor3 = CurrentTheme.Gold end
                if pc then pc.TextColor3 = CurrentTheme.TextMuted end
            end)
        end

        -- Method Toggle
        function Tab:AddToggle(c)
            local state = c.Default or false
            local cb = c.Callback or function() end
            local flag = c.Flag
            local row = CreateRow(42)
            AddHeaderLabels(row, c.Title, c.Description)

            local box = Instance.new("Frame")
            box.Size = UDim2.fromOffset(30, 16)
            box.Position = UDim2.new(1, -42, 0.5, -8)
            box.BackgroundColor3 = CurrentTheme.Bg
            box.BorderSizePixel = 0
            box.Parent = row

            local bStroke = Instance.new("UIStroke")
            bStroke.Color = state and CurrentTheme.Gold or CurrentTheme.BorderHover
            bStroke.Thickness = 1
            bStroke.Parent = box

            local knob = Instance.new("Frame")
            knob.Size = UDim2.fromOffset(10, 10)
            knob.Position = state and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5)
            knob.BackgroundColor3 = state and CurrentTheme.Gold or CurrentTheme.TextDull
            knob.BorderSizePixel = 0
            knob.Parent = box

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = row

            local obj = { Value = state }
            function obj:Set(val)
                state = val and true or false
                obj.Value = state
                TweenService:Create(knob, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {
                    Position = state and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5),
                    BackgroundColor3 = state and CurrentTheme.Gold or CurrentTheme.TextDull
                }):Play()
                bStroke.Color = state and CurrentTheme.Gold or CurrentTheme.BorderHover
                cb(state)
            end

            btn.MouseButton1Click:Connect(function() obj:Set(not state) end)

            RegisterPaint(function()
                box.BackgroundColor3 = CurrentTheme.Bg
                bStroke.Color = state and CurrentTheme.Gold or CurrentTheme.BorderHover
                knob.BackgroundColor3 = state and CurrentTheme.Gold or CurrentTheme.TextDull
            end)

            if flag then Window.Flags[flag] = obj end
            return obj
        end

        -- Method Button
        function Tab:AddButton(c)
            local cb = c.Callback or function() end
            local row = CreateRow(42)
            AddHeaderLabels(row, c.Title, c.Description)

            local bAction = Instance.new("TextButton")
            bAction.Size = UDim2.fromOffset(75, 22)
            bAction.Position = UDim2.new(1, -87, 0.5, -11)
            bAction.BackgroundColor3 = CurrentTheme.Bg
            bAction.BorderSizePixel = 0
            bAction.Text = c.ButtonText or "Execute"
            bAction.Font = Enum.Font.GothamMedium
            bAction.TextSize = 10
            bAction.TextColor3 = CurrentTheme.Gold
            bAction.AutoButtonColor = false
            bAction.Parent = row

            local bStroke = Instance.new("UIStroke")
            bStroke.Color = CurrentTheme.GoldMuted
            bStroke.Thickness = 1
            bStroke.Parent = bAction

            RegisterPaint(function()
                bAction.BackgroundColor3 = CurrentTheme.Bg
                bAction.TextColor3 = CurrentTheme.Gold
                bStroke.Color = CurrentTheme.GoldMuted
            end)

            bAction.MouseEnter:Connect(function()
                TweenService:Create(bAction, TweenInfo.new(0.12), { BackgroundColor3 = CurrentTheme.Gold, TextColor3 = CurrentTheme.Bg }):Play()
            end)
            bAction.MouseLeave:Connect(function()
                TweenService:Create(bAction, TweenInfo.new(0.12), { BackgroundColor3 = CurrentTheme.Bg, TextColor3 = CurrentTheme.Gold }):Play()
            end)
            bAction.MouseButton1Click:Connect(cb)
        end

        -- Method Slider
        function Tab:AddSlider(c)
            local min, max, step = c.Min or 0, c.Max or 100, c.Step or 1
            local cur = math.clamp(c.Default or min, min, max)
            local cb = c.Callback or function() end
            local flag = c.Flag
            local row = CreateRow(46)

            local sTitle = Instance.new("TextLabel")
            sTitle.Position = UDim2.fromOffset(12, 6)
            sTitle.Size = UDim2.new(1, -60, 0, 14)
            sTitle.BackgroundTransparency = 1
            sTitle.Text = c.Title or "Slider"
            sTitle.Font = Enum.Font.GothamMedium
            sTitle.TextSize = 12
            sTitle.TextColor3 = CurrentTheme.Text
            sTitle.TextXAlignment = Enum.TextXAlignment.Left
            sTitle.Parent = row

            local sVal = Instance.new("TextLabel")
            sVal.Position = UDim2.new(1, -50, 0, 6)
            sVal.Size = UDim2.fromOffset(38, 14)
            sVal.BackgroundTransparency = 1
            sVal.Text = tostring(cur)
            sVal.Font = Enum.Font.Gotham
            sVal.TextSize = 11
            sVal.TextColor3 = CurrentTheme.Gold
            sVal.TextXAlignment = Enum.TextXAlignment.Right
            sVal.Parent = row

            local track = Instance.new("Frame")
            track.Position = UDim2.fromOffset(12, 28)
            track.Size = UDim2.new(1, -24, 0, 2)
            track.BackgroundColor3 = CurrentTheme.BorderHover
            track.BorderSizePixel = 0
            track.Parent = row

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((cur - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = CurrentTheme.Gold
            fill.BorderSizePixel = 0
            fill.Parent = track

            local knob = Instance.new("Frame")
            knob.Size = UDim2.fromOffset(4, 10)
            knob.AnchorPoint = Vector2.new(0.5, 0.5)
            knob.Position = UDim2.new((cur - min) / (max - min), 0, 0.5, 0)
            knob.BackgroundColor3 = CurrentTheme.Gold
            knob.BorderSizePixel = 0
            knob.Parent = track

            local trigger = Instance.new("TextButton")
            trigger.Position = UDim2.fromOffset(12, 18)
            trigger.Size = UDim2.new(1, -24, 0, 22)
            trigger.BackgroundTransparency = 1
            trigger.Text = ""
            trigger.Parent = row

            local dragging = false
            local function Update(inputX)
                local ratio = math.clamp((inputX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                local exact = min + (max - min) * ratio
                cur = math.floor(exact / step + 0.5) * step
                fill.Size = UDim2.new(ratio, 0, 1, 0)
                knob.Position = UDim2.new(ratio, 0, 0.5, 0)
                sVal.Text = tostring(cur)
                cb(cur)
            end

            trigger.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    dragging = true; Update(inp.Position.X)
                end
            end)
            trigger.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                    Update(inp.Position.X)
                end
            end)

            RegisterPaint(function()
                sTitle.TextColor3 = CurrentTheme.Text
                sVal.TextColor3 = CurrentTheme.Gold
                track.BackgroundColor3 = CurrentTheme.BorderHover
                fill.BackgroundColor3 = CurrentTheme.Gold
                knob.BackgroundColor3 = CurrentTheme.Gold
            end)

            local obj = { Value = cur }
            function obj:Set(v)
                cur = math.clamp(v, min, max)
                obj.Value = cur
                local ratio = (cur - min) / (max - min)
                fill.Size = UDim2.new(ratio, 0, 1, 0)
                knob.Position = UDim2.new(ratio, 0, 0.5, 0)
                sVal.Text = tostring(cur)
                cb(cur)
            end

            if flag then Window.Flags[flag] = obj end
            return obj
        end

        -- Method Dropdown
        function Tab:AddDropdown(c)
            local values = c.Values or {}
            local current = c.Default or values[1] or "Select..."
            local cb = c.Callback or function() end
            local flag = c.Flag
            local row = CreateRow(42)
            AddHeaderLabels(row, c.Title, c.Description)

            local dropBtn = Instance.new("TextButton")
            dropBtn.Size = UDim2.fromOffset(110, 22)
            dropBtn.Position = UDim2.new(1, -122, 0.5, -11)
            dropBtn.BackgroundColor3 = CurrentTheme.Bg
            dropBtn.BorderSizePixel = 0
            dropBtn.Text = "  " .. tostring(current)
            dropBtn.Font = Enum.Font.Gotham
            dropBtn.TextSize = 10
            dropBtn.TextColor3 = CurrentTheme.Text
            dropBtn.TextXAlignment = Enum.TextXAlignment.Left
            dropBtn.TextTruncate = Enum.TextTruncate.AtEnd
            dropBtn.Parent = row

            local dStroke = Instance.new("UIStroke")
            dStroke.Color = CurrentTheme.Border
            dStroke.Thickness = 1
            dStroke.Parent = dropBtn

            local dChevron = Instance.new("ImageLabel")
            dChevron.Size = UDim2.fromOffset(10, 10)
            dChevron.Position = UDim2.new(1, -14, 0.5, -5)
            dChevron.BackgroundTransparency = 1
            dChevron.Image = Lucide.chevron
            dChevron.ImageColor3 = CurrentTheme.TextMuted
            dChevron.Parent = dropBtn

            RegisterPaint(function()
                dropBtn.BackgroundColor3 = CurrentTheme.Bg
                dropBtn.TextColor3 = CurrentTheme.Text
                dStroke.Color = CurrentTheme.Border
                dChevron.ImageColor3 = CurrentTheme.TextMuted
            end)

            local function OpenMenu()
                if CurrentDropdown == dropBtn then
                    CloseDropdown()
                    return
                end
                CurrentDropdown = dropBtn
                for _, ch in ipairs(DropScroll:GetChildren()) do
                    if ch:IsA("TextButton") then ch:Destroy() end
                end

                for _, val in ipairs(values) do
                    local item = Instance.new("TextButton")
                    item.Size = UDim2.new(1, 0, 0, 22)
                    item.BackgroundColor3 = CurrentTheme.CardHover
                    item.BackgroundTransparency = 1
                    item.Text = "  " .. tostring(val)
                    item.Font = Enum.Font.Gotham
                    item.TextSize = 10
                    item.TextColor3 = (val == current) and CurrentTheme.Gold or CurrentTheme.Text
                    item.TextXAlignment = Enum.TextXAlignment.Left
                    item.Parent = DropScroll

                    item.MouseEnter:Connect(function() item.BackgroundTransparency = 0 end)
                    item.MouseLeave:Connect(function() item.BackgroundTransparency = 1 end)
                    item.MouseButton1Click:Connect(function()
                        current = val
                        dropBtn.Text = "  " .. tostring(current)
                        CloseDropdown()
                        cb(current)
                    end)
                end

                local itemH = math.min(#values * 22, 132)
                GlobalDropdown.Size = UDim2.fromOffset(110, itemH)
                GlobalDropdown.Position = UDim2.fromOffset(dropBtn.AbsolutePosition.X, dropBtn.AbsolutePosition.Y + 24)
                GlobalDropdown.Visible = true
            end

            dropBtn.MouseButton1Click:Connect(OpenMenu)

            local obj = { Value = current }
            function obj:Set(v)
                current = v
                obj.Value = v
                dropBtn.Text = "  " .. tostring(current)
                cb(current)
            end
            function obj:SetValues(newVals)
                values = newVals
                if not table.find(values, current) then current = values[1] or "Select..." end
                dropBtn.Text = "  " .. tostring(current)
            end

            if flag then Window.Flags[flag] = obj end
            return obj
        end

        -- Method Input
        function Tab:AddInput(c)
            local cb = c.Callback or function() end
            local flag = c.Flag
            local row = CreateRow(42)
            AddHeaderLabels(row, c.Title, c.Description)

            local box = Instance.new("TextBox")
            box.Size = UDim2.fromOffset(110, 22)
            box.Position = UDim2.new(1, -122, 0.5, -11)
            box.BackgroundColor3 = CurrentTheme.Bg
            box.BorderSizePixel = 0
            box.Text = c.Default or ""
            box.PlaceholderText = c.Placeholder or "Type here..."
            box.Font = Enum.Font.Gotham
            box.TextSize = 10
            box.TextColor3 = CurrentTheme.Text
            box.PlaceholderColor3 = CurrentTheme.TextDull
            box.ClearTextOnFocus = false
            box.Parent = row

            local iStroke = Instance.new("UIStroke")
            iStroke.Color = CurrentTheme.Border
            iStroke.Thickness = 1
            iStroke.Parent = box

            box.Focused:Connect(function() iStroke.Color = CurrentTheme.Gold end)
            box.FocusLost:Connect(function()
                iStroke.Color = CurrentTheme.Border
                cb(box.Text)
            end)

            RegisterPaint(function()
                box.BackgroundColor3 = CurrentTheme.Bg
                box.TextColor3 = CurrentTheme.Text
                box.PlaceholderColor3 = CurrentTheme.TextDull
                iStroke.Color = CurrentTheme.Border
            end)

            local obj = { Value = box.Text }
            function obj:Set(v)
                box.Text = tostring(v)
                obj.Value = box.Text
                cb(box.Text)
            end

            if flag then Window.Flags[flag] = obj end
            return obj
        end

        -- Method Keybind
        function Tab:AddKeybind(c)
            local current = c.Default or Enum.KeyCode.RightControl
            local cb = c.Callback or function() end
            local flag = c.Flag
            local row = CreateRow(42)
            AddHeaderLabels(row, c.Title, c.Description)

            local bindBtn = Instance.new("TextButton")
            bindBtn.Size = UDim2.fromOffset(80, 22)
            bindBtn.Position = UDim2.new(1, -92, 0.5, -11)
            bindBtn.BackgroundColor3 = CurrentTheme.Bg
            bindBtn.BorderSizePixel = 0
            bindBtn.Text = current.Name
            bindBtn.Font = Enum.Font.GothamMedium
            bindBtn.TextSize = 10
            bindBtn.TextColor3 = CurrentTheme.Gold
            bindBtn.AutoButtonColor = false
            bindBtn.Parent = row

            local bStroke = Instance.new("UIStroke")
            bStroke.Color = CurrentTheme.Border
            bStroke.Thickness = 1
            bStroke.Parent = bindBtn

            local listening = false
            bindBtn.MouseButton1Click:Connect(function()
                listening = true
                bindBtn.Text = "..."
                bStroke.Color = CurrentTheme.Gold
            end)

            UserInputService.InputBegan:Connect(function(inp, proc)
                if listening and inp.UserInputType == Enum.UserInputType.Keyboard then
                    if inp.KeyCode == Enum.KeyCode.Escape then
                        listening = false
                        bindBtn.Text = current.Name
                        bStroke.Color = CurrentTheme.Border
                    else
                        current = inp.KeyCode
                        listening = false
                        bindBtn.Text = current.Name
                        bStroke.Color = CurrentTheme.Border
                        cb(current)
                    end
                elseif not proc and inp.KeyCode == current and not listening then
                    cb(current)
                end
            end)

            RegisterPaint(function()
                bindBtn.BackgroundColor3 = CurrentTheme.Bg
                bindBtn.TextColor3 = CurrentTheme.Gold
                bStroke.Color = CurrentTheme.Border
            end)

            local obj = { Value = current }
            function obj:Set(k)
                current = k
                obj.Value = k
                bindBtn.Text = k.Name
                cb(k)
            end

            if flag then Window.Flags[flag] = obj end
            return obj
        end

        return Tab
    end

    -- BuildConfigSection: Lengkap dengan Settings, Keybind, Config & Live Themes
    function Window:BuildConfigSection(settingsTab)
        if not settingsTab then return end

        settingsTab:AddSection({ Title = "Interface Settings" })

        settingsTab:AddKeybind({
            Title = "Menu Toggle Key",
            Description = "Key used to show/hide this interface",
            Default = Window.ToggleKey,
            Callback = function(key)
                Window.ToggleKey = key
                Kami:Notify({
                    Title = "Keybind Updated",
                    Content = "Menu key set to: " .. key.Name,
                    Duration = 2
                })
            end
        })

        settingsTab:AddDropdown({
            Title = "Interface Theme",
            Description = "Select visual color profile",
            Values = { "Obsidian Gold", "Pitch Dark", "Cyber Gold", "Midnight Gold" },
            Default = "Obsidian Gold",
            Callback = function(themeName)
                ApplyTheme(themeName)
                Kami:Notify({
                    Title = "Theme Applied",
                    Content = "Active theme: " .. themeName,
                    Duration = 2
                })
            end
        })

        settingsTab:AddSection({ Title = "Config Manager" })

        local cfgInput = settingsTab:AddInput({
            Title = "Config Name",
            Description = "Enter target config file name",
            Placeholder = "default",
            Default = "default"
        })

        local configDropdown = nil

        settingsTab:AddButton({
            Title = "Save Configuration",
            Description = "Save current flags and settings to disk",
            ButtonText = "Save",
            Callback = function()
                local name = cfgInput.Value ~= "" and cfgInput.Value or "default"
                local success = Window:SaveConfig(name)
                if success then
                    if configDropdown then configDropdown:SetValues(GetConfigList()) end
                    Kami:Notify({
                        Title = "Config Saved",
                        Content = "Saved config: " .. name .. ".json",
                        Duration = 2
                    })
                else
                    Kami:Notify({
                        Title = "Save Error",
                        Content = "Failed to save. Executor missing file write permission.",
                        Duration = 3
                    })
                end
            end
        })

        configDropdown = settingsTab:AddDropdown({
            Title = "Select Config",
            Description = "Choose a configuration from disk",
            Values = GetConfigList(),
            Default = Window.ActiveConfig,
            Callback = function(chosen)
                Window.ActiveConfig = chosen
                cfgInput:Set(chosen)
            end
        })

        settingsTab:AddButton({
            Title = "Load Configuration",
            Description = "Apply settings from chosen config",
            ButtonText = "Load",
            Callback = function()
                local ok = Window:LoadConfig(Window.ActiveConfig)
                Kami:Notify({
                    Title = ok and "Config Loaded" or "Load Failed",
                    Content = ok and ("Applied settings from: " .. Window.ActiveConfig) or "File could not be found or read.",
                    Duration = 2.5
                })
            end
        })

        settingsTab:AddButton({
            Title = "Delete Configuration",
            Description = "Remove chosen configuration file",
            ButtonText = "Delete",
            Callback = function()
                local ok = Window:DeleteConfig(Window.ActiveConfig)
                if ok then
                    configDropdown:SetValues(GetConfigList())
                    Kami:Notify({
                        Title = "Config Deleted",
                        Content = "Removed: " .. Window.ActiveConfig,
                        Duration = 2
                    })
                end
            end
        })

        settingsTab:AddToggle({
            Title = "Auto-Load On Launch",
            Description = "Automatically load active config when script runs",
            Default = Window.AutoLoad,
            Callback = function(state)
                Window.AutoLoad = state
                if writefile then
                    writefile(AUTO_LOAD_FILE, HttpService:JSONEncode({ Enabled = state, Config = Window.ActiveConfig }))
                end
            end
        })
    end

    -- Auto-Load Check on Startup
    task.spawn(function()
        if isfile and isfile(AUTO_LOAD_FILE) then
            pcall(function()
                local raw = HttpService:JSONDecode(readfile(AUTO_LOAD_FILE))
                if raw and raw.Enabled and raw.Config then
                    Window:LoadConfig(raw.Config)
                end
            end)
        end
    end)

    return Window
end

return Kami
