--[[
    KAMI UI - v1.4.5
    Pitch Dark Edition  ·  Minimal · Sharp · Animated

    v1.4.5 changes:
      - Loading screen: if cfg.Logo is an image that fails to load (Roblox
        blocks most external image URLs), it gracefully falls back to the
        big "K" instead of showing an empty box

    v1.4.4 changes:
      - Loading screen: the logo mark can now be an image via cfg.Logo (with a
        graceful fallback to the big "K"); configurable size via cfg.LogoSize
      - Loader passes the KAMI icon URL for the loading mark

    v1.4.3 changes:
      - Row accent: replaced the short floating tick with a full-height left
        rail that fades softly at both ends (elegant); it brightens on hover
      - Loading screen: the logo mark is now a bold "K" (GothamBlack, accent
        outline) instead of the rotating box; gentler and cleaner
      - Loading screen now returns a handle and crossfades directly into the
        window's open animation (the UI emerges from the loading screen)

    v1.4.2 changes:
      - Loading screen: removed the big backdrop glow (it caused a grey haze
        on dark themes). New clean layout with a rotating gradient logo mark,
        spaced wordmark, thin progress bar with a moving glint, live
        percentage and a small build tag.

    v1.4.1 changes:
      - Left accent stripe on every row (toggle/slider/button/dropdown/input/
        keybind); subtle gradient and it grows on hover
      - Loading screen rebuilt to a clean, minimal layout (wordmark + thin
        progress bar + live percentage, one soft breathing glow)
      - Fixed sidebar footer peeking into the header when the window is
        minimized (footer is hidden while collapsed)
      - Notification reverted to the previous style, lightly polished
        (gradient accent line + top highlight + gradient timer)

    v1.4.0 changes ("Animated Accent" pack):
      - Rotating gradient rim around the window (spins forever)
      - Moving accent glint sweeping along the header underline
      - Accent bar with a flowing vertical gradient
      - Gradient tab indicator, gradient slider fill
      - Button sheen that sweeps on hover
      - Slider knob glow that pulses while dragging

    v1.3.1 changes:
      - Reverted the window/UI colours back to the original (v1.2.1) palette
        and removed the extra "depth" themes/tints. Original 5 themes only.
      - Fixed the minimize → drag → maximize bug: the window is now clamped
        to the screen on collapse/expand, and dragging no longer lags/queues
        (direct positioning instead of stacking tweens).
      - Rebuilt loading screen (drifting glow, HUD brackets, particles,
        rotating rings, orbiting dots, gradient bar w/ diamond head).

    Core features:
      - Multiple themes (Pitch Dark, Graphite, Obsidian Gold, Cyber Gold,
        Midnight Gold)
      - Sharp rect aesthetic (no UICorner)
      - Accent-bar header + clean dual-label title
      - Smooth animations: window open/close, collapse, tab slide, ripples,
        toggle/slider/dropdown motion, sliding notifications w/ timer bar
      - Custom tab icons via rbxassetid / number / built-in name
      - Profile card, game card, stat grid, section, paragraph, label
      - Toggle, Button, Slider, Dropdown (multi + search), ColorPicker, Input, Keybind
      - Scrollable = false tabs + Window:Destroy() + adaptive mobile sizing
      - Post-loading Discord invite prompt
      - Live theme switching + Config manager (save / load / delete / auto-load)
      - Floating toggle button on touch devices
]]

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local HttpService      = game:GetService("HttpService")
local RunService       = game:GetService("RunService")

local Kami = {
    Version = "1.4.5"
}

local CONFIG_FOLDER  = "KamiUI_Configs"
local AUTO_LOAD_FILE = "kamiui_autoload.json"

--==================================================================
-- THEMES
--==================================================================
local RGB = Color3.fromRGB

local Themes = {
    ["Pitch Dark"] = {
        Bg          = RGB(7, 7, 8),
        Sidebar     = RGB(10, 10, 11),
        Card        = RGB(13, 13, 14),
        CardHover   = RGB(19, 19, 21),
        Border      = RGB(28, 28, 30),
        BorderHover = RGB(58, 58, 62),
        Accent      = RGB(236, 236, 236),
        AccentMuted = RGB(125, 125, 130),
        Text        = RGB(242, 242, 242),
        TextMuted   = RGB(138, 138, 144),
        TextDull    = RGB(74, 74, 80),
    },
    ["Graphite"] = {
        Bg          = RGB(14, 14, 15),
        Sidebar     = RGB(17, 17, 18),
        Card        = RGB(21, 21, 23),
        CardHover   = RGB(27, 27, 30),
        Border      = RGB(36, 36, 39),
        BorderHover = RGB(70, 70, 76),
        Accent      = RGB(200, 205, 215),
        AccentMuted = RGB(115, 120, 130),
        Text        = RGB(238, 238, 240),
        TextMuted   = RGB(140, 142, 150),
        TextDull    = RGB(82, 84, 90),
    },
    ["Obsidian Gold"] = {
        Bg          = RGB(8, 8, 9),
        Sidebar     = RGB(11, 11, 13),
        Card        = RGB(14, 14, 16),
        CardHover   = RGB(20, 20, 23),
        Border      = RGB(30, 28, 24),
        BorderHover = RGB(75, 68, 48),
        Accent      = RGB(212, 175, 55),
        AccentMuted = RGB(135, 110, 42),
        Text        = RGB(245, 243, 238),
        TextMuted   = RGB(145, 140, 130),
        TextDull    = RGB(85, 82, 75),
    },
    ["Cyber Gold"] = {
        Bg          = RGB(10, 11, 14),
        Sidebar     = RGB(13, 14, 18),
        Card        = RGB(16, 18, 22),
        CardHover   = RGB(22, 25, 32),
        Border      = RGB(35, 40, 45),
        BorderHover = RGB(85, 80, 55),
        Accent      = RGB(245, 195, 65),
        AccentMuted = RGB(150, 125, 45),
        Text        = RGB(240, 244, 248),
        TextMuted   = RGB(140, 145, 155),
        TextDull    = RGB(80, 85, 95),
    },
    ["Midnight Gold"] = {
        Bg          = RGB(6, 8, 12),
        Sidebar     = RGB(9, 11, 16),
        Card        = RGB(12, 15, 22),
        CardHover   = RGB(17, 21, 30),
        Border      = RGB(25, 32, 45),
        BorderHover = RGB(60, 65, 55),
        Accent      = RGB(220, 180, 70),
        AccentMuted = RGB(130, 110, 50),
        Text        = RGB(235, 240, 245),
        TextMuted   = RGB(130, 138, 150),
        TextDull    = RGB(75, 82, 92),
    },
}

local ThemeOrder = { "Pitch Dark", "Graphite", "Obsidian Gold", "Cyber Gold", "Midnight Gold" }
local CurrentThemeName = "Pitch Dark"
local CurrentTheme = Themes[CurrentThemeName]

Kami.Themes = Themes
Kami.ThemeOrder = ThemeOrder

-- Lucide Icon Asset IDs
local Lucide = {
    home      = "rbxassetid://93110857987859",
    settings  = "rbxassetid://85241284670779",
    info      = "rbxassetid://92425452073561",
    chevron   = "rbxassetid://134243273101015",
    zap       = "rbxassetid://130551565616516",
    user      = "rbxassetid://81589895647169",
    terminal  = "rbxassetid://106783148545356",
    sliders   = "rbxassetid://132977703952271",
    shield    = "rbxassetid://77608084747459",
    folder    = "rbxassetid://122945524502470",
    discord   = "rbxassetid://102424727138621",
}

--==================================================================
-- HELPERS
--==================================================================
local function ResolveIcon(icon)
    if not icon then return nil end
    if type(icon) == "string" then
        local lower = icon:lower()
        if Lucide[lower] then
            return Lucide[lower]
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
    if gethui then
        local ok, h = pcall(gethui)
        if ok and h then return h end
    end
    return CoreGui
end

local function New(class, props)
    local inst = Instance.new(class)
    local parent = nil
    for k, v in pairs(props or {}) do
        if k == "Parent" then parent = v else inst[k] = v end
    end
    if parent then inst.Parent = parent end
    return inst
end

local function Tween(obj, t, props, style, dir)
    local tw = TweenService:Create(
        obj,
        TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
        props
    )
    tw:Play()
    return tw
end

-- Sharp aesthetic: UICorner intentionally disabled
local function Corner(_parent, _r)
    return nil
end

local function ColorToHex(c)
    return string.format("%02X%02X%02X",
        math.floor(c.R * 255 + 0.5),
        math.floor(c.G * 255 + 0.5),
        math.floor(c.B * 255 + 0.5)
    )
end

local function HexToColor(hex)
    hex = tostring(hex or ""):gsub("#", "")
    if #hex ~= 6 then return nil end
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    if not (r and g and b) then return nil end
    return Color3.fromRGB(r, g, b)
end

local function FitWindowSize(size)
    size = size or UDim2.fromOffset(620, 430)
    local cam = workspace.CurrentCamera
    local vs = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
    local padX, padY = 24, 48
    local w = size.X.Offset + (vs.X * size.X.Scale)
    local h = size.Y.Offset + (vs.Y * size.Y.Scale)
    local compact = UserInputService.TouchEnabled or vs.X < 720
    w = math.min(w, vs.X - padX)
    h = math.min(h, vs.Y - padY)
    if compact then
        w = math.min(w, math.max(320, vs.X - padX))
        h = math.min(h, math.max(280, vs.Y - padY))
        if vs.X < 520 then
            w = vs.X - padX
            h = math.min(vs.Y - padY, math.max(300, h))
        end
    end
    return UDim2.fromOffset(math.floor(w), math.floor(h)), compact
end

local function Stroke(parent, color, thick, transp)
    return New("UIStroke", {
        Color = color,
        Thickness = thick or 1,
        Transparency = transp or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, -- prevents stroking the text itself
        Parent = parent,
    })
end

local function Pad(parent, t, b, l, r)
    return New("UIPadding", {
        PaddingTop = UDim.new(0, t or 0), PaddingBottom = UDim.new(0, b or 0),
        PaddingLeft = UDim.new(0, l or 0), PaddingRight = UDim.new(0, r or 0),
        Parent = parent,
    })
end

--==================================================================
-- DEPTH HELPERS (v1.3.0)
--==================================================================
local GLOW_IMAGE = "rbxassetid://6014261993" -- soft blur, reused as a colored glow

local function AddGradient(parent, seq, rotation)
    return New("UIGradient", {
        Color = seq or ColorSequence.new(Color3.new(1, 1, 1)),
        Rotation = rotation or 0,
        Parent = parent,
    })
end

local function AddGlow(parent, color, size, transparency, zindex)
    return New("ImageLabel", {
        Name = "KamiGlow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = size or UDim2.fromScale(1.35, 1.35),
        BackgroundTransparency = 1,
        Image = GLOW_IMAGE,
        ImageColor3 = color,
        ImageTransparency = transparency == nil and 0.7 or transparency,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = zindex or 0,
        Parent = parent,
    })
end

-- Colour a spinner border should cycle through (accent -> border -> accent)
local function SpinSeq()
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, CurrentTheme.Accent),
        ColorSequenceKeypoint.new(0.5, CurrentTheme.Border),
        ColorSequenceKeypoint.new(1, CurrentTheme.Accent),
    })
end

-- Animated gradient rim: a slightly larger frame placed behind `parentOb`, so
-- only a thin rim peeks out. Its gradient spins forever (no per-instance cost
-- beyond a single Tween, so it is safe for the window and notifications).
local function SpawnSpinBorder(parentOb, thickness, zindex, speed)
    local ring = New("Frame", {
        Name = "KamiSpinBorder",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, (thickness or 1) * 2, 1, (thickness or 1) * 2),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        ZIndex = zindex or 0,
        Parent = parentOb,
    })
    local grad = AddGradient(ring, SpinSeq(), 0)
    TweenService:Create(
        grad,
        TweenInfo.new(speed or 6, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        { Rotation = 360 }
    ):Play()
    return ring, grad
end

-- Sharp flash ripple (no round corners)
local function Ripple(btn)
    local size = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 1.6
    local r = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(0, 0),
        BackgroundColor3 = CurrentTheme.Accent,
        BackgroundTransparency = 0.82,
        BorderSizePixel = 0,
        ZIndex = btn.ZIndex + 1,
        Parent = btn,
    })
    Tween(r, 0.55, { Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1 })
    task.delay(0.56, function() r:Destroy() end)
end

-- Little "press" bounce via UIScale
local function Press(guiObj)
    local sc = guiObj:FindFirstChild("KamiPressScale") or New("UIScale", { Name = "KamiPressScale", Parent = guiObj })
    sc.Scale = 0.94
    Tween(sc, 0.35, { Scale = 1 }, Enum.EasingStyle.Back)
end

--==================================================================
-- SCREEN
--==================================================================
if getgenv and getgenv().KamiUIInstance then
    pcall(function() getgenv().KamiUIInstance:Destroy() end)
end

local Screen = New("ScreenGui", {
    Name = "KamiUI_" .. tostring(math.random(10000, 99999)),
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 100,
    Parent = GetParent(),
})

if getgenv then getgenv().KamiUIInstance = Screen end

local Repainters = {}
local function RegisterPaint(fn)
    table.insert(Repainters, fn)
    pcall(fn)
end

local function ApplyTheme(themeName)
    local t = Themes[themeName]
    if not t then return false end
    CurrentTheme = t
    CurrentThemeName = themeName
    for i = #Repainters, 1, -1 do
        local ok = pcall(Repainters[i])
        if not ok then table.remove(Repainters, i) end
    end
    return true
end

function Kami:SetTheme(name) return ApplyTheme(name) end
function Kami:GetTheme() return CurrentThemeName, CurrentTheme end

-- Keybind capture guard (prevents toggle key firing while binding)
local BindingActive = false

--==================================================================
-- LOADING SCREEN  (v1.3.0 - rebuilt)
--==================================================================
local function Spaced(s)
    local out = (s:upper():gsub(".", "%0 "))
    return out:sub(1, -2)
end

