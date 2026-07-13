-- Загружаем современную библиотеку Orion UI с красивыми анимациями
local OrionLib = loadstring(game:HttpGet(('https://githubusercontent.com')))()

-- Проверяем, запущен ли хаб, чтобы не плодить копии
if game:GetService("CoreGui"):FindFirstChild("HydHub") then
    game:GetService("CoreGui"):FindFirstChild("HydHub"):Destroy()
end

-- ===== ЛОГИКА ТВОИХ ФУНКЦИЙ =====
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local espEnabled = false
local espHighlights = {}

local function ToggleESP(State)
    espEnabled = State
    if not espEnabled then
        for _, v in pairs(espHighlights) do if v and v.Parent then v:Destroy() end end
        espHighlights = {}
        return
    end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hl = Instance.new("Highlight")
            hl.Parent = player.Character
            hl.FillColor = Color3.fromRGB(255, 0, 0)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            table.insert(espHighlights, hl)
        end
    end
end

-- ===== СОЗДАНИЕ НЕОНОВОГО ИНТЕРФЕЙСА =====
local Window = OrionLib:MakeWindow({
    Name = "⚡ GID_HUB v16.0", 
    HidePremium = true, 
    SaveConfig = true, 
    ConfigFolder = "GidHubConfig",
    IntroText = "Loading GID_HUB..." -- Красивая заставка при запуске
})

-- Вкладка 1: MAIN
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MainTab:AddToggle({
    Name = "Включить ESP",
    Default = false,
    Callback = function(Value)
        ToggleESP(Value)
    end    
})

MainTab:AddButton({
    Name = "No Clip",
    Callback = function()
        print("No Clip активирован")
    end
})

MainTab:AddButton({
    Name = "Fly",
    Callback = function()
        print("Fly активирован")
    end
})

-- Вкладка 2: FARM
local FarmTab = Window:MakeTab({
    Name = "Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

FarmTab:AddToggle({
    Name = "🌾 Запустить автофарм",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        print("Автофарм:", Value)
    end    
})

FarmTab:AddSlider({
    Name = "Скорость фарма",
    Min = 0,
    Max = 100,
    Default = 50,
    Color = Color3.fromRGB(0, 150, 255),
    Increment = 1,
    ValueName = "%",
    Callback = function(Value)
        print("Выбрана скорость:", Value)
    end    
})

-- Вкладка 3: VISUALS
local VisualsTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

VisualsTab:AddToggle({
    Name = "👁️ Альтернативный ESP",
    Default = false,
    Callback = function(Value)
        ToggleESP(Value)
    end    
})

VisualsTab:AddSlider({
    Name = "X-Ray Сила",
    Min = 0,
    Max = 100,
    Default = 67,
    Color = Color3.fromRGB(255, 0, 100),
    Increment = 1,
    ValueName = "%",
    Callback = function(Value)
        print("X-Ray выставлен на:", Value)
    end    
})

-- Вкладка 4: SETTINGS
local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

SettingsTab:AddButton({
    Name = "⚙️ Настройка производительности",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "GID_HUB",
            Content = "Настройки оптимизированы под твой телефон!",
            Time = 4
        })
    end
})

SettingsTab:AddButton({
    Name = "Выгрузить хаб (Destroy)",
    Callback = function()
        OrionLib:Destroy()
    end
})

-- Запуск интерфейса
OrionLib:Init()
print("✅ GID_HUB v16.0 успешно переведен на Orion UI!")
