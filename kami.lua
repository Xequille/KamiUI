--[[
Kami UI v1.0.0 (Minimalist Dark & Gold Luxury - Sharp Edition)
Initial Release · Clean, Minimalist & Fast Roblox UI Library
]]

local KAMI = {}
KAMI.Version = "1.0.0"

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local function KAMI_C(r, g, b) return Color3.fromRGB(r, g, b) end

local KAMI_Brand = {
Font = Enum.Font.GothamMedium,
FontBody = Enum.Font.Gotham,
FontMono = Enum.Font.Code,
}

local KAMI_Themes = {
Default = {
Background = KAMI_C(11, 11, 12),
Card = KAMI_C(16, 16, 18),
CardHover = KAMI_C(22, 22, 25),
Border = KAMI_C(38, 35, 30),
BorderHover = KAMI_C(180, 145, 45),
TabActive = KAMI_C(20, 18, 14),
Text = KAMI_C(245, 243, 238),
TextDim = KAMI_C(130, 125, 115),
Accent = KAMI_C(212, 175, 55),       -- Pure Satin Gold
AccentDim = KAMI_C(145, 115, 35),   -- Deep Antique Gold
Success = KAMI_C(212, 175, 55),
Warning = KAMI_C(234, 179, 8),
Error = KAMI_C(225, 29, 72),
Info = KAMI_C(212, 175, 55),
},
Pitch = {
Background = KAMI_C(7, 7, 8), Card = KAMI_C(12, 12, 14), CardHover = KAMI_C(18, 18, 20),
Border = KAMI_C(30, 27, 22), BorderHover = KAMI_C(160, 130, 40), TabActive = KAMI_C(16, 14, 11),
Text = KAMI_C(240, 238, 233), TextDim = KAMI_C(110, 105, 96),
Accent = KAMI_C(212, 175, 55), AccentDim = KAMI_C(145, 115, 35),
},
Light = {
Background = KAMI_C(246, 245, 242), Card = KAMI_C(255, 255, 255), CardHover = KAMI_C(242, 240, 235),
Border = KAMI_C(215, 205, 190), BorderHover = KAMI_C(180, 142, 35), TabActive = KAMI_C(238, 232, 220),
Text = KAMI_C(26, 24, 20), TextDim = KAMI_C(130, 124, 114),
Accent = KAMI_C(180, 142, 35), AccentDim = KAMI_C(140, 108, 22),
},
Ocean = {
Background = KAMI_C(8, 14, 18), Card = KAMI_C(13, 20, 26), CardHover = KAMI_C(18, 27, 35),
Border = KAMI_C(28, 38, 44), BorderHover = KAMI_C(180, 145, 45), TabActive = KAMI_C(16, 26, 32),
Text = KAMI_C(235, 240, 242), TextDim = KAMI_C(115, 130, 138),
Accent = KAMI_C(212, 175, 55), AccentDim = KAMI_C(145, 115, 35),
},
Sunset = {
Background = KAMI_C(16, 12, 14), Card = KAMI_C(24, 18, 21), CardHover = KAMI_C(32, 24, 28),
Border = KAMI_C(44, 34, 38), BorderHover = KAMI_C(195, 145, 50), TabActive = KAMI_C(32, 22, 27),
Text = KAMI_C(245, 235, 238), TextDim = KAMI_C(135, 115, 122),
Accent = KAMI_C(224, 168, 62), AccentDim = KAMI_C(160, 115, 38),
},
Mono = {
Background = KAMI_C(12, 12, 12), Card = KAMI_C(18, 18, 18), CardHover = KAMI_C(25, 25, 25),
Border = KAMI_C(38, 38, 38), BorderHover = KAMI_C(180, 145, 45), TabActive = KAMI_C(26, 26, 26),
Text = KAMI_C(240, 240, 240), TextDim = KAMI_C(120, 120, 120),
Accent = KAMI_C(212, 175, 55), AccentDim = KAMI_C(145, 115, 35),
},
}

local KAMI_Theme = {}
for k, v in pairs(KAMI_Themes.Default) do KAMI_Theme[k] = v end
KAMI_Theme.Radius = 0
KAMI_Theme.RadiusWindow = 0

local KAMI_ThemeAliases = {
default = "Default", padrao = "Default",
pitch = "Pitch", escuro = "Pitch", dark = "Pitch",
light = "Light", claro = "Light",
ocean = "Ocean", oceano = "Ocean",
sunset = "Sunset",
mono = "Mono",
}

local KAMI_CurrentThemeName = "Default"
local KAMI_Painters = {}
local KAMI_TransSurf = {}
local KAMI_ThemeListeners = {}

local function KAMI_Paint(fn)
table.insert(KAMI_Painters, fn)
return fn
end

local function KAMI_RegTrans(inst)
table.insert(KAMI_TransSurf, inst)
return inst
end

local function KAMI_OnThemeChange(fn)
table.insert(KAMI_ThemeListeners, fn)
return fn
end

local function KAMI_Repaint()
for i = #KAMI_Painters, 1, -1 do
local ok = pcall(KAMI_Painters[i])
if not ok then table.remove(KAMI_Painters, i) end
end
end

local function KAMI_ApplyThemeAndRepaint(name)
local clean = tostring(name):lower():gsub("^%s+", ""):gsub("%s+$", "")
local resolved = KAMI_ThemeAliases[clean] or name
local t = KAMI_Themes[resolved] or KAMI_Themes.Default
KAMI_CurrentThemeName = resolved
for k, v in pairs(t) do KAMI_Theme[k] = v end
KAMI_Theme.Radius = 0
KAMI_Theme.RadiusWindow = 0
KAMI_Repaint()
for _, fn in ipairs(KAMI_ThemeListeners) do
pcall(fn, KAMI_CurrentThemeName)
end
end

function KAMI:SetTheme(name)
KAMI_ApplyThemeAndRepaint(name)
end

function KAMI:SetAccent(color)
KAMI_Theme.Accent = color
local r, g, b = color.R * 255, color.G * 255, color.B * 255
KAMI_Theme.AccentDim = KAMI_C(math.floor(r * 0.75), math.floor(g * 0.75), math.floor(b * 0.75))
KAMI_Repaint()
end

KAMI.Compat = {
files = (writefile and readfile and isfile) and true or false,
folders = (makefolder and isfolder) and true or false,
list = listfiles and true or false,
hui = gethui and true or false,
protect = protectgui and true or false,
http = request and true or false,
hooks = hookmetamethod and true or false,
}

local KAMI_LucideIcons = {
home = "rbxassetid://93110857987859",
settings = "rbxassetid://85241284670779",
cog = "rbxassetid://100080055332619",
zap = "rbxassetid://130551565616516",
eye = "rbxassetid://114138575379582",
["eye-off"] = "rbxassetid://79889764896824",
user = "rbxassetid://81589895647169",
users = "rbxassetid://115398113982385",
star = "rbxassetid://136141469398409",
shield = "rbxassetid://77608084747459",
key = "rbxassetid://79141369700910",
bell = "rbxassetid://97392696311902",
code = "rbxassetid://127982530911179",
lock = "rbxassetid://96647376545703",
unlock = "rbxassetid://104449445248964",
heart = "rbxassetid://128062038995140",
["heart-crack"] = "rbxassetid://87343101077175",
check = "rbxassetid://93898873302694",
x = "rbxassetid://110786993356448",
plus = "rbxassetid://74188213166406",
minus = "rbxassetid://97918467462219",
["chevron-right"] = "rbxassetid://132956012132591",
["chevron-left"] = "rbxassetid://73764397981677",
["chevron-down"] = "rbxassetid://134243273101015",
["chevron-up"] = "rbxassetid://73526580552431",
search = "rbxassetid://90429033607373",
download = "rbxassetid://123411060281846",
save = "rbxassetid://85888910775066",
trash = "rbxassetid://106723740584310",
edit = "rbxassetid://81811754321385",
terminal = "rbxassetid://106783148545356",
folder = "rbxassetid://122945524502470",
info = "rbxassetid://92425452073561",
warning = "rbxassetid://125920361880643",
error = "rbxassetid://114497774613488",
success = "rbxassetid://103617236554419",
power = "rbxassetid://88300581903213",
menu = "rbxassetid://90119697969636",
close = "rbxassetid://110786993356448",
palette = "rbxassetid://114665132072871",
refresh = "rbxassetid://109128258237016",
sliders = "rbxassetid://132977703952271",
target = "rbxassetid://87563802520297",
crosshair = "rbxassetid://103220493099356",
globe = "rbxassetid://129809231789785",
link = "rbxassetid://131112011281089",
github = "rbxassetid://102424727138621",
trophy = "rbxassetid://131545003268773",
crown = "rbxassetid://79944002922676",
gamepad = "rbxassetid://94845607019445",
["gamepad-2"] = "rbxassetid://114397333122561",
}

local function KAMI_GetIcon(icon)
if type(icon) == "string" then
local lower = icon:lower():gsub("^rbxassetid://", "")
if tonumber(lower) then return "rbxassetid://" .. lower end
return KAMI_LucideIcons[lower] or nil
elseif type(icon) == "number" then
return "rbxassetid://" .. tostring(icon)
end
return nil
end

local KAMI_TITLEBAR_HEIGHT = 44
local KAMI_SIDEBAR_WIDTH = 180
local KAMI_NOTIFY_WIDTH = 300
local KAMI_ConfigFolder = "KamiUI_Configs"
local KAMI_KeyFile = "kamiui_key.json"

local KAMI_GlobalTransparency = 0
local KAMI_AutoSave = true

local function KAMI_RandName(base)
return base .. "_" .. tostring(math.random(10000000, 99999999))
end

local function KAMI_GuiParent()
if gethui then return gethui() end
return CoreGui
end

local function KAMI_Hide(gui)
if protectgui then pcall(function() protectgui(gui) end) end
end

local function KAMI_Clamp(v, lo, hi) return math.clamp(v, lo, hi) end

local function KAMI_Round(v, s)
if s <= 0 then return v end
return math.floor(v / s + 0.5) * s
end

local function KAMI_Normalize(a, b)
if type(a) == "string" then
b = type(b) == "table" and b or {}
b.Title = b.Title or a
return b
end
return type(a) == "table" and a or {}
end

if getgenv and getgenv().KamiUI then
pcall(function() getgenv().KamiUI:Destroy() end)
end

local KAMI_Gui = Instance.new("ScreenGui")
KAMI_Gui.Name = KAMI_RandName("UI")
KAMI_Gui.ResetOnSpawn = false
KAMI_Gui.IgnoreGuiInset = true
KAMI_Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KAMI_Gui.Parent = KAMI_GuiParent()
KAMI_Hide(KAMI_Gui)

local KAMI_NotifyGui = Instance.new("ScreenGui")
KAMI_NotifyGui.Name = KAMI_RandName("Notify")
KAMI_NotifyGui.ResetOnSpawn = false
KAMI_NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KAMI_NotifyGui.DisplayOrder = 100
KAMI_NotifyGui.Parent = KAMI_GuiParent()
KAMI_Hide(KAMI_NotifyGui)

local KAMI_NotifyContainer = Instance.new("Frame")
KAMI_NotifyContainer.AnchorPoint = Vector2.new(1, 1)
KAMI_NotifyContainer.Position = UDim2.new(1, -24, 1, -24)
KAMI_NotifyContainer.Size = UDim2.fromOffset(KAMI_NOTIFY_WIDTH, 400)
KAMI_NotifyContainer.BackgroundTransparency = 1
KAMI_NotifyContainer.Parent = KAMI_NotifyGui

local KAMI_NotifyLayout = Instance.new("UIListLayout")
KAMI_NotifyLayout.Padding = UDim.new(0, 8)
KAMI_NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
KAMI_NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
KAMI_NotifyLayout.Parent = KAMI_NotifyContainer

local function KAMI_AddStroke(parent, color, thickness)
local s = Instance.new("UIStroke")
s.Color = color or KAMI_Theme.Border
s.Thickness = thickness or 1
local isTextObj = parent:IsA("TextBox") or parent:IsA("TextLabel") or parent:IsA("TextButton")
s.ApplyStrokeMode = isTextObj and Enum.ApplyStrokeMode.Border or Enum.ApplyStrokeMode.Contextual
s.Parent = parent
KAMI_Paint(function()
if isTextObj and parent:IsA("TextBox") then
if UserInputService:GetFocusedTextBox() ~= parent then
s.Color = KAMI_Theme.Border
end
else
s.Color = KAMI_Theme.Border
end
end)
return s
end

-- Sharp aesthetic: No rounded borders
local function KAMI_AddRadius(parent, radius)
return nil
end

local KAMI_DropdownPopup = Instance.new("Frame")
KAMI_DropdownPopup.Name = "KAMI_DropdownPopup"
KAMI_DropdownPopup.BackgroundColor3 = KAMI_Theme.Background
KAMI_DropdownPopup.BorderSizePixel = 0
KAMI_DropdownPopup.ClipsDescendants = true
KAMI_DropdownPopup.Visible = false
KAMI_DropdownPopup.ZIndex = 60
KAMI_DropdownPopup.Parent = KAMI_Gui
local KAMI_DropdownStroke = KAMI_AddStroke(KAMI_DropdownPopup, KAMI_Theme.Border)
KAMI_RegTrans(KAMI_DropdownPopup)
KAMI_Paint(function()
KAMI_DropdownPopup.BackgroundColor3 = KAMI_Theme.Background
end)

local KAMI_DropdownList = Instance.new("Frame")
KAMI_DropdownList.Size = UDim2.new(1, 0, 1, 0)
KAMI_DropdownList.BackgroundTransparency = 1
KAMI_DropdownList.ClipsDescendants = true
KAMI_DropdownList.ZIndex = 61
KAMI_DropdownList.Parent = KAMI_DropdownPopup

local KAMI_DropdownLayout = Instance.new("UIListLayout")
KAMI_DropdownLayout.Padding = UDim.new(0, 0)
KAMI_DropdownLayout.Parent = KAMI_DropdownList

