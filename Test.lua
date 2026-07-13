-- ГИД ХАБ v13.0 (MM2 STYLE CUSTOM)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Удаляем старый хаб
if CoreGui:FindFirstChild("HydHub") then
    CoreGui:FindFirstChild("HydHub"):Destroy()
end

-- ===== ESP =====
local espEnabled = false
local espHighlights = {}
local espBillboards = {}

local function ClearESP()
    for _, v in pairs(espHighlights) do if v and v.Parent then v:Destroy() end end
    espHighlights = {}
    for _, v in pairs(espBillboards) do if v and v.Parent then v:Destroy() end end
    espBillboards = {}
end

local function ToggleESP()
    espEnabled = not espEnabled
    if not espEnabled then ClearESP() return end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local hl = Instance.new("Highlight")
                hl.Parent = player.Character
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.3
                table.insert(espHighlights, hl)
                local bb = Instance.new("BillboardGui")
                bb.Parent = root
                bb.AlwaysOnTop = true
                bb.Size = UDim2.new(0, 100, 0, 20)
                bb.StudsOffset = Vector3.new(0, 2, 0)
                local label = Instance.new("TextLabel")
                label.Parent = bb
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = player.Name
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextScaled = true
                label.Font = Enum.Font.GothamBold
                table.insert(espBillboards, bb)
            end
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if espEnabled then ToggleESP() end
    end)
end)

-- ===== ГЛАВНОЕ МЕНЮ (1 В 1 КАК НА СКРИНЕ) =====
local gui = Instance.new("ScreenGui")
gui.Name = "HydHub"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 350, 0, 480)
main.Position = UDim2.new(0.5, -175, 0.5, -240)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.BackgroundTransparency = 0.05
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = main

-- ===== ЗАГОЛОВОК =====
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "⚡ GID_HUB v13.0"
title.TextColor3 = Color3.fromRGB(200, 200, 255)
title.TextScaled = true
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(255, 80, 80)
close.TextScaled = true
close.BackgroundTransparency = 1
close.Font = Enum.Font.GothamBold
close.Parent = main
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ===== ВКЛАДКИ (КАК НА СКРИНЕ) =====
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 30)
tabFrame.Position = UDim2.new(0, 0, 0, 38)
tabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
tabFrame.BackgroundTransparency = 0.1
tabFrame.BorderSizePixel = 0
tabFrame.Parent = main

local tabs = {"Main", "Auto Farm", "Teleport", "Visuals", "Settings"}
local currentTab = 1
local tabButtons = {}
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -10, 1, -80)
contentFrame.Position = UDim2.new(0, 5, 0, 72)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = main

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.2, -2, 1, -2)
    btn.Position = UDim2.new((i-1)*0.2, 0, 0, 0)
    btn.Text = name
    btn.TextColor3 = i == 1 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
    btn.TextScaled = true
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(60, 60, 80) or Color3.fromRGB(25, 25, 30)
    btn.BackgroundTransparency = i == 1 and 0.5 or 0
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = tabFrame
    tabButtons[i] = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(tabButtons) do
            b.TextColor3 = Color3.fromRGB(150, 150, 150)
            b.BackgroundTransparency = 0
        end
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundTransparency = 0.5
        currentTab = i
        UpdateContent()
    end)
end

