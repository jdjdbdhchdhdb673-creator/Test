local Fluent = loadstring(game:HttpGet("https://github.com"))()

-- Убираем старые окна, если они зависли
if game:GetService("CoreGui"):FindFirstChild("Fluent") then
    game:GetService("CoreGui"):FindFirstChild("Fluent"):Destroy()
end

local Window = Fluent:CreateWindow({
    Title = "Roblox Hack Hub",
    SubTitle = "by jdjdbdhchdhdb673",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- Тот самый прозрачный стеклянный фон
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Главная", Icon = "home" })
}

-- ТВОЙ РАБОЧИЙ ESP КОД
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local espEnabled = false
local espHighlights = {}

local function ToggleESP(State)
    espEnabled = State
    if not espEnabled then
        for _, highlight in pairs(espHighlights) do
            if highlight then highlight:Destroy() end
        end
        espHighlights = {}
        return
    end
    
    local function addESP(player)
        if player == LocalPlayer then return end
        local function applyHighlight(character)
            if not espEnabled then return end
            if espHighlights[player] then espHighlights[player]:Destroy() end
            
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.FillColor = Color3.fromRGB(0, 255, 255) -- Бирюзовый цвет под этот интерфейс
            highlight.FillTransparency = 0.5
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 0
            highlight.Adornee = character
            highlight.Parent = game:GetService("CoreGui")
            
            espHighlights[player] = highlight
        end
        if player.Character then applyHighlight(player.Character) end
        player.CharacterAdded:Connect(function(character)
            if espEnabled then task.wait(0.5) applyHighlight(character) end
        end)
    end
    for _, player in ipairs(Players:GetPlayers()) do addESP(player) end
    Players.PlayerAdded:Connect(addESP)
    Players.PlayerRemoving:Connect(function(player)
        if espHighlights[player] then espHighlights[player]:Destroy() espHighlights[player] = nil end
    end)
end

-- ДОБАВЛЯЕМ ТУМБЛЕР В МЕНЮ
local Toggle = Tabs.Main:AddToggle("ESPToggle", {Title = "Включить ESP (Подсветка)", Default = false})
Toggle:OnChanged(function(Value)
    ToggleESP(Value)
    Fluent:Notify({
        Title = "ESP Мод",
        Content = Value and "Подсветка игроков активирована!" or "Подсветка отключена",
        Duration = 3
    })
end)

-- ДОБАВЛЯЕМ КНОПКУ ЗАКРЫТИЯ
Tabs.Main:AddButton({
    Title = "Закрыть чит-меню",
    Description = "Полностью убирает интерфейс с экрана",
    Callback = function()
        Window:Destroy()
    end
})

Window:SelectTab(1)