local KAMI_DropdownPad = Instance.new("UIPadding")
KAMI_DropdownPad.PaddingTop = UDim.new(0, 2)
KAMI_DropdownPad.PaddingBottom = UDim.new(0, 2)
KAMI_DropdownPad.Parent = KAMI_DropdownList

local KAMI_DropdownCurrent = nil

local function KAMI_CloseDropdown()
if not KAMI_DropdownCurrent then return end
local prev = KAMI_DropdownCurrent
KAMI_DropdownCurrent = nil
if prev.sign and prev.sign.Parent then
TweenService:Create(prev.sign, TweenInfo.new(0.2, Enum.EasingStyle.Quint), { Rotation = 0 }):Play()
end
local w = KAMI_DropdownPopup.Size.X.Offset
TweenService:Create(KAMI_DropdownPopup, TweenInfo.new(0.15, Enum.EasingStyle.Quint), { Size = UDim2.fromOffset(w, 0) }):Play()
task.delay(0.16, function()
if not KAMI_DropdownCurrent then KAMI_DropdownPopup.Visible = false end
end)
end

local function KAMI_OpenDropdown(entry)
if not entry or not entry.trigger or not entry.trigger.Parent then return end
if KAMI_DropdownCurrent == entry then
KAMI_CloseDropdown()
return
end
if KAMI_DropdownCurrent and KAMI_DropdownCurrent.sign and KAMI_DropdownCurrent.sign.Parent then
TweenService:Create(KAMI_DropdownCurrent.sign, TweenInfo.new(0.2, Enum.EasingStyle.Quint), { Rotation = 0 }):Play()
end
KAMI_DropdownCurrent = entry
for _, child in ipairs(KAMI_DropdownList:GetChildren()) do
if child:IsA("TextButton") then child:Destroy() end
end
local values = entry.getValues()
for _, v in ipairs(values) do
local isSel = (v == entry.getValue())
local op = Instance.new("TextButton")
op.Size = UDim2.new(1, 0, 0, 30)
op.BackgroundColor3 = KAMI_Theme.CardHover
op.BackgroundTransparency = isSel and 0.5 or 1
op.Text = tostring(v)
op.Font = KAMI_Brand.FontBody
op.TextSize = 12
op.TextColor3 = isSel and KAMI_Theme.Accent or KAMI_Theme.TextDim
op.TextXAlignment = Enum.TextXAlignment.Left
op.AutoButtonColor = false
op.BorderSizePixel = 0
op.ZIndex = 61
op.Parent = KAMI_DropdownList
local opp = Instance.new("UIPadding")
opp.PaddingLeft = UDim.new(0, 14)
opp.Parent = op
op.MouseEnter:Connect(function()
TweenService:Create(op, TweenInfo.new(0.1), { TextColor3 = KAMI_Theme.Text, BackgroundTransparency = 0, BackgroundColor3 = KAMI_Theme.CardHover }):Play()
end)
op.MouseLeave:Connect(function()
local curSel = (v == entry.getValue())
TweenService:Create(op, TweenInfo.new(0.1), { TextColor3 = curSel and KAMI_Theme.Accent or KAMI_Theme.TextDim, BackgroundTransparency = curSel and 0.5 or 1 }):Play()
end)
op.MouseButton1Click:Connect(function()
entry.pick(v)
KAMI_CloseDropdown()
end)
end
local popH = math.min(#values * 30 + 4, 220)
local popW = entry.width or 150
local trigPos = entry.trigger.AbsolutePosition
local trigSize = entry.trigger.AbsoluteSize
local guiPos = KAMI_Gui.AbsolutePosition
local winPos = entry.windowFrame.AbsolutePosition
local winSize = entry.windowFrame.AbsoluteSize
local winX = winPos.X - guiPos.X
local winY = winPos.Y - guiPos.Y
local x = trigPos.X - guiPos.X + trigSize.X - popW
local y = trigPos.Y - guiPos.Y + trigSize.Y + 4
if y + popH > winY + winSize.Y - 6 then
y = trigPos.Y - guiPos.Y - popH - 4
end
x = KAMI_Clamp(x, winX + 6, winX + winSize.X - popW - 6)
y = KAMI_Clamp(y, winY + 6, winY + winSize.Y - popH - 6)
KAMI_DropdownPopup.Position = UDim2.fromOffset(x, y)
KAMI_DropdownPopup.Visible = true
KAMI_DropdownPopup.Size = UDim2.fromOffset(popW, 0)
if entry.sign then
TweenService:Create(entry.sign, TweenInfo.new(0.2, Enum.EasingStyle.Quint), { Rotation = 180 }):Play()
end
TweenService:Create(KAMI_DropdownPopup, TweenInfo.new(0.18, Enum.EasingStyle.Quint), { Size = UDim2.fromOffset(popW, popH) }):Play()
end

UserInputService.InputBegan:Connect(function(input, processed)
if processed then return end
if KAMI_DropdownCurrent and input.UserInputType == Enum.UserInputType.MouseButton1 then
local current = KAMI_DropdownCurrent
if not current.trigger or not current.trigger.Parent then
KAMI_DropdownCurrent = nil
KAMI_DropdownPopup.Visible = false
return
end
local pos = input.Position
local popPos = KAMI_DropdownPopup.AbsolutePosition
local popSize = KAMI_DropdownPopup.AbsoluteSize
local inPopup = pos.X >= popPos.X and pos.X <= popPos.X + popSize.X and pos.Y >= popPos.Y and pos.Y <= popPos.Y + popSize.Y
local trigPos = current.trigger.AbsolutePosition
local trigSize = current.trigger.AbsoluteSize
local inTrig = pos.X >= trigPos.X and pos.X <= trigPos.X + trigSize.X and pos.Y >= trigPos.Y and pos.Y <= trigPos.Y + trigSize.Y
if not inPopup and not inTrig then
KAMI_CloseDropdown()
end
end
end)

local function KAMI_MakeDraggable(frame, handle)
local dragging, start, startPos = false, nil, nil
handle.InputBegan:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
dragging = true; start = i.Position; startPos = frame.Position
end
end)
handle.InputEnded:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)
UserInputService.InputChanged:Connect(function(i)
if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
local d = i.Position - start
frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
end
end)
end

local function KAMI_NewRow(page, height)
local row = Instance.new("Frame")
row.Size = UDim2.new(1, 0, 0, height)
row.BackgroundColor3 = KAMI_Theme.Card
row.BackgroundTransparency = KAMI_GlobalTransparency
row.BorderSizePixel = 0
row.ClipsDescendants = true
row.Parent = page
local st = KAMI_AddStroke(row, KAMI_Theme.Border)
KAMI_RegTrans(row)
local hovering = false
KAMI_Paint(function()
row.BackgroundColor3 = hovering and KAMI_Theme.CardHover or KAMI_Theme.Card
st.Color = hovering and KAMI_Theme.BorderHover or KAMI_Theme.Border
end)
row.MouseEnter:Connect(function()
hovering = true
TweenService:Create(st, TweenInfo.new(0.15), { Color = KAMI_Theme.BorderHover }):Play()
TweenService:Create(row, TweenInfo.new(0.15), { BackgroundColor3 = KAMI_Theme.CardHover }):Play()
end)
row.MouseLeave:Connect(function()
hovering = false
TweenService:Create(st, TweenInfo.new(0.15), { Color = KAMI_Theme.Border }):Play()
TweenService:Create(row, TweenInfo.new(0.15), { BackgroundColor3 = KAMI_Theme.Card }):Play()
end)
return row
end

local function KAMI_RowTitle(row, text, desc, height, rightPad)
local pad = rightPad or 130
local l = Instance.new("TextLabel")
l.Position = UDim2.fromOffset(14, desc and 8 or 0)
l.Size = UDim2.new(1, -pad, 0, desc and 16 or (height or 44))
l.BackgroundTransparency = 1
l.Text = text
l.Font = KAMI_Brand.FontBody
l.TextSize = 13
l.TextColor3 = KAMI_Theme.Text
l.TextXAlignment = Enum.TextXAlignment.Left
l.TextTruncate = Enum.TextTruncate.AtEnd
l.Parent = row
KAMI_Paint(function() l.TextColor3 = KAMI_Theme.Text end)
if desc and desc ~= "" then
local d = Instance.new("TextLabel")
d.Position = UDim2.fromOffset(14, 26)
d.Size = UDim2.new(1, -pad, 0, 14)
d.BackgroundTransparency = 1
d.Text = desc
d.Font = KAMI_Brand.FontBody
d.TextSize = 11
d.TextColor3 = KAMI_Theme.TextDim
d.TextXAlignment = Enum.TextXAlignment.Left
d.TextTruncate = Enum.TextTruncate.AtEnd
d.Parent = row
KAMI_Paint(function() d.TextColor3 = KAMI_Theme.TextDim end)
end
return l
end

local function KAMI_SaveConfig(placeId, configName, data)
if not writefile then return false end
return pcall(function()
if not isfolder(KAMI_ConfigFolder) then makefolder(KAMI_ConfigFolder) end
writefile(KAMI_ConfigFolder .. "/" .. tostring(placeId) .. "_" .. configName .. ".json", HttpService:JSONEncode(data))
end)
end

local function KAMI_LoadConfig(placeId, configName)
if not readfile or not isfile then return nil end
local ok, data = pcall(function()
local p = KAMI_ConfigFolder .. "/" .. tostring(placeId) .. "_" .. configName .. ".json"
if isfile(p) then return HttpService:JSONDecode(readfile(p)) end
return nil
end)
return ok and data or nil
end

local function KAMI_DeleteConfig(placeId, configName)
if not delfile or not isfile then return false end
return pcall(function()
local p = KAMI_ConfigFolder .. "/" .. tostring(placeId) .. "_" .. configName .. ".json"
if isfile(p) then delfile(p) end
end)
end

