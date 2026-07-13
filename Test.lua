-- ГИД ХАБ v15.0 (ПОЛНАЯ КОПИЯ MM2)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("HydHub") then
    CoreGui:FindFirstChild("HydHub"):Destroy()
end

-- ===== ESP (РАБОЧИЙ) =====
local espEnabled = false
local espHighlights = {}
local espConnections = {}

local function AddESP(player)
    if not player or player == LocalPlayer then return end
    if espHighlights[player] then return end
    local char = player.Character
    if not char then
        local conn = player.CharacterAdded:Connect(function()
            task.wait(0.5)
            AddESP(player)
            conn:Disconnect()
        end)
        table.insert(espConnections, conn)
        return
    end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hl = Instance.new("Highlight")
    hl.Parent = char
    hl.FillColor = Color3.fromRGB(255, 0, 0)
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.3
    espHighlights[player] = hl
end

local function ClearESP()
    for _, obj in pairs(espHighlights) do if obj and obj.Parent then obj:Destroy() end end
    espHighlights = {}
    for _, conn in pairs(espConnections) do if conn then conn:Disconnect() end end
    espConnections = {}
end

local function ToggleESP()
    espEnabled = not espEnabled
    if not espEnabled then ClearESP() return end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then AddESP(player) end
    end
    local conn = Players.PlayerAdded:Connect(function(player)
        if espEnabled then AddESP(player) end
    end)
    table.insert(espConnections, conn)
end

Players.PlayerRemoving:Connect(function(player)
    if espHighlights[player] then
        espHighlights[player]:Destroy()
        espHighlights[player] = nil
    end
end)

-- ===== ИНТЕРФЕЙС (1 В 1) =====
local gui = Instance.new("ScreenGui")
gui.Name = "HydHub"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 340, 0, 480)
main.Position = UDim2.new(0.5, -170, 0.5, -240)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
main.BackgroundTransparency = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 6)
mainCorner.Parent = main

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "⚡ GID_HUB v15.0"
title.TextColor3 = Color3.fromRGB(200, 200, 255)
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 28, 0, 28)
close.Position = UDim2.new(1, -35, 0, 5)
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(255, 80, 80)
close.TextScaled = true
close.BackgroundTransparency = 1
close.Font = Enum.Font.GothamBold
close.Parent = main
close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- ===== ВКЛАДКИ (9 ШТУК, КАК НА СКРИНЕ) =====
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 28)
tabFrame.Position = UDim2.new(0, 0, 0, 35)
tabFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
tabFrame.BorderSizePixel = 0
tabFrame.Parent = main

local tabs = {"Main", "Sheriff", "Murder", "Auto Farm", "Teleport", "Fun/Troll", "Fling Players", "Visuals", "Settings"}
local currentTab = 1
local tabButtons = {}
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -10, 1, -75)
contentFrame.Position = UDim2.new(0, 5, 0, 65)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = main

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.11, -2, 1, 0)
    btn.Position = UDim2.new((i-1)*0.11, 0, 0, 0)
    btn.Text = name
    btn.TextColor3 = i == 1 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(130, 130, 150)
    btn.TextScaled = true
    btn.BackgroundTransparency = 1
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = tabFrame
    tabButtons[i] = btn
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(tabButtons) do b.TextColor3 = Color3.fromRGB(130, 130, 150) end
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        currentTab = i
        UpdateContent()
    end)
end

