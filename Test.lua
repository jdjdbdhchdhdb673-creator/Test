-- ГИД ХАБ v12.1 (TWIN FARM EDITION)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

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
                hl.FillColor = Color3.fromRGB(0, 255, 0)
                hl.OutlineColor = Color3.fromRGB(0, 255, 0)
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
                label.TextColor3 = Color3.fromRGB(0, 255, 0)
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

-- ===== ОСНОВНОЕ МЕНЮ =====
local gui = Instance.new("ScreenGui")
gui.Name = "HydHub"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 340, 0, 460)
main.Position = UDim2.new(0.5, -170, 0.5, -230)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.BackgroundTransparency = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

-- ===== ЗАГОЛОВОК =====
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 40)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "GID_HUB v12.1 [TWIN FARM]"
title.TextColor3 = Color3.fromRGB(200, 200, 255)
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -40, 0, 5)
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(255, 80, 80)
close.TextScaled = true
close.BackgroundTransparency = 1
close.Font = Enum.Font.GothamBold
close.Parent = main
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ===== ВКЛАДКИ =====
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 35)
tabFrame.Position = UDim2.new(0, 0, 0, 45)
tabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
tabFrame.BackgroundTransparency = 0.1
tabFrame.BorderSizePixel = 0
tabFrame.Parent = main

local tabs = {"Main", "Visuals", "Teleport", "Twin Farm"}
local currentTab = 1
local tabButtons = {}
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -10, 1, -90)
contentFrame.Position = UDim2.new(0, 5, 0, 85)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = main

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, -2, 1, -2)
    btn.Position = UDim2.new((i-1)*0.25, 0, 0, 0)
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

-- ===== ФУНКЦИЯ СОЗДАНИЯ КНОПОК =====
local function CreateButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
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
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateSlider(text, yPos, defaultVal)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.9, 0, 0, 40)
    frame.Position = UDim2.new(0.05, 0, yPos, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = contentFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0.5, 0, 0.3, 0)
    slider.Position = UDim2.new(0.45, 0, 0.35, 0)
    slider.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    slider.BorderSizePixel = 0
    slider.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = slider
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(defaultVal or 0.5, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill
    
    local value = Instance.new("TextLabel")
    value.Size = UDim2.new(0.2, 0, 1, 0)
    value.Position = UDim2.new(0.8, 0, 0, 0)
    value.Text = math.floor((defaultVal or 0.5) * 100) .. "%"
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
        CreateButton("📌 Главная кнопка", 0.05, function()
            print("Главная нажата!")
        end)
        CreateButton("⚙️ Настройка 1", 0.2, function()
            print("Настройка 1!")
        end)
        CreateButton("⚙️ Настройка 2", 0.35, function()
            print("Настройка 2!")
        end)
        
    elseif currentTab == 2 then
        CreateButton("👁️ ESP", 0.05, function()
            ToggleESP()
        end)
        CreateButton("🔴 Красный ESP", 0.2, function()
            print("Красный ESP!")
        end)
        CreateSlider("X-Ray Strength", 0.4, 0.67)
        CreateButton("🌈 Свой цвет", 0.65, function()
            print("Свой цвет!")
        end)
        
    elseif currentTab == 3 then
        CreateButton("🌀 К игроку", 0.05, function()
            print("Телепорт к игроку!")
        end)
        CreateButton("📌 К объекту", 0.2, function()
            print("Телепорт к объекту!")
        end)
        CreateButton("🏠 В спавн", 0.35, function()
            print("В спавн!")
        end)
        
    elseif currentTab == 4 then
        -- ВКЛАДКА TWIN FARM
        local counterLabel = Instance.new("TextLabel")
        counterLabel.Size = UDim2.new(1, 0, 0, 30)
        counterLabel.Position = UDim2.new(0, 0, 0, 0)
        counterLabel.Text = "Аккаунтов обработано: 0/10"
        counterLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        counterLabel.TextScaled = true
        counterLabel.BackgroundTransparency = 1
        counterLabel.Font = Enum.Font.GothamBold
        counterLabel.Parent = contentFrame
        
        local count = 0
        CreateButton("🚀 Запустить фарм", 0.2, function()
            count = count + 1
            counterLabel.Text = "Аккаунтов обработано: " .. count .. "/10"
            print("Фарм для твинка запущен!")
            -- СЮДА ТВОЙ КОД ФАРМА
        end)
        
        CreateButton("⏭️ Следующий аккаунт", 0.4, function()
            print("Переключение на следующий аккаунт!")
            -- СЮДА ЛОГИКА ПЕРЕКЛЮЧЕНИЯ
        end)
        
        CreateButton("🔄 Сбросить счётчик", 0.6, function()
            count = 0
            counterLabel.Text = "Аккаунтов обработано: 0/10"
            print("Счётчик сброшен!")
        end)
    end
end

UpdateContent()

-- ===== ТЕКСТ ВНИЗУ =====
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 20)
footer.Position = UDim2.new(0, 0, 1, -25)
footer.Text = "github.com/your-repo"
footer.TextColor3 = Color3.fromRGB(100, 100, 120)
footer.TextScaled = true
footer.BackgroundTransparency = 1
footer.Font = Enum.Font.GothamBold
footer.Parent = main

print("✅ GID_HUB v12.1 (Twin Farm) загружен!")