local function KAMI_ListConfigs(placeId)
if not listfiles or not isfolder then return {} end
local configs = {}
local ok, files = pcall(function()
if isfolder(KAMI_ConfigFolder) then return listfiles(KAMI_ConfigFolder) end
return {}
end)
if not ok then return {} end
local base = tostring(placeId) .. "_"
for _, file in ipairs(files) do
local name = file:match("([^/\]+)$") or file
if name:sub(1, #base) == base and name:sub(-5) == ".json" then
table.insert(configs, name:sub(#base + 1, #name - 5))
end
end
return configs
end

local function KAMI_SaveKey(key, duration, filename)
if not writefile then return false end
return pcall(function()
writefile(filename or KAMI_KeyFile, HttpService:JSONEncode({ key = key, timestamp = os.time(), expiresAt = os.time() + (duration or 86400) }))
end)
end

local function KAMI_ClearKey(filename)
if not delfile then return false end
return pcall(function() if isfile(filename or KAMI_KeyFile) then delfile(filename or KAMI_KeyFile) end end)
end

local function KAMI_LoadKey(filename)
if not readfile or not isfile then return nil end
local ok, data = pcall(function()
if isfile(filename or KAMI_KeyFile) then
local d = HttpService:JSONDecode(readfile(filename or KAMI_KeyFile))
if d.expiresAt and os.time() > d.expiresAt then KAMI_ClearKey(filename) return nil end
return d.key
end
return nil
end)
return ok and data or nil
end

local KAMI_KeyDurationGlobal = 86400

local function KAMI_ValidateKey(key, validator)
if not key or key == "" then return false end
if type(validator) == "function" then
local success, result = pcall(validator, key)
return success and result == true
end
return false
end

local function KAMI_ShowLoadingScreen(title, subtitle, duration)
local gui = Instance.new("ScreenGui")
gui.Name = KAMI_RandName("Loading")
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 300
gui.Parent = KAMI_GuiParent()
KAMI_Hide(gui)
local holder = Instance.new("Frame")
holder.AnchorPoint = Vector2.new(0.5, 0.5)
holder.Position = UDim2.new(0.5, 0, 0.5, 0)
holder.Size = UDim2.fromOffset(420, 150)
holder.BackgroundTransparency = 1
holder.Parent = gui
local lay = Instance.new("UIListLayout")
lay.FillDirection = Enum.FillDirection.Vertical
lay.HorizontalAlignment = Enum.HorizontalAlignment.Center
lay.VerticalAlignment = Enum.VerticalAlignment.Center
lay.Padding = UDim.new(0, 10)
lay.Parent = holder
local letter = Instance.new("TextLabel")
letter.Size = UDim2.fromOffset(60, 60)
letter.BackgroundTransparency = 1
letter.Text = "K"
letter.Font = KAMI_Brand.Font
letter.TextSize = 44
letter.TextColor3 = KAMI_Theme.Accent
letter.TextTransparency = 1
letter.Parent = holder
KAMI_Paint(function() letter.TextColor3 = KAMI_Theme.Accent end)
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.fromOffset(420, 24)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = string.upper(title or "KAMI UI")
titleLabel.Font = KAMI_Brand.Font
titleLabel.TextSize = 16
titleLabel.TextColor3 = KAMI_Theme.Text
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
titleLabel.TextTransparency = 1
titleLabel.Parent = holder
KAMI_Paint(function() titleLabel.TextColor3 = KAMI_Theme.Text end)
local subLabel = Instance.new("TextLabel")
subLabel.Size = UDim2.fromOffset(420, 18)
subLabel.BackgroundTransparency = 1
subLabel.Text = subtitle or "Initializing environment..."
subLabel.Font = KAMI_Brand.FontBody
subLabel.TextSize = 12
subLabel.TextColor3 = KAMI_Theme.TextDim
subLabel.TextXAlignment = Enum.TextXAlignment.Center
subLabel.TextTruncate = Enum.TextTruncate.AtEnd
subLabel.TextTransparency = 1
subLabel.Parent = holder
KAMI_Paint(function() subLabel.TextColor3 = KAMI_Theme.TextDim end)
local fadeInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
TweenService:Create(letter, fadeInfo, { TextTransparency = 0 }):Play()
TweenService:Create(titleLabel, fadeInfo, { TextTransparency = 0 }):Play()
TweenService:Create(subLabel, fadeInfo, { TextTransparency = 0 }):Play()
task.wait(duration or 2)
local outInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
TweenService:Create(letter, outInfo, { TextTransparency = 1 }):Play()
TweenService:Create(titleLabel, outInfo, { TextTransparency = 1 }):Play()
TweenService:Create(subLabel, outInfo, { TextTransparency = 1 }):Play()
task.wait(0.32)
gui:Destroy()
end

local function KAMI_ShowDiscordPrompt(invite, callback)
local gui = Instance.new("ScreenGui")
gui.Name = KAMI_RandName("Discord")
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 250
gui.Parent = KAMI_GuiParent()
KAMI_Hide(gui)

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(460, 280)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundColor3 = KAMI_Theme.Background
frame.BorderSizePixel = 0
frame.Parent = gui
KAMI_AddStroke(frame, KAMI_Theme.Accent, 1)
KAMI_RegTrans(frame)
KAMI_Paint(function() frame.BackgroundColor3 = KAMI_Theme.Background end)

local iconFrame = Instance.new("Frame")
iconFrame.Size = UDim2.fromOffset(44, 44)
iconFrame.Position = UDim2.new(0.5, -22, 0, 24)
iconFrame.BackgroundColor3 = KAMI_Theme.Card
iconFrame.BorderSizePixel = 0
iconFrame.Parent = frame
KAMI_AddStroke(iconFrame, KAMI_Theme.Accent, 1)

local iconLetter = Instance.new("TextLabel")
iconLetter.Size = UDim2.new(1, 0, 1, 0)
iconLetter.BackgroundTransparency = 1
iconLetter.Text = "D"
iconLetter.Font = KAMI_Brand.Font
iconLetter.TextSize = 24
iconLetter.TextColor3 = KAMI_Theme.Accent
iconLetter.Parent = iconFrame
KAMI_Paint(function() iconLetter.TextColor3 = KAMI_Theme.Accent end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 24)
title.Position = UDim2.new(0.5, 0, 0, 84)
title.AnchorPoint = Vector2.new(0.5, 0)
title.BackgroundTransparency = 1
title.Text = "JOIN THE COMMUNITY"
title.Font = KAMI_Brand.Font
title.TextSize = 15
title.TextColor3 = KAMI_Theme.Text
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = frame
KAMI_Paint(function() title.TextColor3 = KAMI_Theme.Text end)

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1, -40, 0, 36)
sub.Position = UDim2.new(0.5, 0, 0, 112)
sub.AnchorPoint = Vector2.new(0.5, 0)
sub.BackgroundTransparency = 1
sub.Text = "Get real-time updates and exclusive access.\nCopy the invite link below to join."
sub.Font = KAMI_Brand.FontBody
sub.TextSize = 12
sub.TextColor3 = KAMI_Theme.TextDim
sub.TextXAlignment = Enum.TextXAlignment.Center
sub.TextWrapped = true
sub.Parent = frame
KAMI_Paint(function() sub.TextColor3 = KAMI_Theme.TextDim end)

local inviteLabel = Instance.new("Frame")
inviteLabel.Size = UDim2.new(1, -40, 0, 40)
inviteLabel.Position = UDim2.new(0.5, 0, 0, 156)
inviteLabel.AnchorPoint = Vector2.new(0.5, 0)
inviteLabel.BackgroundColor3 = KAMI_Theme.Card
inviteLabel.BorderSizePixel = 0
inviteLabel.Parent = frame
KAMI_AddStroke(inviteLabel, KAMI_Theme.Border)
KAMI_RegTrans(inviteLabel)
KAMI_Paint(function() inviteLabel.BackgroundColor3 = KAMI_Theme.Card end)

local inviteText = Instance.new("TextLabel")
inviteText.Size = UDim2.new(1, -20, 1, 0)
inviteText.BackgroundTransparency = 1
inviteText.Text = "discord.gg/" .. invite
inviteText.Font = KAMI_Brand.FontMono
inviteText.TextSize = 13
inviteText.TextColor3 = KAMI_Theme.Accent
inviteText.TextXAlignment = Enum.TextXAlignment.Center
inviteText.Parent = inviteLabel
KAMI_Paint(function() inviteText.TextColor3 = KAMI_Theme.Accent end)

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.48, 0, 0, 38)
copyBtn.Position = UDim2.new(0.02, 0, 0, 218)
copyBtn.BackgroundColor3 = KAMI_Theme.Card
copyBtn.BorderSizePixel = 0
copyBtn.Text = "COPY LINK"
copyBtn.Font = KAMI_Brand.Font
copyBtn.TextSize = 12
copyBtn.TextColor3 = KAMI_Theme.Accent
copyBtn.AutoButtonColor = false
copyBtn.Parent = frame
local cpySt = KAMI_AddStroke(copyBtn, KAMI_Theme.Accent, 1)
KAMI_Paint(function() copyBtn.BackgroundColor3 = KAMI_Theme.Card; copyBtn.TextColor3 = KAMI_Theme.Accent end)

local skipBtn = Instance.new("TextButton")
skipBtn.Size = UDim2.new(0.48, 0, 0, 38)
skipBtn.Position = UDim2.new(0.52, 0, 0, 218)
skipBtn.BackgroundColor3 = KAMI_Theme.Background
skipBtn.BorderSizePixel = 0
skipBtn.Text = "SKIP"
skipBtn.Font = KAMI_Brand.Font
skipBtn.TextSize = 12
skipBtn.TextColor3 = KAMI_Theme.TextDim
skipBtn.AutoButtonColor = false
skipBtn.Parent = frame
local skipSt = KAMI_AddStroke(skipBtn, KAMI_Theme.Border)
KAMI_Paint(function() skipBtn.BackgroundColor3 = KAMI_Theme.Background; skipBtn.TextColor3 = KAMI_Theme.TextDim end)

copyBtn.MouseEnter:Connect(function()
    TweenService:Create(copyBtn, TweenInfo.new(0.12), { BackgroundColor3 = KAMI_Theme.Accent, TextColor3 = KAMI_Theme.Background }):Play()
end)
copyBtn.MouseLeave:Connect(function()
    TweenService:Create(copyBtn, TweenInfo.new(0.12), { BackgroundColor3 = KAMI_Theme.Card, TextColor3 = KAMI_Theme.Accent }):Play()
end)

skipBtn.MouseEnter:Connect(function() TweenService:Create(skipSt, TweenInfo.new(0.12), { Color = KAMI_Theme.Accent }):Play() end)
skipBtn.MouseLeave:Connect(function() TweenService:Create(skipSt, TweenInfo.new(0.12), { Color = KAMI_Theme.Border }):Play() end)

copyBtn.MouseButton1Click:Connect(function()
    local link = "https://discord.gg/" .. invite
    local copied = false
    if setclipboard then
        setclipboard(link)
        copied = true
    elseif toclipboard then
        toclipboard(link)
        copied = true
    end
    if copied then
        copyBtn.Text = "COPIED"
        task.delay(1.5, function()
            if copyBtn.Parent then copyBtn.Text = "COPY LINK" end
        end)
    else
        copyBtn.Text = link
        task.delay(3, function()
            if copyBtn.Parent then copyBtn.Text = "COPY LINK" end
        end)
    end
    gui:Destroy()
    callback(true)
end)

skipBtn.MouseButton1Click:Connect(function() gui:Destroy(); callback(false) end)


end

local function KAMI_ShowKeyScreen(options, validator, callback)
local gui = Instance.new("ScreenGui")
gui.Name = KAMI_RandName("Key")
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 200
gui.Parent = KAMI_GuiParent()
KAMI_Hide(gui)
local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(420, 260)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundColor3 = KAMI_Theme.Background
frame.BorderSizePixel = 0
frame.Parent = gui
KAMI_AddStroke(frame, KAMI_Theme.Border, 1)
KAMI_RegTrans(frame)
KAMI_Paint(function() frame.BackgroundColor3 = KAMI_Theme.Background end)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -28, 0, 24)
title.Position = UDim2.fromOffset(16, 16)
title.BackgroundTransparency = 1
title.Text = string.upper(options.Title or "Enter Key")
title.Font = KAMI_Brand.Font
title.TextSize = 14
title.TextColor3 = KAMI_Theme.Text
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame
KAMI_Paint(function() title.TextColor3 = KAMI_Theme.Text end)
local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1, -28, 0, 16)
sub.Position = UDim2.fromOffset(16, 42)
sub.BackgroundTransparency = 1
sub.Text = options.Subtitle or "Authenticate your session to unlock access"
sub.Font = KAMI_Brand.FontBody
sub.TextSize = 12
sub.TextColor3 = KAMI_Theme.TextDim
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.Parent = frame
KAMI_Paint(function() sub.TextColor3 = KAMI_Theme.TextDim end)
local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -32, 0, 38)
input.Position = UDim2.fromOffset(16, 76)
input.BackgroundColor3 = KAMI_Theme.Card
input.BorderSizePixel = 0
input.Text = ""
input.PlaceholderText = "Paste access key..."
input.Font = KAMI_Brand.FontMono
input.TextSize = 12
input.TextColor3 = KAMI_Theme.Text
input.PlaceholderColor3 = KAMI_Theme.TextDim
input.TextXAlignment = Enum.TextXAlignment.Left
input.ClearTextOnFocus = false
input.Parent = frame
local ist = KAMI_AddStroke(input, KAMI_Theme.Border)
KAMI_RegTrans(input)
KAMI_Paint(function() input.BackgroundColor3 = KAMI_Theme.Card; input.TextColor3 = KAMI_Theme.Text; input.PlaceholderColor3 = KAMI_Theme.TextDim end)
local ip = Instance.new("UIPadding")
ip.PaddingLeft = UDim.new(0, 12); ip.PaddingRight = UDim.new(0, 12); ip.Parent = input
input.Focused:Connect(function() ist.Color = KAMI_Theme.Accent end)
input.FocusLost:Connect(function() ist.Color = KAMI_Theme.Border end)
local note = Instance.new("TextLabel")
note.Size = UDim2.new(1, -32, 0, 16)
note.Position = UDim2.fromOffset(16, 122)
note.BackgroundTransparency = 1
note.Text = options.Note or ""
note.Font = KAMI_Brand.FontBody
note.TextSize = 11
note.TextColor3 = KAMI_Theme.TextDim
note.TextXAlignment = Enum.TextXAlignment.Left
note.Parent = frame
KAMI_Paint(function() note.TextColor3 = KAMI_Theme.TextDim end)
local submit = Instance.new("TextButton")
submit.Size = UDim2.new(0.48, 0, 0, 36)
submit.Position = UDim2.new(0.04, 0, 0, 154)
submit.BackgroundColor3 = KAMI_Theme.Card
submit.BorderSizePixel = 0
submit.Text = "SUBMIT"
submit.Font = KAMI_Brand.Font
submit.TextSize = 12
submit.TextColor3 = KAMI_Theme.Accent
submit.AutoButtonColor = false
submit.Parent = frame
local sbst = KAMI_AddStroke(submit, KAMI_Theme.Accent, 1)
KAMI_Paint(function() submit.BackgroundColor3 = KAMI_Theme.Card; submit.TextColor3 = KAMI_Theme.Accent end)
submit.MouseEnter:Connect(function()
TweenService:Create(submit, TweenInfo.new(0.12), { BackgroundColor3 = KAMI_Theme.Accent, TextColor3 = KAMI_Theme.Background }):Play()
end)
submit.MouseLeave:Connect(function()
TweenService:Create(submit, TweenInfo.new(0.12), { BackgroundColor3 = KAMI_Theme.Card, TextColor3 = KAMI_Theme.Accent }):Play()
end)
local cancel = Instance.new("TextButton")
cancel.Size = UDim2.new(0.48, 0, 0, 36)
cancel.Position = UDim2.new(0.52, 0, 0, 154)
cancel.BackgroundColor3 = KAMI_Theme.Background
cancel.BorderSizePixel = 0
cancel.Text = "CANCEL"
cancel.Font = KAMI_Brand.Font
cancel.TextSize = 12
cancel.TextColor3 = KAMI_Theme.TextDim
cancel.AutoButtonColor = false
cancel.Parent = frame
local cst = KAMI_AddStroke(cancel, KAMI_Theme.Border)
KAMI_Paint(function() cancel.BackgroundColor3 = KAMI_Theme.Background; cancel.TextColor3 = KAMI_Theme.TextDim end)
cancel.MouseEnter:Connect(function() TweenService:Create(cst, TweenInfo.new(0.12), { Color = KAMI_Theme.Accent }):Play() end)
cancel.MouseLeave:Connect(function() TweenService:Create(cst, TweenInfo.new(0.12), { Color = KAMI_Theme.Border }):Play() end)
local err = Instance.new("TextLabel")
err.Size = UDim2.new(1, -32, 0, 18)
err.Position = UDim2.fromOffset(16, 204)
err.BackgroundTransparency = 1
err.Text = ""
err.Font = KAMI_Brand.FontBody
err.TextSize = 11
err.TextColor3 = KAMI_Theme.Error
err.TextXAlignment = Enum.TextXAlignment.Left
err.Parent = frame
local function doSubmit()
local key = input.Text
err.Text = "Authenticating..."
err.TextColor3 = KAMI_Theme.TextDim
task.spawn(function()
if KAMI_ValidateKey(key, validator) then
KAMI_SaveKey(key, KAMI_KeyDurationGlobal, options.FileName)
gui:Destroy()
callback(true, key)
else
err.Text = "Invalid access key. Please try again."
err.TextColor3 = KAMI_Theme.Error
input.Text = ""
end
end)
end
submit.MouseButton1Click:Connect(doSubmit)
input.FocusLost:Connect(function(enter) if enter then doSubmit() end end)
cancel.MouseButton1Click:Connect(function() gui:Destroy(); callback(false, nil) end)
input:CaptureFocus()
end