-- ===== ФУНКЦИЯ СОЗДАНИЯ КНОПОК (СТИЛЬ MM2) =====
local function CreateButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.Position = UDim2.new(0.05, 0, yPos, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.BackgroundTransparency = 0.1
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(60, 60, 80)
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = contentFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ===== ПОЛЗУНОК (КАК НА СКРИНЕ) =====
local function CreateSlider(text, yPos, defaultVal)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.9, 0, 0, 38)
    frame.Position = UDim2.new(0.05, 0, yPos, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = contentFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.45, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0.35, 0, 0.25, 0)
    slider.Position = UDim2.new(0.5, 0, 0.35, 0)
    slider.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    slider.BorderSizePixel = 0
    slider.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = slider
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(defaultVal or 0.67, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill
    
    local value = Instance.new("TextLabel")
    value.Size = UDim2.new(0.15, 0, 1, 0)
    value.Position = UDim2.new(0.85, 0, 0, 0)
    value.Text = math.floor((defaultVal or 0.67) * 100) .. "%"
    value.TextColor3 = Color3.fromRGB(200, 200, 200)
    value.TextScaled = true
    value.TextXAlignment = Enum.TextXAlignment.Right
    value.BackgroundTransparency = 1
    value.Font = Enum.Font.GothamSemibold
    value.Parent = frame
    
    return frame
end

-- ===== КОНТЕНТ ВКЛАДОК =====
local function UpdateContent()
    for _, child in pairs(contentFrame:GetChildren()) do
        child:Destroy()
    end
    
    if currentTab == 1 then
        -- MAIN
        CreateButton("☑ ESP", 0.05, function()
            ToggleESP()
        end)
        CreateButton("☐ No Clip", 0.2, function()
            print("No Clip")
        end)
        CreateButton("☐ Fly", 0.35, function()
            print("Fly")
        end)
        CreateButton("☐ Infinite Jump", 0.5, function()
            print("Infinite Jump")
        end)
        CreateButton("☐ Auto Fling", 0.65, function()
            print("Auto Fling")
        end)
        
    elseif currentTab == 2 then
        -- AUTO FARM
        CreateButton("🌾 Запустить фарм", 0.05, function()
            print("Фарм запущен!")
            -- СЮДА ТВОЙ КОД ФАРМА
        end)
        CreateButton("🔄 Авто-респавн", 0.2, function()
            print("Респавн!")
        end)
        CreateSlider("Скорость фарма", 0.4, 0.5)
        CreateButton("📊 Статистика", 0.65, function()
            print("Статистика!")
        end)
        
    elseif currentTab == 3 then
        -- TELEPORT
        CreateButton("🌀 К игроку", 0.05, function()
            print("Телепорт к игроку!")
        end)
        CreateButton("📌 К объекту", 0.2, function()
            print("Телепорт к объекту!")
        end)
        CreateButton("🏠 В спавн", 0.35, function()
            print("В спавн!")
        end)
        CreateButton("⭐ В точку", 0.5, function()
            print("В точку!")
        end)
        
    elseif currentTab == 4 then
        -- VISUALS
        CreateButton("👁️ ESP (вкл)", 0.05, function()
            ToggleESP()
        end)
        CreateButton("🔴 Красный ESP", 0.2, function()
            print("Красный ESP")
        end)
        CreateSlider("X-Ray Strength", 0.4, 0.67)
        CreateButton("🌈 Сменить цвет", 0.65, function()
            print("Сменить цвет")
        end)
        
    elseif currentTab == 5 then
        -- SETTINGS
        CreateButton("⚙️ Настройка 1", 0.05, function()
            print("Настройка 1")
        end)
        CreateButton("⚙️ Настройка 2", 0.2, function()
            print("Настройка 2")
        end)
        CreateButton("🔄 Сбросить всё", 0.35, function()
            print("Сброс")
        end)
        CreateButton("💾 Сохранить", 0.5, function()
            print("Сохранено")
        end)
    end
end

UpdateContent()

-- ===== ТЕКСТ ВНИЗУ (КАК НА СКРИНЕ) =====
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 20)
footer.Position = UDim2.new(0, 0, 1, -22)
footer.Text = "github.com/your-repo"
footer.TextColor3 = Color3.fromRGB(100, 100, 120)
footer.TextScaled = true
footer.BackgroundTransparency = 1
footer.Font = Enum.Font.GothamBold
footer.Parent = main

print("✅ GID_HUB v13.0 (MM2 Style) загружен!")
