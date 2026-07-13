local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("HydHub") then
    CoreGui:FindFirstChild("HydHub"):Destroy()
end

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

local function ToggleESP()
    espEnabled = not espEnabled
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

local gui = Instance.new("ScreenGui")
gui.Name = "HydHub"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 400)
main.Position = UDim2.new(0.5, -150, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
main.BackgroundTransparency = 0.1
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "⚡ GID_HUB v16.0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
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
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0.8, 0, 0, 50)
espBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
espBtn.Text = "☐ ESP"
espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espBtn.TextScaled = true
espBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
espBtn.BackgroundTransparency = 0.2
espBtn.Font = Enum.Font.GothamSemibold
espBtn.Parent = main

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 10)
espCorner.Parent = espBtn

espBtn.MouseButton1Click:Connect(function()
    ToggleESP()
    espBtn.Text = espEnabled and "☑ ESP" or "☐ ESP"
    espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
end)

print("✅ GID_HUB v16.0 загружен!")