function KAMI:Notify(options)
options = options or {}
local t = options.Title or "KAMI UI"
local c = options.Content or ""
local d = options.Duration or 3
local style = (options.Style or "Info"):lower()
local buttons = options.Buttons or {}
local onOpen = options.OnOpen
local onClose = options.OnClose
local hasButtons = #buttons > 0
local height = hasButtons and 92 or 66
local styleColor = KAMI_Theme.Accent
if style == "success" then styleColor = KAMI_Theme.Success
elseif style == "warning" then styleColor = KAMI_Theme.Warning
elseif style == "error" then styleColor = KAMI_Theme.Error end

local holder = Instance.new("Frame")
holder.Size = UDim2.fromOffset(0, height)
holder.BackgroundTransparency = 1
holder.ClipsDescendants = true
holder.Parent = KAMI_NotifyContainer

local card = Instance.new("Frame")
card.Size = UDim2.fromOffset(KAMI_NOTIFY_WIDTH, height)
card.BackgroundColor3 = KAMI_Theme.Card
card.BackgroundTransparency = KAMI_GlobalTransparency
card.BorderSizePixel = 0
card.Parent = holder
KAMI_AddStroke(card, KAMI_Theme.Border)
KAMI_RegTrans(card)
KAMI_Paint(function() card.BackgroundColor3 = KAMI_Theme.Card end)

local bar = Instance.new("Frame")
bar.Size = UDim2.new(0, 2, 1, 0)
bar.Position = UDim2.fromOffset(0, 0)
bar.BackgroundColor3 = styleColor
bar.BorderSizePixel = 0
bar.Parent = card

local tl = Instance.new("TextLabel")
tl.Position = UDim2.fromOffset(14, 10)
tl.Size = UDim2.new(1, -24, 0, 16)
tl.BackgroundTransparency = 1
tl.Text = string.upper(t)
tl.Font = KAMI_Brand.Font
tl.TextSize = 12
tl.TextColor3 = KAMI_Theme.Accent
tl.TextXAlignment = Enum.TextXAlignment.Left
tl.TextTruncate = Enum.TextTruncate.AtEnd
tl.Parent = card
KAMI_Paint(function() tl.TextColor3 = KAMI_Theme.Accent end)

local cl = Instance.new("TextLabel")
cl.Position = UDim2.fromOffset(14, 28)
cl.Size = UDim2.new(1, -24, 0, 28)
cl.BackgroundTransparency = 1
cl.Text = c
cl.Font = KAMI_Brand.FontBody
cl.TextSize = 12
cl.TextColor3 = KAMI_Theme.TextDim
cl.TextXAlignment = Enum.TextXAlignment.Left
cl.TextYAlignment = Enum.TextYAlignment.Top
cl.TextWrapped = true
cl.Parent = card
KAMI_Paint(function() cl.TextColor3 = KAMI_Theme.TextDim end)

if hasButtons then
    local btnRow = Instance.new("Frame")
    btnRow.Size = UDim2.new(1, -28, 0, 24)
    btnRow.Position = UDim2.fromOffset(14, 58)
    btnRow.BackgroundTransparency = 1
    btnRow.Parent = card
    local btnLayout = Instance.new("UIListLayout")
    btnLayout.FillDirection = Enum.FillDirection.Horizontal
    btnLayout.Padding = UDim.new(0, 6)
    btnLayout.Parent = btnRow
    for _, btnData in ipairs(buttons) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.5, -3, 1, 0)
        btn.BackgroundColor3 = KAMI_Theme.Background
        btn.BorderSizePixel = 0
        btn.Text = string.upper(btnData.Title)
        btn.Font = KAMI_Brand.Font
        btn.TextSize = 10
        btn.TextColor3 = KAMI_Theme.Text
        btn.AutoButtonColor = false
        btn.Parent = btnRow
        local bst = KAMI_AddStroke(btn, KAMI_Theme.Border)
        KAMI_Paint(function() btn.BackgroundColor3 = KAMI_Theme.Background; btn.TextColor3 = KAMI_Theme.Text end)
        btn.MouseEnter:Connect(function() TweenService:Create(bst, TweenInfo.new(0.12), { Color = KAMI_Theme.Accent }):Play() end)
        btn.MouseLeave:Connect(function() TweenService:Create(bst, TweenInfo.new(0.12), { Color = KAMI_Theme.Border }):Play() end)
        btn.MouseButton1Click:Connect(function()
            if btnData.Callback then btnData.Callback() end
            holder:Destroy()
            if onClose then onClose("Action") end
        end)
    end
end
if onOpen then onOpen() end
TweenService:Create(holder, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(KAMI_NOTIFY_WIDTH, height) }):Play()
if d > 0 then
    task.delay(d, function()
        if not holder.Parent then return end
        TweenService:Create(holder, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Size = UDim2.fromOffset(0, height) }):Play()
        task.wait(0.22)
        holder:Destroy()
        if onClose then onClose("Timeout") end
    end)
end


end

function KAMI:CreateWindow(options)
options = options or {}
local KAMI_Name = options.Name or "KAMI UI"
local KAMI_SubTitle = options.SubTitle or ""
local KAMI_Size = options.Size or UDim2.fromOffset(630, 440)
local KAMI_MinKey = options.MinimizeKey or Enum.KeyCode.RightControl
local KAMI_ConfigId = options.ConfigId or tostring(game.PlaceId)
KAMI_KeyDurationGlobal = options.KeyDuration or 86400
KAMI_GlobalTransparency = KAMI_Clamp(options.Transparency or 0, 0, 0.9)
local KAMI_AutoLoad = options.AutoLoad ~= false

if options.LoadingTitle then
    KAMI_ShowLoadingScreen(options.LoadingTitle, options.LoadingSubtitle or "", options.LoadingDuration or 2)
end
if options.Discord and options.Discord.Enabled then
    local resolved = false
    KAMI_ShowDiscordPrompt(options.Discord.Invite, function() resolved = true end)
    while not resolved do task.wait(0.1) end
end
if options.KeySystem and options.KeySystem.Enabled then
    local keyOptions = { Title = options.KeySystem.Title, Subtitle = options.KeySystem.Subtitle, Note = options.KeySystem.Note, FileName = options.KeySystem.FileName }
    local savedKey = KAMI_LoadKey(options.KeySystem.FileName)
    if not (savedKey and KAMI_ValidateKey(savedKey, options.KeySystem.validator)) then
        local resolved, success = false, false
        KAMI_ShowKeyScreen(keyOptions, options.KeySystem.validator, function(s) success = s; resolved = true end)
        while not resolved do task.wait(0.1) end
        if not success then
            KAMI:Notify({ Title = "Kami UI", Content = "Access denied.", Style = "Error", Duration = 3 })
            return nil
        end
    end
end

local KAMI_Window = {}
KAMI_Window.Minimized = false
KAMI_Window.ConfigData = {}
KAMI_Window.Elements = {}
KAMI_Window.CurrentConfig = "default"

