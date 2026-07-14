-- GOTHBEACH MINI RAGE (без Kavo)
local p = game.Players.LocalPlayer
local c = p.Character or p.CharacterAdded:Wait()
local h = c:WaitForChild("Humanoid")
local r = c:WaitForChild("HumanoidRootPart")

local noclip = false
local esp = false
local infJump = false

-- Простое меню
local gui = Instance.new("ScreenGui")
gui.Parent = p.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 140)
frame.Position = UDim2.new(0.5, -90, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BackgroundTransparency = 0.15
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local function btn(text, y, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.9, 0, 0, 28)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Parent = frame
    b.MouseButton1Click:Connect(cb)
end

btn("Speed 80", 10, function() h.WalkSpeed = 80; h.JumpPower = 120 end)
btn("Noclip", 45, function() noclip = not noclip end)
btn("ESP", 80, function()
    esp = not esp
    if esp then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= p and plr.Character and plr.Character:FindFirstChild("Head") then
                local head = plr.Character.Head
                if not head:FindFirstChild("ESPtag") then
                    local bill = Instance.new("BillboardGui")
                    bill.Name = "ESPtag"
                    bill.Size = UDim2.new(0, 200, 0, 40)
                    bill.StudsOffset = Vector3.new(0, 2.5, 0)
                    bill.AlwaysOnTop = true
                    bill.Parent = head
                    local lbl = Instance.new("TextLabel")
                    lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = plr.Name
                    lbl.TextColor3 = Color3.fromRGB(255, 0, 0)
                    lbl.TextScaled = true
                    lbl.Parent = bill
                end
            end
        end
    else
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Head") then
                local tag = plr.Character.Head:FindFirstChild("ESPtag")
                if tag then tag:Destroy() end
            end
        end
    end
end)
btn("Inf Jump", 115, function() infJump = not infJump end)

-- Циклы
game:GetService("RunService").Stepped:Connect(function()
    if noclip and c then
        for _, part in pairs(c:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump and h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

print("GOTHBEACH MINI RAGE загружен!")
