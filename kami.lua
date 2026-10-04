--[[
    KAMI UI - v1.0.0
    Luxury Dark & Gold Edition
    Clean & Natural Language Interface
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local Kami = {
    Version = "1.0.0"
}

local Theme = {
    Bg          = Color3.fromRGB(8, 8, 9),
    Sidebar     = Color3.fromRGB(11, 11, 13),
    Card        = Color3.fromRGB(14, 14, 16),
    CardHover   = Color3.fromRGB(18, 18, 21),
    Border      = Color3.fromRGB(28, 26, 22),
    BorderHover = Color3.fromRGB(65, 58, 42),
    Gold        = Color3.fromRGB(212, 175, 55),
    GoldMuted   = Color3.fromRGB(130, 105, 38),
    Text        = Color3.fromRGB(245, 243, 238),
    TextMuted   = Color3.fromRGB(140, 136, 128),
    TextDull    = Color3.fromRGB(80, 77, 72),
}

local Lucide = {
    home = "rbxassetid://93110857987859",
    settings = "rbxassetid://85241284670779",
    info = "rbxassetid://92425452073561",
    chevron = "rbxassetid://134243273101015",
}

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

-- Loading Screen Animasi "K"
function Kami:ShowLoadingScreen(cfg)
    cfg = cfg or {}
    local steps = cfg.Steps or {
        "Memeriksa executor...",
        "Mengambil profil akun...",
        "Memuat tampilan menu...",
        "Selesai."
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
    Bg.BackgroundColor3 = Theme.Bg
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
    KLogo.TextColor3 = Theme.Gold
    KLogo.TextTransparency = 1
    KLogo.Parent = Center

    local Title = Instance.new("TextLabel")
    Title.Position = UDim2.new(0, 0, 0.52, 0)
    Title.Size = UDim2.new(1, 0, 0, 16)
    Title.BackgroundTransparency = 1
    Title.Text = (cfg.Title or "KAMI UI"):upper()
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 11
    Title.TextColor3 = Theme.Text
    Title.TextTransparency = 1
    Title.Parent = Center

    local Status = Instance.new("TextLabel")
    Status.Position = UDim2.new(0, 0, 0.65, 0)
    Status.Size = UDim2.new(1, 0, 0, 14)
    Status.BackgroundTransparency = 1
    Status.Text = steps[1] or "Memuat..."
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 10
    Status.TextColor3 = Theme.GoldMuted
    Status.TextTransparency = 1
    Status.Parent = Center

    local BarBg = Instance.new("Frame")
    BarBg.Position = UDim2.new(0.1, 0, 0.85, 0)
    BarBg.Size = UDim2.new(0.8, 0, 0, 2)
    BarBg.BackgroundColor3 = Theme.Border
    BarBg.BorderSizePixel = 0
    BarBg.Parent = Center

    local BarFill = Instance.new("Frame")
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = Theme.Gold
    BarFill.BorderSizePixel = 0
    BarFill.Parent = BarBg

    TweenService:Create(KLogo, TweenInfo.new(0.35), { TextTransparency = 0 }):Play()
    TweenService:Create(Title, TweenInfo.new(0.35), { TextTransparency = 0 }):Play()
    TweenService:Create(Status, TweenInfo.new(0.35), { TextTransparency = 0 }):Play()

    local pulsing = true
    task.spawn(function()
        while pulsing and KLogo.Parent do
            TweenService:Create(KLogo, TweenInfo.new(0.55, Enum.EasingStyle.Sine), { TextColor3 = Theme.Text }):Play()
            task.wait(0.55)
            if not pulsing then break end
            TweenService:Create(KLogo, TweenInfo.new(0.55, Enum.EasingStyle.Sine), { TextColor3 = Theme.Gold }):Play()
            task.wait(0.55)
        end
    end)

    local delayPerStep = duration / #steps
    for i, stepText in ipairs(steps) do
        Status.Text = stepText
        local targetRatio = i / #steps
        TweenService:Create(BarFill, TweenInfo.new(delayPerStep * 0.8, Enum.EasingStyle.Quad), {
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

-- Global Dropdown
local GlobalDropdown = Instance.new("Frame")
GlobalDropdown.Size = UDim2.fromOffset(130, 0)
GlobalDropdown.BackgroundColor3 = Theme.Card
GlobalDropdown.BorderSizePixel = 0
GlobalDropdown.ZIndex = 100
GlobalDropdown.Visible = false
GlobalDropdown.ClipsDescendants = true
GlobalDropdown.Parent = Screen

local DropStroke = Instance.new("UIStroke")
DropStroke.Color = Theme.GoldMuted
DropStroke.Thickness = 1
DropStroke.Parent = GlobalDropdown

local DropScroll = Instance.new("ScrollingFrame")
DropScroll.Size = UDim2.new(1, 0, 1, 0)
DropScroll.BackgroundTransparency = 1
DropScroll.BorderSizePixel = 0
DropScroll.ScrollBarThickness = 2
DropScroll.ScrollBarImageColor3 = Theme.Gold
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
    local nTitle = cfg.Title or "Pemberitahuan"
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
    card.BackgroundColor3 = Theme.Card
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.Parent = notifyHolder

    local cStroke = Instance.new("UIStroke")
    cStroke.Color = Theme.GoldMuted
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
    titleLbl.TextColor3 = Theme.Gold
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
    descLbl.TextColor3 = Theme.Text
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
    local winSize = cfg.Size or UDim2.fromOffset(610, 420)
    local minKey = cfg.MinimizeKey or Enum.KeyCode.RightControl

    if cfg.Loading and cfg.Loading.Enabled ~= false then
        Kami:ShowLoadingScreen(cfg.Loading)
    end

    local Window = { Tabs = {}, CurrentTab = nil }

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Kami_Main"
    MainFrame.Size = winSize
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundColor3 = Theme.Bg
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = Screen

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Theme.Border
    MainStroke.Thickness = 1
    MainStroke.Parent = MainFrame

    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 36)
    Header.BackgroundColor3 = Theme.Sidebar
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local HeaderLine = Instance.new("Frame")
    HeaderLine.Size = UDim2.new(1, 0, 0, 1)
    HeaderLine.Position = UDim2.new(0, 0, 1, -1)
    HeaderLine.BackgroundColor3 = Theme.Border
    HeaderLine.BorderSizePixel = 0
    HeaderLine.Parent = Header

    local LogoDiamond = Instance.new("TextLabel")
    LogoDiamond.Size = UDim2.fromOffset(36, 36)
    LogoDiamond.BackgroundTransparency = 1
    LogoDiamond.Text = "◆"
    LogoDiamond.Font = Enum.Font.GothamMedium
    LogoDiamond.TextSize = 10
    LogoDiamond.TextColor3 = Theme.Gold
    LogoDiamond.Parent = Header

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Position = UDim2.fromOffset(34, 0)
    TitleLabel.Size = UDim2.new(1, -90, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = string.format("<b>%s</b>  <font color=\"#48453E\">/  %s</font>", winName:upper(), winSub)
    TitleLabel.RichText = true
    TitleLabel.Font = Enum.Font.Gotham
    TitleLabel.TextSize = 11
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.fromOffset(36, 36)
    MinBtn.Position = UDim2.new(1, -36, 0, 0)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "—"
    MinBtn.Font = Enum.Font.Gotham
    MinBtn.TextSize = 11
    MinBtn.TextColor3 = Theme.TextMuted
    MinBtn.Parent = Header

    local isMinimized = false
    local function ToggleMin()
        isMinimized = not isMinimized
        CloseDropdown()
        MainFrame.Visible = not isMinimized
    end
    MinBtn.MouseButton1Click:Connect(ToggleMin)
    UserInputService.InputBegan:Connect(function(inp, proc)
        if not proc and inp.KeyCode == minKey then ToggleMin() end
    end)

    -- Dragging
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
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SidebarBorder = Instance.new("Frame")
    SidebarBorder.Size = UDim2.new(0, 1, 1, 0)
    SidebarBorder.Position = UDim2.new(1, -1, 0, 0)
    SidebarBorder.BackgroundColor3 = Theme.Border
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
    Footer.TextColor3 = Theme.TextDull
    Footer.TextXAlignment = Enum.TextXAlignment.Left
    Footer.Parent = Sidebar

    local ContentHolder = Instance.new("Frame")
    ContentHolder.Size = UDim2.new(1, -140, 1, -36)
    ContentHolder.Position = UDim2.new(0, 140, 0, 36)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.ClipsDescendants = true
    ContentHolder.Parent = MainFrame

    function Window:AddTab(opt)
        opt = opt or {}
        local tabTitle = opt.Title or "Menu"
        local tabIcon = opt.Icon and Lucide[opt.Icon]

        local Tab = {}
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 28)
        TabBtn.BackgroundColor3 = Theme.Card
        TabBtn.BackgroundTransparency = 1
        TabBtn.BorderSizePixel = 0
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = NavScroll

        local TabIndicator = Instance.new("Frame")
        TabIndicator.Size = UDim2.new(0, 2, 0, 12)
        TabIndicator.Position = UDim2.new(0, 2, 0.5, -6)
        TabIndicator.BackgroundColor3 = Theme.Gold
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Visible = false
        TabIndicator.Parent = TabBtn

        local textOffset = 12
        if tabIcon then
            local iconImg = Instance.new("ImageLabel")
            iconImg.Size = UDim2.fromOffset(12, 12)
            iconImg.Position = UDim2.new(0, 10, 0.5, -6)
            iconImg.BackgroundTransparency = 1
            iconImg.Image = tabIcon
            iconImg.ImageColor3 = Theme.TextMuted
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
        TabLbl.TextColor3 = Theme.TextMuted
        TabLbl.TextXAlignment = Enum.TextXAlignment.Left
        TabLbl.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Theme.BorderHover
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
                t.Label.TextColor3 = Theme.TextMuted
                t.Button.BackgroundTransparency = 1
            end
            Page.Visible = true
            TabIndicator.Visible = true
            TabLbl.TextColor3 = Theme.Text
            TabBtn.BackgroundTransparency = 0
            Window.CurrentTab = Tab
        end

        TabBtn.MouseButton1Click:Connect(SetActive)
        table.insert(Window.Tabs, { Button = TabBtn, Label = TabLbl, Indicator = TabIndicator, Page = Page })
        if #Window.Tabs == 1 then SetActive() end

        local function CreateRow(h)
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, h or 42)
            row.BackgroundColor3 = Theme.Card
            row.BorderSizePixel = 0
            row.Parent = Page

            local st = Instance.new("UIStroke")
            st.Color = Theme.Border
            st.Thickness = 1
            st.Parent = row

            row.MouseEnter:Connect(function()
                st.Color = Theme.BorderHover
                row.BackgroundColor3 = Theme.CardHover
            end)
            row.MouseLeave:Connect(function()
                st.Color = Theme.Border
                row.BackgroundColor3 = Theme.Card
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
            t.TextColor3 = Theme.Text
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.Parent = row

            if desc and desc ~= "" then
                local d = Instance.new("TextLabel")
                d.Position = UDim2.fromOffset(12, 22)
                d.Size = UDim2.new(1, -120, 0, 14)
                d.BackgroundTransparency = 1
                d.Text = desc
                d.Font = Enum.Font.Gotham
                d.TextSize = 10
                d.TextColor3 = Theme.TextMuted
                d.TextXAlignment = Enum.TextXAlignment.Left
                d.Parent = row
            end
        end

        -- PROFILE CARD
        function Tab:AddProfileCard(c)
            c = c or {}
            local card = Instance.new("Frame")
            card.Size = UDim2.new(1, 0, 0, 68)
            card.BackgroundColor3 = Theme.Card
            card.BorderSizePixel = 0
            card.Parent = Page

            local cStroke = Instance.new("UIStroke")
            cStroke.Color = Theme.BorderHover
            cStroke.Thickness = 1
            cStroke.Parent = card

            local avatarImg = Instance.new("ImageLabel")
            avatarImg.Size = UDim2.fromOffset(48, 48)
            avatarImg.Position = UDim2.fromOffset(10, 10)
            avatarImg.BackgroundColor3 = Theme.Bg
            avatarImg.BorderSizePixel = 0
            avatarImg.Image = c.Image or ""
            avatarImg.Parent = card

            local aStroke = Instance.new("UIStroke")
            aStroke.Color = Theme.GoldMuted
            aStroke.Thickness = 1
            aStroke.Parent = avatarImg

            local dName = Instance.new("TextLabel")
            dName.Position = UDim2.fromOffset(68, 12)
            dName.Size = UDim2.new(1, -180, 0, 16)
            dName.BackgroundTransparency = 1
            dName.Text = c.DisplayName or "User"
            dName.Font = Enum.Font.GothamBold
            dName.TextSize = 13
            dName.TextColor3 = Theme.Gold
            dName.TextXAlignment = Enum.TextXAlignment.Left
            dName.Parent = card

            local uName = Instance.new("TextLabel")
            uName.Position = UDim2.fromOffset(68, 28)
            uName.Size = UDim2.new(1, -180, 0, 14)
            uName.BackgroundTransparency = 1
            uName.Text = "@" .. (c.Username or "username")
            uName.Font = Enum.Font.Gotham
            uName.TextSize = 10
            uName.TextColor3 = Theme.TextMuted
            uName.TextXAlignment = Enum.TextXAlignment.Left
            uName.Parent = card

            local statusSub = Instance.new("TextLabel")
            statusSub.Position = UDim2.fromOffset(68, 42)
            statusSub.Size = UDim2.new(1, -180, 0, 14)
            statusSub.BackgroundTransparency = 1
            statusSub.Text = c.Subtitle or "Akun Aktif"
            statusSub.Font = Enum.Font.Gotham
            statusSub.TextSize = 9
            statusSub.TextColor3 = Theme.TextDull
            statusSub.TextXAlignment = Enum.TextXAlignment.Left
            statusSub.Parent = card

            local badge = Instance.new("Frame")
            badge.Size = UDim2.fromOffset(100, 24)
            badge.Position = UDim2.new(1, -110, 0.5, -12)
            badge.BackgroundColor3 = Theme.Bg
            badge.BorderSizePixel = 0
            badge.Parent = card

            local bStroke = Instance.new("UIStroke")
            bStroke.Color = Theme.Border
            bStroke.Thickness = 1
            bStroke.Parent = badge

            local badgeText = Instance.new("TextLabel")
            badgeText.Size = UDim2.new(1, 0, 1, 0)
            badgeText.BackgroundTransparency = 1
            badgeText.Text = c.Badge or "ONLINE"
            badgeText.Font = Enum.Font.GothamMedium
            badgeText.TextSize = 9
            badgeText.TextColor3 = Theme.Gold
            badgeText.Parent = badge
        end

        -- STAT GRID
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

            for _, stat in ipairs(items) do
                local sCard = Instance.new("Frame")
                sCard.BackgroundColor3 = Theme.Card
                sCard.BorderSizePixel = 0
                sCard.Parent = gridHolder

                local sStroke = Instance.new("UIStroke")
                sStroke.Color = Theme.Border
                sStroke.Thickness = 1
                sStroke.Parent = sCard

                local sKey = Instance.new("TextLabel")
                sKey.Position = UDim2.fromOffset(10, 6)
                sKey.Size = UDim2.new(1, -20, 0, 12)
                sKey.BackgroundTransparency = 1
                sKey.Text = string.upper(stat.Title or "")
                sKey.Font = Enum.Font.GothamMedium
                sKey.TextSize = 9
                sKey.TextColor3 = Theme.GoldMuted
                sKey.TextXAlignment = Enum.TextXAlignment.Left
                sKey.Parent = sCard

                local sVal = Instance.new("TextLabel")
                sVal.Position = UDim2.fromOffset(10, 20)
                sVal.Size = UDim2.new(1, -20, 0, 18)
                sVal.BackgroundTransparency = 1
                sVal.Text = stat.Value or "-"
                sVal.Font = Enum.Font.Gotham
                sVal.TextSize = 11
                sVal.TextColor3 = Theme.Text
                sVal.TextXAlignment = Enum.TextXAlignment.Left
                sVal.TextTruncate = Enum.TextTruncate.AtEnd
                sVal.Parent = sCard
            end
        end

        -- SECTION
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
            sText.TextColor3 = Theme.GoldMuted
            sText.TextXAlignment = Enum.TextXAlignment.Left
            sText.Parent = sHolder

            local sLine = Instance.new("Frame")
            sLine.Position = UDim2.new(0, sText.AbsoluteSize.X + 8, 0.5, 0)
            sLine.Size = UDim2.new(1, -(sText.AbsoluteSize.X + 8), 0, 1)
            sLine.BackgroundColor3 = Theme.Border
            sLine.BorderSizePixel = 0
            sLine.Parent = sHolder

            sText:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                sLine.Position = UDim2.new(0, sText.AbsoluteSize.X + 8, 0.5, 0)
                sLine.Size = UDim2.new(1, -(sText.AbsoluteSize.X + 8), 0, 1)
            end)
        end

        -- PARAGRAPH
        function Tab:AddParagraph(c)
            local pRow = Instance.new("Frame")
            pRow.Size = UDim2.new(1, 0, 0, 0)
            pRow.AutomaticSize = Enum.AutomaticSize.Y
            pRow.BackgroundColor3 = Theme.Card
            pRow.BorderSizePixel = 0
            pRow.Parent = Page

            local pStroke = Instance.new("UIStroke")
            pStroke.Color = Theme.Border
            pStroke.Thickness = 1
            pStroke.Parent = pRow

            local pPad = Instance.new("UIPadding")
            pPad.PaddingTop = UDim.new(0, 8); pPad.PaddingBottom = UDim.new(0, 8)
            pPad.PaddingLeft = UDim.new(0, 12); pPad.PaddingRight = UDim.new(0, 12)
            pPad.Parent = pRow

            local pLay = Instance.new("UIListLayout")
            pLay.Padding = UDim.new(0, 3)
            pLay.Parent = pRow

            if c.Title and c.Title ~= "" then
                local pt = Instance.new("TextLabel")
                pt.Size = UDim2.new(1, 0, 0, 0); pt.AutomaticSize = Enum.AutomaticSize.Y
                pt.BackgroundTransparency = 1
                pt.Text = c.Title
                pt.Font = Enum.Font.GothamMedium
                pt.TextSize = 11
                pt.TextColor3 = Theme.Gold
                pt.TextXAlignment = Enum.TextXAlignment.Left
                pt.Parent = pRow
            end

            if c.Content and c.Content ~= "" then
                local pc = Instance.new("TextLabel")
                pc.Size = UDim2.new(1, 0, 0, 0); pc.AutomaticSize = Enum.AutomaticSize.Y
                pc.BackgroundTransparency = 1
                pc.Text = c.Content
                pc.Font = Enum.Font.Gotham
                pc.TextSize = 10
                pc.TextColor3 = Theme.TextMuted
                pc.TextXAlignment = Enum.TextXAlignment.Left
                pc.TextWrapped = true
                pc.Parent = pRow
            end
        end

        -- TOGGLE
        function Tab:AddToggle(c)
            local state = c.Default or false
            local cb = c.Callback or function() end
            local row = CreateRow(42)
            AddHeaderLabels(row, c.Title, c.Description)

            local box = Instance.new("Frame")
            box.Size = UDim2.fromOffset(30, 16)
            box.Position = UDim2.new(1, -42, 0.5, -8)
            box.BackgroundColor3 = Theme.Bg
            box.BorderSizePixel = 0
            box.Parent = row

            local bStroke = Instance.new("UIStroke")
            bStroke.Color = state and Theme.Gold or Theme.BorderHover
            bStroke.Thickness = 1
            bStroke.Parent = box

            local knob = Instance.new("Frame")
            knob.Size = UDim2.fromOffset(10, 10)
            knob.Position = state and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5)
            knob.BackgroundColor3 = state and Theme.Gold or Theme.TextDull
            knob.BorderSizePixel = 0
            knob.Parent = box

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = row

            local obj = {}
            function obj:Set(val)
                state = val and true or false
                TweenService:Create(knob, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {
                    Position = state and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5),
                    BackgroundColor3 = state and Theme.Gold or Theme.TextDull
                }):Play()
                bStroke.Color = state and Theme.Gold or Theme.BorderHover
                cb(state)
            end

            btn.MouseButton1Click:Connect(function() obj:Set(not state) end)
            return obj
        end

        -- BUTTON
        function Tab:AddButton(c)
            local cb = c.Callback or function() end
            local row = CreateRow(42)
            AddHeaderLabels(row, c.Title, c.Description)

            local bAction = Instance.new("TextButton")
            bAction.Size = UDim2.fromOffset(75, 22)
            bAction.Position = UDim2.new(1, -87, 0.5, -11)
            bAction.BackgroundColor3 = Theme.Bg
            bAction.BorderSizePixel = 0
            bAction.Text = c.ButtonText or "Jalankan"
            bAction.Font = Enum.Font.GothamMedium
            bAction.TextSize = 10
            bAction.TextColor3 = Theme.Gold
            bAction.AutoButtonColor = false
            bAction.Parent = row

            local bStroke = Instance.new("UIStroke")
            bStroke.Color = Theme.GoldMuted
            bStroke.Thickness = 1
            bStroke.Parent = bAction

            bAction.MouseEnter:Connect(function()
                bAction.BackgroundColor3 = Theme.Gold
                bAction.TextColor3 = Theme.Bg
            end)
            bAction.MouseLeave:Connect(function()
                bAction.BackgroundColor3 = Theme.Bg
                bAction.TextColor3 = Theme.Gold
            end)
            bAction.MouseButton1Click:Connect(cb)
        end

        -- SLIDER
        function Tab:AddSlider(c)
            local min, max, step = c.Min or 0, c.Max or 100, c.Step or 1
            local cur = math.clamp(c.Default or min, min, max)
            local cb = c.Callback or function() end
            local row = CreateRow(46)

            local sTitle = Instance.new("TextLabel")
            sTitle.Position = UDim2.fromOffset(12, 6)
            sTitle.Size = UDim2.new(1, -60, 0, 14)
            sTitle.BackgroundTransparency = 1
            sTitle.Text = c.Title or "Slider"
            sTitle.Font = Enum.Font.GothamMedium
            sTitle.TextSize = 12
            sTitle.TextColor3 = Theme.Text
            sTitle.TextXAlignment = Enum.TextXAlignment.Left
            sTitle.Parent = row

            local sVal = Instance.new("TextLabel")
            sVal.Position = UDim2.new(1, -50, 0, 6)
            sVal.Size = UDim2.fromOffset(38, 14)
            sVal.BackgroundTransparency = 1
            sVal.Text = tostring(cur)
            sVal.Font = Enum.Font.Gotham
            sVal.TextSize = 11
            sVal.TextColor3 = Theme.Gold
            sVal.TextXAlignment = Enum.TextXAlignment.Right
            sVal.Parent = row

            local track = Instance.new("Frame")
            track.Position = UDim2.fromOffset(12, 28)
            track.Size = UDim2.new(1, -24, 0, 2)
            track.BackgroundColor3 = Theme.BorderHover
            track.BorderSizePixel = 0
            track.Parent = row

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((cur - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = Theme.Gold
            fill.BorderSizePixel = 0
            fill.Parent = track

            local knob = Instance.new("Frame")
            knob.Size = UDim2.fromOffset(4, 10)
            knob.AnchorPoint = Vector2.new(0.5, 0.5)
            knob.Position = UDim2.new((cur - min) / (max - min), 0, 0.5, 0)
            knob.BackgroundColor3 = Theme.Gold
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

            local obj = {}
            function obj:Set(v)
                cur = math.clamp(v, min, max)
                local ratio = (cur - min) / (max - min)
                fill.Size = UDim2.new(ratio, 0, 1, 0)
                knob.Position = UDim2.new(ratio, 0, 0.5, 0)
                sVal.Text = tostring(cur)
                cb(cur)
            end
            return obj
        end

        -- DROPDOWN
        function Tab:AddDropdown(c)
            local values = c.Values or {}
            local current = c.Default or values[1] or "Pilih..."
            local cb = c.Callback or function() end
            local row = CreateRow(42)
            AddHeaderLabels(row, c.Title, c.Description)

            local dropBtn = Instance.new("TextButton")
            dropBtn.Size = UDim2.fromOffset(110, 22)
            dropBtn.Position = UDim2.new(1, -122, 0.5, -11)
            dropBtn.BackgroundColor3 = Theme.Bg
            dropBtn.BorderSizePixel = 0
            dropBtn.Text = "  " .. tostring(current)
            dropBtn.Font = Enum.Font.Gotham
            dropBtn.TextSize = 10
            dropBtn.TextColor3 = Theme.Text
            dropBtn.TextXAlignment = Enum.TextXAlignment.Left
            dropBtn.TextTruncate = Enum.TextTruncate.AtEnd
            dropBtn.Parent = row

            local dStroke = Instance.new("UIStroke")
            dStroke.Color = Theme.Border
            dStroke.Thickness = 1
            dStroke.Parent = dropBtn

            local dChevron = Instance.new("ImageLabel")
            dChevron.Size = UDim2.fromOffset(10, 10)
            dChevron.Position = UDim2.new(1, -14, 0.5, -5)
            dChevron.BackgroundTransparency = 1
            dChevron.Image = Lucide.chevron
            dChevron.ImageColor3 = Theme.TextMuted
            dChevron.Parent = dropBtn

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
                    item.BackgroundColor3 = Theme.CardHover
                    item.BackgroundTransparency = 1
                    item.Text = "  " .. tostring(val)
                    item.Font = Enum.Font.Gotham
                    item.TextSize = 10
                    item.TextColor3 = (val == current) and Theme.Gold or Theme.Text
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

            local obj = {}
            function obj:Set(v)
                current = v
                dropBtn.Text = "  " .. tostring(current)
                cb(current)
            end
            return obj
        end

        -- INPUT
        function Tab:AddInput(c)
            local cb = c.Callback or function() end
            local row = CreateRow(42)
            AddHeaderLabels(row, c.Title, c.Description)

            local box = Instance.new("TextBox")
            box.Size = UDim2.fromOffset(110, 22)
            box.Position = UDim2.new(1, -122, 0.5, -11)
            box.BackgroundColor3 = Theme.Bg
            box.BorderSizePixel = 0
            box.Text = c.Default or ""
            box.PlaceholderText = c.Placeholder or "Ketik di sini..."
            box.Font = Enum.Font.Gotham
            box.TextSize = 10
            box.TextColor3 = Theme.Text
            box.PlaceholderColor3 = Theme.TextDull
            box.ClearTextOnFocus = false
            box.Parent = row

            local iStroke = Instance.new("UIStroke")
            iStroke.Color = Theme.Border
            iStroke.Thickness = 1
            iStroke.Parent = box

            box.Focused:Connect(function() iStroke.Color = Theme.Gold end)
            box.FocusLost:Connect(function()
                iStroke.Color = Theme.Border
                cb(box.Text)
            end)

            local obj = {}
            function obj:Set(v)
                box.Text = tostring(v)
                cb(box.Text)
            end
            return obj
        end

        return Tab
    end

    function Window:BuildConfigSection(settingsTab)
        if not settingsTab then return end
        settingsTab:AddSection({ Title = "Tentang Menu" })
        settingsTab:AddParagraph({
            Title = "Kami UI",
            Content = "Menu script bertema hitam & emas dengan sudut siku-siku rapi.",
        })
    end

    return Window
end

return Kami