function Kami:ShowLoadingScreen(cfg)
    cfg = cfg or {}
    local steps = cfg.Steps or {
        "Initializing...",
        "Loading modules...",
        "Building interface...",
        "Ready.",
    }
    if #steps == 0 then steps = { "Loading..." } end
    local duration = cfg.Duration or 2.6
    local title = cfg.Title or "KAMI"
    local T = CurrentTheme

    local LoadGui = New("ScreenGui", {
        Name = "Kami_Loading",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 999,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = GetParent(),
    })

    local Bg = New("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = T.Bg,
        BorderSizePixel = 0,
        Parent = LoadGui,
    })

    local Center = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(320, 232),
        BackgroundTransparency = 1,
        Parent = Bg,
    })
    local CenterScale = New("UIScale", { Scale = 1, Parent = Center })
    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        Parent = Center,
    })

    -- logo mark: use cfg.Logo (image URL) when given, otherwise a big "K"
    local logoURL = cfg.Logo
    local Mark, MarkStroke, MarkIsImage
    if logoURL and logoURL ~= "" then
        local size = tonumber(cfg.LogoSize) or 88
        Mark = New("ImageLabel", {
            Size = UDim2.fromOffset(size, size),
            BackgroundTransparency = 1,
            Image = logoURL,
            ImageTransparency = 1,
            LayoutOrder = 1,
            Parent = Center,
        })
        MarkIsImage = true
    else
        Mark = New("TextLabel", {
            Size = UDim2.fromOffset(300, 62),
            BackgroundTransparency = 1,
            Text = "K",
            Font = Enum.Font.GothamBlack,
            TextSize = 56,
            TextColor3 = T.Text,
            TextXAlignment = Enum.TextXAlignment.Center,
            LayoutOrder = 1,
            Parent = Center,
        })
        MarkStroke = Stroke(Mark, T.Accent, 1.5)
        MarkIsImage = false
    end

    local function MarkFade(t, v)
        if MarkIsImage then
            Tween(Mark, t, { ImageTransparency = v })
        else
            Tween(Mark, t, { TextTransparency = v })
        end
    end

    -- spaced wordmark
    local Word = New("TextLabel", {
        Size = UDim2.fromOffset(300, 16),
        BackgroundTransparency = 1,
        Text = Spaced(title),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = T.TextMuted,
        TextXAlignment = Enum.TextXAlignment.Center,
        LayoutOrder = 2,
        Parent = Center,
    })

    local Status = New("TextLabel", {
        Size = UDim2.fromOffset(300, 13),
        BackgroundTransparency = 1,
        Text = steps[1],
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextColor3 = T.TextDull,
        TextXAlignment = Enum.TextXAlignment.Center,
        LayoutOrder = 3,
        Parent = Center,
    })

    -- thin progress bar with a moving glint
    local BarBg = New("Frame", {
        Size = UDim2.new(0, 220, 0, 2),
        BackgroundColor3 = T.Border,
        BorderSizePixel = 0,
        LayoutOrder = 4,
        Parent = Center,
    })
    local BarFill = New("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
        Parent = BarBg,
    })
    AddGradient(BarFill, ColorSequence.new({
        ColorSequenceKeypoint.new(0, T.AccentMuted),
        ColorSequenceKeypoint.new(1, T.Accent),
    }), 0)
    local Glint = New("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = BarFill,
    })
    local GlintGrad = AddGradient(Glint, ColorSequence.new(Color3.new(1, 1, 1)), 0)
    GlintGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.35),
        NumberSequenceKeypoint.new(1, 1),
    })
    GlintGrad.Offset = Vector2.new(-1, 0)
    local shimmer = TweenService:Create(GlintGrad, TweenInfo.new(1.6, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), { Offset = Vector2.new(1, 0) })
    shimmer:Play()

    local Percent = New("TextLabel", {
        Size = UDim2.fromOffset(220, 12),
        BackgroundTransparency = 1,
        Text = "0%",
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextColor3 = T.TextDull,
        TextXAlignment = Enum.TextXAlignment.Right,
        LayoutOrder = 5,
        Parent = Center,
    })

    local Build = New("TextLabel", {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 22, 1, -18),
        Size = UDim2.fromOffset(220, 14),
        BackgroundTransparency = 1,
        Text = "KAMI  ·  v" .. Kami.Version,
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextColor3 = T.TextDull,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Bg,
    })

    -- entrance: the mark pops in
    CenterScale.Scale = 0.9
    if MarkIsImage then Mark.ImageTransparency = 1 else Mark.TextTransparency = 1 end
    Word.TextTransparency = 1
    Status.TextTransparency = 1
    Tween(CenterScale, 0.7, { Scale = 1 }, Enum.EasingStyle.Back)
    MarkFade(0.5, 0)
    if MarkStroke then Tween(MarkStroke, 0.5, { Transparency = 0 }) end
    Tween(Word, 0.5, { TextTransparency = 0 })
    Tween(Status, 0.4, { TextTransparency = 0 })

    -- gentle breathing on the mark while loading
    local finished = false
    local breathe = TweenService:Create(CenterScale, TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { Scale = 1.03 })
    task.delay(0.8, function() if not finished then breathe:Play() end end)

    -- If the logo is an image that fails to load (Roblox blocks most external
    -- image URLs), fall back to the big "K" so the screen never looks blank.
    if MarkIsImage then
        task.delay(1.2, function()
            if finished or not Mark or not Mark.Parent or Mark.IsLoaded then return end
            local order = Mark.LayoutOrder
            Mark:Destroy()
            Mark = New("TextLabel", {
                Size = UDim2.fromOffset(300, 62),
                BackgroundTransparency = 1,
                Text = "K",
                Font = Enum.Font.GothamBlack,
                TextSize = 56,
                TextColor3 = T.Text,
                TextXAlignment = Enum.TextXAlignment.Center,
                LayoutOrder = order,
                TextTransparency = 1,
                Parent = Center,
            })
            MarkStroke = Stroke(Mark, T.Accent, 1.5)
            MarkIsImage = false
            Tween(Mark, 0.35, { TextTransparency = 0 })
            Tween(MarkStroke, 0.35, { Transparency = 0 })
        end)
    end

    local pctConn = RunService.RenderStepped:Connect(function()
        Percent.Text = tostring(math.floor(BarFill.Size.X.Scale * 100 + 0.5)) .. "%"
    end)

    task.wait(0.4)

    local delayPerStep = duration / #steps
    for i, stepText in ipairs(steps) do
        if i > 1 then
            Tween(Status, 0.12, { TextTransparency = 1 })
            task.wait(0.12)
        end
        Status.Text = stepText
        Tween(Status, 0.18, { TextTransparency = 0 })
        Tween(BarFill, delayPerStep * 0.85, { Size = UDim2.new(i / #steps, 0, 1, 0) }, Enum.EasingStyle.Quad)
        task.wait(math.max(delayPerStep - (i > 1 and 0.12 or 0), 0.05))
    end

    task.wait(0.15)
    pctConn:Disconnect()

    -- Return a handle. CreateWindow calls :Finish() together with its own open
    -- animation, so the loading screen crossfades straight into the UI.
    return {
        Finish = function()
            if finished then return end
            finished = true
            breathe:Cancel()
            CenterScale.Scale = 1
            Tween(CenterScale, 0.45, { Scale = 1.12 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            Tween(Bg, 0.5, { BackgroundTransparency = 1 })
            MarkFade(0.4, 1)
            if MarkStroke then Tween(MarkStroke, 0.4, { Transparency = 1 }) end
            Tween(Word, 0.35, { TextTransparency = 1 })
            Tween(Status, 0.35, { TextTransparency = 1 })
            Tween(Percent, 0.35, { TextTransparency = 1 })
            Tween(Build, 0.35, { TextTransparency = 1 })
            Tween(BarBg, 0.35, { BackgroundTransparency = 1 })
            Tween(BarFill, 0.35, { BackgroundTransparency = 1 })
            task.wait(0.55)
            shimmer:Cancel()
            LoadGui:Destroy()
        end,
    }
end

--==================================================================
-- GLOBAL DROPDOWN OVERLAY
--==================================================================
local GlobalDropdown = New("Frame", {
    Size = UDim2.fromOffset(130, 0),
    BackgroundColor3 = CurrentTheme.Card,
    BorderSizePixel = 0,
    ZIndex = 100,
    Visible = false,
    ClipsDescendants = true,
    Parent = Screen,
})
Corner(GlobalDropdown, 5)
local DropStroke = Stroke(GlobalDropdown, CurrentTheme.BorderHover)

local DropSearch = New("TextBox", {
    Name = "DropSearch",
    Size = UDim2.new(1, -8, 0, 24),
    Position = UDim2.fromOffset(4, 4),
    BackgroundColor3 = CurrentTheme.Bg,
    BorderSizePixel = 0,
    Text = "",
    PlaceholderText = "Search...",
    Font = Enum.Font.Gotham,
    TextSize = 10,
    TextColor3 = CurrentTheme.Text,
    PlaceholderColor3 = CurrentTheme.TextDull,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
    Visible = false,
    ZIndex = 101,
    Parent = GlobalDropdown,
})
Pad(DropSearch, 0, 0, 8, 8)
local DropSearchStroke = Stroke(DropSearch, CurrentTheme.Border)

local DropScroll = New("ScrollingFrame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = CurrentTheme.BorderHover,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ZIndex = 101,
    Parent = GlobalDropdown,
})
New("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = DropScroll })
Pad(DropScroll, 4, 4, 4, 4)

RegisterPaint(function()
    GlobalDropdown.BackgroundColor3 = CurrentTheme.Card
    DropStroke.Color = CurrentTheme.BorderHover
    DropScroll.ScrollBarImageColor3 = CurrentTheme.BorderHover
    DropSearch.BackgroundColor3 = CurrentTheme.Bg
    DropSearch.TextColor3 = CurrentTheme.Text
    DropSearch.PlaceholderColor3 = CurrentTheme.TextDull
    DropSearchStroke.Color = CurrentTheme.Border
end)

local CurrentDropdown = nil   -- handle table { Button, Hovered, OnClose }
local OverDropdown = false
GlobalDropdown.MouseEnter:Connect(function() OverDropdown = true end)
GlobalDropdown.MouseLeave:Connect(function() OverDropdown = false end)

local function CloseDropdown()
    if not CurrentDropdown then return end
    local owner = CurrentDropdown
    CurrentDropdown = nil
    OverDropdown = false
    DropSearch.Text = ""
    DropSearch.Visible = false
    if owner.OnClose then pcall(owner.OnClose) end
    Tween(GlobalDropdown, 0.18, { Size = UDim2.fromOffset(GlobalDropdown.Size.X.Offset, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    task.delay(0.19, function()
        if not CurrentDropdown then GlobalDropdown.Visible = false end
    end)
end

UserInputService.InputBegan:Connect(function(input)
    if not CurrentDropdown then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if not OverDropdown and not CurrentDropdown.Hovered then
            CloseDropdown()
        end
    end
end)

-- Global color picker overlay
local GlobalColorPicker = New("Frame", {
    Size = UDim2.fromOffset(220, 0),
    BackgroundColor3 = CurrentTheme.Card,
    BorderSizePixel = 0,
    ZIndex = 110,
    Visible = false,
    ClipsDescendants = true,
    Parent = Screen,
})
local ColorPickerStroke = Stroke(GlobalColorPicker, CurrentTheme.BorderHover)
local CurrentColorPicker = nil
local OverColorPicker = false
GlobalColorPicker.MouseEnter:Connect(function() OverColorPicker = true end)
GlobalColorPicker.MouseLeave:Connect(function() OverColorPicker = false end)

RegisterPaint(function()
    GlobalColorPicker.BackgroundColor3 = CurrentTheme.Card
    ColorPickerStroke.Color = CurrentTheme.BorderHover
end)

local function CloseColorPicker()
    if not CurrentColorPicker then return end
    local owner = CurrentColorPicker
    CurrentColorPicker = nil
    OverColorPicker = false
    if owner.OnClose then pcall(owner.OnClose) end
    Tween(GlobalColorPicker, 0.18, { Size = UDim2.fromOffset(GlobalColorPicker.Size.X.Offset, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    task.delay(0.19, function()
        if not CurrentColorPicker then
            GlobalColorPicker.Visible = false
            for _, ch in ipairs(GlobalColorPicker:GetChildren()) do
                if not ch:IsA("UIStroke") then ch:Destroy() end
            end
        end
    end)
end

UserInputService.InputBegan:Connect(function(input)
    if not CurrentColorPicker then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if not OverColorPicker and not CurrentColorPicker.Hovered then
            CloseColorPicker()
        end
    end
end)

--==================================================================
-- NOTIFICATIONS
--==================================================================
local NotifyHolder = nil
local NotifyCount = 0

local function GetNotifyHolder()
    if NotifyHolder and NotifyHolder.Parent then return NotifyHolder end
    NotifyHolder = New("Frame", {
        Name = "NotifyHolder",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -16, 1, -16),
        Size = UDim2.new(0, 280, 1, -32),
        BackgroundTransparency = 1,
        ZIndex = 200,
        Parent = Screen,
    })
    New("UIListLayout", {
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = NotifyHolder,
    })
    return NotifyHolder
end

function Kami:Notify(cfg)
    cfg = cfg or {}
    local T = CurrentTheme
    local nTitle = cfg.Title or "Notification"
    local nDesc = cfg.Content or ""
    local nDur = cfg.Duration or 3
    local actionBtn = cfg.Button

    NotifyCount = NotifyCount + 1
    local holder = GetNotifyHolder()

    local slot = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        LayoutOrder = NotifyCount,
        Parent = holder,
    })

    local card = New("Frame", {
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.new(1, 40, 0, 0),
        BackgroundColor3 = T.Card,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = slot,
    })
    Corner(card, 6)
    Stroke(card, T.Border)

    -- top highlight (subtle bevel)
    New("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.92,
        BorderSizePixel = 0,
        Parent = card,
    })

    -- left accent line (subtle vertical gradient)
    local nAccent = New("Frame", {
        Size = UDim2.new(0, 2, 1, -16),
        Position = UDim2.fromOffset(0, 8),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Parent = card,
    })
    AddGradient(nAccent, ColorSequence.new({
        ColorSequenceKeypoint.new(0, T.AccentMuted),
        ColorSequenceKeypoint.new(0.5, T.Accent),
        ColorSequenceKeypoint.new(1, T.AccentMuted),
    }), 90)

    local body = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = card,
    })
    Pad(body, 10, 12, 14, 12)
    New("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = body })

    local top = New("Frame", {
        Size = UDim2.new(1, 0, 0, 14),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Parent = body,
    })
    New("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        BackgroundTransparency = 1,
        Text = Spaced(nTitle),
        Font = Enum.Font.GothamMedium,
        TextSize = 9,
        TextColor3 = T.Accent,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = top,
    })
    local closeX = New("TextButton", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.fromOffset(14, 14),
        BackgroundTransparency = 1,
        Text = "×",
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = T.TextDull,
        Parent = top,
    })

    if nDesc ~= "" then
        New("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Text = nDesc,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextColor3 = T.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            LayoutOrder = 2,
            Parent = body,
        })
    end

    local closed = false
    local sizeConn

    local function Dismiss()
        if closed then return end
        closed = true
        if sizeConn then sizeConn:Disconnect() end
        Tween(card, 0.3, { Position = UDim2.new(1, 40, 0, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        task.delay(0.3, function()
            Tween(slot, 0.2, { Size = UDim2.new(1, 0, 0, 0) })
            task.delay(0.22, function() slot:Destroy() end)
        end)
    end

    if actionBtn then
        local act = New("TextButton", {
            Size = UDim2.new(1, 0, 0, 24),
            BackgroundColor3 = T.Bg,
            BorderSizePixel = 0,
            Text = actionBtn.Text or "Open",
            Font = Enum.Font.GothamMedium,
            TextSize = 10,
            TextColor3 = T.Text,
            AutoButtonColor = false,
            ClipsDescendants = true,
            LayoutOrder = 3,
            Parent = body,
        })
        Corner(act, 4)
        local aStroke = Stroke(act, T.BorderHover)
        act.MouseEnter:Connect(function()
            Tween(act, 0.15, { BackgroundColor3 = CurrentTheme.Accent, TextColor3 = CurrentTheme.Bg })
            Tween(aStroke, 0.15, { Color = CurrentTheme.Accent })
        end)
        act.MouseLeave:Connect(function()
            Tween(act, 0.15, { BackgroundColor3 = CurrentTheme.Bg, TextColor3 = CurrentTheme.Text })
            Tween(aStroke, 0.15, { Color = CurrentTheme.BorderHover })
        end)
        act.MouseButton1Click:Connect(function()
            Ripple(act); Press(act)
            if actionBtn.Callback then task.spawn(actionBtn.Callback) end
            if actionBtn.CloseOnClick ~= false then task.delay(0.15, Dismiss) end
        end)
    end

    -- timer bar
    local timer = New("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 2),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.55,
        BorderSizePixel = 0,
        Parent = card,
    })
    AddGradient(timer, ColorSequence.new({
        ColorSequenceKeypoint.new(0, T.AccentMuted),
        ColorSequenceKeypoint.new(1, T.Accent),
    }))

    local function Fit()
        if closed then return end
        slot.Size = UDim2.new(1, 0, 0, body.AbsoluteSize.Y)
    end
    sizeConn = body:GetPropertyChangedSignal("AbsoluteSize"):Connect(Fit)
    Fit()

    task.defer(function()
        Fit()
        Tween(card, 0.45, { Position = UDim2.new(0, 0, 0, 0) })
        Tween(timer, nDur, { Size = UDim2.new(0, 0, 0, 2) }, Enum.EasingStyle.Linear)
    end)

    closeX.MouseEnter:Connect(function() Tween(closeX, 0.15, { TextColor3 = CurrentTheme.Text }) end)
    closeX.MouseLeave:Connect(function() Tween(closeX, 0.15, { TextColor3 = CurrentTheme.TextDull }) end)
    closeX.MouseButton1Click:Connect(Dismiss)

    task.delay(nDur + 0.45, Dismiss)

    return { Dismiss = Dismiss }
end

--==================================================================
-- WINDOW
--==================================================================
function Kami:CreateWindow(cfg)
    cfg = cfg or {}
    local winName = cfg.Name or "KAMI"
    local winSub = cfg.SubTitle or "menu"
    local winSize, isCompact = FitWindowSize(cfg.Size or UDim2.fromOffset(620, 430))
    local minKey = cfg.MinimizeKey or Enum.KeyCode.RightControl
    local destroyed = false
    local connections = {}

    local function Bind(signal, fn)
        local conn = signal:Connect(fn)
        table.insert(connections, conn)
        return conn
    end

    if cfg.Theme and Themes[cfg.Theme] then ApplyTheme(cfg.Theme) end

    local loadingHandle = nil
    if cfg.Loading and cfg.Loading.Enabled ~= false then
        loadingHandle = Kami:ShowLoadingScreen(cfg.Loading)
    end

    local Window = {
        Tabs = {},
        CurrentTab = nil,
        Flags = {},
        ActiveConfig = "default",
        ToggleKey = minKey,
        AutoLoad = false,
        Visible = true,
        _Silent = false,
        Compact = isCompact,
    }

    -- Read auto-load state
    pcall(function()
        if isfile and readfile and isfile(AUTO_LOAD_FILE) then
            local raw = HttpService:JSONDecode(readfile(AUTO_LOAD_FILE))
            if type(raw) == "table" then
                Window.AutoLoad = raw.Enabled == true
                if type(raw.Config) == "string" and raw.Config ~= "" then
                    Window.ActiveConfig = raw.Config
                end
            end
        end
    end)

    -- Holder (scaled / dragged) -> Glow + Shadow + MainFrame
    local Holder = New("Frame", {
        Name = "Kami_Holder",
        Size = winSize,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundTransparency = 1,
        Parent = Screen,
    })
    local HolderScale = New("UIScale", { Scale = 0.94, Parent = Holder })

    -- Keep the window fully on-screen (used on collapse/expand and while dragging)
    local function ScreenVec()
        local vs = Screen.AbsoluteSize
        if vs.X <= 0 or vs.Y <= 0 then
            local cam = workspace.CurrentCamera
            vs = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
        end
        return vs
    end

    local function ClampCenter(cx, cy, size)
        local vs = ScreenVec()
        local halfW, halfH = size.X / 2, size.Y / 2
        if vs.X - halfW >= halfW then cx = math.clamp(cx, halfW, vs.X - halfW) else cx = vs.X / 2 end
        if vs.Y - halfH >= halfH then cy = math.clamp(cy, halfH, vs.Y - halfH) else cy = vs.Y / 2 end
        return cx, cy
    end

    local function ClampHolderPosition(targetSize)
        local vs = ScreenVec()
        local sz = Holder.AbsoluteSize
        if targetSize then
            sz = Vector2.new(targetSize.X.Scale * vs.X + targetSize.X.Offset, targetSize.Y.Scale * vs.Y + targetSize.Y.Offset)
        end
        local pos = Holder.Position
        local nx, ny = ClampCenter(pos.X.Scale * vs.X + pos.X.Offset, pos.Y.Scale * vs.Y + pos.Y.Offset, sz)
        return UDim2.fromOffset(nx, ny)
    end

    local Shadow = New("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 48, 1, 48),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = 0,
        Parent = Holder,
    })

    local MainFrame = New("Frame", {
        Name = "Kami_Main",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = CurrentTheme.Bg,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 1,
        Parent = Holder,
    })
    Corner(MainFrame, 8)
    local MainStroke = Stroke(MainFrame, CurrentTheme.Border)
    -- Animated gradient rim (rotates forever) peeking out behind the window
    local BorderSpin, BorderSpinGrad = SpawnSpinBorder(Holder, 1, 0, 6)

    -- Fade veil (gives the window a "fade" without CanvasGroup)
    local Veil = New("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = CurrentTheme.Bg,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ZIndex = 60,
        Parent = MainFrame,
    })
    Corner(Veil, 8)

    RegisterPaint(function()
        MainFrame.BackgroundColor3 = CurrentTheme.Bg
        MainStroke.Color = CurrentTheme.Border
        Veil.BackgroundColor3 = CurrentTheme.Bg
        BorderSpinGrad.Color = SpinSeq()
    end)

    --================ HEADER ================
    local HEADER_H = 40
    local Header = New("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, HEADER_H),
        BackgroundColor3 = CurrentTheme.Sidebar,
        BorderSizePixel = 0,
        Parent = MainFrame,
    })

    local HeaderLine = New("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = CurrentTheme.Border,
        BorderSizePixel = 0,
        Parent = Header,
    })

    -- Moving accent glint sweeping along the header underline
    local HeaderGlint = New("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = Header,
    })
    local HeaderGlintGrad = AddGradient(HeaderGlint, ColorSequence.new(CurrentTheme.Accent))
    HeaderGlintGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1),
    })
    HeaderGlintGrad.Offset = Vector2.new(-1, 0)
    TweenService:Create(
        HeaderGlintGrad,
        TweenInfo.new(3.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        { Offset = Vector2.new(1, 0) }
    ):Play()

    -- Accent bar (replaces K logo mark)
    local AccentBar = New("Frame", {
        Size = UDim2.new(0, 2, 1, -16),
        Position = UDim2.fromOffset(12, 8),
        BackgroundColor3 = CurrentTheme.Accent,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = Header,
    })
    -- gradient flowing vertically down the accent bar
    local AccentBarGrad = AddGradient(AccentBar, ColorSequence.new({
        ColorSequenceKeypoint.new(0, CurrentTheme.AccentMuted),
        ColorSequenceKeypoint.new(0.5, CurrentTheme.Accent),
        ColorSequenceKeypoint.new(1, CurrentTheme.AccentMuted),
    }), 90)
    AccentBarGrad.Offset = Vector2.new(0, -1)
    TweenService:Create(
        AccentBarGrad,
        TweenInfo.new(2.6, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        { Offset = Vector2.new(0, 1) }
    ):Play()

    local TitleName = New("TextLabel", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 24, 0.5, 0),
        Size = UDim2.fromOffset(0, 18),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Text = winName:upper(),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = CurrentTheme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Header,
    })

    local TitleSub = New("TextLabel", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 24, 0.5, 0),
        Size = UDim2.fromOffset(0, 18),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Text = "/  " .. winSub,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = CurrentTheme.TextDull,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Header,
    })

    local function LayoutTitle()
        TitleSub.Position = UDim2.new(0, 24 + TitleName.TextBounds.X + 8, 0.5, 0)
    end
    TitleName:GetPropertyChangedSignal("TextBounds"):Connect(LayoutTitle)
    LayoutTitle()

    -- Right controls cluster: Crumb · Min · Close
    local RightCluster = New("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(0, 22),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Parent = Header,
    })
    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = RightCluster,
    })

    local Crumb = New("TextLabel", {
        Size = UDim2.fromOffset(0, 22),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Text = "",
        Font = Enum.Font.GothamMedium,
        TextSize = 10,
        TextColor3 = CurrentTheme.TextDull,
        TextXAlignment = Enum.TextXAlignment.Right,
        LayoutOrder = 1,
        Parent = RightCluster,
    })

    local function HeaderBtn(txt, size, order)
        local b = New("TextButton", {
            Size = UDim2.fromOffset(26, 22),
            BackgroundColor3 = CurrentTheme.CardHover,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = txt,
            Font = Enum.Font.Gotham,
            TextSize = size or 12,
            TextColor3 = CurrentTheme.TextMuted,
            AutoButtonColor = false,
            LayoutOrder = order,
            Parent = RightCluster,
        })
        b.MouseEnter:Connect(function()
            Tween(b, 0.15, { BackgroundTransparency = 0, TextColor3 = CurrentTheme.Text })
        end)
        b.MouseLeave:Connect(function()
            Tween(b, 0.15, { BackgroundTransparency = 1, TextColor3 = CurrentTheme.TextMuted })
        end)
        RegisterPaint(function()
            b.BackgroundColor3 = CurrentTheme.CardHover
            b.TextColor3 = CurrentTheme.TextMuted
        end)
        return b
    end

    local MinBtn = HeaderBtn("—", 10, 2)
    local CloseBtn = HeaderBtn("×", 15, 3)

    RegisterPaint(function()
        Header.BackgroundColor3 = CurrentTheme.Sidebar
        HeaderLine.BackgroundColor3 = CurrentTheme.Border
        AccentBar.BackgroundColor3 = CurrentTheme.Accent
        HeaderGlintGrad.Color = ColorSequence.new(CurrentTheme.Accent)
        AccentBarGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, CurrentTheme.AccentMuted),
            ColorSequenceKeypoint.new(0.5, CurrentTheme.Accent),
            ColorSequenceKeypoint.new(1, CurrentTheme.AccentMuted),
        })
        TitleName.TextColor3 = CurrentTheme.Text
        TitleSub.TextColor3 = CurrentTheme.TextDull
        Crumb.TextColor3 = CurrentTheme.TextDull
        TitleName.Text = winName:upper()
        TitleSub.Text = "/  " .. winSub
        LayoutTitle()
    end)

    --================ VISIBILITY / COLLAPSE ================
    local MobileBtn -- forward

    function Window:SetVisible(v)
        if destroyed then return end
        v = v and true or false
        if v == Window.Visible then return end
        Window.Visible = v
        CloseDropdown()
        CloseColorPicker()
        if v then
            Holder.Visible = true
            Veil.Visible = true
            Veil.BackgroundTransparency = 0
            HolderScale.Scale = 0.94
            Tween(HolderScale, 0.4, { Scale = 1 }, Enum.EasingStyle.Back)
            Tween(Shadow, 0.4, { ImageTransparency = 0.45 })
            Tween(Veil, 0.35, { BackgroundTransparency = 1 })
            task.delay(0.36, function() if Window.Visible then Veil.Visible = false end end)
        else
            Veil.Visible = true
            Tween(Veil, 0.16, { BackgroundTransparency = 0 })
            Tween(HolderScale, 0.22, { Scale = 0.94 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            Tween(Shadow, 0.2, { ImageTransparency = 1 })
            task.delay(0.22, function() if not Window.Visible then Holder.Visible = false end end)
        end
    end

    function Window:Toggle() Window:SetVisible(not Window.Visible) end

    -- Sidebar footer parts (filled in after the sidebar is built). When the
    -- window is collapsed, their bottom-anchored positions would flip up into
    -- the header strip, so we hide them while collapsed.
    local SidebarFooterParts = {}
    local function ShowSidebarFooter(v)
        for _, ob in ipairs(SidebarFooterParts) do ob.Visible = v end
    end

    local collapsed = false
    function Window:SetCollapsed(state)
        collapsed = state and true or false
        CloseDropdown()
        CloseColorPicker()
        ShowSidebarFooter(not collapsed)
        local target = collapsed and UDim2.new(winSize.X.Scale, winSize.X.Offset, 0, HEADER_H) or winSize
        -- Re-clamp so expanding near a screen edge can never push the window off-screen
        Tween(Holder, 0.45, { Size = target, Position = ClampHolderPosition(target) })
        MinBtn.Text = collapsed and "+" or "—"
        MinBtn.TextSize = collapsed and 14 or 10
    end

    MinBtn.MouseButton1Click:Connect(function()
        Press(MinBtn)
        Window:SetCollapsed(not collapsed)
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        Window:SetVisible(false)
        Kami:Notify({
            Title = "Interface Hidden",
            Content = "Press " .. Window.ToggleKey.Name .. " to bring the menu back.",
            Duration = 3,
        })
    end)

    Bind(UserInputService.InputBegan, function(inp, proc)
        if destroyed or proc or BindingActive then return end
        if inp.KeyCode == Window.ToggleKey then Window:Toggle() end
    end)

    -- Open animation
    task.defer(function()
        Tween(HolderScale, 0.5, { Scale = 1 }, Enum.EasingStyle.Back)
        Tween(Shadow, 0.5, { ImageTransparency = 0.45 })
        Tween(Veil, 0.45, { BackgroundTransparency = 1 })
        task.delay(0.46, function() if Window.Visible then Veil.Visible = false end end)
        -- crossfade the loading screen into the freshly opened UI
        if loadingHandle and loadingHandle.Finish then
            task.spawn(loadingHandle.Finish)
        end
    end)

    --================ DRAG ================
    do
        local dragging, dragStart, startPos = false, nil, nil
        Header.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = inp.Position
                startPos = Holder.Position
                CloseDropdown()
            end
        end)
        UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                local vs = ScreenVec()
                local d = inp.Position - dragStart
                local baseX = startPos.X.Scale * vs.X + startPos.X.Offset
                local baseY = startPos.Y.Scale * vs.Y + startPos.Y.Offset
                local nx, ny = ClampCenter(baseX + d.X, baseY + d.Y, Holder.AbsoluteSize)
                -- Assign directly (no tween) so dragging stays 1:1 and never lags/queues
                Holder.Position = UDim2.fromOffset(nx, ny)
            end
        end)
    end

    --================ SIDEBAR ================
    local SIDEBAR_W = isCompact and 110 or 150

    local Sidebar = New("Frame", {
        Size = UDim2.new(0, SIDEBAR_W, 1, -HEADER_H),
        Position = UDim2.fromOffset(0, HEADER_H),
        BackgroundColor3 = CurrentTheme.Sidebar,
        BorderSizePixel = 0,
        Parent = MainFrame,
    })

    local SidebarBorder = New("Frame", {
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, -1, 0, 0),
        BackgroundColor3 = CurrentTheme.Border,
        BorderSizePixel = 0,
        Parent = Sidebar,
    })

    local NavLabel = New("TextLabel", {
        Position = UDim2.fromOffset(16, 10),
        Size = UDim2.new(1, -32, 0, 12),
        BackgroundTransparency = 1,
        Text = "N A V I G A T I O N",
        Font = Enum.Font.GothamMedium,
        TextSize = 8,
        TextColor3 = CurrentTheme.TextDull,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Sidebar,
    })

    local NavScroll = New("ScrollingFrame", {
        Position = UDim2.fromOffset(0, 26),
        Size = UDim2.new(1, 0, 1, -60),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = Sidebar,
    })
    New("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder, Parent = NavScroll })
    Pad(NavScroll, 2, 4, 8, 9)

    -- Footer: pulsing status dot + version
    local FooterLine = New("Frame", {
        Position = UDim2.new(0, 12, 1, -34),
        Size = UDim2.new(1, -25, 0, 1),
        BackgroundColor3 = CurrentTheme.Border,
        BorderSizePixel = 0,
        Parent = Sidebar,
    })
    local StatusDot = New("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 16, 1, -17),
        Size = UDim2.fromOffset(5, 5),
        BackgroundColor3 = CurrentTheme.Accent,
        BorderSizePixel = 0,
        Parent = Sidebar,
    })
    Corner(StatusDot, 999)
    TweenService:Create(StatusDot, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { BackgroundTransparency = 0.75 }):Play()

    local Footer = New("TextLabel", {
        Position = UDim2.new(0, 28, 1, -26),
        Size = UDim2.new(1, -40, 0, 18),
        BackgroundTransparency = 1,
        Text = "KAMI  ·  v" .. Kami.Version,
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextColor3 = CurrentTheme.TextDull,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Sidebar,
    })
    SidebarFooterParts[1] = FooterLine
    SidebarFooterParts[2] = StatusDot
    SidebarFooterParts[3] = Footer

    RegisterPaint(function()
        Sidebar.BackgroundColor3 = CurrentTheme.Sidebar
        SidebarBorder.BackgroundColor3 = CurrentTheme.Border
        NavLabel.TextColor3 = CurrentTheme.TextDull
        FooterLine.BackgroundColor3 = CurrentTheme.Border
        StatusDot.BackgroundColor3 = CurrentTheme.Accent
        Footer.TextColor3 = CurrentTheme.TextDull
    end)

    local ContentHolder = New("Frame", {
        Size = UDim2.new(1, -SIDEBAR_W, 1, -HEADER_H),
        Position = UDim2.fromOffset(SIDEBAR_W, HEADER_H),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = MainFrame,
    })

    --================ MOBILE FLOATING BUTTON ================
    if UserInputService.TouchEnabled then
        MobileBtn = New("TextButton", {
            Position = UDim2.fromOffset(20, 80),
            Size = UDim2.fromOffset(40, 40),
            BackgroundColor3 = CurrentTheme.Card,
            BorderSizePixel = 0,
            Text = "K",
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            TextColor3 = CurrentTheme.Accent,
            AutoButtonColor = false,
            ZIndex = 150,
            Parent = Screen,
        })
        Corner(MobileBtn, 10)
        local mbStroke = Stroke(MobileBtn, CurrentTheme.BorderHover)
        RegisterPaint(function()
            MobileBtn.BackgroundColor3 = CurrentTheme.Card
            MobileBtn.TextColor3 = CurrentTheme.Accent
            mbStroke.Color = CurrentTheme.BorderHover
        end)

        local mDrag, mStart, mPos, moved = false, nil, nil, false
        MobileBtn.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
                mDrag, moved, mStart, mPos = true, false, inp.Position, MobileBtn.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if mDrag and (inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseMovement) then
                local d = inp.Position - mStart
                if d.Magnitude > 6 then moved = true end
                MobileBtn.Position = UDim2.new(mPos.X.Scale, mPos.X.Offset + d.X, mPos.Y.Scale, mPos.Y.Offset + d.Y)
            end
        end)
        MobileBtn.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
                mDrag = false
                if not moved then Press(MobileBtn); Window:Toggle() end
            end
        end)
    end

    --================ CONFIG SYSTEM ================
    local function SanitizeName(n)
        n = tostring(n or ""):gsub("[^%w%-%_ ]", "")
        if n == "" then n = "default" end
        return n
    end

    local function GetConfigList()
        local list = {}
        pcall(function()
            if not listfiles or not isfolder then return end
            if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
            for _, f in ipairs(listfiles(CONFIG_FOLDER)) do
                local clean = f:match("([^/\\]+)%.json$")
                if clean then table.insert(list, clean) end
            end
        end)
        if #list == 0 then table.insert(list, "default") end
        table.sort(list)
        return list
    end
    Window.GetConfigList = GetConfigList

    local function Encode(v)
        if typeof(v) == "EnumItem" then
            return { __enum = tostring(v.EnumType), name = v.Name }
        elseif typeof(v) == "Color3" then
            return { __color = true, r = v.R, g = v.G, b = v.B }
        end
        return v
    end

    local function Decode(v)
        if type(v) == "table" then
            if v.__enum and v.name then
                local ok, item = pcall(function() return Enum[v.__enum][v.name] end)
                if ok then return item end
                return nil
            elseif v.__color then
                return Color3.new(v.r or 0, v.g or 0, v.b or 0)
            end
        end
        return v
    end

    function Window:SaveConfig(name)
        if not writefile then return false end
        name = SanitizeName(name or Window.ActiveConfig)
        local ok = pcall(function()
            if isfolder and makefolder and not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
            local data = {}
            for flag, item in pairs(Window.Flags) do
                data[flag] = Encode(item.Value)
            end
            writefile(CONFIG_FOLDER .. "/" .. name .. ".json", HttpService:JSONEncode(data))
        end)
        if ok then Window.ActiveConfig = name end
        return ok
    end

    function Window:LoadConfig(name)
        if not readfile or not isfile then return false end
        name = SanitizeName(name or Window.ActiveConfig)
        local path = CONFIG_FOLDER .. "/" .. name .. ".json"
        local okExists, exists = pcall(isfile, path)
        if not okExists or not exists then return false end
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
        if not ok or type(data) ~= "table" then return false end
        Window._Silent = true
        for flag, val in pairs(data) do
            local item = Window.Flags[flag]
            local decoded = Decode(val)
            if item and item.Set and decoded ~= nil then
                pcall(function() item:Set(decoded) end)
            end
        end
        Window._Silent = false
        Window.ActiveConfig = name
        return true
    end

    function Window:DeleteConfig(name)
        if not delfile or not isfile then return false end
        local path = CONFIG_FOLDER .. "/" .. SanitizeName(name) .. ".json"
        local ok, res = pcall(function()
            if isfile(path) then delfile(path) return true end
            return false
        end)
        return ok and res
    end

    local function WriteAutoLoad()
        if not writefile then return end
        pcall(function()
            writefile(AUTO_LOAD_FILE, HttpService:JSONEncode({ Enabled = Window.AutoLoad, Config = Window.ActiveConfig }))
        end)
    end

    --================ TABS ================
    function Window:AddTab(opt)
        opt = opt or {}
        local tabTitle = opt.Title or "Tab"
        local tabIcon = ResolveIcon(opt.Icon)
        local scrollable = opt.Scrollable
        if scrollable == nil then scrollable = true end

        local Tab = {}
        local index = #Window.Tabs + 1

        local TabBtn = New("TextButton", {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = CurrentTheme.Card,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = index,
            Parent = NavScroll,
        })
        Corner(TabBtn, 5)
        local TabStroke = Stroke(TabBtn, CurrentTheme.Border, 1, 1)

        local TabIndicator = New("Frame", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(0, 2, 0, 0),
            BackgroundColor3 = CurrentTheme.Accent,
            BorderSizePixel = 0,
            Parent = TabBtn,
        })
        Corner(TabIndicator, 2)
        AddGradient(TabIndicator, ColorSequence.new({
            ColorSequenceKeypoint.new(0, CurrentTheme.AccentMuted),
            ColorSequenceKeypoint.new(1, CurrentTheme.Accent),
        }), 90)

        local textOffset = 14
        local iconImg = nil
        if tabIcon then
            iconImg = New("ImageLabel", {
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.fromOffset(14, 14),
                Position = UDim2.new(0, 12, 0.5, 0),
                BackgroundTransparency = 1,
                Image = tabIcon,
                ImageColor3 = CurrentTheme.TextMuted,
                Parent = TabBtn,
            })
            textOffset = 34
        end

        local TabLbl = New("TextLabel", {
            Size = UDim2.new(1, -textOffset, 1, 0),
            Position = UDim2.fromOffset(textOffset, 0),
            BackgroundTransparency = 1,
            Text = tabTitle,
            Font = Enum.Font.GothamMedium,
            TextSize = 11,
            TextColor3 = CurrentTheme.TextMuted,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = TabBtn,
        })

        local Page = New("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = scrollable and 2 or 0,
            ScrollingEnabled = scrollable,
            ScrollBarImageColor3 = CurrentTheme.BorderHover,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = scrollable and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
            Visible = false,
            Parent = ContentHolder,
        })
        New("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Page })
        Pad(Page, 16, 16, 16, 16)

        Page:GetPropertyChangedSignal("CanvasPosition"):Connect(CloseDropdown)

        local isActive = false
        local orderCounter = 0
        local function NextOrder()
            orderCounter = orderCounter + 1
            return orderCounter
        end

        local function Deactivate()
            isActive = false
            Page.Visible = false
            Tween(TabIndicator, 0.25, { Size = UDim2.new(0, 2, 0, 0) })
            Tween(TabBtn, 0.25, { BackgroundTransparency = 1 })
            Tween(TabStroke, 0.25, { Transparency = 1 })
            Tween(TabLbl, 0.25, { TextColor3 = CurrentTheme.TextMuted, Position = UDim2.fromOffset(textOffset, 0) })
            if iconImg then Tween(iconImg, 0.25, { ImageColor3 = CurrentTheme.TextMuted }) end
        end

        local function SetActive()
            if isActive then return end
            CloseDropdown()
            for _, t in ipairs(Window.Tabs) do
                if t.Tab ~= Tab then t.Deactivate() end
            end
            isActive = true
            Window.CurrentTab = Tab

            Page.Visible = true
            Page.CanvasPosition = Vector2.new(0, 0)
            Page.Position = UDim2.fromOffset(0, 16)
            Tween(Page, 0.45, { Position = UDim2.fromOffset(0, 0) })

            Tween(TabIndicator, 0.4, { Size = UDim2.new(0, 2, 0, 16) }, Enum.EasingStyle.Back)
            Tween(TabBtn, 0.25, { BackgroundTransparency = 0 })
            Tween(TabStroke, 0.25, { Transparency = 0 })
            Tween(TabLbl, 0.3, { TextColor3 = CurrentTheme.Text, Position = UDim2.fromOffset(textOffset + 3, 0) })
            if iconImg then Tween(iconImg, 0.3, { ImageColor3 = CurrentTheme.Accent }) end

            Crumb.TextTransparency = 1
            Crumb.Text = tabTitle:upper()
            Tween(Crumb, 0.3, { TextTransparency = 0 })
        end

        TabBtn.MouseEnter:Connect(function()
            if isActive then return end
            Tween(TabBtn, 0.18, { BackgroundTransparency = 0.5 })
            Tween(TabLbl, 0.18, { TextColor3 = CurrentTheme.Text })
        end)
        TabBtn.MouseLeave:Connect(function()
            if isActive then return end
            Tween(TabBtn, 0.18, { BackgroundTransparency = 1 })
            Tween(TabLbl, 0.18, { TextColor3 = CurrentTheme.TextMuted })
        end)
        TabBtn.MouseButton1Click:Connect(SetActive)

        table.insert(Window.Tabs, {
            Tab = Tab, Button = TabBtn, Label = TabLbl, Indicator = TabIndicator,
            Page = Page, Icon = iconImg, Deactivate = Deactivate, Activate = SetActive,
        })
        Tab.Select = SetActive
        if #Window.Tabs == 1 then SetActive() end

        RegisterPaint(function()
            TabBtn.BackgroundColor3 = CurrentTheme.Card
            TabStroke.Color = CurrentTheme.Border
            TabIndicator.BackgroundColor3 = CurrentTheme.Accent
            Page.ScrollBarImageColor3 = CurrentTheme.BorderHover
            if isActive then
                TabLbl.TextColor3 = CurrentTheme.Text
                if iconImg then iconImg.ImageColor3 = CurrentTheme.Accent end
            else
                TabLbl.TextColor3 = CurrentTheme.TextMuted
                if iconImg then iconImg.ImageColor3 = CurrentTheme.TextMuted end
            end
        end)

        ------------------------------------------------------------
        -- Shared element builders
        ------------------------------------------------------------
        local function CreateRow(h)
            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, h or 44),
                BackgroundColor3 = CurrentTheme.Card,
                BorderSizePixel = 0,
                LayoutOrder = NextOrder(),
                Parent = Page,
            })
            Corner(row, 5)
            local st = Stroke(row, CurrentTheme.Border)

            -- full-height left accent rail with soft faded ends (elegant, not a floating tick)
            local rowAccent = New("Frame", {
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(0, 2, 1, 0),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                Parent = row,
            })
            local rowAccentGrad = AddGradient(rowAccent, ColorSequence.new({
                ColorSequenceKeypoint.new(0, CurrentTheme.AccentMuted),
                ColorSequenceKeypoint.new(1, CurrentTheme.Accent),
            }), 90)
            rowAccentGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.55),
                NumberSequenceKeypoint.new(0.5, 0.05),
                NumberSequenceKeypoint.new(1, 0.55),
            })

            RegisterPaint(function()
                row.BackgroundColor3 = CurrentTheme.Card
                st.Color = CurrentTheme.Border
                rowAccentGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, CurrentTheme.AccentMuted),
                    ColorSequenceKeypoint.new(1, CurrentTheme.Accent),
                })
            end)

            row.MouseEnter:Connect(function()
                Tween(st, 0.2, { Color = CurrentTheme.BorderHover })
                Tween(row, 0.2, { BackgroundColor3 = CurrentTheme.CardHover })
                Tween(rowAccentGrad, 0.25, { Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.15),
                    NumberSequenceKeypoint.new(0.5, 0),
                    NumberSequenceKeypoint.new(1, 0.15),
                }) })
            end)
            row.MouseLeave:Connect(function()
                Tween(st, 0.2, { Color = CurrentTheme.Border })
                Tween(row, 0.2, { BackgroundColor3 = CurrentTheme.Card })
                Tween(rowAccentGrad, 0.25, { Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.55),
                    NumberSequenceKeypoint.new(0.5, 0.05),
                    NumberSequenceKeypoint.new(1, 0.55),
                }) })
            end)

            return row, st
        end

        local function AddHeaderLabels(row, title, desc, rightSpace)
            rightSpace = rightSpace or 160
            local hasDesc = desc and desc ~= ""
            local t = New("TextLabel", {
                Position = UDim2.fromOffset(14, hasDesc and 7 or 0),
                Size = UDim2.new(1, -rightSpace, 0, hasDesc and 16 or row.Size.Y.Offset),
                BackgroundTransparency = 1,
                Text = title or "",
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = CurrentTheme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = row,
            })

            local d = nil
            if hasDesc then
                d = New("TextLabel", {
                    Position = UDim2.fromOffset(14, 23),
                    Size = UDim2.new(1, -rightSpace, 0, 14),
                    BackgroundTransparency = 1,
                    Text = desc,
                    Font = Enum.Font.Gotham,
                    TextSize = 10,
                    TextColor3 = CurrentTheme.TextMuted,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Parent = row,
                })
            end

            RegisterPaint(function()
                t.TextColor3 = CurrentTheme.Text
                if d then d.TextColor3 = CurrentTheme.TextMuted end
            end)
            return t, d
        end

        ------------------------------------------------------------
        -- Profile Card
        ------------------------------------------------------------
        function Tab:AddProfileCard(c)
            c = c or {}
            local card = New("Frame", {
                Size = UDim2.new(1, 0, 0, 72),
                BackgroundColor3 = CurrentTheme.Card,
                BorderSizePixel = 0,
                LayoutOrder = NextOrder(),
                Parent = Page,
            })
            Corner(card, 6)
            local cStroke = Stroke(card, Color3.new(1, 1, 1))
            local cGrad = AddGradient(cStroke, ColorSequence.new({
                ColorSequenceKeypoint.new(0, CurrentTheme.Border),
                ColorSequenceKeypoint.new(0.5, CurrentTheme.AccentMuted),
                ColorSequenceKeypoint.new(1, CurrentTheme.Border),
            }))
            TweenService:Create(cGrad, TweenInfo.new(6, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), { Rotation = 360 }):Play()

            local avatarImg = New("ImageLabel", {
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.fromOffset(46, 46),
                Position = UDim2.new(0, 14, 0.5, 0),
                BackgroundColor3 = CurrentTheme.Bg,
                BorderSizePixel = 0,
                Image = c.Image or "",
                Parent = card,
            })
            Corner(avatarImg, 999)
            local aStroke = Stroke(avatarImg, CurrentTheme.BorderHover, 1.5)

            local dName = New("TextLabel", {
                Position = UDim2.fromOffset(72, 14),
                Size = UDim2.new(1, -200, 0, 16),
                BackgroundTransparency = 1,
                Text = c.DisplayName or "User",
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                TextColor3 = CurrentTheme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = card,
            })

            local uName = New("TextLabel", {
                Position = UDim2.fromOffset(72, 31),
                Size = UDim2.new(1, -200, 0, 13),
                BackgroundTransparency = 1,
                Text = "@" .. (c.Username or "username"),
                Font = Enum.Font.Gotham,
                TextSize = 10,
                TextColor3 = CurrentTheme.TextMuted,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = card,
            })

            local statusSub = New("TextLabel", {
                Position = UDim2.fromOffset(72, 45),
                Size = UDim2.new(1, -200, 0, 13),
                BackgroundTransparency = 1,
                Text = c.Subtitle or "Active Client",
                Font = Enum.Font.Gotham,
                TextSize = 9,
                TextColor3 = CurrentTheme.TextDull,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = card,
            })

            local badge = New("Frame", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -14, 0.5, 0),
                Size = UDim2.fromOffset(0, 24),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = CurrentTheme.Bg,
                BorderSizePixel = 0,
                Parent = card,
            })
            Corner(badge, 999)
            local bStroke = Stroke(badge, CurrentTheme.Border)
            Pad(badge, 0, 0, 10, 12)
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = badge,
            })
            local bDot = New("Frame", {
                Size = UDim2.fromOffset(5, 5),
                BackgroundColor3 = CurrentTheme.Accent,
                BorderSizePixel = 0,
                LayoutOrder = 1,
                Parent = badge,
            })
            Corner(bDot, 999)
            TweenService:Create(bDot, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { BackgroundTransparency = 0.8 }):Play()

            local badgeText = New("TextLabel", {
                Size = UDim2.fromOffset(0, 24),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Text = c.Badge or "ONLINE",
                Font = Enum.Font.GothamMedium,
                TextSize = 9,
                TextColor3 = CurrentTheme.Text,
                LayoutOrder = 2,
                Parent = badge,
            })

            RegisterPaint(function()
                card.BackgroundColor3 = CurrentTheme.Card
                cGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, CurrentTheme.Border),
                    ColorSequenceKeypoint.new(0.5, CurrentTheme.AccentMuted),
                    ColorSequenceKeypoint.new(1, CurrentTheme.Border),
                })
                avatarImg.BackgroundColor3 = CurrentTheme.Bg
                aStroke.Color = CurrentTheme.BorderHover
                dName.TextColor3 = CurrentTheme.Text
                uName.TextColor3 = CurrentTheme.TextMuted
                statusSub.TextColor3 = CurrentTheme.TextDull
                badge.BackgroundColor3 = CurrentTheme.Bg
                bStroke.Color = CurrentTheme.Border
                bDot.BackgroundColor3 = CurrentTheme.Accent
                badgeText.TextColor3 = CurrentTheme.Text
            end)

            local obj = {}
            function obj:SetSubtitle(s) statusSub.Text = tostring(s) end
            function obj:SetBadge(s) badgeText.Text = tostring(s) end
            function obj:SetImage(s) avatarImg.Image = tostring(s) end
            return obj
        end

        ------------------------------------------------------------
        -- Game Card (full-width place info)
        ------------------------------------------------------------
        function Tab:AddGameCard(c)
            c = c or {}
            local card = New("Frame", {
                Size = UDim2.new(1, 0, 0, 64),
                BackgroundColor3 = CurrentTheme.Card,
                BorderSizePixel = 0,
                LayoutOrder = NextOrder(),
                Parent = Page,
            })
            local cStroke = Stroke(card, CurrentTheme.Border)

            local iconImg = New("ImageLabel", {
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.fromOffset(44, 44),
                Position = UDim2.new(0, 12, 0.5, 0),
                BackgroundColor3 = CurrentTheme.Bg,
                BorderSizePixel = 0,
                Image = c.Image or "",
                ScaleType = Enum.ScaleType.Crop,
                Parent = card,
            })
            Stroke(iconImg, CurrentTheme.BorderHover)

            local gName = New("TextLabel", {
                Position = UDim2.fromOffset(68, 14),
                Size = UDim2.new(1, -160, 0, 16),
                BackgroundTransparency = 1,
                Text = c.Name or "Unknown Game",
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                TextColor3 = CurrentTheme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = card,
            })

            local gPlayers = New("TextLabel", {
                Position = UDim2.fromOffset(68, 34),
                Size = UDim2.new(1, -160, 0, 14),
                BackgroundTransparency = 1,
                Text = tostring(c.Players or "0") .. " Players",
                Font = Enum.Font.Gotham,
                TextSize = 10,
                TextColor3 = CurrentTheme.TextMuted,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = card,
            })

            -- Right status pill (live / online)
            local status = New("Frame", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.fromOffset(0, 26),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = CurrentTheme.Bg,
                BorderSizePixel = 0,
                Parent = card,
            })
            local stStroke = Stroke(status, CurrentTheme.Border)
            Pad(status, 0, 0, 10, 12)
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = status,
            })

            local liveColor = Color3.fromRGB(60, 200, 120)
            local liveDot = New("Frame", {
                Size = UDim2.fromOffset(7, 7),
                BackgroundColor3 = liveColor,
                BorderSizePixel = 0,
                LayoutOrder = 1,
                Parent = status,
            })
            TweenService:Create(liveDot, TweenInfo.new(0.85, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                BackgroundTransparency = 0.65,
            }):Play()

            local liveLbl = New("TextLabel", {
                Size = UDim2.fromOffset(0, 26),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Text = c.Status or "LIVE",
                Font = Enum.Font.GothamMedium,
                TextSize = 9,
                TextColor3 = liveColor,
                LayoutOrder = 2,
                Parent = status,
            })

            card.MouseEnter:Connect(function()
                Tween(cStroke, 0.2, { Color = CurrentTheme.BorderHover })
                Tween(card, 0.2, { BackgroundColor3 = CurrentTheme.CardHover })
            end)
            card.MouseLeave:Connect(function()
                Tween(cStroke, 0.2, { Color = CurrentTheme.Border })
                Tween(card, 0.2, { BackgroundColor3 = CurrentTheme.Card })
            end)

            RegisterPaint(function()
                card.BackgroundColor3 = CurrentTheme.Card
                cStroke.Color = CurrentTheme.Border
                iconImg.BackgroundColor3 = CurrentTheme.Bg
                gName.TextColor3 = CurrentTheme.Text
                gPlayers.TextColor3 = CurrentTheme.TextMuted
                status.BackgroundColor3 = CurrentTheme.Bg
                stStroke.Color = CurrentTheme.Border
            end)

            local obj = {}
            function obj:SetName(n) gName.Text = tostring(n) end
            function obj:SetPlayers(n) gPlayers.Text = tostring(n) .. " Players" end
            function obj:SetImage(s) iconImg.Image = tostring(s) end
            function obj:SetStatus(s) liveLbl.Text = tostring(s) end
            return obj
        end

        ------------------------------------------------------------
        -- Stat Grid
        ------------------------------------------------------------
        function Tab:AddStatGrid(items)
            items = items or {}
            local rows = math.ceil(#items / 2)
            local gridH = rows * 48 + math.max(rows - 1, 0) * 8
            local gridHolder = New("Frame", {
                Size = UDim2.new(1, 0, 0, gridH),
                BackgroundTransparency = 1,
                LayoutOrder = NextOrder(),
                Parent = Page,
            })
            New("UIGridLayout", {
                CellSize = UDim2.new(0.5, -4, 0, 48),
                CellPadding = UDim2.fromOffset(8, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = gridHolder,
            })

            local statRefs = {}
            for i, stat in ipairs(items) do
                local sCard = New("Frame", {
                    BackgroundColor3 = CurrentTheme.Card,
                    BorderSizePixel = 0,
                    LayoutOrder = i,
                    Parent = gridHolder,
                })
                Corner(sCard, 5)
                local sStroke = Stroke(sCard, CurrentTheme.Border)

                local sKey = New("TextLabel", {
                    Position = UDim2.fromOffset(12, 8),
                    Size = UDim2.new(1, -24, 0, 11),
                    BackgroundTransparency = 1,
                    Text = string.upper(stat.Title or ""),
                    Font = Enum.Font.GothamMedium,
                    TextSize = 8,
                    TextColor3 = CurrentTheme.TextDull,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = sCard,
                })

                local sVal = New("TextLabel", {
                    Position = UDim2.fromOffset(12, 22),
                    Size = UDim2.new(1, -24, 0, 18),
                    BackgroundTransparency = 1,
                    Text = tostring(stat.Value or "-"),
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    TextColor3 = CurrentTheme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Parent = sCard,
                })

                statRefs[stat.Title or ""] = sVal

                sCard.MouseEnter:Connect(function()
                    Tween(sStroke, 0.2, { Color = CurrentTheme.BorderHover })
                    Tween(sCard, 0.2, { BackgroundColor3 = CurrentTheme.CardHover })
                end)
                sCard.MouseLeave:Connect(function()
                    Tween(sStroke, 0.2, { Color = CurrentTheme.Border })
                    Tween(sCard, 0.2, { BackgroundColor3 = CurrentTheme.Card })
                end)

                RegisterPaint(function()
                    sCard.BackgroundColor3 = CurrentTheme.Card
                    sStroke.Color = CurrentTheme.Border
                    sKey.TextColor3 = CurrentTheme.TextDull
                    sVal.TextColor3 = CurrentTheme.Text
                end)
            end

            local gridObj = {}
            function gridObj:Update(key, newVal)
                local lbl = statRefs[key]
                if lbl then lbl.Text = tostring(newVal) end
            end
            gridObj.Set = gridObj.Update
            return gridObj
        end

        ------------------------------------------------------------
        -- Section
        ------------------------------------------------------------
        function Tab:AddSection(c)
            c = c or {}
            local sHolder = New("Frame", {
                Size = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
                LayoutOrder = NextOrder(),
                Parent = Page,
            })

            local sText = New("TextLabel", {
                Position = UDim2.fromOffset(2, 4),
                Size = UDim2.new(1, -2, 1, -4),
                BackgroundTransparency = 1,
                Text = Spaced(c.Title or ""),
                Font = Enum.Font.GothamMedium,
                TextSize = 8,
                TextColor3 = CurrentTheme.TextMuted,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sHolder,
            })

            local sLine = New("Frame", {
                BackgroundColor3 = CurrentTheme.BorderHover,
                BorderSizePixel = 0,
                Parent = sHolder,
            })
            New("UIGradient", {
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1),
                }),
                Parent = sLine,
            })

            local function Layout()
                local w = sText.TextBounds.X + 12
                sLine.Position = UDim2.new(0, w, 0.5, 2)
                sLine.Size = UDim2.new(1, -w, 0, 1)
            end
            sText:GetPropertyChangedSignal("TextBounds"):Connect(Layout)
            Layout()

            RegisterPaint(function()
                sText.TextColor3 = CurrentTheme.TextMuted
                sLine.BackgroundColor3 = CurrentTheme.BorderHover
            end)

            local obj = {}
            function obj:Set(t) sText.Text = Spaced(tostring(t)) end
            return obj
        end

        ------------------------------------------------------------
        -- Label
        ------------------------------------------------------------
        function Tab:AddLabel(c)
            c = type(c) == "string" and { Text = c } or (c or {})
            local lbl = New("TextLabel", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Text = c.Text or "",
                Font = Enum.Font.Gotham,
                TextSize = 10,
                TextColor3 = CurrentTheme.TextMuted,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                RichText = true,
                LayoutOrder = NextOrder(),
                Parent = Page,
            })
            Pad(lbl, 2, 2, 2, 2)
            RegisterPaint(function() lbl.TextColor3 = CurrentTheme.TextMuted end)
            local obj = {}
            function obj:Set(t) lbl.Text = tostring(t) end
            return obj
        end

        ------------------------------------------------------------
        -- Paragraph
        ------------------------------------------------------------
        function Tab:AddParagraph(c)
            c = c or {}
            local pRow = New("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = CurrentTheme.Card,
                BorderSizePixel = 0,
                LayoutOrder = NextOrder(),
                Parent = Page,
            })
            Corner(pRow, 5)
            local pStroke = Stroke(pRow, CurrentTheme.Border)
            Pad(pRow, 10, 10, 14, 14)
            New("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = pRow })

            local pt = New("TextLabel", {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Text = c.Title or "",
                Visible = (c.Title or "") ~= "",
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = CurrentTheme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                LayoutOrder = 1,
                Parent = pRow,
            })

            local pc = New("TextLabel", {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Text = c.Content or "",
                Visible = (c.Content or "") ~= "",
                Font = Enum.Font.Gotham,
                TextSize = 10,
                TextColor3 = CurrentTheme.TextMuted,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                RichText = true,
                LayoutOrder = 2,
                Parent = pRow,
            })

            RegisterPaint(function()
                pRow.BackgroundColor3 = CurrentTheme.Card
                pStroke.Color = CurrentTheme.Border
                pt.TextColor3 = CurrentTheme.Text
                pc.TextColor3 = CurrentTheme.TextMuted
            end)

            local obj = {}
            function obj:SetTitle(t) pt.Text = tostring(t); pt.Visible = pt.Text ~= "" end
            function obj:SetContent(t) pc.Text = tostring(t); pc.Visible = pc.Text ~= "" end
            return obj
        end

        ------------------------------------------------------------
        -- Toggle
        ------------------------------------------------------------
        function Tab:AddToggle(c)
            c = c or {}
            local state = c.Default and true or false
            local cb = c.Callback or function() end
            local flag = c.Flag
            local row = CreateRow(44)
            AddHeaderLabels(row, c.Title, c.Description, 80)

            local box = New("Frame", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -14, 0.5, 0),
                Size = UDim2.fromOffset(34, 18),
                BackgroundColor3 = CurrentTheme.Bg,
                BorderSizePixel = 0,
                Parent = row,
            })
            Corner(box, 999)
            local bStroke = Stroke(box, CurrentTheme.BorderHover)

            local knob = New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.fromOffset(12, 12),
                Position = UDim2.new(0, 3, 0.5, 0),
                BackgroundColor3 = CurrentTheme.TextDull,
                BorderSizePixel = 0,
                Parent = box,
            })
            Corner(knob, 999)

            local btn = New("TextButton", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = "",
                Parent = row,
            })

            local function Visual(instant)
                local t = instant and 0 or 0.28
                local T = CurrentTheme
                Tween(knob, t, {
                    Position = state and UDim2.new(1, -15, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                    BackgroundColor3 = state and T.Bg or T.TextDull,
                })
                Tween(box, t, { BackgroundColor3 = state and T.Accent or T.Bg })
                Tween(bStroke, t, { Color = state and T.Accent or T.BorderHover })
            end
            Visual(true)

            local obj = { Value = state }
            function obj:Set(val)
                state = val and true or false
                obj.Value = state
                Visual(false)
                task.spawn(cb, state)
            end

            btn.MouseButton1Down:Connect(function()
                Tween(knob, 0.12, { Size = UDim2.fromOffset(16, 12) })
            end)
            btn.MouseButton1Up:Connect(function()
                Tween(knob, 0.2, { Size = UDim2.fromOffset(12, 12) })
            end)
            btn.MouseLeave:Connect(function()
                Tween(knob, 0.2, { Size = UDim2.fromOffset(12, 12) })
            end)
            btn.MouseButton1Click:Connect(function()
                knob.Size = UDim2.fromOffset(12, 12)
                obj:Set(not state)
            end)

            RegisterPaint(function() Visual(true) end)

            if flag then Window.Flags[flag] = obj end
            return obj
        end

        ------------------------------------------------------------
        -- Button
        ------------------------------------------------------------
        function Tab:AddButton(c)
            c = c or {}
            local cb = c.Callback or function() end
            local row = CreateRow(44)
            AddHeaderLabels(row, c.Title, c.Description, 120)

            local bAction = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -14, 0.5, 0),
                Size = UDim2.fromOffset(0, 24),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = CurrentTheme.Bg,
                BorderSizePixel = 0,
                Text = c.ButtonText or "Execute",
                Font = Enum.Font.GothamMedium,
                TextSize = 10,
                TextColor3 = CurrentTheme.Text,
                AutoButtonColor = false,
                ClipsDescendants = true,
                Parent = row,
            })
            Corner(bAction, 4)
            Pad(bAction, 0, 0, 14, 14)
            local bStroke = Stroke(bAction, CurrentTheme.BorderHover)
            -- subtle sheen that sweeps across when hovered
            local bGrad = AddGradient(bAction, ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(214, 214, 222)),
            }), 90)

            local hovering = false
            RegisterPaint(function()
                bAction.BackgroundColor3 = hovering and CurrentTheme.Accent or CurrentTheme.Bg
                bAction.TextColor3 = hovering and CurrentTheme.Bg or CurrentTheme.Text
                bStroke.Color = hovering and CurrentTheme.Accent or CurrentTheme.BorderHover
            end)

            bAction.MouseEnter:Connect(function()
                hovering = true
                Tween(bAction, 0.18, { BackgroundColor3 = CurrentTheme.Accent, TextColor3 = CurrentTheme.Bg })
                Tween(bStroke, 0.18, { Color = CurrentTheme.Accent })
                Tween(bGrad, 0.35, { Offset = Vector2.new(0, 0.4) })
            end)
            bAction.MouseLeave:Connect(function()
                hovering = false
                Tween(bAction, 0.18, { BackgroundColor3 = CurrentTheme.Bg, TextColor3 = CurrentTheme.Text })
                Tween(bStroke, 0.18, { Color = CurrentTheme.BorderHover })
                Tween(bGrad, 0.35, { Offset = Vector2.new(0, 0) })
            end)
            bAction.MouseButton1Click:Connect(function()
                Ripple(bAction)
                Press(bAction)
                task.spawn(cb)
            end)

            local obj = {}
            function obj:SetText(t) bAction.Text = tostring(t) end
            return obj
        end

        ------------------------------------------------------------
        -- Slider
        ------------------------------------------------------------
        function Tab:AddSlider(c)
            c = c or {}
            local min, max, step = c.Min or 0, c.Max or 100, c.Step or 1
            if step <= 0 then step = 1 end
            local suffix = c.Suffix or ""
            local decimals = 0
            do
                local d = tostring(step):match("%.(%d+)$")
                decimals = d and #d or 0
            end
            local function Round(v)
                local r = math.floor((v - min) / step + 0.5) * step + min
                r = tonumber(string.format("%." .. decimals .. "f", r))
                return math.clamp(r, min, max)
            end
            local function Fmt(v)
                if decimals > 0 then return string.format("%." .. decimals .. "f", v) .. suffix end
                return tostring(math.floor(v + 0.5)) .. suffix
            end
            local function Ratio(v)
                if max == min then return 0 end
                return (v - min) / (max - min)
            end

            local cur = Round(c.Default or min)
            local cb = c.Callback or function() end
            local flag = c.Flag
            local row = CreateRow(52)

            local sTitle = New("TextLabel", {
                Position = UDim2.fromOffset(14, 8),
                Size = UDim2.new(1, -100, 0, 16),
                BackgroundTransparency = 1,
                Text = c.Title or "Slider",
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = CurrentTheme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = row,
            })

            local valBox = New("Frame", {
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -14, 0, 7),
                Size = UDim2.fromOffset(0, 18),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = CurrentTheme.Bg,
                BorderSizePixel = 0,
                Parent = row,
            })
            Corner(valBox, 4)
            local vStroke = Stroke(valBox, CurrentTheme.Border)
            Pad(valBox, 0, 0, 8, 8)
            local sVal = New("TextLabel", {
                Size = UDim2.fromOffset(0, 18),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Text = Fmt(cur),
                Font = Enum.Font.GothamMedium,
                TextSize = 10,
                TextColor3 = CurrentTheme.Text,
                Parent = valBox,
            })

            local track = New("Frame", {
                Position = UDim2.fromOffset(14, 36),
                Size = UDim2.new(1, -28, 0, 3),
                BackgroundColor3 = CurrentTheme.Border,
                BorderSizePixel = 0,
                Parent = row,
            })
            Corner(track, 999)

            local fill = New("Frame", {
                Size = UDim2.new(Ratio(cur), 0, 1, 0),
                BackgroundColor3 = CurrentTheme.Accent,
                BorderSizePixel = 0,
                Parent = track,
            })
            Corner(fill, 999)
            local fillGrad = AddGradient(fill, ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 190, 190)),
                ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
            }), 0)

            local knob = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.fromOffset(10, 10),
                Position = UDim2.new(Ratio(cur), 0, 0.5, 0),
                BackgroundColor3 = CurrentTheme.Accent,
                BorderSizePixel = 0,
                ZIndex = 2,
                Parent = track,
            })
            Corner(knob, 999)
            local kStroke = Stroke(knob, CurrentTheme.Bg, 2)

            -- glow behind the knob; pulses while dragging
            local knobGlow = AddGlow(track, CurrentTheme.Accent, UDim2.fromOffset(26, 26), 0.85, 1)
            knobGlow.Position = UDim2.new(Ratio(cur), 0, 0.5, 0)
            local knobPulse = TweenService:Create(
                knobGlow,
                TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                { ImageTransparency = 0.95 }
            )

            local trigger = New("TextButton", {
                Position = UDim2.fromOffset(8, 26),
                Size = UDim2.new(1, -16, 0, 22),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 3,
                Parent = row,
            })

            local function Render(instant)
                local r = Ratio(cur)
                local t = instant and 0 or 0.12
                Tween(fill, t, { Size = UDim2.new(r, 0, 1, 0) })
                Tween(knob, t, { Position = UDim2.new(r, 0, 0.5, 0) })
                Tween(knobGlow, t, { Position = UDim2.new(r, 0, 0.5, 0) })
                sVal.Text = Fmt(cur)
            end

            local obj = { Value = cur }

            local dragging = false
            local function Update(inputX)
                local r = math.clamp((inputX - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
                local nv = Round(min + (max - min) * r)
                if nv ~= cur then
                    cur = nv
                    obj.Value = cur
                    Render(false)
                    task.spawn(cb, cur)
                end
            end

            trigger.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    Tween(knob, 0.2, { Size = UDim2.fromOffset(14, 14) }, Enum.EasingStyle.Back)
                    Tween(vStroke, 0.2, { Color = CurrentTheme.AccentMuted })
                    knobGlow.ImageTransparency = 0.7
                    knobPulse:Play()
                    Update(inp.Position.X)
                end
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if dragging and (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then
                    dragging = false
                    Tween(knob, 0.2, { Size = UDim2.fromOffset(10, 10) })
                    Tween(vStroke, 0.2, { Color = CurrentTheme.Border })
                    knobPulse:Cancel()
                    knobGlow.ImageTransparency = 0.85
                end
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                    Update(inp.Position.X)
                end
            end)

            RegisterPaint(function()
                sTitle.TextColor3 = CurrentTheme.Text
                sVal.TextColor3 = CurrentTheme.Text
                valBox.BackgroundColor3 = CurrentTheme.Bg
                vStroke.Color = CurrentTheme.Border
                track.BackgroundColor3 = CurrentTheme.Border
                fill.BackgroundColor3 = CurrentTheme.Accent
                knob.BackgroundColor3 = CurrentTheme.Accent
                knobGlow.ImageColor3 = CurrentTheme.Accent
                kStroke.Color = CurrentTheme.Card
            end)

            function obj:Set(v)
                v = tonumber(v)
                if not v then return end
                cur = Round(v)
                obj.Value = cur
                Render(false)
                task.spawn(cb, cur)
            end

            if flag then Window.Flags[flag] = obj end
            return obj
        end

        ------------------------------------------------------------
        -- Dropdown (single / multi + optional search)
        ------------------------------------------------------------
        function Tab:AddDropdown(c)
            c = c or {}
            local values = c.Values or {}
            local multi = c.Multi == true
            local searchable = c.Searchable == true or (#values >= 8)
            local cb = c.Callback or function() end
            local flag = c.Flag

            local current
            if multi then
                current = {}
                if type(c.Default) == "table" then
                    for _, v in ipairs(c.Default) do table.insert(current, v) end
                elseif c.Default ~= nil then
                    table.insert(current, c.Default)
                end
            else
                current = c.Default or values[1] or "Select..."
            end

            local row = CreateRow(44)
            AddHeaderLabels(row, c.Title, c.Description, 170)

            local dropBtn = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -14, 0.5, 0),
                Size = UDim2.fromOffset(136, 24),
                BackgroundColor3 = CurrentTheme.Bg,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = row,
            })
            Corner(dropBtn, 4)
            local dStroke = Stroke(dropBtn, CurrentTheme.Border)

            local function FormatLabel()
                if multi then
                    if #current == 0 then return "None" end
                    if #current == 1 then return tostring(current[1]) end
                    return tostring(#current) .. " selected"
                end
                return tostring(current)
            end

            local dText = New("TextLabel", {
                Position = UDim2.fromOffset(10, 0),
                Size = UDim2.new(1, -30, 1, 0),
                BackgroundTransparency = 1,
                Text = FormatLabel(),
                Font = Enum.Font.Gotham,
                TextSize = 10,
                TextColor3 = CurrentTheme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = dropBtn,
            })

            local dChevron = New("ImageLabel", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.fromOffset(10, 10),
                BackgroundTransparency = 1,
                Image = Lucide.chevron,
                ImageColor3 = CurrentTheme.TextMuted,
                Parent = dropBtn,
            })

            local handle = { Button = dropBtn, Hovered = false }
            local isOpen = false

            handle.OnClose = function()
                isOpen = false
                Tween(dChevron, 0.3, { Rotation = 0, ImageColor3 = CurrentTheme.TextMuted })
                Tween(dStroke, 0.2, { Color = handle.Hovered and CurrentTheme.BorderHover or CurrentTheme.Border })
            end

            dropBtn.MouseEnter:Connect(function()
                handle.Hovered = true
                if not isOpen then Tween(dStroke, 0.15, { Color = CurrentTheme.BorderHover }) end
            end)
            dropBtn.MouseLeave:Connect(function()
                handle.Hovered = false
                if not isOpen then Tween(dStroke, 0.15, { Color = CurrentTheme.Border }) end
            end)

            RegisterPaint(function()
                dropBtn.BackgroundColor3 = CurrentTheme.Bg
                dText.TextColor3 = CurrentTheme.Text
                dStroke.Color = isOpen and CurrentTheme.Accent or CurrentTheme.Border
                dChevron.ImageColor3 = isOpen and CurrentTheme.Accent or CurrentTheme.TextMuted
            end)

            local function CloneList(t)
                local n = {}
                for i, v in ipairs(t) do n[i] = v end
                return n
            end

            local obj = { Value = multi and CloneList(current) or current }

            local function IsSelected(val)
                if multi then
                    return table.find(current, val) ~= nil
                end
                return val == current
            end

            local function Emit(silent)
                if multi then
                    obj.Value = CloneList(current)
                else
                    obj.Value = current
                end
                dText.Text = FormatLabel()
                if not silent then task.spawn(cb, obj.Value) end
            end

            local function Select(val, silent)
                if multi then
                    local idx = table.find(current, val)
                    if idx then
                        table.remove(current, idx)
                    else
                        table.insert(current, val)
                    end
                else
                    current = val
                end
                Emit(silent)
            end

            local function ClearItems()
                for _, ch in ipairs(DropScroll:GetChildren()) do
                    if ch:IsA("TextButton") or ch:IsA("TextLabel") then ch:Destroy() end
                end
            end

            local function BuildItems(filter)
                ClearItems()
                DropScroll.CanvasPosition = Vector2.new(0, 0)
                local T = CurrentTheme
                local q = tostring(filter or ""):lower()
                local shown = 0

                for i, val in ipairs(values) do
                    local label = tostring(val)
                    if q == "" or label:lower():find(q, 1, true) then
                    shown = shown + 1
                    local selected = IsSelected(val)
                    local item = New("TextButton", {
                        Size = UDim2.new(1, 0, 0, 24),
                        BackgroundColor3 = T.CardHover,
                        BackgroundTransparency = selected and 0 or 1,
                        BorderSizePixel = 0,
                        Text = "",
                        AutoButtonColor = false,
                        LayoutOrder = shown,
                        ZIndex = 101,
                        Parent = DropScroll,
                    })
                    Corner(item, 3)

                    local leftPad = (multi or selected) and 22 or 8
                    if multi then
                        local box = New("Frame", {
                            AnchorPoint = Vector2.new(0, 0.5),
                            Position = UDim2.new(0, 6, 0.5, 0),
                            Size = UDim2.fromOffset(10, 10),
                            BackgroundColor3 = selected and T.Accent or T.Bg,
                            BorderSizePixel = 0,
                            ZIndex = 102,
                            Parent = item,
                        })
                        Stroke(box, selected and T.Accent or T.BorderHover)
                        if selected then
                            New("TextLabel", {
                                Size = UDim2.fromScale(1, 1),
                                BackgroundTransparency = 1,
                                Text = "✓",
                                Font = Enum.Font.GothamBold,
                                TextSize = 8,
                                TextColor3 = T.Bg,
                                ZIndex = 103,
                                Parent = box,
                            })
                        end
                    elseif selected then
                        New("Frame", {
                            AnchorPoint = Vector2.new(0, 0.5),
                            Position = UDim2.new(0, 7, 0.5, 0),
                            Size = UDim2.fromOffset(4, 4),
                            BackgroundColor3 = T.Accent,
                            BorderSizePixel = 0,
                            ZIndex = 102,
                            Parent = item,
                        })
                    end

                    local itemLbl = New("TextLabel", {
                        Position = UDim2.fromOffset(leftPad, 0),
                        Size = UDim2.new(1, -leftPad - 6, 1, 0),
                        BackgroundTransparency = 1,
                        Text = label,
                        Font = selected and Enum.Font.GothamMedium or Enum.Font.Gotham,
                        TextSize = 10,
                        TextColor3 = selected and T.Text or T.TextMuted,
                        TextTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextTruncate = Enum.TextTruncate.AtEnd,
                        ZIndex = 102,
                        Parent = item,
                    })

                    task.delay((shown - 1) * 0.012, function()
                        if itemLbl.Parent then Tween(itemLbl, 0.18, { TextTransparency = 0 }) end
                    end)

                    item.MouseEnter:Connect(function()
                        Tween(item, 0.12, { BackgroundTransparency = 0 })
                        Tween(itemLbl, 0.12, { TextColor3 = CurrentTheme.Text })
                    end)
                    item.MouseLeave:Connect(function()
                        if not IsSelected(val) then
                            Tween(item, 0.12, { BackgroundTransparency = 1 })
                            Tween(itemLbl, 0.12, { TextColor3 = CurrentTheme.TextMuted })
                        end
                    end)
                    item.MouseButton1Click:Connect(function()
                        Select(val)
                        if multi then
                            BuildItems(DropSearch.Text)
                        else
                            CloseDropdown()
                        end
                    end)
                    end
                end

                if shown == 0 then
                    New("TextLabel", {
                        Size = UDim2.new(1, 0, 0, 24),
                        BackgroundTransparency = 1,
                        Text = "No results",
                        Font = Enum.Font.Gotham,
                        TextSize = 10,
                        TextColor3 = CurrentTheme.TextDull,
                        ZIndex = 102,
                        Parent = DropScroll,
                    })
                end

                return shown
            end

            local function OpenMenu()
                if CurrentDropdown == handle then
                    CloseDropdown()
                    return
                end
                CloseColorPicker()
                if CurrentDropdown then CloseDropdown() end
                CurrentDropdown = handle
                isOpen = true

                local searchH = searchable and 32 or 0
                DropSearch.Visible = searchable
                DropSearch.Text = ""
                if searchable then
                    DropScroll.Position = UDim2.fromOffset(0, searchH)
                    DropScroll.Size = UDim2.new(1, 0, 1, -searchH)
                else
                    DropScroll.Position = UDim2.fromOffset(0, 0)
                    DropScroll.Size = UDim2.fromScale(1, 1)
                end

                local shown = BuildItems("")
                local listH = math.min(math.max(shown, 1) * 26, 26 * 6) + 8
                local h = listH + searchH
                local w = math.max(dropBtn.AbsoluteSize.X, searchable and 160 or 136)
                local x = dropBtn.AbsolutePosition.X
                local y = dropBtn.AbsolutePosition.Y + dropBtn.AbsoluteSize.Y + 4
                if y + h > Screen.AbsoluteSize.Y - 8 then
                    y = dropBtn.AbsolutePosition.Y - h - 4
                end

                GlobalDropdown.Position = UDim2.fromOffset(x, y)
                GlobalDropdown.Size = UDim2.fromOffset(w, 0)
                GlobalDropdown.Visible = true
                Tween(GlobalDropdown, 0.32, { Size = UDim2.fromOffset(w, h) })
                Tween(dChevron, 0.3, { Rotation = 180, ImageColor3 = CurrentTheme.Accent })
                Tween(dStroke, 0.2, { Color = CurrentTheme.Accent })

                if searchable then
                    task.defer(function() DropSearch:CaptureFocus() end)
                end
            end

            DropSearch:GetPropertyChangedSignal("Text"):Connect(function()
                if CurrentDropdown == handle and DropSearch.Visible then
                    BuildItems(DropSearch.Text)
                end
            end)

            dropBtn.MouseButton1Click:Connect(OpenMenu)

            function obj:Set(v)
                if multi then
                    current = {}
                    if type(v) == "table" then
                        for _, item in ipairs(v) do table.insert(current, item) end
                    elseif v ~= nil then
                        table.insert(current, v)
                    end
                else
                    current = v
                end
                Emit(false)
                if CurrentDropdown == handle then BuildItems(DropSearch.Text) end
            end

            function obj:SetValues(newVals)
                values = newVals or {}
                if multi then
                    local kept = {}
                    for _, v in ipairs(current) do
                        if table.find(values, v) then table.insert(kept, v) end
                    end
                    current = kept
                else
                    if not table.find(values, current) then
                        current = values[1] or "Select..."
                    end
                end
                Emit(true)
                if CurrentDropdown == handle then CloseDropdown() end
            end

            if flag then Window.Flags[flag] = obj end
            return obj
        end

        ------------------------------------------------------------
        -- ColorPicker
        ------------------------------------------------------------
        function Tab:AddColorPicker(c)
            c = c or {}
            local color = c.Default or Color3.fromRGB(236, 236, 236)
            if type(color) == "string" then color = HexToColor(color) or Color3.fromRGB(236, 236, 236) end
            local cb = c.Callback or function() end
            local flag = c.Flag
            local row = CreateRow(44)
            AddHeaderLabels(row, c.Title, c.Description, 150)

            local hexLbl = New("TextLabel", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -44, 0.5, 0),
                Size = UDim2.fromOffset(58, 18),
                BackgroundTransparency = 1,
                Text = "#" .. ColorToHex(color),
                Font = Enum.Font.GothamMedium,
                TextSize = 10,
                TextColor3 = CurrentTheme.TextMuted,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = row,
            })

            local swatch = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -14, 0.5, 0),
                Size = UDim2.fromOffset(22, 22),
                BackgroundColor3 = color,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = row,
            })
            local sStroke = Stroke(swatch, CurrentTheme.BorderHover)

            local handle = { Button = swatch, Hovered = false }
            local isOpen = false
            local h, s, v = Color3.toHSV(color)

            handle.OnClose = function()
                isOpen = false
                Tween(sStroke, 0.2, { Color = handle.Hovered and CurrentTheme.BorderHover or CurrentTheme.Border })
            end

            swatch.MouseEnter:Connect(function()
                handle.Hovered = true
                if not isOpen then Tween(sStroke, 0.15, { Color = CurrentTheme.AccentMuted }) end
            end)
            swatch.MouseLeave:Connect(function()
                handle.Hovered = false
                if not isOpen then Tween(sStroke, 0.15, { Color = CurrentTheme.BorderHover }) end
            end)

            local obj = { Value = color }

            local function ApplyColor(newColor, silent)
                color = newColor
                h, s, v = Color3.toHSV(color)
                obj.Value = color
                swatch.BackgroundColor3 = color
                hexLbl.Text = "#" .. ColorToHex(color)
                if not silent then task.spawn(cb, color) end
            end

            local function OpenPicker()
                if CurrentColorPicker == handle then
                    CloseColorPicker()
                    return
                end
                CloseDropdown()
                if CurrentColorPicker then CloseColorPicker() end
                CurrentColorPicker = handle
                isOpen = true

                for _, ch in ipairs(GlobalColorPicker:GetChildren()) do
                    if not ch:IsA("UIStroke") then ch:Destroy() end
                end

                local T = CurrentTheme
                local body = New("Frame", {
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    Parent = GlobalColorPicker,
                })
                Pad(body, 10, 10, 10, 10)

                local preview = New("Frame", {
                    Size = UDim2.new(1, 0, 0, 28),
                    BackgroundColor3 = color,
                    BorderSizePixel = 0,
                    Parent = body,
                })
                Stroke(preview, T.Border)

                local hexBox = New("TextBox", {
                    Position = UDim2.fromOffset(0, 36),
                    Size = UDim2.new(1, 0, 0, 24),
                    BackgroundColor3 = T.Bg,
                    BorderSizePixel = 0,
                    Text = ColorToHex(color),
                    PlaceholderText = "HEX",
                    Font = Enum.Font.GothamMedium,
                    TextSize = 11,
                    TextColor3 = T.Text,
                    PlaceholderColor3 = T.TextDull,
                    ClearTextOnFocus = false,
                    Parent = body,
                })
                Pad(hexBox, 0, 0, 8, 8)
                Stroke(hexBox, T.Border)

                local function MakeChannel(y, label, getVal, setVal)
                    local title = New("TextLabel", {
                        Position = UDim2.fromOffset(0, y),
                        Size = UDim2.new(1, 0, 0, 12),
                        BackgroundTransparency = 1,
                        Text = label,
                        Font = Enum.Font.GothamMedium,
                        TextSize = 9,
                        TextColor3 = T.TextDull,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = body,
                    })
                    local track = New("Frame", {
                        Position = UDim2.fromOffset(0, y + 14),
                        Size = UDim2.new(1, 0, 0, 4),
                        BackgroundColor3 = T.Border,
                        BorderSizePixel = 0,
                        Parent = body,
                    })
                    local fill = New("Frame", {
                        Size = UDim2.new(getVal(), 0, 1, 0),
                        BackgroundColor3 = T.Accent,
                        BorderSizePixel = 0,
                        Parent = track,
                    })
                    local knob = New("Frame", {
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(getVal(), 0, 0.5, 0),
                        Size = UDim2.fromOffset(10, 10),
                        BackgroundColor3 = T.Accent,
                        BorderSizePixel = 0,
                        ZIndex = 2,
                        Parent = track,
                    })
                    local hit = New("TextButton", {
                        Position = UDim2.fromOffset(0, y + 8),
                        Size = UDim2.new(1, 0, 0, 16),
                        BackgroundTransparency = 1,
                        Text = "",
                        ZIndex = 3,
                        Parent = body,
                    })
                    local dragging = false
                    local function Update(x)
                        local r = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
                        setVal(r)
                        fill.Size = UDim2.new(r, 0, 1, 0)
                        knob.Position = UDim2.new(r, 0, 0.5, 0)
                        local nc = Color3.fromHSV(h, s, v)
                        preview.BackgroundColor3 = nc
                        hexBox.Text = ColorToHex(nc)
                        ApplyColor(nc, false)
                    end
                    hit.InputBegan:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                            dragging = true
                            Update(inp.Position.X)
                        end
                    end)
                    Bind(UserInputService.InputEnded, function(inp)
                        if dragging and (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then
                            dragging = false
                        end
                    end)
                    Bind(UserInputService.InputChanged, function(inp)
                        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                            Update(inp.Position.X)
                        end
                    end)
                    return title
                end

                MakeChannel(68, "HUE", function() return h end, function(r) h = r end)
                MakeChannel(100, "SAT", function() return s end, function(r) s = r end)
                MakeChannel(132, "VAL", function() return v end, function(r) v = r end)

                hexBox.FocusLost:Connect(function()
                    local parsed = HexToColor(hexBox.Text)
                    if parsed then
                        ApplyColor(parsed, false)
                        preview.BackgroundColor3 = parsed
                        hexBox.Text = ColorToHex(parsed)
                    else
                        hexBox.Text = ColorToHex(color)
                    end
                end)

                local w, hPanel = 220, 178
                local x = swatch.AbsolutePosition.X + swatch.AbsoluteSize.X - w
                local y = swatch.AbsolutePosition.Y + swatch.AbsoluteSize.Y + 4
                if x < 8 then x = 8 end
                if y + hPanel > Screen.AbsoluteSize.Y - 8 then
                    y = swatch.AbsolutePosition.Y - hPanel - 4
                end

                GlobalColorPicker.Position = UDim2.fromOffset(x, y)
                GlobalColorPicker.Size = UDim2.fromOffset(w, 0)
                GlobalColorPicker.Visible = true
                Tween(GlobalColorPicker, 0.28, { Size = UDim2.fromOffset(w, hPanel) })
                Tween(sStroke, 0.2, { Color = CurrentTheme.Accent })
            end

            swatch.MouseButton1Click:Connect(OpenPicker)

            RegisterPaint(function()
                hexLbl.TextColor3 = CurrentTheme.TextMuted
                sStroke.Color = isOpen and CurrentTheme.Accent or CurrentTheme.BorderHover
            end)

            function obj:Set(v)
                if type(v) == "string" then v = HexToColor(v) end
                if typeof(v) ~= "Color3" then return end
                ApplyColor(v, false)
            end

            if flag then Window.Flags[flag] = obj end
            return obj
        end

        ------------------------------------------------------------
        -- Input
        ------------------------------------------------------------
        function Tab:AddInput(c)
            c = c or {}
            local cb = c.Callback or function() end
            local flag = c.Flag
            local row = CreateRow(44)
            AddHeaderLabels(row, c.Title, c.Description, 170)

            local box = New("TextBox", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -14, 0.5, 0),
                Size = UDim2.fromOffset(136, 24),
                BackgroundColor3 = CurrentTheme.Bg,
                BorderSizePixel = 0,
                Text = c.Default or "",
                PlaceholderText = c.Placeholder or "Type here...",
                Font = Enum.Font.Gotham,
                TextSize = 10,
                TextColor3 = CurrentTheme.Text,
                PlaceholderColor3 = CurrentTheme.TextDull,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                ClipsDescendants = true,
                Parent = row,
            })
            Corner(box, 4)
            Pad(box, 0, 0, 10, 10)
            local iStroke = Stroke(box, CurrentTheme.Border)

            -- focus underline
            local underline = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.new(0.5, 0, 1, 0),
                Size = UDim2.new(0, 0, 0, 1),
                BackgroundColor3 = CurrentTheme.Accent,
                BorderSizePixel = 0,
                Parent = box,
            })

            local obj = { Value = box.Text }

            box.Focused:Connect(function()
                Tween(iStroke, 0.2, { Color = CurrentTheme.BorderHover })
                Tween(underline, 0.3, { Size = UDim2.new(1, 20, 0, 1) })
            end)
            box.FocusLost:Connect(function()
                Tween(iStroke, 0.2, { Color = CurrentTheme.Border })
                Tween(underline, 0.25, { Size = UDim2.new(0, 0, 0, 1) })
                obj.Value = box.Text
                task.spawn(cb, box.Text)
            end)

            RegisterPaint(function()
                box.BackgroundColor3 = CurrentTheme.Bg
                box.TextColor3 = CurrentTheme.Text
                box.PlaceholderColor3 = CurrentTheme.TextDull
                iStroke.Color = CurrentTheme.Border
                underline.BackgroundColor3 = CurrentTheme.Accent
            end)

            function obj:Set(v)
                box.Text = tostring(v)
                obj.Value = box.Text
                task.spawn(cb, box.Text)
            end

            if flag then Window.Flags[flag] = obj end
            return obj
        end

        ------------------------------------------------------------
        -- Keybind
        --   Callback  -> fired when the bound key is pressed
        --   OnChanged -> fired when the bind is changed
        ------------------------------------------------------------
        function Tab:AddKeybind(c)
            c = c or {}
            local current = c.Default or Enum.KeyCode.RightControl
            if type(current) == "string" then current = Enum.KeyCode[current] or Enum.KeyCode.RightControl end
            local cb = c.Callback or function() end
            local onChanged = c.OnChanged or function() end
            local flag = c.Flag
            local row = CreateRow(44)
            AddHeaderLabels(row, c.Title, c.Description, 130)

            local bindBtn = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -14, 0.5, 0),
                Size = UDim2.fromOffset(0, 24),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = CurrentTheme.Bg,
                BorderSizePixel = 0,
                Text = current.Name,
                Font = Enum.Font.GothamMedium,
                TextSize = 10,
                TextColor3 = CurrentTheme.Text,
                AutoButtonColor = false,
                Parent = row,
            })
            Corner(bindBtn, 4)
            Pad(bindBtn, 0, 0, 12, 12)
            local bStroke = Stroke(bindBtn, CurrentTheme.BorderHover)

            local listening = false
            local pulse = nil

            local function StopListening()
                listening = false
                if pulse then pulse:Cancel(); pulse = nil end
                bindBtn.TextTransparency = 0
                bindBtn.Text = current.Name
                Tween(bStroke, 0.2, { Color = CurrentTheme.BorderHover })
                task.defer(function() BindingActive = false end)
            end

            local obj = { Value = current }

            bindBtn.MouseButton1Click:Connect(function()
                if listening then return end
                Press(bindBtn)
                listening = true
                BindingActive = true
                bindBtn.Text = "press a key"
                Tween(bStroke, 0.2, { Color = CurrentTheme.Accent })
                pulse = TweenService:Create(bindBtn, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { TextTransparency = 0.6 })
                pulse:Play()
            end)

            UserInputService.InputBegan:Connect(function(inp, proc)
                if listening then
                    if inp.UserInputType == Enum.UserInputType.Keyboard then
                        if inp.KeyCode ~= Enum.KeyCode.Escape then
                            current = inp.KeyCode
                            obj.Value = current
                            task.spawn(onChanged, current)
                        end
                        StopListening()
                    end
                elseif not proc and inp.KeyCode == current then
                    task.spawn(cb, current)
                end
            end)

            RegisterPaint(function()
                bindBtn.BackgroundColor3 = CurrentTheme.Bg
                bindBtn.TextColor3 = CurrentTheme.Text
                bStroke.Color = listening and CurrentTheme.Accent or CurrentTheme.BorderHover
            end)

            function obj:Set(k)
                if type(k) == "string" then k = Enum.KeyCode[k] end
                if typeof(k) ~= "EnumItem" then return end
                current = k
                obj.Value = k
                bindBtn.Text = k.Name
                task.spawn(onChanged, k)
            end

            if flag then Window.Flags[flag] = obj end
            return obj
        end

        return Tab
    end

    function Window:SelectTab(i)
        local t = Window.Tabs[i]
        if t then t.Activate() end
    end

    function Window:Notify(c) return Kami:Notify(c) end

    --================ SETTINGS / CONFIG UI ================
    function Window:BuildConfigSection(settingsTab)
        if not settingsTab then return end

        settingsTab:AddSection({ Title = "Interface" })

        settingsTab:AddKeybind({
            Title = "Menu Toggle Key",
            Description = "Show / hide this interface",
            Default = Window.ToggleKey,
            Flag = "__KamiToggleKey",
            OnChanged = function(key)
                Window.ToggleKey = key
                if not Window._Silent then
                    Kami:Notify({ Title = "Keybind Updated", Content = "Menu key set to " .. key.Name, Duration = 2 })
                end
            end,
        })

        settingsTab:AddDropdown({
            Title = "Interface Theme",
            Description = "Select visual color profile",
            Values = ThemeOrder,
            Default = CurrentThemeName,
            Flag = "__KamiTheme",
            Callback = function(themeName)
                if ApplyTheme(themeName) and not Window._Silent then
                    Kami:Notify({ Title = "Theme Applied", Content = "Active theme: " .. themeName, Duration = 2 })
                end
            end,
        })

        settingsTab:AddSection({ Title = "Config Manager" })

        local cfgInput = settingsTab:AddInput({
            Title = "Config Name",
            Description = "Target config file name",
            Placeholder = "default",
            Default = Window.ActiveConfig,
        })

        local configDropdown

        settingsTab:AddButton({
            Title = "Save Configuration",
            Description = "Write current settings to disk",
            ButtonText = "Save",
            Callback = function()
                local name = SanitizeName(cfgInput.Value)
                if Window:SaveConfig(name) then
                    if configDropdown then
                        configDropdown:SetValues(GetConfigList())
                        configDropdown:Set(name)
                    end
                    if Window.AutoLoad then WriteAutoLoad() end
                    Kami:Notify({ Title = "Config Saved", Content = "Saved as " .. name .. ".json", Duration = 2 })
                else
                    Kami:Notify({ Title = "Save Error", Content = "Executor lacks file write support.", Duration = 3 })
                end
            end,
        })

        configDropdown = settingsTab:AddDropdown({
            Title = "Select Config",
            Description = "Choose a saved configuration",
            Values = GetConfigList(),
            Default = Window.ActiveConfig,
            Callback = function(chosen)
                Window.ActiveConfig = chosen
                cfgInput:Set(chosen)
            end,
        })

        settingsTab:AddButton({
            Title = "Load Configuration",
            Description = "Apply the selected config",
            ButtonText = "Load",
            Callback = function()
                local ok = Window:LoadConfig(Window.ActiveConfig)
                Kami:Notify({
                    Title = ok and "Config Loaded" or "Load Failed",
                    Content = ok and ("Applied " .. Window.ActiveConfig) or "File could not be found or read.",
                    Duration = 2.5,
                })
            end,
        })

        settingsTab:AddButton({
            Title = "Delete Configuration",
            Description = "Remove the selected config file",
            ButtonText = "Delete",
            Callback = function()
                local name = Window.ActiveConfig
                if Window:DeleteConfig(name) then
                    configDropdown:SetValues(GetConfigList())
                    Kami:Notify({ Title = "Config Deleted", Content = "Removed " .. name, Duration = 2 })
                else
                    Kami:Notify({ Title = "Delete Failed", Content = "Config not found.", Duration = 2 })
                end
            end,
        })

        settingsTab:AddButton({
            Title = "Refresh List",
            Description = "Rescan the config folder",
            ButtonText = "Refresh",
            Callback = function()
                configDropdown:SetValues(GetConfigList())
            end,
        })

        settingsTab:AddToggle({
            Title = "Auto-Load On Launch",
            Description = "Load the selected config when the script runs",
            Default = Window.AutoLoad,
            Callback = function(state)
                Window.AutoLoad = state
                WriteAutoLoad()
            end,
        })
    end

    --================ DISCORD PROMPT ================
    if cfg.Discord and cfg.Discord.Enabled and cfg.Discord.Invite then
        task.delay(0.6, function()
            local inv = tostring(cfg.Discord.Invite)
            local inviteUrl = inv:match("^https?://") and inv or ("https://discord.gg/" .. inv)
            Kami:Notify({
                Title = "Discord Community",
                Content = cfg.Discord.Note or "Join our official community server for updates.",
                Duration = cfg.Discord.Duration or 8,
                Button = {
                    Text = "Copy Invite Link",
                    Callback = function()
                        local clip = setclipboard or toclipboard or (Clipboard and Clipboard.set)
                        if clip then
                            pcall(clip, inviteUrl)
                            Kami:Notify({ Title = "Copied", Content = "Discord link copied to clipboard.", Duration = 2 })
                        else
                            Kami:Notify({ Title = "Unsupported", Content = inviteUrl, Duration = 5 })
                        end
                    end,
                },
            })
        end)
    end

    --================ AUTO LOAD ================
    -- Delayed so the user script can finish creating every flagged element first.
    task.delay(1, function()
        if destroyed then return end
        if Window.AutoLoad then
            local ok = Window:LoadConfig(Window.ActiveConfig)
            if ok then
                Kami:Notify({ Title = "Auto-Load", Content = "Loaded config: " .. Window.ActiveConfig, Duration = 2 })
            end
        end
    end)

    function Window:Destroy()
        if destroyed then return end
        destroyed = true
        CloseDropdown()
        CloseColorPicker()
        for i = #connections, 1, -1 do
            pcall(function() connections[i]:Disconnect() end)
            connections[i] = nil
        end
        pcall(function()
            if MobileBtn then MobileBtn:Destroy() end
        end)
        pcall(function()
            if Screen then Screen:Destroy() end
        end)
        if getgenv and getgenv().KamiUIInstance then
            getgenv().KamiUIInstance = nil
        end
        Window.Visible = false
        Window.Tabs = {}
        Window.Flags = {}
    end

    return Window
end

function Kami:Destroy()
    pcall(function()
        if Screen then Screen:Destroy() end
    end)
    if getgenv and getgenv().KamiUIInstance then
        getgenv().KamiUIInstance = nil
    end
end

return Kami
