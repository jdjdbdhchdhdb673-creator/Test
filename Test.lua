-- ===================================================
-- ФИНАЛЬНЫЙ СБОРНИК: Aimbot + ESP + Speed + Jump + Invis + God
-- ДЛЯ ТЕЛЕФОНА (DELTA / ARCEUS X)
-- ===================================================

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local camera = game.Workspace.CurrentCamera

-- ===== НАСТРОЙКИ (меняй под себя) =====
local SPEED = 50
local JUMP = 80
local AIM_FOV = 200
local AIM_SMOOTH = 0.3
local ESP_COLOR = Color3.fromRGB(255, 0, 0)
local ESP_THICKNESS = 2

-- ===== СОСТОЯНИЯ =====
local state = {
    speed = false,
    jump = false,
    invis = false,
    god = false,
    aimbot = false,
    esp = false
}

-- ===== ОБНОВЛЕНИЕ ПЕРСОНАЖА =====
local function refreshChar()
    char = player.Character or player.CharacterAdded:Wait()
    hum = char:FindFirstChild("Humanoid")
end
player.CharacterAdded:Connect(refreshChar)

-- ===== МЕНЮ (для телефона) =====
local ui = Instance.new("ScreenGui")
ui.Name = "FinalMenu"
ui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.5, 0, 0.7, 0)
frame.Position = UDim2.new(0.25, 0, 0.15, 0)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Parent = ui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
title.Text = "⚡ КОНТРОЛЬ"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Parent = frame

local function createBtn(text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0.1, 0)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

createBtn("🏃 Скорость (x3)", 0.12, function()
    state.speed = not state.speed
    refreshChar()
    if hum then hum.WalkSpeed = state.speed and SPEED or 16 end
end)

createBtn("⬆ Прыжок (x2)", 0.24, function()
    state.jump = not state.jump
    refreshChar()
    if hum then hum.JumpPower = state.jump and JUMP or 50 end
end)

createBtn("👻 Невидимость", 0.36, function()
    state.invis = not state.invis
    refreshChar()
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("BasePart") then
            v.Transparency = state.invis and 1 or 0
        end
    end
end)

createBtn("🛡 Бессмертие", 0.48, function()
    state.god = not state.god
    refreshChar()
    if hum then
        hum.MaxHealth = state.god and math.huge or 100
        hum.Health = state.god and math.huge or 100
    end
end)

createBtn("🎯 Aimbot (вкл/выкл)", 0.60, function()
    state.aimbot = not state.aimbot
end)

createBtn("👁 ESP (вкл/выкл)", 0.72, function()
    state.esp = not state.esp
end)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 50, 0, 40)
closeBtn.Position = UDim2.new(1, -55, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
    ui:Destroy()
end)

-- Открытие/закрытие по трём пальцам
local touchCount = 0
game:GetService("UserInputService").TouchStarted:Connect(function()
    touchCount = touchCount + 1
    if touchCount >= 3 then
        ui.Enabled = not ui.Enabled
        touchCount = 0
    end
    task.wait(0.5)
    touchCount = 0
end)

-- ===== AIMBOT =====
local function getClosestPlayer()
    local closest = nil
    local dist = AIM_FOV
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = camera:WorldToScreenPoint(plr.Character.HumanoidRootPart.Position)
            if onScreen then
                local screenDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)).Magnitude
                if screenDist < dist then
                    dist = screenDist
                    closest = plr
                end
            end
        end
    end
    return closest
end

game:GetService("RunService").RenderStepped:Connect(function()
    if state.aimbot then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local root = target.Character.HumanoidRootPart
            local lookAt = root.Position + Vector3.new(0, 1.5, 0)
            camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, lookAt), AIM_SMOOTH)
        end
    end
end)

-- ===== ESP (подсветка игроков) =====
local espObjects = {}
game:GetService("RunService").RenderStepped:Connect(function()
    if state.esp then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    if not espObjects[plr] then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Size = Vector3.new(4, 6, 2)
                        box.Adornee = root
                        box.ZIndex = 0
                        box.AlwaysOnTop = true
                        box.Color3 = ESP_COLOR
                        box.Transparency = 0.5
                        box.Visible = true
                        box.Parent = root
                        espObjects[plr] = box
                    end
                end
            end
        end
    else
        for _, obj in pairs(espObjects) do
            obj:Destroy()
        end
        espObjects = {}
    end
end)

print("✅ Финальный скрипт загружен! Три пальца = меню.")
