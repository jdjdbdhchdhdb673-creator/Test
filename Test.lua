-- ГИД ХАБ v3.0 (ESP + КРАСИВЫЙ ДИЗАЙН)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")

-- Переменные ESP
local espEnabled = false
local espObjects = {}
local espConnections = {}

-- Удаляем старый хаб
if CoreGui:FindFirstChild("HydHub") then
    CoreGui:FindFirstChild("HydHub"):Destroy()
end

-- ===== ФУНКЦИИ ESP =====
local function CreateESP(player)
    if not player or not player.Character then return end
    if espObjects[player] then return end

    local char = player.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Основная подсветка
    local highlight = Instance.new("Highlight")
    highlight.Parent = char
    highlight.FillColor = Color3.fromRGB(0, 200, 255)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0.1
    espObjects[player] = highlight

    -- Биллборд с именем
    local billboard = Instance.new("BillboardGui")
    billboard.Parent = root
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 120, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.Name = "ESP_Billboard"
    espObjects[player .. "_BB"] = billboard

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = billboard
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    
    -- Индикатор здоровья (полоска)
    local healthBar = Instance.new("Frame")
    healthBar.Parent = billboard
    healthBar.Size = UDim2.new(1, 0, 0.2, 0)
    healthBar.Position = UDim2.new(0, 0, 1.1, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthBar.BorderSizePixel = 0
    
    local healthBg = Instance.new("Frame")
    healthBg.Parent = billboard
    healthBg.Size = UDim2.new(1, 0, 0.2, 0)
    healthBg.Position = UDim2.new(0, 0, 1.1, 0)
    healthBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    healthBg.BorderSizePixel = 0
    healthBg.ZIndex = 0
    
    -- Обновление здоровья
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        local conn = hum:GetPropertyChangedSignal("Health"):Connect(function()
            local hp = hum.Health / hum.MaxHealth
            healthBar.Size = UDim2.new(hp, 0, 0.2, 0)
            if hp > 0.6 then
                healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            elseif hp > 0.3 then
                healthBar.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
            else
                healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            end
        end)
        table.insert(espConnections, conn)
    end
end

local function ClearESP()
    for key, obj in pairs(espObjects) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    espObjects = {}
    for _, conn in pairs(espConnections) do
        if conn then conn:Disconnect() end
    end
    espConnections = {}
end

local function ToggleESP()
    espEnabled = not espEnabled
    if not espEnabled then
        ClearESP()
        return
    end
    
    -- Создаём ESP для всех игроков
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateESP(player)
        end
    end
end

-- Обновление ESP при появлении новых игроков
Players.PlayerAdded:Connect(function(player)
    if espEnabled then
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            CreateESP(player)
        end)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if espObjects[player] then
        espObjects[player]:Destroy()
        espObjects[player] = nil
    end
    if espObjects[player .. "_BB"] then
        espObjects[player .. "_BB"]:Destroy()
        espObjects[player .. "_BB"] = nil
    end
end)

-- ===== КРАСИВЫЙ GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "HydHub"
gui.Parent = CoreGui
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Главное окно
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 360, 0, 480)
main.Position = UDim2.new(0.5, -180, 0.5, -240)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
main.BackgroundTransparency = 0.05
main.Active = true
main.Draggable = true
main.Parent = gui
main.ClipsDescendants = true

-- Скругление (через UICorner)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = main

-- Градиентный фон (невидимый)
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 50)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 50))
})
gradient.Rotation = 45
gradient.Parent = main

-- Неоновая обводка
local outline = Instance.new("Frame")
outline.Size = UDim2.new(1, 0, 1, 0)
outline.BackgroundTransparency = 1
outline.BorderSizePixel = 2
outline.BorderColor3 = Color3.fromRGB(0, 200, 255)
outline.Parent = main

local outlineCorner = Instance.new("UICorner")
outlineCorner.CornerRadius = UDim.new(0, 20)
outlineCorner.Parent = outline

-- Заголовок с градиентом
local titleBg = Instance.new("Frame")
titleBg.Size = UDim2.new(1, 0, 0, 55)
titleBg.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
titleBg.BackgroundTransparency = 0.15
titleBg.BorderSizePixel = 0
titleBg.Parent = main

local titleGrad = Instance.new("UIGradient")
titleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255))
})
titleGrad.Parent = titleBg

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 20)
titleCorner.Parent = titleBg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 30, 0, 0)
title.Text = "⚡ ГИД ХАБ v3.0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Parent = titleBg

-- Кнопка закрытия
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 40, 0, 40)
close.Position = UDim2.new(1, -50, 0, 8)
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(255, 80, 80)
close.TextScaled = true
close.BackgroundTransparency = 1
close.Font = Enum.Font.GothamBold
close.Parent = titleBg
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ===== КНОПКИ =====

-- Функция создания красивой кнопки
local function CreateButton(text, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 55)
    btn.Position = UDim2.new(0.075, 0, yPos, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    btn.Parent = main
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = btn
    
    local btnGrad = Instance.new("UIGradient")
    btnGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(color.r * 0.7, color.g * 0.7, color.b * 0.7))
    })
    btnGrad.Rotation = 90
    btnGrad.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Кнопка ESP
local espBtn = CreateButton("👁️ ESP (вкл/выкл)", 0.18, Color3.fromRGB(0, 150, 255), function()
    ToggleESP()
    espBtn.Text = espEnabled and "👁️ ESP (ВКЛ)" or "👁️ ESP (ВЫКЛ)"
    espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(150, 0, 0)
end)

-- Кнопка Фарм
CreateButton("🌾 ФАРМ", 0.36, Color3.fromRGB(0, 180, 80), function()
    print("Фарм запущен! Вставь свой код сюда")
    -- СЮДА ТВОЙ КОД ФАРМА
end)

-- Кнопка Телепорт
CreateButton("🌀 ТЕЛЕПОРТ", 0.54, Color3.fromRGB(255, 170, 0), function()
    print("Телепорт! Вставь свой код")
    -- СЮДА ТВОЙ ТЕЛЕПОРТ
end)

-- Кнопка Моя фишка
CreateButton("🧠 МОЯ ФИШКА", 0.72, Color3.fromRGB(180, 0, 255), function()
    print("Кастомная фишка!")
    -- СЮДА ТВОЯ ФИШКА
end)

-- Анимация появления
main.BackgroundTransparency = 1
main.Size = UDim2.new(0, 300, 0, 400)
main.Position = UDim2.new(0.5, -150, 0.5, -200)
task.wait(0.1)
main:TweenSizeAndPosition(
    UDim2.new(0, 360, 0, 480),
    UDim2.new(0.5, -180, 0.5, -240),
    Enum.EasingDirection.Out,
    Enum.EasingStyle.Quad,
    0.3,
    true
)
main.BackgroundTransparency = 0.05

print("🚀 ГИД ХАБ v3.0 загружен! Нажми ESP для включения подсветки игроков.")
