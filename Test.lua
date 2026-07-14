-- GOTHBEACH MEGA SCRIPT v1.1 (с ESP)
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- 1. Скорость + прыжок
hum.WalkSpeed = 80
hum.JumpPower = 120

-- 2. Вечные прыжки
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 3. Ноклип
local noclip = true
game:GetService("RunService").Stepped:Connect(function()
    if noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 4. ESP (видеть игроков через стены)
local espEnabled = true
local function createESP()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local billboard = Instance.new("BillboardGui")
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = head

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = plr.Name .. "\n♥" .. tostring(plr.Character.Humanoid.Health)
                label.TextColor3 = Color3.new(1, 0, 0)
                label.TextScaled = true
                label.Parent = billboard
            end
        end
    end
end

-- Обновляем ESP при добавлении новых игроков
game.Players.PlayerAdded:Connect(createESP)
-- Запускаем для уже существующих
createESP()
-- Обновляем каждые 2 секунды (для здоровья)
while espEnabled do
    wait(2)
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            local bill = head:FindFirstChild("BillboardGui")
            if bill and bill:FindFirstChild("TextLabel") then
                bill.TextLabel.Text = plr.Name .. "\n♥" .. tostring(plr.Character.Humanoid.Health)
            end
        end
    end
end
