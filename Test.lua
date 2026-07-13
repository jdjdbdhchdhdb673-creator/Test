-- ГИД ХАБ v7.0 (ЧЁРНЫЙ КАК YARHM)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

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
                hl.FillColor = Color3.fromRGB(0, 200, 255)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.3
                table.insert(espHighlights, hl)
                local bb = Instance.new("BillboardGui")
                bb.Parent = root
                bb.AlwaysOnTop = true
                bb.Size = UDim2.new(0, 80, 0, 20)
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

-- ===== ГЛАВНОЕ МЕНЮ (ЧЁРНОЕ) =====
local gui = Instance.new("ScreenGui")
gui.Name = "HydHub"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 320, 0, 400)
main.Position = UDim2.new(0.5, -160, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.BackgroundTransparency = 0.05
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

-- Заголовок (как в YARHM)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "⚡ ГИД ХАБ v7.0"
title.TextColor3 = Color3.fromRGB(200, 200, 255)
title.TextScaled = true
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Parent = main

-- Кнопка закрыть (как в YARHM)
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

-- ===== ФУНКЦИЯ СОЗДАНИЯ КНОПОК (как в YARHM) =====
local function CreateButton(text, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, yPos, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.GothamSemibold
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Parent = main
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ===== ВКЛАДКИ (как в YARHM) =====
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 30)
tabFrame.Position = UDim2.new(0, 0, 0, 40)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = main

local tabs = {"ESP", "Фарм", "Телепорт", "Фишки"}
local currentTab = 1
local tabButtons = {}
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -10, 1, -80)
contentFrame.Position = UDim2.new(0, 5, 0, 70)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = main

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, -2, 1, 0)
    btn.Position = UDim2.new((i-1)*0.25, 0, 0, 0)
    btn.Text = name
    btn.TextColor3 = i == 1 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
    btn.TextScaled = true
    btn.BackgroundTransparency = 1
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = tabFrame
    tabButtons[i] = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(tabButtons) do
            b.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        currentTab = i
        UpdateContent()
    end)
end

-- ===== КОНТЕНТ ВКЛАДОК =====
local function UpdateContent()
    for _, child in pairs(contentFrame:GetChildren()) do
        child:Destroy()
    end
    
    if currentTab == 1 then
        -- Вкладка ESP
        local espBtn = CreateButton("☐ ESP", 0.1, Color3.fromRGB(0, 150, 255), function()
            ToggleESP()
            espBtn.Text = espEnabled and "☑ ESP" or "☐ ESP"
            espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        espBtn.Parent = contentFrame
        
        local btn2 = CreateButton("🔴 ESP (красный)", 0.3, Color3.fromRGB(150, 0, 0), function()
            print("Красный ESP - вставь свой код")
        end)
        btn2.Parent = contentFrame
        
    elseif currentTab == 2 then
        -- Вкладка Фарм
        local btn1 = CreateButton("🌾 Авто-фарм", 0.1, Color3.fromRGB(0, 180, 80), function()
            print("Фарм запущен!")
        end)
        btn1.Parent = contentFrame
        
        local btn2 = CreateButton("🔄 Авто-респавн", 0.3, Color3.fromRGB(200, 150, 0), function()
            print("Респавн!")
        end)
        btn2.Parent = contentFrame
        
    elseif currentTab == 3 then
        -- Вкладка Телепорт
        local btn1 = CreateButton("🌀 К игроку", 0.1, Color3.fromRGB(255, 170, 0), function()
            print("Телепорт к игроку!")
        end)
        btn1.Parent = contentFrame
        
        local btn2 = CreateButton("📌 К объекту", 0.3, Color3.fromRGB(200, 100, 0), function()
            print("Телепорт к объекту!")
        end)
        btn2.Parent = contentFrame
        
    elseif currentTab == 4 then
        -- Вкладка Фишки
        local btn1 = CreateButton("🧠 Моя фишка #1", 0.1, Color3.fromRGB(180, 0, 255), function()
            print("Фишка #1!")
        end)
        btn1.Parent = contentFrame
        
        local btn2 = CreateButton("🧠 Моя фишка #2", 0.3, Color3.fromRGB(150, 0, 200), function()
            print("Фишка #2!")
        end)
        btn2.Parent = contentFrame
    end
end

UpdateContent()

print("✅ ГИД ХАБ v7.0 (как YARHM) загружен!")
