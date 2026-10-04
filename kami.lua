--[[
    KAMI UI - v1.0.0
    Pure Minimalist, Sharp Luxury Dark & Gold Interface for Roblox.
    Engineered cleanly from scratch.
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Kami = {
    Version = "1.0.0"
}

-- Luxury Dark & Gold Color Palette
local Palette = {
    Background  = Color3.fromRGB(9, 9, 10),
    Sidebar     = Color3.fromRGB(12, 12, 14),
    Card        = Color3.fromRGB(16, 16, 18),
    CardHover   = Color3.fromRGB(22, 22, 25),
    Border      = Color3.fromRGB(36, 33, 28),
    BorderHover = Color3.fromRGB(75, 65, 45),
    BorderGold  = Color3.fromRGB(212, 175, 55),
    Gold        = Color3.fromRGB(212, 175, 55),
    GoldDim     = Color3.fromRGB(150, 120, 35),
    Text        = Color3.fromRGB(242, 240, 235),
    TextMuted   = Color3.fromRGB(135, 130, 120),
    Success     = Color3.fromRGB(195, 170, 70),
    Error       = Color3.fromRGB(200, 60, 60),
    Warning     = Color3.fromRGB(225, 155, 45),
}

local Lucide = {
    home = "rbxassetid://93110857987859",
    settings = "rbxassetid://85241284670779",
    cog = "rbxassetid://100080055332619",
    zap = "rbxassetid://130551565616516",
    eye = "rbxassetid://114138575379582",
    user = "rbxassetid://81589895647169",
    terminal = "rbxassetid://106783148545356",
    crosshair = "rbxassetid://103220493099356",
    info = "rbxassetid://92425452073561",
    chevron = "rbxassetid://134243273101015",
}

local function GetParent()
    if gethui then return gethui() end
    return CoreGui
end

-- Cleanup instance lama jika ada
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

-- Global Dropdown Container
local GlobalDropdown = Instance.new("Frame")
GlobalDropdown.Size = UDim2.fromOffset(170, 0)
GlobalDropdown.BackgroundColor3 = Palette.Background
GlobalDropdown.BorderSizePixel = 0
GlobalDropdown.ZIndex = 80
GlobalDropdown.Visible = false
GlobalDropdown.ClipsDescendants = true
GlobalDropdown.Parent = Screen

local DropStroke = Instance.new("UIStroke")
DropStroke.Color = Palette.BorderGold
DropStroke.Thickness = 1
DropStroke.Parent = GlobalDropdown

local DropScroll = Instance.new("ScrollingFrame")
DropScroll.Size = UDim2.new(1, 0, 1, 0)
DropScroll.BackgroundTransparency = 1
DropScroll.BorderSizePixel = 0
DropScroll.ScrollBarThickness = 2
DropScroll.ScrollBarImageColor3 = Palette.Gold
DropScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
DropScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
DropScroll.Parent = GlobalDropdown

local DropLayout = Instance.new("UIListLayout")
DropLayout.Padding = UDim.new(0, 1)
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

-- Notifikasi
function Kami:Notify(cfg)
    cfg = cfg or {}
    local nTitle = cfg.Title or "KAMI UI"
    local nDesc = cfg.Content or ""
    local nDur = cfg.Duration or 3

    local notifyHolder = Screen:FindFirstChild("NotifyHolder")
    if not notifyHolder then
        notifyHolder = Instance.new("Frame")
        notifyHolder.Name = "NotifyHolder"
        notifyHolder.Size = UDim2.new(0, 280, 1, -20)
        notifyHolder.Position = UDim2.new(1, -290, 0, 10)
        notifyHolder.BackgroundTransparency = 1
        notifyHolder.Parent = Screen

        local nLayout = Instance.new("UIListLayout")
        nLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        nLayout.Padding = UDim.new(0, 8)
        nLayout.Parent = notifyHolder
    end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = Palette.Card
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.Parent = notifyHolder

    local cStroke = Instance.new("UIStroke")
    cStroke.Color = Palette.BorderGold
    cStroke.Thickness = 1
    cStroke.Parent = card

    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 2, 1, 0)
    line.BackgroundColor3 = Palette.Gold
    line.BorderSizePixel = 0
    line.Parent = card

    local cPad = Instance.new("UIPadding")
    cPad.PaddingTop = UDim.new(0, 8)
    cPad.PaddingBottom = UDim.new(0, 8)
    cPad.PaddingLeft = UDim.new(0, 12)
    cPad.PaddingRight = UDim.new(0, 10)
    cPad.Parent = card

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, 0, 0, 16)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = nTitle:upper()
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 11
    titleLbl.TextColor3 = Palette.Gold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = card

    local descLbl = Instance.new("TextLabel")
    descLbl.Position = UDim2.fromOffset(0, 18)
    descLbl.Size = UDim2.new(1, 0, 0, 0)
    descLbl.AutomaticSize = Enum.AutomaticSize.Y
    descLbl.BackgroundTransparency = 1
    descLbl.Text = nDesc
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 11
    descLbl.TextColor3 = Palette.Text
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
    local winName = cfg.Name or "KAMI UI"
    local winSub = cfg.SubTitle or "LUXURY EDITION"
    local winSize = cfg.Size or UDim2.fromOffset(600, 420)
    local minKey = cfg.MinimizeKey or Enum.KeyCode.RightControl

    local Window = { Tabs = {}, CurrentTab = nil }

    -- Frame Utama
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Kami_Main"
    MainFrame.Size = winSize
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundColor3 = Palette.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = Screen

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Palette.Border
    MainStroke.Thickness = 1
    MainStroke.Parent = MainFrame

    -- Draggable Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 36)
    Header.BackgroundColor3 = Palette.Sidebar
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local HeaderBottom = Instance.new("Frame")
    HeaderBottom.Size = UDim2.new(1, 0, 0, 1)
    HeaderBottom.Position = UDim2.new(0, 0, 1, -1)
    HeaderBottom.BackgroundColor3 = Palette.Border
    HeaderBottom.BorderSizePixel = 0
    HeaderBottom.Parent = Header

    local LogoDiamond = Instance.new("TextLabel")
    LogoDiamond.Size = UDim2.fromOffset(36, 36)
    LogoDiamond.BackgroundTransparency = 1
    LogoDiamond.Text = "◆"
    LogoDiamond.Font = Enum.Font.GothamBold
    LogoDiamond.TextSize = 10
    LogoDiamond.TextColor3 = Palette.Gold
    LogoDiamond.Parent = Header

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Position = UDim2.fromOffset(34, 0)
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = string.format("<b>%s</b>   <font color=\"#6E685E\">/   %s</font>", winName:upper(), winSub:lower())
    TitleLabel.RichText = true
    TitleLabel.Font = Enum.Font.Code
    TitleLabel.TextSize = 11
    TitleLabel.TextColor3 = Palette.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.fromOffset(36, 36)
    CloseBtn.Position = UDim2.new(1, -36, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "—"
    CloseBtn.Font = Enum.Font.Gotham
    CloseBtn.TextSize = 13
    CloseBtn.TextColor3 = Palette.TextMuted
    CloseBtn.Parent = Header

    local isMinimized = false
    local function ToggleMinimize()
        isMinimized = not isMinimized
        CloseDropdown()
        MainFrame.Visible = not isMinimized
    end
    CloseBtn.MouseButton1Click:Connect(ToggleMinimize)
    UserInputService.InputBegan:Connect(function(inp, proc)
        if not proc and inp.KeyCode == minKey then ToggleMinimize() end
    end)

    -- Logic Drag Window
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

    -- Sidebar Navigasi
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, -36)
    Sidebar.Position = UDim2.new(0, 0, 0, 36)
    Sidebar.BackgroundColor3 = Palette.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SidebarBorder = Instance.new("Frame")
    SidebarBorder.Size = UDim2.new(0, 1, 1, 0)
    SidebarBorder.Position = UDim2.new(1, -1, 0, 0)
    SidebarBorder.BackgroundColor3 = Palette.Border
    SidebarBorder.BorderSizePixel = 0
    SidebarBorder.Parent = Sidebar

    local NavScroll = Instance.new("ScrollingFrame")
    NavScroll.Size = UDim2.new(1, 0, 1, -26)
    NavScroll.BackgroundTransparency = 1
    NavScroll.BorderSizePixel = 0
    NavScroll.ScrollBarThickness = 0
    NavScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    NavScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    NavScroll.Parent = Sidebar

    local NavLayout = Instance.new("UIListLayout")
    NavLayout.Padding = UDim.new(0, 2)
    NavLayout.Parent = NavScroll

    local NavPad = Instance.new("UIPadding")
    NavPad.PaddingTop = UDim.new(0, 8)
    NavPad.PaddingLeft = UDim.new(0, 6)
    NavPad.PaddingRight = UDim.new(0, 6)
    NavPad.Parent = NavScroll

    -- Footer Watermark (Aman & Terisolasi)
    local Footer = Instance.new("Frame")
    Footer.Size = UDim2.new(1, 0, 0, 24)
    Footer.Position = UDim2.new(0, 0, 1, -24)
    Footer.BackgroundTransparency = 1
    Footer.Parent = Sidebar

    local FooterText = Instance.new("TextLabel")
    FooterText.Size = UDim2.new(1, -12, 1, 0)
    FooterText.Position = UDim2.fromOffset(8, 0)
    FooterText.BackgroundTransparency = 1
    FooterText.Text = "KAMI · v" .. Kami.Version
    FooterText.Font = Enum.Font.Code
    FooterText.TextSize = 9
    FooterText.TextColor3 = Palette.TextMuted
    FooterText.TextXAlignment = Enum.TextXAlignment.Left
    FooterText.Parent = Footer

    -- Container Konten
    local ContentHolder = Instance.new("Frame")
    ContentHolder.Name = "Content"
    ContentHolder.Size = UDim2.new(1, -150, 1, -36)
    ContentHolder.Position = UDim2.new(0, 150, 0, 36)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.ClipsDescendants = true
    ContentHolder.Parent = MainFrame

    -- Tab Builder
    function Window:AddTab(opt)
        opt = opt or {}
        local tabTitle = opt.Title or "Tab"
        local tabIcon = opt.Icon and Lucide[opt.Icon]

        local Tab = {}
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.BackgroundColor3 = Palette.Background
        TabBtn.BackgroundTransparency = 1
        TabBtn.BorderSizePixel = 0
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = NavScroll

        local TabIndicator = Instance.new("Frame")
        TabIndicator.Size = UDim2.new(0, 2, 0, 14)
        TabIndicator.Position = UDim2.new(0, 2, 0.5, -7)
        TabIndicator.BackgroundColor3 = Palette.Gold
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Visible = false
        TabIndicator.Parent = TabBtn

        local textOffset = 14
        if tabIcon then
            local iconImg = Instance.new("ImageLabel")
            iconImg.Size = UDim2.fromOffset(13, 13)
            iconImg.Position = UDim2.new(0, 12, 0.5, -6)
            iconImg.BackgroundTransparency = 1
            iconImg.Image = tabIcon
            iconImg.ImageColor3 = Palette.TextMuted
            iconImg.Parent = TabBtn
            textOffset = 32
        end

        local TabLbl = Instance.new("TextLabel")
        TabLbl.Size = UDim2.new(1, -textOffset, 1, 0)
        TabLbl.Position = UDim2.fromOffset(textOffset, 0)
        TabLbl.BackgroundTransparency = 1
        TabLbl.Text = tabTitle
        TabLbl.Font = Enum.Font.Gotham
        TabLbl.TextSize = 12
        TabLbl.TextColor3 = Palette.TextMuted
        TabLbl.TextXAlignment = Enum.TextXAlignment.Left
        TabLbl.Parent = TabBtn

        -- Konten Halaman
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Palette.BorderHover
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Visible = false
        Page.Parent = ContentHolder

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.Parent = Page

        local PagePad = Instance.new("UIPadding")
        PagePad.PaddingTop = UDim.new(0, 14)
        PagePad.PaddingBottom = UDim.new(0, 14)
        PagePad.PaddingLeft = UDim.new(0, 14)
        PagePad.PaddingRight = UDim.new(0, 14)
        PagePad.Parent = Page

        local function SetActive()
            CloseDropdown()
            for _, t in ipairs(Window.Tabs) do
                t.Page.Visible = false
                t.Indicator.Visible = false
                t.Label.TextColor3 = Palette.TextMuted
                t.Button.BackgroundTransparency = 1
            end
            Page.Visible = true
            TabIndicator.Visible = true
            TabLbl.TextColor3 = Palette.Text
            TabBtn.BackgroundTransparency = 0
            Window.CurrentTab = Tab
        end

        TabBtn.MouseButton1Click:Connect(SetActive)
        table.insert(Window.Tabs, { Button = TabBtn, Label = TabLbl, Indicator = TabIndicator, Page = Page })
        if #Window.Tabs == 1 then SetActive() end

        -- Elemen Form Helper
        local function CreateRow(h)
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, h or 40)
            row.BackgroundColor3 = Palette.Card
            row.BorderSizePixel = 0
            row.Parent = Page

            local st = Instance.new("UIStroke")
            st.Color = Palette.Border
            st.Thickness = 1
            st.Parent = row

            row.MouseEnter:Connect(function()
                st.Color = Palette.BorderHover
                row.BackgroundColor3 = Palette.CardHover
            end)
            row.MouseLeave:Connect(function()
                st.Color = Palette.Border
                row.BackgroundColor3 = Palette.Card
            end)

            return row, st
        end

        local function AddHeaderLabels(row, title, desc)
            local t = Instance.new("TextLabel")
            t.Position = UDim2.fromOffset(12, desc and 6 or 0)
            t.Size = UDim2.new(1, -120, 0, desc and 16 or row.Size.Y.Offset)
            t.BackgroundTransparency = 1
            t.Text = title or ""
            t.Font = Enum.Font.Gotham
            t.TextSize = 12
            t.TextColor3 = Palette.Text
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.Parent = row

            if desc and desc ~= "" then
                local d = Instance.new("TextLabel")
                d.Position = UDim2.fromOffset(12, 22)
                d.Size = UDim2.new(1, -120, 0, 12)
                d.BackgroundTransparency = 1
                d.Text = desc
                d.Font = Enum.Font.Gotham
                d.TextSize = 10
                d.TextColor3 = Palette.TextMuted
                d.TextXAlignment = Enum.TextXAlignment.Left
                d.Parent = row
            end
        end

        -- SECTION
        function Tab:AddSection(c)
            local sHolder = Instance.new("Frame")
            sHolder.Size = UDim2.new(1, 0, 0, 22)
            sHolder.BackgroundTransparency = 1
            sHolder.Parent = Page

            local sText = Instance.new("TextLabel")
            sText.Size = UDim2.new(1, 0, 1, 0)
            sText.BackgroundTransparency = 1
            sText.Text = "—  " .. string.upper(c.Title or "")
            sText.Font = Enum.Font.Code
            sText.TextSize = 10
            sText.TextColor3 = Palette.GoldDim
            sText.TextXAlignment = Enum.TextXAlignment.Left
            sText.Parent = sHolder
        end

        -- PARAGRAPH
        function Tab:AddParagraph(c)
            local pRow = Instance.new("Frame")
            pRow.Size = UDim2.new(1, 0, 0, 0)
            pRow.AutomaticSize = Enum.AutomaticSize.Y
            pRow.BackgroundColor3 = Palette.Card
            pRow.BorderSizePixel = 0
            pRow.Parent = Page

            local pStroke = Instance.new("UIStroke")
            pStroke.Color = Palette.Border
            pStroke.Thickness = 1
            pStroke.Parent = pRow

            local pPad = Instance.new("UIPadding")
            pPad.PaddingTop = UDim.new(0, 10); pPad.PaddingBottom = UDim.new(0, 10)
            pPad.PaddingLeft = UDim.new(0, 12); pPad.PaddingRight = UDim.new(0, 12)
            pPad.Parent = pRow

            local pLay = Instance.new("UIListLayout")
            pLay.Padding = UDim.new(0, 4)
            pLay.Parent = pRow

            if c.Title and c.Title ~= "" then
                local pt = Instance.new("TextLabel")
                pt.Size = UDim2.new(1, 0, 0, 0); pt.AutomaticSize = Enum.AutomaticSize.Y
                pt.BackgroundTransparency = 1
                pt.Text = c.Title
                pt.Font = Enum.Font.GothamBold
                pt.TextSize = 12
                pt.TextColor3 = Palette.Gold
                pt.TextXAlignment = Enum.TextXAlignment.Left
                pt.Parent = pRow
            end

            if c.Content and c.Content ~= "" then
                local pc = Instance.new("TextLabel")
                pc.Size = UDim2.new(1, 0, 0, 0); pc.AutomaticSize = Enum.AutomaticSize.Y
                pc.BackgroundTransparency = 1
                pc.Text = c.Content
                pc.Font = Enum.Font.Gotham
                pc.TextSize = 11
                pc.TextColor3 = Palette.TextMuted
                pc.TextXAlignment = Enum.TextXAlignment.Left
                pc.TextWrapped = true
                pc.Parent = pRow
            end
        end

        -- TOGGLE (Checkbox Minimalist)
        function Tab:AddToggle(c)
            local state = c.Default or false
            local cb = c.Callback or function() end
            local row = CreateRow(40)
            AddHeaderLabels(row, c.Title, c.Description)

            local box = Instance.new("Frame")
            box.Size = UDim2.fromOffset(18, 18)
            box.Position = UDim2.new(1, -30, 0.5, -9)
            box.BackgroundColor3 = Palette.Background
            box.BorderSizePixel = 0
            box.Parent = row

            local bStroke = Instance.new("UIStroke")
            bStroke.Color = state and Palette.Gold or Palette.BorderHover
            bStroke.Thickness = 1
            bStroke.Parent = box

            local check = Instance.new("Frame")
            check.Size = UDim2.fromOffset(8, 8)
            check.Position = UDim2.new(0.5, -4, 0.5, -4)
            check.BackgroundColor3 = Palette.Gold
            check.BorderSizePixel = 0
            check.Visible = state
            check.Parent = box

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = row

            local obj = {}
            function obj:Set(val)
                state = val and true or false
                check.Visible = state
                bStroke.Color = state and Palette.Gold or Palette.BorderHover
                cb(state)
            end

            btn.MouseButton1Click:Connect(function() obj:Set(not state) end)
            return obj
        end

        -- BUTTON
        function Tab:AddButton(c)
            local cb = c.Callback or function() end
            local row = CreateRow(40)
            AddHeaderLabels(row, c.Title, c.Description)

            local bAction = Instance.new("TextButton")
            bAction.Size = UDim2.fromOffset(80, 24)
            bAction.Position = UDim2.new(1, -92, 0.5, -12)
            bAction.BackgroundColor3 = Palette.Background
            bAction.BorderSizePixel = 0
            bAction.Text = (c.ButtonText or "RUN"):upper()
            bAction.Font = Enum.Font.Code
            bAction.TextSize = 11
            bAction.TextColor3 = Palette.Gold
            bAction.AutoButtonColor = false
            bAction.Parent = row

            local bStroke = Instance.new("UIStroke")
            bStroke.Color = Palette.BorderGold
            bStroke.Thickness = 1
            bStroke.Parent = bAction

            bAction.MouseEnter:Connect(function()
                bAction.BackgroundColor3 = Palette.Gold
                bAction.TextColor3 = Palette.Background
            end)
            bAction.MouseLeave:Connect(function()
                bAction.BackgroundColor3 = Palette.Background
                bAction.TextColor3 = Palette.Gold
            end)
            bAction.MouseButton1Click:Connect(function()
                cb()
            end)
        end

        -- SLIDER
        function Tab:AddSlider(c)
            local min, max, step = c.Min or 0, c.Max or 100, c.Step or 1
            local cur = math.clamp(c.Default or min, min, max)
            local cb = c.Callback or function() end
            local row = CreateRow(48)

            local sTitle = Instance.new("TextLabel")
            sTitle.Position = UDim2.fromOffset(12, 6)
            sTitle.Size = UDim2.new(1, -70, 0, 14)
            sTitle.BackgroundTransparency = 1
            sTitle.Text = c.Title or "Slider"
            sTitle.Font = Enum.Font.Gotham
            sTitle.TextSize = 12
            sTitle.TextColor3 = Palette.Text
            sTitle.TextXAlignment = Enum.TextXAlignment.Left
            sTitle.Parent = row

            local sVal = Instance.new("TextLabel")
            sVal.Position = UDim2.new(1, -54, 0, 6)
            sVal.Size = UDim2.fromOffset(42, 14)
            sVal.BackgroundTransparency = 1
            sVal.Text = tostring(cur)
            sVal.Font = Enum.Font.Code
            sVal.TextSize = 11
            sVal.TextColor3 = Palette.Gold
            sVal.TextXAlignment = Enum.TextXAlignment.Right
            sVal.Parent = row

            local track = Instance.new("Frame")
            track.Position = UDim2.fromOffset(12, 30)
            track.Size = UDim2.new(1, -24, 0, 2)
            track.BackgroundColor3 = Palette.BorderHover
            track.BorderSizePixel = 0
            track.Parent = row

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((cur - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = Palette.Gold
            fill.BorderSizePixel = 0
            fill.Parent = track

            local knob = Instance.new("Frame")
            knob.Size = UDim2.fromOffset(6, 12)
            knob.AnchorPoint = Vector2.new(0.5, 0.5)
            knob.Position = UDim2.new((cur - min) / (max - min), 0, 0.5, 0)
            knob.BackgroundColor3 = Palette.Gold
            knob.BorderSizePixel = 0
            knob.Parent = track

            local trigger = Instance.new("TextButton")
            trigger.Position = UDim2.fromOffset(12, 20)
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
            local current = c.Default or values[1] or "None"
            local cb = c.Callback or function() end
            local row = CreateRow(40)
            AddHeaderLabels(row, c.Title, c.Description)

            local dropBtn = Instance.new("TextButton")
            dropBtn.Size = UDim2.fromOffset(130, 24)
            dropBtn.Position = UDim2.new(1, -142, 0.5, -12)
            dropBtn.BackgroundColor3 = Palette.Background
            dropBtn.BorderSizePixel = 0
            dropBtn.Text = "  " .. tostring(current)
            dropBtn.Font = Enum.Font.Gotham
            dropBtn.TextSize = 11
            dropBtn.TextColor3 = Palette.Text
            dropBtn.TextXAlignment = Enum.TextXAlignment.Left
            dropBtn.TextTruncate = Enum.TextTruncate.AtEnd
            dropBtn.Parent = row

            local dStroke = Instance.new("UIStroke")
            dStroke.Color = Palette.Border
            dStroke.Thickness = 1
            dStroke.Parent = dropBtn

            local dChevron = Instance.new("ImageLabel")
            dChevron.Size = UDim2.fromOffset(12, 12)
            dChevron.Position = UDim2.new(1, -16, 0.5, -6)
            dChevron.BackgroundTransparency = 1
            dChevron.Image = Lucide.chevron
            dChevron.ImageColor3 = Palette.TextMuted
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
                    item.Size = UDim2.new(1, 0, 0, 24)
                    item.BackgroundColor3 = Palette.Card
                    item.BackgroundTransparency = 1
                    item.Text = "  " .. tostring(val)
                    item.Font = Enum.Font.Gotham
                    item.TextSize = 11
                    item.TextColor3 = (val == current) and Palette.Gold or Palette.Text
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

                local itemH = math.min(#values * 25, 150)
                GlobalDropdown.Size = UDim2.fromOffset(130, itemH)
                GlobalDropdown.Position = UDim2.fromOffset(dropBtn.AbsolutePosition.X, dropBtn.AbsolutePosition.Y + 26)
                GlobalDropdown.Visible = true
            end

            dropBtn.MouseButton1Click:Connect(OpenMenu)

            local obj = {}
            function obj:Set(v)
                current = v
                dropBtn.Text = "  " .. tostring(current)
                cb(current)
            end
            function obj:SetValues(newVals)
                values = newVals
                if not table.find(values, current) then current = values[1] or "None" end
                dropBtn.Text = "  " .. tostring(current)
            end
            return obj
        end

        -- INPUT
        function Tab:AddInput(c)
            local cb = c.Callback or function() end
            local row = CreateRow(40)
            AddHeaderLabels(row, c.Title, c.Description)

            local box = Instance.new("TextBox")
            box.Size = UDim2.fromOffset(130, 24)
            box.Position = UDim2.new(1, -142, 0.5, -12)
            box.BackgroundColor3 = Palette.Background
            box.BorderSizePixel = 0
            box.Text = c.Default or ""
            box.PlaceholderText = c.Placeholder or "Enter value..."
            box.Font = Enum.Font.Code
            box.TextSize = 11
            box.TextColor3 = Palette.Text
            box.PlaceholderColor3 = Palette.TextMuted
            box.ClearTextOnFocus = false
            box.Parent = row

            local iStroke = Instance.new("UIStroke")
            iStroke.Color = Palette.Border
            iStroke.Thickness = 1
            iStroke.Parent = box

            box.Focused:Connect(function() iStroke.Color = Palette.BorderGold end)
            box.FocusLost:Connect(function(enter)
                iStroke.Color = Palette.Border
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
        settingsTab:AddSection({ Title = "System Controls" })
        settingsTab:AddParagraph({
            Title = "Kami UI Framework",
            Content = "Minimalist luxury interface with zero corner curves and pure sharp layout."
        })
    end

    return Window
end

return Kami
