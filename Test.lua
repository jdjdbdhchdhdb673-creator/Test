-- Загружаем современную библиотеку Orion
local OrionLib = loadstring(game:HttpGet("https://githubusercontent.com"))()

-- Проверяем, запущен ли хаб, чтобы избежать дублирования UI
if game:GetService("CoreGui"):FindFirstChild("Orion") then
    game:GetService("CoreGui"):FindFirstChild("Orion"):Destroy()
end

-- ===== ЛОГИКА ТВОИХ ФУНКЦИЙ =====
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local espEnabled = false
local espHighlights = {}

local function ToggleESP(State)
    espEnabled = State
    
    -- Очищаем старую подсветку при выключении
    if not espEnabled then
        for _, highlight in pairs(espHighlights) do
            if highlight then highlight:Destroy() end
        end
        espHighlights = {}
        return
    end
    
    -- Функция для добавления подсветки игрока
    local function addESP(player)
        if player == LocalPlayer then return end
        
        local function applyHighlight(character)
            if not espEnabled then return end
            if espHighlights[player] then espHighlights[player]:Destroy() end
            
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Красный цвет заливки
            highlight.FillTransparency = 0.5
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Белая обводка
            highlight.OutlineTransparency = 0
            highlight.Adornee = character
            highlight.Parent = game:GetService("CoreGui")
            
            espHighlights[player] = highlight
        end
        
        if player.Character then
            applyHighlight(player.Character)
        end
        
        player.CharacterAdded:Connect(function(character)
            if espEnabled then
                task.wait(0.5)
                applyHighlight(character)
            end
        end)
    end
    
    -- Включаем ESP для всех текущих игроков
    for _, player in ipairs(Players:GetPlayers()) do
        addESP(player)
    end
    
    -- Отслеживаем новых зашедших на сервер игроков
    Players.PlayerAdded:Connect(addESP)
    
    -- Удаляем подсветку, если игрок вышел
    Players.PlayerRemoving:Connect(function(player)
        if espHighlights[player] then
            espHighlights[player]:Destroy()
            espHighlights[player] = nil
        end
    end)
end

-- ===== СОЗДАНИЕ ИНТЕРФЕЙСА ORION =====
local Window = OrionLib:MakeWindow({
    Name = "Roblox Hack Hub", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "OrionTest"
})

local Tab = Window:MakeTab({
    Name = "Главная",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

Tab:AddToggle({
    Name = "Включить ESP (Подсветка игроков)",
    Default = false,
    Callback = function(Value)
        ToggleESP(Value)
    end    
})

Tab:AddButton({
    Name = "Уничтожить чит-меню",
    Callback = function()
        OrionLib:Destroy()
    end
})

-- Инициализация интерфейса
OrionLib:Init()