-- ===== ФУНКЦИЯ СОЗДАНИЯ ЭЛЕМЕНТОВ =====
local function CreateItem(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 30)
    btn.Position = UDim2.new(0.075, 0, yPos, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextScaled = true
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.BackgroundTransparency = 0.1
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(45, 45, 55)
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = contentFrame
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateSlider(text, yPos, defaultVal)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.85, 0, 0, 30)
    frame.Position = UDim2.new(0.075, 0, yPos, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = contentFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(180, 180, 180)
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0.3, 0, 0.3, 0)
    slider.Position = UDim2.new(0.55, 0, 0.35, 0)
    slider.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    slider.BorderSizePixel = 0
    slider.Parent = frame
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 3)
    c.Parent = slider
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(defaultVal or 0.67, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(0, 3)
    fc.Parent = fill
    
    local val = Instance.new("TextLabel")
    val.Size = UDim2.new(0.15, 0, 1, 0)
    val.Position = UDim2.new(0.85, 0, 0, 0)
    val.Text = math.floor((defaultVal or 0.67) * 100) .. "%"
    val.TextColor3 = Color3.fromRGB(180, 180, 180)
    val.TextScaled = true
    val.TextXAlignment = Enum.TextXAlignment.Right
    val.BackgroundTransparency = 1
    val.Font = Enum.Font.GothamSemibold
    val.Parent = frame
    return frame
end

-- ===== КОНТЕНТ ВКЛАДОК (ПОЛНАЯ КОПИЯ) =====
local function UpdateContent()
    for _, child in pairs(contentFrame:GetChildren()) do child:Destroy() end
    local y = 0.05
    
    if currentTab == 1 then -- MAIN
        CreateItem("☑ ESP", y, ToggleESP)
        y = y + 0.11
        CreateItem("☐ No Clip", y, function() print("No Clip") end)
        y = y + 0.11
        CreateItem("☐ Fly", y, function() print("Fly") end)
        y = y + 0.11
        CreateItem("☐ Infinite Jump", y, function() print("Infinite Jump") end)
        y = y + 0.11
        CreateItem("☐ Auto Fling", y, function() print("Auto Fling") end)
        
    elseif currentTab == 2 then -- SHERIFF
        CreateItem("🔫 Auto Shoot", y, function() print("Auto Shoot") end)
        y = y + 0.11
        CreateItem("👁️ See Murderer", y, function() print("See Murderer") end)
        
    elseif currentTab == 3 then -- MURDER
        CreateItem("🔪 Auto Kill", y, function() print("Auto Kill") end)
        y = y + 0.11
        CreateItem("🏃 Speed Hack", y, function() print("Speed Hack") end)
        
    elseif currentTab == 4 then -- AUTO FARM
        CreateItem("🌾 Запустить фарм", y, function() print("Фарм!") end)
        y = y + 0.11
        CreateItem("🔄 Авто-респавн", y, function() print("Респавн!") end)
        y = y + 0.11
        CreateSlider("Скорость", y, 0.5)
        
    elseif currentTab == 5 then -- TELEPORT
        CreateItem("🌀 К игроку", y, function() print("К игроку") end)
        y = y + 0.11
        CreateItem("📌 К объекту", y, function() print("К объекту") end)
        y = y + 0.11
        CreateItem("🏠 В спавн", y, function() print("В спавн") end)
        
    elseif currentTab == 6 then -- FUN/TROLL
        CreateItem("🎉 Забавить", y, function() print("Забавить") end)
        y = y + 0.11
        CreateItem("🤡 Троллинг", y, function() print("Троллинг") end)
        
    elseif currentTab == 7 then -- FLING PLAYERS
        CreateItem("🔄 Fling", y, function() print("Fling") end)
        y = y + 0.11
        CreateItem("🌀 Fling всех", y, function() print("Fling всех") end)
        
    elseif currentTab == 8 then -- VISUALS
        CreateItem("👁️ ESP", y, ToggleESP)
        y = y + 0.11
        CreateItem("🔴 Красный ESP", y, function() print("Красный ESP") end)
        y = y + 0.11
        CreateSlider("X-Ray", y, 0.67)
        y = y + 0.11
        CreateItem("🌈 Цвет", y, function() print("Цвет") end)
        
    elseif currentTab == 9 then -- SETTINGS
        CreateItem("⚙️ Настройка 1", y, function() print("Настр 1") end)
        y = y + 0.11
        CreateItem("⚙️ Настройка 2", y, function() print("Настр 2") end)
        y = y + 0.11
        CreateItem("🔄 Сброс", y, function() print("Сброс") end)
    end
end
UpdateContent()

-- Нижний колонтитул
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 18)
footer.Position = UDim2.new(0, 0, 1, -20)
footer.Text = "github.com/your-repo"
footer.TextColor3 = Color3.fromRGB(80, 80, 100)
footer.TextScaled = true
footer.BackgroundTransparency = 1
footer.Font = Enum.Font.GothamBold
footer.Parent = main

print("✅ GID_HUB v15.0 (Полная копия MM2) загружен!")