local function KAMI_BuildWindow()
    local frame = Instance.new("Frame")
    frame.Name = "Window"
    frame.Size = UDim2.fromOffset(KAMI_Size.X.Offset * 0.96, KAMI_Size.Y.Offset * 0.96)
    frame.Position = UDim2.new(0.5, -(KAMI_Size.X.Offset * 0.96) / 2, 0.5, -(KAMI_Size.Y.Offset * 0.96) / 2)
    frame.BackgroundColor3 = KAMI_Theme.Background
    frame.BackgroundTransparency = KAMI_GlobalTransparency
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = KAMI_Gui
    KAMI_AddStroke(frame, KAMI_Theme.Border, 1)
    KAMI_RegTrans(frame)
    KAMI_Paint(function() frame.BackgroundColor3 = KAMI_Theme.Background end)
    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = KAMI_Size, Position = UDim2.new(0.5, -KAMI_Size.X.Offset / 2, 0.5, -KAMI_Size.Y.Offset / 2)
    }):Play()

    local titlebar = Instance.new("Frame")
    titlebar.Size = UDim2.new(1, 0, 0, KAMI_TITLEBAR_HEIGHT)
    titlebar.BackgroundColor3 = KAMI_Theme.Card
    titlebar.BackgroundTransparency = KAMI_GlobalTransparency
    titlebar.BorderSizePixel = 0
    titlebar.Parent = frame
    KAMI_RegTrans(titlebar)
    KAMI_Paint(function() titlebar.BackgroundColor3 = KAMI_Theme.Card end)

    local tline = Instance.new("Frame")
    tline.Size = UDim2.new(1, 0, 0, 1)
    tline.Position = UDim2.new(0, 0, 1, -1)
    tline.BackgroundColor3 = KAMI_Theme.Border
    tline.BorderSizePixel = 0
    tline.Parent = titlebar
    KAMI_Paint(function() tline.BackgroundColor3 = KAMI_Theme.Border end)

    local logoLetter = Instance.new("TextLabel")
    logoLetter.Size = UDim2.fromOffset(26, 26)
    logoLetter.Position = UDim2.new(0, 14, 0.5, -13)
    logoLetter.BackgroundTransparency = 1
    logoLetter.Text = "◆"
    logoLetter.Font = KAMI_Brand.FontBody
    logoLetter.TextSize = 14
    logoLetter.TextColor3 = KAMI_Theme.Accent
    logoLetter.TextXAlignment = Enum.TextXAlignment.Center
    logoLetter.Parent = titlebar
    KAMI_Paint(function() logoLetter.TextColor3 = KAMI_Theme.Accent end)

    local tholder = Instance.new("Frame")
    tholder.BackgroundTransparency = 1
    tholder.Size = UDim2.new(1, -120, 1, 0)
    tholder.Position = UDim2.fromOffset(46, 0)
    tholder.Parent = titlebar
    local tlay = Instance.new("UIListLayout")
    tlay.FillDirection = Enum.FillDirection.Horizontal
    tlay.VerticalAlignment = Enum.VerticalAlignment.Center
    tlay.Padding = UDim.new(0, 8)
    tlay.Parent = tholder

    local tlabel = Instance.new("TextLabel")
    tlabel.BackgroundTransparency = 1
    tlabel.Size = UDim2.fromOffset(0, 20)
    tlabel.AutomaticSize = Enum.AutomaticSize.X
    tlabel.Text = string.upper(KAMI_Name)
    tlabel.Font = KAMI_Brand.Font
    tlabel.TextSize = 13
    tlabel.TextColor3 = KAMI_Theme.Text
    tlabel.Parent = tholder
    KAMI_Paint(function() tlabel.TextColor3 = KAMI_Theme.Text end)

    local tdiv = Instance.new("TextLabel")
    tdiv.BackgroundTransparency = 1
    tdiv.Size = UDim2.fromOffset(6, 20)
    tdiv.Text = "/"
    tdiv.Font = KAMI_Brand.FontMono
    tdiv.TextSize = 12
    tdiv.TextColor3 = KAMI_Theme.AccentDim
    tdiv.Parent = tholder
    KAMI_Paint(function() tdiv.TextColor3 = KAMI_Theme.AccentDim end)

    local slabel = Instance.new("TextLabel")
    slabel.BackgroundTransparency = 1
    slabel.Size = UDim2.fromOffset(0, 18)
    slabel.AutomaticSize = Enum.AutomaticSize.X
    slabel.Text = string.lower(KAMI_SubTitle)
    slabel.Font = KAMI_Brand.FontMono
    slabel.TextSize = 11
    slabel.TextColor3 = KAMI_Theme.TextDim
    slabel.Parent = tholder
    KAMI_Paint(function() slabel.TextColor3 = KAMI_Theme.TextDim end)

    local minbtn = Instance.new("TextButton")
    minbtn.Size = UDim2.fromOffset(28, 28)
    minbtn.Position = UDim2.new(1, -38, 0.5, -14)
    minbtn.BackgroundColor3 = KAMI_Theme.CardHover
    minbtn.BackgroundTransparency = 1
    minbtn.Text = ""
    minbtn.AutoButtonColor = false
    minbtn.BorderSizePixel = 0
    minbtn.Parent = titlebar
    
    local minicon = Instance.new("Frame")
    minicon.Size = UDim2.fromOffset(12, 1)
    minicon.Position = UDim2.new(0.5, -6, 0.5, 0)
    minicon.BackgroundColor3 = KAMI_Theme.TextDim
    minicon.BorderSizePixel = 0
    minicon.Parent = minbtn
    KAMI_Paint(function() minicon.BackgroundColor3 = KAMI_Theme.TextDim end)

    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, KAMI_SIDEBAR_WIDTH, 1, -KAMI_TITLEBAR_HEIGHT)
    sidebar.Position = UDim2.new(0, 0, 0, KAMI_TITLEBAR_HEIGHT)
    sidebar.BackgroundColor3 = KAMI_Theme.Card
    sidebar.BackgroundTransparency = KAMI_GlobalTransparency
    sidebar.BorderSizePixel = 0
    sidebar.ClipsDescendants = true
    sidebar.Parent = frame
    KAMI_RegTrans(sidebar)
    KAMI_Paint(function() sidebar.BackgroundColor3 = KAMI_Theme.Card end)

    local tabsContainer = Instance.new("Frame")
    tabsContainer.Size = UDim2.new(1, 0, 1, 0)
    tabsContainer.Position = UDim2.new(0, 0, 0, 0)
    tabsContainer.BackgroundTransparency = 1
    tabsContainer.ClipsDescendants = true
    tabsContainer.Parent = sidebar

    local slay = Instance.new("UIListLayout")
    slay.Padding = UDim.new(0, 2)
    slay.Parent = tabsContainer

    local spad = Instance.new("UIPadding")
    spad.PaddingTop = UDim.new(0, 10)
    spad.PaddingBottom = UDim.new(0, 10)
    spad.PaddingLeft = UDim.new(0, 8)
    spad.PaddingRight = UDim.new(0, 8)
    spad.Parent = tabsContainer

    local sline = Instance.new("Frame")
    sline.Size = UDim2.new(0, 1, 1, -KAMI_TITLEBAR_HEIGHT)
    sline.Position = UDim2.new(0, KAMI_SIDEBAR_WIDTH - 1, 0, KAMI_TITLEBAR_HEIGHT)
    sline.BackgroundColor3 = KAMI_Theme.Border
    sline.BorderSizePixel = 0
    sline.Parent = frame
    KAMI_Paint(function() sline.BackgroundColor3 = KAMI_Theme.Border end)

    local content = Instance.new("Frame")
    content.Position = UDim2.new(0, KAMI_SIDEBAR_WIDTH, 0, KAMI_TITLEBAR_HEIGHT)
    content.Size = UDim2.new(1, -KAMI_SIDEBAR_WIDTH, 1, -KAMI_TITLEBAR_HEIGHT)
    content.BackgroundTransparency = 1
    content.ClipsDescendants = true
    content.Parent = frame

    local wm = Instance.new("TextLabel")
    wm.AnchorPoint = Vector2.new(1, 1)
    wm.Position = UDim2.new(1, -14, 1, -8)
    wm.Size = UDim2.fromOffset(160, 14)
    wm.BackgroundTransparency = 1
    wm.Text = "KAMI UI · v" .. KAMI.Version
    wm.Font = KAMI_Brand.FontMono
    wm.TextSize = 10
    wm.TextColor3 = KAMI_Theme.TextDim
    wm.TextXAlignment = Enum.TextXAlignment.Right
    wm.Parent = frame
    KAMI_Paint(function() wm.TextColor3 = KAMI_Theme.TextDim end)

    local registry = {}
    local activeData = nil

    local function selectTab(target)
        KAMI_CloseDropdown()
        activeData = target
        for _, d in ipairs(registry) do
            d.Active = (d == target)
            d.Page.Visible = d.Active
            TweenService:Create(d.Button, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                BackgroundTransparency = d.Active and 0 or 1
            }):Play()
            TweenService:Create(d.Label, TweenInfo.new(0.12), {
                TextColor3 = d.Active and KAMI_Theme.Text or KAMI_Theme.TextDim
            }):Play()
            if d.Icon then
                TweenService:Create(d.Icon, TweenInfo.new(0.12), {
                    ImageColor3 = d.Active and KAMI_Theme.Accent or KAMI_Theme.TextDim
                }):Play()
            end
            TweenService:Create(d.Indicator, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = d.Active and UDim2.new(0, 2, 0, 18) or UDim2.new(0, 0, 0, 0)
            }):Play()
        end
    end

    local function setMinimized(state)
        if not frame.Parent then return end
        KAMI_CloseDropdown()
        if state then
            local focused = UserInputService:GetFocusedTextBox()
            if focused then focused:ReleaseFocus() end
        end
        KAMI_Window.Minimized = state
        frame.Visible = not state
    end

    minbtn.MouseEnter:Connect(function()
        TweenService:Create(minbtn, TweenInfo.new(0.12), { BackgroundTransparency = 0 }):Play()
        TweenService:Create(minicon, TweenInfo.new(0.12), { BackgroundColor3 = KAMI_Theme.Accent }):Play()
    end)
    minbtn.MouseLeave:Connect(function()
        TweenService:Create(minbtn, TweenInfo.new(0.12), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(minicon, TweenInfo.new(0.12), { BackgroundColor3 = KAMI_Theme.TextDim }):Play()
    end)
    minbtn.MouseButton1Click:Connect(function() setMinimized(not KAMI_Window.Minimized) end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == KAMI_MinKey then setMinimized(not KAMI_Window.Minimized) end
    end)

    KAMI_MakeDraggable(frame, titlebar)

    function KAMI_Window:AddTab(opt)
        opt = opt or {}
        local tabTitle = opt.Title or "Tab"
        local tabIcon = KAMI_GetIcon(opt.Icon)
        local data = {}
        local tab = {}

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 34)
        btn.BackgroundColor3 = KAMI_Theme.TabActive
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.Parent = tabsContainer

        local indicator = Instance.new("Frame")
        indicator.Position = UDim2.fromOffset(2, 8)
        indicator.Size = UDim2.new(0, 0, 0, 0)
        indicator.BackgroundColor3 = KAMI_Theme.Accent
        indicator.BorderSizePixel = 0
        indicator.Parent = btn

        local iconLbl = nil
        local iconOffset = 12
        if tabIcon then
            iconLbl = Instance.new("ImageLabel")
            iconLbl.Size = UDim2.fromOffset(15, 15)
            iconLbl.Position = UDim2.new(0, 14, 0.5, -7)
            iconLbl.BackgroundTransparency = 1
            iconLbl.Image = tabIcon
            iconLbl.ImageColor3 = KAMI_Theme.TextDim
            iconLbl.Parent = btn
            iconOffset = 38
        end

        local lbl = Instance.new("TextLabel")
        lbl.Position = UDim2.fromOffset(iconOffset, 0)
        lbl.Size = UDim2.new(1, -(iconOffset + 6), 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = tabTitle
        lbl.Font = KAMI_Brand.FontBody
        lbl.TextSize = 13
        lbl.TextColor3 = KAMI_Theme.TextDim
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextTruncate = Enum.TextTruncate.AtEnd
        lbl.Parent = btn

        data.Button = btn; data.Label = lbl; data.Page = nil; data.Icon = iconLbl
        data.Indicator = indicator; data.Active = false

        KAMI_Paint(function()
            btn.BackgroundColor3 = KAMI_Theme.TabActive
            indicator.BackgroundColor3 = KAMI_Theme.Accent
            if data.Active then
                lbl.TextColor3 = KAMI_Theme.Text
                if iconLbl then iconLbl.ImageColor3 = KAMI_Theme.Accent end
            else
                lbl.TextColor3 = KAMI_Theme.TextDim
                if iconLbl then iconLbl.ImageColor3 = KAMI_Theme.TextDim end
            end
        end)

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = KAMI_Theme.AccentDim
        KAMI_Paint(function() page.ScrollBarImageColor3 = KAMI_Theme.AccentDim end)
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.Visible = false
        page.Parent = content
        data.Page = page
        local play = Instance.new("UIListLayout")
        play.Padding = UDim.new(0, 8); play.Parent = page
        local ppad = Instance.new("UIPadding")
        ppad.PaddingTop = UDim.new(0, 16); ppad.PaddingBottom = UDim.new(0, 16)
        ppad.PaddingLeft = UDim.new(0, 18); ppad.PaddingRight = UDim.new(0, 18); ppad.Parent = page

        table.insert(registry, data)

        btn.MouseEnter:Connect(function()
            if not data.Active then
                TweenService:Create(lbl, TweenInfo.new(0.12), { TextColor3 = KAMI_Theme.Text }):Play()
                if iconLbl then
                    TweenService:Create(iconLbl, TweenInfo.new(0.12), { ImageColor3 = KAMI_Theme.Text }):Play()
                end
            end
        end)
        btn.MouseLeave:Connect(function()
            if not data.Active then
                TweenService:Create(lbl, TweenInfo.new(0.12), { TextColor3 = KAMI_Theme.TextDim }):Play()
                if iconLbl then
                    TweenService:Create(iconLbl, TweenInfo.new(0.12), { ImageColor3 = KAMI_Theme.TextDim }):Play()
                end
            end
        end)
        btn.MouseButton1Click:Connect(function() selectTab(data) end)
        if #registry == 1 then selectTab(data) end

        function tab:AddSection(o)
            o = o or {}
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1, 0, 0, 28)
            holder.BackgroundTransparency = 1
            holder.Parent = page
            local line1 = Instance.new("Frame")
            line1.Size = UDim2.new(1, 0, 0, 1)
            line1.Position = UDim2.new(0, 0, 0.5, 0)
            line1.BackgroundColor3 = KAMI_Theme.Border
            line1.BorderSizePixel = 0
            line1.Parent = holder
            KAMI_Paint(function() line1.BackgroundColor3 = KAMI_Theme.Border end)
            
            local tag = Instance.new("Frame")
            tag.AutomaticSize = Enum.AutomaticSize.X
            tag.Size = UDim2.new(0, 0, 0, 18)
            tag.Position = UDim2.new(0, 12, 0.5, -9)
            tag.BackgroundColor3 = KAMI_Theme.Background
            tag.BorderSizePixel = 0
            tag.Parent = holder
            KAMI_Paint(function() tag.BackgroundColor3 = KAMI_Theme.Background end)
            
            local tpad = Instance.new("UIPadding")
            tpad.PaddingLeft = UDim.new(0, 6)
            tpad.PaddingRight = UDim.new(0, 6)
            tpad.Parent = tag

            local t = Instance.new("TextLabel")
            t.Size = UDim2.new(0, 0, 1, 0)
            t.AutomaticSize = Enum.AutomaticSize.X
            t.BackgroundTransparency = 1
            t.Text = string.upper(o.Title or "")
            t.Font = KAMI_Brand.FontMono
            t.TextSize = 10
            t.TextColor3 = KAMI_Theme.Accent
            t.TextXAlignment = Enum.TextXAlignment.Center
            t.Parent = tag
            KAMI_Paint(function() t.TextColor3 = KAMI_Theme.Accent end)
            
            local obj = {}
            function obj:Set(x) t.Text = string.upper(x or "") end
            return obj
        end

        function tab:AddDivider()
            local div = Instance.new("Frame")
            div.Size = UDim2.new(1, 0, 0, 1)
            div.BackgroundColor3 = KAMI_Theme.Border
            div.BorderSizePixel = 0
            div.Parent = page
            KAMI_Paint(function() div.BackgroundColor3 = KAMI_Theme.Border end)
            local obj = {}
            function obj:Set(v) div.Visible = v end
            return obj
        end

        function tab:AddParagraph(a, b)
            local o = KAMI_Normalize(a, b)
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 0)
            row.AutomaticSize = Enum.AutomaticSize.Y
            row.BackgroundColor3 = KAMI_Theme.Card
            row.BackgroundTransparency = KAMI_GlobalTransparency
            row.BorderSizePixel = 0
            row.Parent = page
            KAMI_AddStroke(row, KAMI_Theme.Border)
            KAMI_RegTrans(row)
            KAMI_Paint(function() row.BackgroundColor3 = KAMI_Theme.Card end)
            
            local accentBar = Instance.new("Frame")
            accentBar.Size = UDim2.new(0, 2, 1, 0)
            accentBar.Position = UDim2.new(0, 0, 0, 0)
            accentBar.BackgroundColor3 = KAMI_Theme.AccentDim
            accentBar.BorderSizePixel = 0
            accentBar.Parent = row
            KAMI_Paint(function() accentBar.BackgroundColor3 = KAMI_Theme.AccentDim end)

            local lay = Instance.new("UIListLayout")
            lay.Padding = UDim.new(0, 4); lay.Parent = row
            local pad = Instance.new("UIPadding")
            pad.PaddingLeft = UDim.new(0, 16); pad.PaddingRight = UDim.new(0, 14)
            pad.PaddingTop = UDim.new(0, 12); pad.PaddingBottom = UDim.new(0, 12); pad.Parent = row
            local cl = nil
            if o.Title and o.Title ~= "" then
                local pt = Instance.new("TextLabel")
                pt.Size = UDim2.new(1, 0, 0, 0); pt.AutomaticSize = Enum.AutomaticSize.Y
                pt.BackgroundTransparency = 1; pt.Text = o.Title
                pt.Font = KAMI_Brand.Font; pt.TextSize = 13; pt.TextColor3 = KAMI_Theme.Text
                pt.TextXAlignment = Enum.TextXAlignment.Left; pt.TextWrapped = true; pt.Parent = row
                KAMI_Paint(function() pt.TextColor3 = KAMI_Theme.Text end)
            end
            if o.Content and o.Content ~= "" then
                cl = Instance.new("TextLabel")
                cl.Size = UDim2.new(1, 0, 0, 0); cl.AutomaticSize = Enum.AutomaticSize.Y
                cl.BackgroundTransparency = 1; cl.Text = o.Content
                cl.Font = KAMI_Brand.FontBody; cl.TextSize = 12; cl.TextColor3 = KAMI_Theme.TextDim
                cl.TextXAlignment = Enum.TextXAlignment.Left; cl.TextWrapped = true; cl.Parent = row
                KAMI_Paint(function() cl.TextColor3 = KAMI_Theme.TextDim end)
            end
            local obj = {}
            function obj:Set(x) if cl then cl.Text = x or "" end end
            return obj
        end

        function tab:AddLabel(text)
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 0)
            row.AutomaticSize = Enum.AutomaticSize.Y
            row.BackgroundTransparency = 1
            row.Parent = page
            local pad = Instance.new("UIPadding")
            pad.PaddingLeft = UDim.new(0, 12); pad.PaddingRight = UDim.new(0, 12); pad.Parent = row
            local t = Instance.new("TextLabel")
            t.Size = UDim2.new(1, 0, 0, 0); t.AutomaticSize = Enum.AutomaticSize.Y
            t.BackgroundTransparency = 1; t.Text = text or ""
            t.Font = KAMI_Brand.FontBody; t.TextSize = 12; t.TextColor3 = KAMI_Theme.TextDim
            t.TextXAlignment = Enum.TextXAlignment.Left; t.TextWrapped = true; t.Parent = row
            KAMI_Paint(function() t.TextColor3 = KAMI_Theme.TextDim end)
            local obj = {}
            function obj:Set(x) t.Text = x or "" end
            return obj
        end

        function tab:AddToggle(a, b)
            local o = KAMI_Normalize(a, b)
            local cb = o.Callback or function() end
            local id = o.Flag or o.Id or o.Title or "toggle_" .. os.clock()
            local obj = { Value = o.Default and true or false, Id = id, Flag = o.Flag, Type = "toggle", Default = o.Default and true or false }
            local row = KAMI_NewRow(page, 44)
            KAMI_RowTitle(row, o.Title or "Toggle", o.Description, 44)
            
            -- Sharp Minimalist Check-box Box Style
            local box = Instance.new("Frame")
            box.Size = UDim2.fromOffset(20, 20)
            box.Position = UDim2.new(1, -38, 0.5, -10)
            box.BackgroundColor3 = KAMI_Theme.Background
            box.BorderSizePixel = 0
            box.Parent = row
            local boxStroke = KAMI_AddStroke(box, KAMI_Theme.BorderHover, 1)
            
            local inner = Instance.new("Frame")
            inner.Size = UDim2.fromOffset(12, 12)
            inner.Position = UDim2.fromOffset(4, 4)
            inner.BackgroundColor3 = KAMI_Theme.Accent
            inner.BorderSizePixel = 0
            inner.Parent = box

            local function paintToggle()
                local on = obj.Value
                boxStroke.Color = on and KAMI_Theme.Accent or KAMI_Theme.Border
                inner.Visible = on
                inner.BackgroundColor3 = KAMI_Theme.Accent
            end
            KAMI_Paint(paintToggle)

            local function renderTween()
                local on = obj.Value
                inner.Visible = on
                TweenService:Create(boxStroke, TweenInfo.new(0.12), { Color = on and KAMI_Theme.Accent or KAMI_Theme.Border }):Play()
                if on then
                    inner.Size = UDim2.fromOffset(6, 6)
                    inner.Position = UDim2.fromOffset(7, 7)
                    TweenService:Create(inner, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Size = UDim2.fromOffset(12, 12),
                        Position = UDim2.fromOffset(4, 4)
                    }):Play()
                end
            end
            function obj:Set(state, silent)
                obj.Value = state and true or false
                renderTween()
                if not silent then
                    cb(obj.Value)
                    if obj.Flag and KAMI_AutoSave then
                        KAMI_Window.ConfigData[id] = { type = "toggle", value = obj.Value }
                        KAMI_Window:SaveConfig(KAMI_Window.CurrentConfig)
                    end
                end
            end
            row.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then obj:Set(not obj.Value) end
            end)
            paintToggle()
            if obj.Flag then table.insert(KAMI_Window.Elements, obj) end
            return obj
        end

        function tab:AddButton(a, b)
            local o = KAMI_Normalize(a, b)
            local cb = o.Callback or function() end
            local obj = {}
            local row = KAMI_NewRow(page, 44)
            KAMI_RowTitle(row, o.Title or "Button", o.Description, 44)
            
            -- Sharp luxury bordered button
            local act = Instance.new("TextButton")
            act.Size = UDim2.fromOffset(92, 28)
            act.Position = UDim2.new(1, -106, 0.5, -14)
            act.BackgroundColor3 = KAMI_Theme.Background
            act.BorderSizePixel = 0
            act.Text = string.upper(o.ButtonText or "RUN")
            act.Font = KAMI_Brand.FontMono
            act.TextSize = 11
            act.TextColor3 = KAMI_Theme.Accent
            act.AutoButtonColor = false
            act.Parent = row
            local ast = KAMI_AddStroke(act, KAMI_Theme.AccentDim, 1)
            
            KAMI_Paint(function()
                act.BackgroundColor3 = KAMI_Theme.Background
                act.TextColor3 = KAMI_Theme.Accent
                ast.Color = KAMI_Theme.AccentDim
            end)
            act.MouseEnter:Connect(function()
                TweenService:Create(act, TweenInfo.new(0.12), { BackgroundColor3 = KAMI_Theme.Accent, TextColor3 = KAMI_Theme.Background }):Play()
                TweenService:Create(ast, TweenInfo.new(0.12), { Color = KAMI_Theme.Accent }):Play()
            end)
            act.MouseLeave:Connect(function()
                TweenService:Create(act, TweenInfo.new(0.12), { BackgroundColor3 = KAMI_Theme.Background, TextColor3 = KAMI_Theme.Accent }):Play()
                TweenService:Create(ast, TweenInfo.new(0.12), { Color = KAMI_Theme.AccentDim }):Play()
            end)
            function obj:Fire()
                TweenService:Create(act, TweenInfo.new(0.08), { Size = UDim2.fromOffset(88, 26) }):Play()
                task.delay(0.08, function()
                    if act.Parent then
                        TweenService:Create(act, TweenInfo.new(0.12, Enum.EasingStyle.Quint), { Size = UDim2.fromOffset(92, 28) }):Play()
                    end
                end)
                cb()
            end
            act.MouseButton1Click:Connect(function() obj:Fire() end)
            function obj:SetTitle(t) act.Text = string.upper(t or "") end
            return obj
        end

        function tab:AddSlider(a, b)
            local o = KAMI_Normalize(a, b)
            local mn, mx, st = o.Min or 0, o.Max or 100, o.Step or 1
            local cb = o.Callback or function() end
            local id = o.Flag or o.Id or o.Title or "slider_" .. os.clock()
            local obj = { Value = o.Default or mn, Id = id, Flag = o.Flag, Type = "slider", Default = o.Default or mn }
            local dragging = false
            local row = KAMI_NewRow(page, 58)
            local tl = Instance.new("TextLabel")
            tl.Position = UDim2.fromOffset(14, 10)
            tl.Size = UDim2.new(1, -110, 0, 16)
            tl.BackgroundTransparency = 1
            tl.Text = o.Title or "Slider"
            tl.Font = KAMI_Brand.FontBody; tl.TextSize = 13; tl.TextColor3 = KAMI_Theme.Text
            tl.TextXAlignment = Enum.TextXAlignment.Left; tl.TextTruncate = Enum.TextTruncate.AtEnd
            tl.Parent = row
            KAMI_Paint(function() tl.TextColor3 = KAMI_Theme.Text end)
            
            local vl = Instance.new("TextLabel")
            vl.AnchorPoint = Vector2.new(1, 0)
            vl.Position = UDim2.new(1, -14, 0, 10)
            vl.Size = UDim2.fromOffset(80, 16)
            vl.BackgroundTransparency = 1
            vl.Font = KAMI_Brand.FontMono; vl.TextSize = 12; vl.TextColor3 = KAMI_Theme.Accent
            vl.TextXAlignment = Enum.TextXAlignment.Right
            vl.Parent = row
            KAMI_Paint(function() vl.TextColor3 = KAMI_Theme.Accent end)
            
            -- Ultra-minimalist thin line slider with sharp thumb
            local track = Instance.new("Frame")
            track.Position = UDim2.fromOffset(14, 38)
            track.Size = UDim2.new(1, -28, 0, 2)
            track.BackgroundColor3 = KAMI_Theme.BorderHover
            track.BorderSizePixel = 0
            track.Parent = row
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(0, 0, 1, 0)
            fill.BackgroundColor3 = KAMI_Theme.Accent
            fill.BorderSizePixel = 0
            fill.Parent = track
            
            local knob = Instance.new("Frame")
            knob.AnchorPoint = Vector2.new(0.5, 0.5)
            knob.Size = UDim2.fromOffset(8, 14)
            knob.Position = UDim2.new(0, 0, 0.5, 0)
            knob.BackgroundColor3 = KAMI_Theme.Accent
            knob.BorderSizePixel = 0
            knob.Parent = track
            
            local cap = Instance.new("TextButton")
            cap.Position = UDim2.fromOffset(14, 26)
            cap.Size = UDim2.new(1, -28, 0, 24)
            cap.BackgroundTransparency = 1
            cap.Text = ""
            cap.AutoButtonColor = false
            cap.Parent = row
            
            local function fmt(n)
                if st >= 1 then return tostring(math.floor(n + 0.5)) end
                return string.format("%.1f", n)
            end
            local function refreshVisual()
                local r = (mx - mn) == 0 and 0 or (obj.Value - mn) / (mx - mn)
                fill.Size = UDim2.new(r, 0, 1, 0)
                knob.Position = UDim2.new(r, 0, 0.5, 0)
                vl.Text = fmt(obj.Value)
            end
            KAMI_Paint(function()
                track.BackgroundColor3 = KAMI_Theme.BorderHover
                fill.BackgroundColor3 = KAMI_Theme.Accent
                knob.BackgroundColor3 = KAMI_Theme.Accent
                refreshVisual()
            end)
            local function apply(raw, silent)
                local v = KAMI_Round(KAMI_Clamp(raw, mn, mx), st)
                obj.Value = v
                refreshVisual()
                if not silent then
                    cb(v)
                    if obj.Flag and KAMI_AutoSave then
                        KAMI_Window.ConfigData[id] = { type = "slider", value = v }
                        KAMI_Window:SaveConfig(KAMI_Window.CurrentConfig)
                    end
                end
            end
            local function fromPtr(x)
                local w = track.AbsoluteSize.X
                if w <= 0 then return obj.Value end
                return mn + KAMI_Clamp((x - track.AbsolutePosition.X) / w, 0, 1) * (mx - mn)
            end
            cap.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = true; apply(fromPtr(i.Position.X), false)
                end
            end)
            cap.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                    apply(fromPtr(i.Position.X), false)
                end
            end)
            function obj:Set(n, silent) apply(tonumber(n) or mn, silent) end
            apply(obj.Value, true)
            if obj.Flag then table.insert(KAMI_Window.Elements, obj) end
            return obj
        end

        function tab:AddDropdown(a, b)
            local o = KAMI_Normalize(a, b)
            local values = o.Values or o.Options or {}
            local cb = o.Callback or function() end
            local id = o.Flag or o.Id or o.Title or "dropdown_" .. os.clock()
            local obj = { Value = o.Default, Id = id, Flag = o.Flag, Type = "dropdown", Default = o.Default }
            local row = KAMI_NewRow(page, 44)
            KAMI_RowTitle(row, o.Title or "Dropdown", o.Description, 44, 190)
            
            local trigger = Instance.new("TextButton")
            trigger.Size = UDim2.fromOffset(160, 26)
            trigger.Position = UDim2.new(1, -174, 0.5, -13)
            trigger.BackgroundColor3 = KAMI_Theme.Background
            trigger.BorderSizePixel = 0
            trigger.Text = ""
            trigger.AutoButtonColor = false
            trigger.Parent = row
            local trgSt = KAMI_AddStroke(trigger, KAMI_Theme.Border)
            
            local trigText = Instance.new("TextLabel")
            trigText.Size = UDim2.new(1, -28, 1, 0)
            trigText.Position = UDim2.fromOffset(10, 0)
            trigText.BackgroundTransparency = 1
            trigText.Text = obj.Value and tostring(obj.Value) or "None"
            trigText.Font = KAMI_Brand.FontMono
            trigText.TextSize = 11
            trigText.TextColor3 = KAMI_Theme.Text
            trigText.TextXAlignment = Enum.TextXAlignment.Left
            trigText.TextTruncate = Enum.TextTruncate.AtEnd
            trigText.Parent = trigger
            
            local sign = Instance.new("ImageLabel")
            sign.AnchorPoint = Vector2.new(1, 0.5)
            sign.Position = UDim2.new(1, -8, 0.5, 0)
            sign.Size = UDim2.fromOffset(12, 12)
            sign.BackgroundTransparency = 1
            sign.Image = KAMI_LucideIcons["chevron-down"]
            sign.ImageColor3 = KAMI_Theme.AccentDim
            sign.Parent = trigger
            KAMI_Paint(function()
                trigger.BackgroundColor3 = KAMI_Theme.Background
                trigText.TextColor3 = KAMI_Theme.Text
                sign.ImageColor3 = KAMI_Theme.AccentDim
            end)
            local entry = {
                trigger = trigger,
                sign = sign,
                windowFrame = frame,
                width = 174,
                getValues = function() return values end,
                getValue = function() return obj.Value end,
                pick = function(v) obj:Set(v, false) end,
            }
            function obj:Set(v, silent)
                obj.Value = v
                trigText.Text = tostring(v)
                if not silent then
                    cb(v)
                    if obj.Flag and KAMI_AutoSave then
                        KAMI_Window.ConfigData[id] = { type = "dropdown", value = v }
                        KAMI_Window:SaveConfig(KAMI_Window.CurrentConfig)
                    end
                end
            end
            function obj:SetValues(newValues)
                values = newValues
                if KAMI_DropdownCurrent == entry then
                    KAMI_CloseDropdown()
                end
            end
            trigger.MouseButton1Click:Connect(function()
                KAMI_OpenDropdown(entry)
            end)
            if obj.Flag then table.insert(KAMI_Window.Elements, obj) end
            return obj
        end

        function tab:AddInput(a, b)
            local o = KAMI_Normalize(a, b)
            local cb = o.Callback or function() end
            local id = o.Flag or o.Id or o.Title or "input_" .. os.clock()
            local obj = { Value = o.Default or "", Id = id, Flag = o.Flag, Type = "input", Default = o.Default or "" }
            local row = KAMI_NewRow(page, 44)
            KAMI_RowTitle(row, o.Title or "Input", o.Description, 44, 190)
            
            local box = Instance.new("TextBox")
            box.Size = UDim2.fromOffset(160, 26)
            box.Position = UDim2.new(1, -174, 0.5, -13)
            box.BackgroundColor3 = KAMI_Theme.Background
            box.BorderSizePixel = 0
            box.Text = obj.Value
            box.Font = KAMI_Brand.FontMono
            box.TextSize = 11
            box.TextColor3 = KAMI_Theme.Text
            box.PlaceholderText = o.Placeholder or "..."
            box.PlaceholderColor3 = KAMI_Theme.TextDim
            box.TextXAlignment = Enum.TextXAlignment.Left
            box.ClearTextOnFocus = false
            box.Parent = row
            local bst = KAMI_AddStroke(box, KAMI_Theme.Border)
            KAMI_RegTrans(box)
            KAMI_Paint(function()
                box.BackgroundColor3 = KAMI_Theme.Background
                box.TextColor3 = KAMI_Theme.Text
                box.PlaceholderColor3 = KAMI_Theme.TextDim
            end)
            local bpad = Instance.new("UIPadding")
            bpad.PaddingLeft = UDim.new(0, 10); bpad.PaddingRight = UDim.new(0, 10); bpad.Parent = box
            box.Focused:Connect(function() bst.Color = KAMI_Theme.Accent end)
            box.FocusLost:Connect(function()
                bst.Color = KAMI_Theme.Border
                obj:Set(box.Text, false)
            end)
            function obj:Set(t, silent)
                obj.Value = t or ""
                box.Text = obj.Value
                if not silent then
                    cb(obj.Value)
                    if obj.Flag and KAMI_AutoSave then
                        KAMI_Window.ConfigData[id] = { type = "input", value = t }
                        KAMI_Window:SaveConfig(KAMI_Window.CurrentConfig)
                    end
                end
            end
            if obj.Flag then table.insert(KAMI_Window.Elements, obj) end
            return obj
        end

        function tab:AddTextArea(a, b)
            local o = KAMI_Normalize(a, b)
            local cb = o.Callback or function() end
            local id = o.Flag or o.Id or o.Title or "textarea_" .. os.clock()
            local obj = { Value = o.Default or "", Id = id, Flag = o.Flag, Type = "textarea", Default = o.Default or "" }
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 110)
            row.BackgroundColor3 = KAMI_Theme.Card
            row.BackgroundTransparency = KAMI_GlobalTransparency
            row.BorderSizePixel = 0
            row.Parent = page
            KAMI_AddStroke(row, KAMI_Theme.Border)
            KAMI_RegTrans(row)
            KAMI_Paint(function() row.BackgroundColor3 = KAMI_Theme.Card end)
            
            local tl = Instance.new("TextLabel")
            tl.Position = UDim2.fromOffset(14, 10)
            tl.Size = UDim2.new(1, -28, 0, 16)
            tl.BackgroundTransparency = 1
            tl.Text = o.Title or "Text Area"
            tl.Font = KAMI_Brand.FontBody; tl.TextSize = 13; tl.TextColor3 = KAMI_Theme.Text
            tl.TextXAlignment = Enum.TextXAlignment.Left
            tl.Parent = row
            KAMI_Paint(function() tl.TextColor3 = KAMI_Theme.Text end)
            
            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, -28, 0, 70)
            box.Position = UDim2.fromOffset(14, 30)
            box.BackgroundColor3 = KAMI_Theme.Background
            box.BorderSizePixel = 0
            box.Text = obj.Value
            box.Font = KAMI_Brand.FontMono; box.TextSize = 11; box.TextColor3 = KAMI_Theme.Text
            box.PlaceholderText = o.Placeholder or "..."
            box.PlaceholderColor3 = KAMI_Theme.TextDim
            box.TextXAlignment = Enum.TextXAlignment.Left
            box.TextYAlignment = Enum.TextYAlignment.Top
            box.TextWrapped = true
            box.ClearTextOnFocus = false
            box.MultiLine = true
            box.Parent = row
            local bst = KAMI_AddStroke(box, KAMI_Theme.Border)
            KAMI_RegTrans(box)
            KAMI_Paint(function()
                box.BackgroundColor3 = KAMI_Theme.Background
                box.TextColor3 = KAMI_Theme.Text
                box.PlaceholderColor3 = KAMI_Theme.TextDim
            end)
            local bpad = Instance.new("UIPadding")
            bpad.PaddingLeft = UDim.new(0, 10); bpad.PaddingRight = UDim.new(0, 10)
            bpad.PaddingTop = UDim.new(0, 8); bpad.PaddingBottom = UDim.new(0, 8); bpad.Parent = box
            box.Focused:Connect(function() bst.Color = KAMI_Theme.Accent end)
            box.FocusLost:Connect(function()
                bst.Color = KAMI_Theme.Border
                obj:Set(box.Text, false)
            end)
            function obj:Set(t, silent)
                obj.Value = t or ""
                box.Text = obj.Value
                if not silent then
                    cb(obj.Value)
                    if obj.Flag and KAMI_AutoSave then
                        KAMI_Window.ConfigData[id] = { type = "textarea", value = t }
                        KAMI_Window:SaveConfig(KAMI_Window.CurrentConfig)
                    end
                end
            end
            if obj.Flag then table.insert(KAMI_Window.Elements, obj) end
            return obj
        end

        function tab:AddProgressBar(a, b)
            local o = KAMI_Normalize(a, b)
            local obj = { Value = o.Default or 0 }
            local row = KAMI_NewRow(page, 48)
            local tl = Instance.new("TextLabel")
            tl.Position = UDim2.fromOffset(14, 10)
            tl.Size = UDim2.new(1, -80, 0, 16)
            tl.BackgroundTransparency = 1
            tl.Text = o.Title or "Progress"
            tl.Font = KAMI_Brand.FontBody; tl.TextSize = 13; tl.TextColor3 = KAMI_Theme.Text
            tl.TextXAlignment = Enum.TextXAlignment.Left
            tl.Parent = row
            KAMI_Paint(function() tl.TextColor3 = KAMI_Theme.Text end)
            
            local vl = Instance.new("TextLabel")
            vl.AnchorPoint = Vector2.new(1, 0)
            vl.Position = UDim2.new(1, -14, 0, 10)
            vl.Size = UDim2.fromOffset(60, 16)
            vl.BackgroundTransparency = 1
            vl.Font = KAMI_Brand.FontMono; vl.TextSize = 12; vl.TextColor3 = KAMI_Theme.Accent
            vl.TextXAlignment = Enum.TextXAlignment.Right
            vl.Text = tostring(obj.Value) .. "%"
            vl.Parent = row
            KAMI_Paint(function() vl.TextColor3 = KAMI_Theme.Accent end)
            
            local track = Instance.new("Frame")
            track.Position = UDim2.fromOffset(14, 32)
            track.Size = UDim2.new(1, -28, 0, 2)
            track.BackgroundColor3 = KAMI_Theme.BorderHover
            track.BorderSizePixel = 0
            track.Parent = row
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(obj.Value / 100, 0, 1, 0)
            fill.BackgroundColor3 = KAMI_Theme.Accent
            fill.BorderSizePixel = 0
            fill.Parent = track
            KAMI_Paint(function()
                track.BackgroundColor3 = KAMI_Theme.BorderHover
                fill.BackgroundColor3 = KAMI_Theme.Accent
            end)
            function obj:Set(val)
                obj.Value = KAMI_Clamp(val, 0, 100)
                TweenService:Create(fill, TweenInfo.new(0.2, Enum.EasingStyle.Quint), { Size = UDim2.new(obj.Value / 100, 0, 1, 0) }):Play()
                vl.Text = tostring(obj.Value) .. "%"
            end
            return obj
        end

        function tab:AddColorPicker(a, b)
            local o = KAMI_Normalize(a, b)
            local cb = o.Callback or function() end
            local id = o.Flag or o.Id or o.Title or "color_" .. os.clock()
            local def = o.Default or Color3.fromRGB(212, 175, 55)
            local obj = { Value = def, Id = id, Flag = o.Flag, Type = "color", Default = def }
            local open = false
            local r, g, b = math.floor(def.R * 255), math.floor(def.G * 255), math.floor(def.B * 255)
            local row = KAMI_NewRow(page, 44)
            KAMI_RowTitle(row, o.Title or "Color", o.Description, 44, 90)
            
            local sw = Instance.new("Frame")
            sw.Size = UDim2.fromOffset(24, 24)
            sw.Position = UDim2.new(1, -52, 0.5, -12)
            sw.BackgroundColor3 = obj.Value
            sw.BorderSizePixel = 0
            sw.Parent = row
            KAMI_AddStroke(sw, KAMI_Theme.Border)
            
            local sign = Instance.new("ImageLabel")
            sign.AnchorPoint = Vector2.new(1, 0)
            sign.Position = UDim2.new(1, -14, 0, 0)
            sign.Size = UDim2.fromOffset(14, 44)
            sign.BackgroundTransparency = 1
            sign.Image = KAMI_LucideIcons["chevron-down"]
            sign.ImageColor3 = KAMI_Theme.AccentDim
            sign.Parent = row
            KAMI_Paint(function() sign.ImageColor3 = KAMI_Theme.AccentDim end)
            
            local panel = Instance.new("Frame")
            panel.Position = UDim2.fromOffset(1, 44)
            panel.Size = UDim2.new(1, -2, 0, 0)
            panel.BackgroundColor3 = KAMI_Theme.Background
            panel.BorderSizePixel = 0
            panel.ClipsDescendants = true
            panel.Parent = row
            KAMI_RegTrans(panel)
            KAMI_Paint(function() panel.BackgroundColor3 = KAMI_Theme.Background end)
            local play2 = Instance.new("UIListLayout"); play2.Padding = UDim.new(0, 8); play2.Parent = panel
            local ppad2 = Instance.new("UIPadding")
            ppad2.PaddingTop = UDim.new(0, 10); ppad2.PaddingBottom = UDim.new(0, 10)
            ppad2.PaddingLeft = UDim.new(0, 14); ppad2.PaddingRight = UDim.new(0, 14); ppad2.Parent = panel
            local updateScheduled = false
            local function update(silent)
                obj.Value = Color3.fromRGB(r, g, b)
                sw.BackgroundColor3 = obj.Value
                if silent then return end
                if updateScheduled then return end
                updateScheduled = true
                task.delay(0.08, function()
                    updateScheduled = false
                    cb(obj.Value)
                    if obj.Flag and KAMI_AutoSave then
                        KAMI_Window.ConfigData[id] = { type = "color", value = { math.floor(obj.Value.R * 255), math.floor(obj.Value.G * 255), math.floor(obj.Value.B * 255) } }
                        KAMI_Window:SaveConfig(KAMI_Window.CurrentConfig)
                    end
                end)
            end
            local function channel(letter, get, set)
                local holder = Instance.new("Frame")
                holder.Size = UDim2.new(1, 0, 0, 20)
                holder.BackgroundTransparency = 1
                holder.Parent = panel
                local lab = Instance.new("TextLabel")
                lab.Size = UDim2.fromOffset(14, 20)
                lab.BackgroundTransparency = 1
                lab.Text = letter
                lab.Font = KAMI_Brand.FontMono; lab.TextSize = 11; lab.TextColor3 = KAMI_Theme.AccentDim
                lab.TextXAlignment = Enum.TextXAlignment.Left
                lab.Parent = holder
                KAMI_Paint(function() lab.TextColor3 = KAMI_Theme.AccentDim end)
                
                local track = Instance.new("Frame")
                track.Position = UDim2.fromOffset(24, 9)
                track.Size = UDim2.new(1, -70, 0, 2)
                track.BackgroundColor3 = KAMI_Theme.BorderHover
                track.BorderSizePixel = 0
                track.Parent = holder
                
                local fill = Instance.new("Frame")
                fill.Size = UDim2.new(get() / 255, 0, 1, 0)
                fill.BackgroundColor3 = KAMI_Theme.Accent
                fill.BorderSizePixel = 0
                fill.Parent = track
                
                local cvl = Instance.new("TextLabel")
                cvl.AnchorPoint = Vector2.new(1, 0)
                cvl.Position = UDim2.new(1, 0, 0, 2)
                cvl.Size = UDim2.fromOffset(36, 16)
                cvl.BackgroundTransparency = 1
                cvl.Font = KAMI_Brand.FontMono; cvl.TextSize = 11; cvl.TextColor3 = KAMI_Theme.TextDim
                cvl.TextXAlignment = Enum.TextXAlignment.Right
                cvl.Text = tostring(get())
                cvl.Parent = holder
                KAMI_Paint(function()
                    track.BackgroundColor3 = KAMI_Theme.BorderHover
                    fill.BackgroundColor3 = KAMI_Theme.Accent
                    cvl.TextColor3 = KAMI_Theme.TextDim
                end)
                local cap = Instance.new("TextButton")
                cap.Position = UDim2.fromOffset(24, 0)
                cap.Size = UDim2.new(1, -70, 0, 20)
                cap.BackgroundTransparency = 1
                cap.Text = ""
                cap.AutoButtonColor = false
                cap.Parent = holder
                local drag = false
                local function apply(x)
                    local w = track.AbsoluteSize.X
                    if w <= 0 then return end
                    local v = math.floor(KAMI_Clamp((x - track.AbsolutePosition.X) / w, 0, 1) * 255)
                    set(v)
                    fill.Size = UDim2.new(v / 255, 0, 1, 0)
                    cvl.Text = tostring(v)
                    update(false)
                end
                cap.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; apply(i.Position.X) end
                end)
                cap.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then apply(i.Position.X) end
                end)
            end
            channel("R", function() return r end, function(v) r = v end)
            channel("G", function() return g end, function(v) g = v end)
            channel("B", function() return b end, function(v) b = v end)
            local function setOpen(s)
                open = s
                TweenService:Create(sign, TweenInfo.new(0.2, Enum.EasingStyle.Quint), { Rotation = s and 180 or 0 }):Play()
                local h = s and 100 or 0
                TweenService:Create(row, TweenInfo.new(0.18, Enum.EasingStyle.Quint), { Size = UDim2.new(1, 0, 0, 44 + h) }):Play()
                TweenService:Create(panel, TweenInfo.new(0.18, Enum.EasingStyle.Quint), { Size = UDim2.new(1, -2, 0, h) }):Play()
            end
            row.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    if i.Position.Y < row.AbsolutePosition.Y + 44 then setOpen(not open) end
                end
            end)
            function obj:Set(color, silent)
                r = math.floor(color.R * 255); g = math.floor(color.G * 255); b = math.floor(color.B * 255)
                update(silent)
            end
            if obj.Flag then table.insert(KAMI_Window.Elements, obj) end
            return obj
        end

        function tab:AddKeybind(a, b)
            local o = KAMI_Normalize(a, b)
            local cb = o.Callback or function() end
            local id = o.Flag or o.Id or o.Title or "keybind_" .. os.clock()
            local obj = { Value = o.Default, Id = id, Flag = o.Flag, Type = "keybind", Default = o.Default }
            local listening = false
            local row = KAMI_NewRow(page, 44)
            KAMI_RowTitle(row, o.Title or "Keybind", o.Description, 44, 100)
            
            local kl = Instance.new("TextButton")
            kl.Position = UDim2.new(1, -84, 0.5, -13)
            kl.Size = UDim2.fromOffset(70, 26)
            kl.BackgroundColor3 = KAMI_Theme.Background
            kl.BorderSizePixel = 0
            kl.Text = obj.Value and string.upper(obj.Value.Name) or "NONE"
            kl.Font = KAMI_Brand.FontMono
            kl.TextSize = 11
            kl.TextColor3 = KAMI_Theme.Text
            kl.TextXAlignment = Enum.TextXAlignment.Center
            kl.AutoButtonColor = false
            kl.Parent = row
            local klst = KAMI_AddStroke(kl, KAMI_Theme.Border)
            KAMI_RegTrans(kl)
            KAMI_Paint(function()
                kl.BackgroundColor3 = KAMI_Theme.Background
                kl.TextColor3 = KAMI_Theme.Text
                if not listening then klst.Color = KAMI_Theme.Border end
            end)
            UserInputService.InputBegan:Connect(function(input, processed)
                if listening then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        if input.KeyCode == Enum.KeyCode.Escape then
                            listening = false
                            kl.Text = obj.Value and string.upper(obj.Value.Name) or "NONE"
                            klst.Color = KAMI_Theme.Border
                        else
                            obj.Value = input.KeyCode
                            listening = false
                            kl.Text = string.upper(input.KeyCode.Name)
                            klst.Color = KAMI_Theme.Border
                            cb(input.KeyCode)
                            if obj.Flag and KAMI_AutoSave then
                                KAMI_Window.ConfigData[id] = { type = "keybind", value = input.KeyCode.Name }
                                KAMI_Window:SaveConfig(KAMI_Window.CurrentConfig)
                            end
                        end
                    end
                    return
                end
                if obj.Value and input.KeyCode == obj.Value and not processed then
                    if not UserInputService:GetFocusedTextBox() then cb() end
                end
            end)
            kl.MouseEnter:Connect(function() if not listening then klst.Color = KAMI_Theme.Accent end end)
            kl.MouseLeave:Connect(function() if not listening then klst.Color = KAMI_Theme.Border end end)
            kl.MouseButton1Click:Connect(function()
                listening = true
                kl.Text = "..."
                klst.Color = KAMI_Theme.Accent
            end)
            function obj:Set(key, silent)
                obj.Value = key
                kl.Text = key and string.upper(key.Name) or "NONE"
                if not silent and obj.Flag and KAMI_AutoSave then
                    KAMI_Window.ConfigData[id] = { type = "keybind", value = key and key.Name or nil }
                    KAMI_Window:SaveConfig(KAMI_Window.CurrentConfig)
                end
            end
            if obj.Flag then table.insert(KAMI_Window.Elements, obj) end
            return obj
        end

        tab.CreateSection = tab.AddSection
        tab.CreateDivider = tab.AddDivider
        tab.CreateParagraph = tab.AddParagraph
        tab.CreateLabel = tab.AddLabel
        tab.CreateToggle = tab.AddToggle
        tab.CreateButton = tab.AddButton
        tab.CreateSlider = tab.AddSlider
        tab.CreateDropdown = tab.AddDropdown
        tab.CreateInput = tab.AddInput
        tab.CreateTextArea = tab.AddTextArea
        tab.CreateProgressBar = tab.AddProgressBar
        tab.CreateColorPicker = tab.AddColorPicker
        tab.CreateKeybind = tab.AddKeybind

        return tab
    end

    KAMI_Window.CreateTab = KAMI_Window.AddTab

    function KAMI_Window:SetTransparency(t)
        KAMI_GlobalTransparency = KAMI_Clamp(t, 0, 0.9)
        for _, inst in ipairs(KAMI_TransSurf) do
            if inst.Parent then
                inst.BackgroundTransparency = KAMI_GlobalTransparency
            end
        end
    end

    function KAMI_Window:SetMinimizeKey(key)
        KAMI_MinKey = key
    end

    function KAMI_Window:SaveConfig(configName)
        configName = configName or KAMI_Window.CurrentConfig
        local data = { _meta = { theme = KAMI_CurrentThemeName, transparency = KAMI_GlobalTransparency, autoSave = KAMI_AutoSave } }
        for _, el in ipairs(KAMI_Window.Elements) do
            if el.Flag then
                if el.Type == "color" then
                    data[el.Id] = { type = "color", value = { math.floor(el.Value.R * 255), math.floor(el.Value.G * 255), math.floor(el.Value.B * 255) } }
                elseif el.Type == "keybind" then
                    data[el.Id] = { type = "keybind", value = el.Value and el.Value.Name or nil }
                else
                    data[el.Id] = { type = el.Type, value = el.Value }
                end
            end
        end
        KAMI_Window.ConfigData = data
        KAMI_Window.CurrentConfig = configName
        return KAMI_SaveConfig(KAMI_ConfigId, configName, data)
    end

    function KAMI_Window:LoadConfig(configName)
        configName = configName or KAMI_Window.CurrentConfig
        local data = KAMI_LoadConfig(KAMI_ConfigId, configName)
        if not data then return false end
        local ignored = 0
        for key, _ in pairs(data) do
            if key ~= "_meta" then
                local found = false
                for _, el in ipairs(KAMI_Window.Elements) do
                    if el.Id == key then found = true break end
                end
                if not found then ignored = ignored + 1 end
            end
        end
        if data._meta then
            if data._meta.theme then
                KAMI_ApplyThemeAndRepaint(data._meta.theme)
            end
            if data._meta.transparency then KAMI_Window:SetTransparency(data._meta.transparency) end
            if data._meta.autoSave ~= nil then KAMI_AutoSave = data._meta.autoSave end
        end
        for _, el in ipairs(KAMI_Window.Elements) do
            local d = data[el.Id]
            if d then
                if d.type == "color" then
                    el:Set(Color3.fromRGB(d.value[1], d.value[2], d.value[3]), true)
                elseif d.type == "keybind" then
                    el:Set(d.value and Enum.KeyCode[d.value] or nil, true)
                else
                    el:Set(d.value, true)
                end
            end
        end
        KAMI_Window.CurrentConfig = configName
        if ignored > 0 then
            task.spawn(function()
                KAMI:Notify({ Title = "Config", Content = ignored .. " saved field(s) no longer exist and were skipped.", Style = "Warning", Duration = 3 })
            end)
        end
        return true
    end

    function KAMI_Window:ResetConfig(configName)
        configName = configName or KAMI_Window.CurrentConfig
        KAMI_DeleteConfig(KAMI_ConfigId, configName)
        KAMI_Window.ConfigData = {}
        for _, el in ipairs(KAMI_Window.Elements) do
            if el.Default ~= nil then el:Set(el.Default, true) end
        end
        return true
    end

    function KAMI_Window:ListConfigs()
        return KAMI_ListConfigs(KAMI_ConfigId)
    end

    function KAMI_Window:BuildConfigSection(tab)
        if tab._kamiConfigBuilt then return end
        tab._kamiConfigBuilt = true
        local savedConfigsDropdown = nil
        local themeDropdown = nil
        local function persistAppearance()
            if KAMI_AutoSave then
                KAMI_Window:SaveConfig(KAMI_Window.CurrentConfig)
            end
        end
        tab:AddSection({ Title = "configuration" })
        tab:AddToggle({
            Title = "Auto-Save",
            Description = "Save settings automatically when changed",
            Default = KAMI_AutoSave,
            Callback = function(s)
                KAMI_AutoSave = s
                persistAppearance()
            end
        })
        local configNameInput = tab:AddInput({
            Title = "Config Name",
            Description = "Name used when saving a new config",
            Placeholder = "default",
            Default = "",
            Callback = function() end
        })
        tab:AddButton({
            Title = "Save Config",
            Description = "Save current settings, theme and binds",
            ButtonText = "Save",
            Callback = function()
                local name = (configNameInput.Value ~= "" and configNameInput.Value) or KAMI_Window.CurrentConfig
                KAMI_Window:SaveConfig(name)
                if savedConfigsDropdown then
                    savedConfigsDropdown:SetValues(KAMI_Window:ListConfigs())
                end
                KAMI:Notify({ Title = "Config", Content = "Config '" .. name .. "' saved.", Style = "Success", Duration = 2 })
            end
        })
        savedConfigsDropdown = tab:AddDropdown({
            Title = "Saved Configs",
            Description = "Pick a saved config to load or delete",
            Values = KAMI_Window:ListConfigs(),
            Default = nil,
            Callback = function(name)
                KAMI_Window.CurrentConfig = name
            end
        })
        tab:AddButton({
            Title = "Load Config",
            Description = "Load the config selected above",
            ButtonText = "Load",
            Callback = function()
                local name = KAMI_Window.CurrentConfig
                local ok = KAMI_Window:LoadConfig(name)
                KAMI:Notify({ Title = "Config", Content = ok and ("Config '" .. name .. "' loaded.") or ("No config named '" .. name .. "'."), Style = ok and "Success" or "Warning", Duration = 2 })
            end
        })
        tab:AddButton({
            Title = "Delete Config",
            Description = "Delete the config selected above",
            ButtonText = "Delete",
            Callback = function()
                local name = KAMI_Window.CurrentConfig
                KAMI_DeleteConfig(KAMI_ConfigId, name)
                if savedConfigsDropdown then
                    savedConfigsDropdown:SetValues(KAMI_Window:ListConfigs())
                end
                KAMI:Notify({ Title = "Config", Content = "Config '" .. name .. "' deleted.", Style = "Warning", Duration = 2 })
            end
        })
        tab:AddButton({
            Title = "Reset to Defaults",
            Description = "Reset all settings to their default values",
            ButtonText = "Reset",
            Callback = function()
                for _, el in ipairs(KAMI_Window.Elements) do
                    if el.Default ~= nil then el:Set(el.Default, true) end
                end
                KAMI:Notify({ Title = "Config", Content = "All settings reset to defaults.", Style = "Warning", Duration = 2 })
            end
        })
        tab:AddSection({ Title = "appearance" })
        tab:AddKeybind({
            Title = "Minimize Key",
            Description = "Key to hide/show the hub",
            Flag = "_minimize_key",
            Default = KAMI_MinKey,
            Callback = function(key)
                if key then
                    KAMI_MinKey = key
                    persistAppearance()
                    KAMI:Notify({ Title = "Key Changed", Content = "Minimize key set to " .. key.Name, Style = "Success", Duration = 2 })
                end
            end
        })
        tab:AddSlider({
            Title = "Window Transparency",
            Description = "Adjust UI transparency (0-90%)",
            Min = 0, Max = 90, Default = math.floor(KAMI_GlobalTransparency * 100), Step = 5,
            Callback = function(v)
                KAMI_Window:SetTransparency(v / 100)
                persistAppearance()
            end
        })
        themeDropdown = tab:AddDropdown({
            Title = "Theme",
            Description = "Change the UI theme (applies instantly)",
            Values = { "Default", "Pitch", "Light", "Ocean", "Sunset", "Mono" },
            Default = KAMI_CurrentThemeName,
            Callback = function(theme)
                KAMI:SetTheme(theme)
                persistAppearance()
                KAMI:Notify({ Title = "Theme Changed", Content = "Switched to " .. theme .. " theme", Style = "Success", Duration = 2 })
            end
        })
        KAMI_OnThemeChange(function(name)
            if themeDropdown and themeDropdown.Value ~= name then
                themeDropdown:Set(name, true)
            end
        end)
    end

    KAMI_Window.Frame = frame
    KAMI_Window.Titlebar = titlebar
    KAMI_Window.Sidebar = sidebar
    KAMI_Window.Content = content
    KAMI_Window.SetMinimized = setMinimized

    if KAMI_AutoLoad then
        local saved = KAMI_LoadConfig(KAMI_ConfigId, "default")
        if saved then
            KAMI_Window.ConfigData = saved
            KAMI_Window.CurrentConfig = "default"
            if saved._meta then
                if saved._meta.theme then
                    KAMI_ApplyThemeAndRepaint(saved._meta.theme)
                end
                if saved._meta.transparency then KAMI_GlobalTransparency = KAMI_Clamp(saved._meta.transparency, 0, 0.9) end
                if saved._meta.autoSave ~= nil then KAMI_AutoSave = saved._meta.autoSave end
            end
            for _, el in ipairs(KAMI_Window.Elements) do
                local d = saved[el.Id]
                if d then
                    if d.type == "color" then
                        el:Set(Color3.fromRGB(d.value[1], d.value[2], d.value[3]), true)
                    elseif d.type == "keybind" then
                        el:Set(d.value and Enum.KeyCode[d.value] or nil, true)
                    else
                        el:Set(d.value, true)
                    end
                end
            end
            KAMI_Repaint()
            for _, inst in ipairs(KAMI_TransSurf) do
                if inst.Parent then inst.BackgroundTransparency = KAMI_GlobalTransparency end
            end
        end
    end

    return KAMI_Window
end

return KAMI_BuildWindow()


end

function KAMI:Destroy()
KAMI_CloseDropdown()
KAMI_Gui:Destroy()
KAMI_NotifyGui:Destroy()
table.clear(KAMI_Painters)
table.clear(KAMI_TransSurf)
table.clear(KAMI_ThemeListeners)
if getgenv then getgenv().KamiUI = nil end
end

function KAMI:Logout()
KAMI_ClearKey()
KAMI:Notify({ Title = "Kami UI", Content = "Logged out. Restart to re-enter key.", Style = "Info", Duration = 3 })
end

if getgenv then getgenv().KamiUI = KAMI end

return KAMI
