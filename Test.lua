-- Загружаем библиотеку Orion (правильная ссылка)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- Удаляем старый хаб, если есть
if game:GetService("CoreGui"):FindFirstChild("Orion") then
    game:GetService("CoreGui"):FindFirstChild("Orion"):Destroy()
end

-- ===== ТВОИ СТАРЫЕ ФУНКЦИИ (КОТОРЫЕ РАБОТАЛИ) =====
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
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
    for _, obj in pairs(espHighlights) do
        if obj and obj.Parent then obj:Destroy() end
    end
    espHighlights = {}
    for _, conn in pairs(espConnections) do
        if conn then conn:Disconnect() end
    end
    espConnections = {}
end

local function ToggleESP(State)
    espEnabled = State
    if not espEnabled then
        ClearESP()
        return
    end
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

-- ===== ИНТЕРФЕЙС В ТОЧНОСТИ КАК У ГУГЛА =====
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

OrionLib:Init()
print("✅ GID_HUB v16.0 (Гугл-интерфейс + Твои функции) загружен!")
