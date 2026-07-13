-- ГИД ХАБ v9.0 (ПРОФЕССИОНАЛЬНЫЙ ИНТЕРФЕЙС)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- Удаляем старый хаб
if CoreGui:FindFirstChild("HydHub") then
    CoreGui:FindFirstChild("HydHub"):Destroy()
end

-- ===== ESP (СТРОГИЙ) =====
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
                hl.FillColor = Color3.fromRGB(0, 255, 0)
                hl.OutlineColor = Color3.fromRGB(0, 255, 0)
                hl.FillTransparency = 0.3
                table.insert(espHighlights, hl)
                local bb = Instance.new("BillboardGui")
                bb.Parent = root
                bb.AlwaysOnTop = true
                bb.Size = UDim2.new(0, 100, 0, 20)
                bb.StudsOffset = Vector3.new(0, 2, 0)
                local label = Instance.new("TextLabel")
                label.Parent = bb
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = player.Name
                label.TextColor3 = Color3.fromRGB(0, 255, 0)
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

-- ===== ИНТЕРФЕЙС (СТРОГИЙ, БЕЗ ЛИШНЕГО) =====
local gui = Instance.new("ScreenGui")
gui.Name = "HydHub"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 320, 0, 420)
main.Position = UDim2.new(0.5, -160, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BackgroundTransparency = 0
main.BorderSizePixel = 1
main.BorderColor3 = Color3.fromRGB(50, 50, 50)
main.Active = true
main.Draggable = true
main.Parent = gui

-- ЗАГОЛОВОК
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "GID_HUB v9.0"
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 0)
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(255, 80, 80)
close.TextScaled = true
close.BackgroundTransparency = 1
close.Font = Enum.Font.GothamBold
close.Parent = main
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- РАЗДЕЛИТЕЛЬ (горизонтальная линия)
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -20, 0, 1)
divider.Position = UDim2.new(0, 10, 0, 35)
divider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
divider.BorderSizePixel = 0
divider.Parent = main

-- ===== БЛОК 1: УСТРОЙСТВА (ГАЛОЧКИ) =====
local deviceFrame = Instance.new("Frame")
deviceFrame.Size = UDim2.new(1, -20, 0, 80)
deviceFrame.Position = UDim2.new(0, 10, 0, 45)
deviceFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
deviceFrame.BorderSizePixel = 0
deviceFrame.Parent = main

local deviceLabel = Instance.new("TextLabel")
deviceLabel.Size = UDim2.new(1, 0, 0, 20)
deviceLabel.Text = "> TARGETS"
deviceLabel.TextColor3 = Color3.fromRGB(136, 136, 136)
deviceLabel.TextScaled = true
deviceLabel.TextXAlignment = Enum.TextXAlignment.Left
deviceLabel.BackgroundTransparency = 1
deviceLabel.Font = Enum.Font.GothamBold
deviceLabel.Parent = deviceFrame

local devices = {"iPhone 13", "iPhone 14", "Samsung S23"}
local checkboxes = {}
for i, name in ipairs(devices) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.3, 0, 0, 25)
    btn.Position = UDim2.new((i-1)*0.33, 0, 0.4, 0)
    btn.Text = "☐ " .. name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextScaled = true
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BackgroundTransparency = 1
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = deviceFrame
    checkboxes[i] = {btn = btn, state = false}
    btn.MouseButton1Click:Connect(function()
        checkboxes[i].state = not checkboxes[i].state
        btn.Text = (checkboxes[i].state and "☑ " or "☐ ") .. name
        btn.TextColor3 = checkboxes[i].state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(200, 200, 200)
    end)
end

-- РАЗДЕЛИТЕЛЬ 2
local divider2 = Instance.new("Frame")
divider2.Size = UDim2.new(1, -20, 0, 1)
divider2.Position = UDim2.new(0, 10, 0, 130)
divider2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
divider2.BorderSizePixel = 0
divider2.Parent = main

-- ===== БЛОК 2: НАСТРОЙКИ =====
local configFrame = Instance.new("Frame")
configFrame.Size = UDim2.new(1, -20, 0, 110)
configFrame.Position = UDim2.new(0, 10, 0, 140)
configFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
configFrame.BorderSizePixel = 0
configFrame.Parent = main

local configLabel = Instance.new("TextLabel")
configLabel.Size = UDim2.new(1, 0, 0, 20)
configLabel.Text = "> CONFIG"
configLabel.TextColor3 = Color3.fromRGB(136, 136, 136)
configLabel.TextScaled = true
configLabel.TextXAlignment = Enum.TextXAlignment.Left
configLabel.BackgroundTransparency = 1
configLabel.Font = Enum.Font.GothamBold
configLabel.Parent = configFrame

-- Ширина
local wLabel = Instance.new("TextLabel")
wLabel.Size = UDim2.new(0.2, 0, 0, 25)
wLabel.Position = UDim2.new(0, 0, 0.35, 0)
wLabel.Text = "W:"
wLabel.TextColor3 = Color3.fromRGB(136, 136, 136)
wLabel.TextScaled = true
wLabel.TextXAlignment = Enum.TextXAlignment.Left
wLabel.BackgroundTransparency = 1
wLabel.Font = Enum.Font.GothamBold
wLabel.Parent = configFrame

local wInput = Instance.new("TextBox")
wInput.Size = UDim2.new(0.15, 0, 0, 25)
wInput.Position = UDim2.new(0.15, 0, 0.35, 0)
wInput.Text = "1080"
wInput.TextColor3 = Color3.fromRGB(255, 255, 255)
wInput.TextScaled = true
wInput.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
wInput.BorderSizePixel = 1
wInput.BorderColor3 = Color3.fromRGB(50, 50, 50)
wInput.Font = Enum.Font.GothamSemibold
wInput.Parent = configFrame

-- Высота
local hLabel = Instance.new("TextLabel")
hLabel.Size = UDim2.new(0.2, 0, 0, 25)
hLabel.Position = UDim2.new(0.35, 0, 0.35, 0)
hLabel.Text = "H:"
hLabel.TextColor3 = Color3.fromRGB(136, 136, 136)
hLabel.TextScaled = true
hLabel.TextXAlignment = Enum.TextXAlignment.Left
hLabel.BackgroundTransparency = 1
hLabel.Font = Enum.Font.GothamBold
hLabel.Parent = configFrame

local hInput = Instance.new("TextBox")
hInput.Size = UDim2.new(0.15, 0, 0, 25)
hInput.Position = UDim2.new(0.5, 0, 0.35, 0)
hInput.Text = "1920"
hInput.TextColor3 = Color3.fromRGB(255, 255, 255)
hInput.TextScaled = true
hInput.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
hInput.BorderSizePixel = 1
hInput.BorderColor3 = Color3.fromRGB(50, 50, 50)
hInput.Font = Enum.Font.GothamSemibold
hInput.Parent = configFrame

-- Ползунок
local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(0.5, 0, 0, 20)
sliderLabel.Position = UDim2.new(0, 0, 0.75, 0)
sliderLabel.Text = "SENS: 50%"
sliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
sliderLabel.TextScaled = true
sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
sliderLabel.BackgroundTransparency = 1
sliderLabel.Font = Enum.Font.GothamSemibold
sliderLabel.Parent = configFrame

-- РАЗДЕЛИТЕЛЬ 3
local divider3 = Instance.new("Frame")
divider3.Size = UDim2.new(1, -20, 0, 1)
divider3.Position = UDim2.new(0, 10, 0, 255)
divider3.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
divider3.BorderSizePixel = 0
divider3.Parent = main

-- ===== БЛОК 3: УПРАВЛЕНИЕ =====
local actionFrame = Instance.new("Frame")
actionFrame.Size = UDim2.new(1, -20, 0, 70)
actionFrame.Position = UDim2.new(0, 10, 0, 265)
actionFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
actionFrame.BorderSizePixel = 0
actionFrame.Parent = main

local actionLabel = Instance.new("TextLabel")
actionLabel.Size = UDim2.new(1, 0, 0, 20)
actionLabel.Text = "> ACTION"
actionLabel.TextColor3 = Color3.fromRGB(136, 136, 136)
actionLabel.TextScaled = true
actionLabel.TextXAlignment = Enum.TextXAlignment.Left
actionLabel.BackgroundTransparency = 1
actionLabel.Font = Enum.Font.GothamBold
actionLabel.Parent = actionFrame

-- Кнопка СТАРТ
local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0.5, -5, 0, 35)
startBtn.Position = UDim2.new(0, 0, 0.5, 0)
startBtn.Text = "EXECUTE"
startBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
startBtn.TextScaled = true
startBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
startBtn.BorderSizePixel = 1
startBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
startBtn.Font = Enum.Font.GothamBold
startBtn.Parent = actionFrame

startBtn.MouseButton1Click:Connect(function()
    print("[ EXECUTE ] Нажат!")
    -- СЮДА ТВОЙ КОД
end)

-- Кнопка ОТМЕНА
local cancelBtn = Instance.new("TextButton")
cancelBtn.Size = UDim2.new(0.5, -5, 0, 35)
cancelBtn.Position = UDim2.new(0.5, 5, 0.5, 0)
cancelBtn.Text = "CANCEL"
cancelBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
cancelBtn.TextScaled = true
cancelBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
cancelBtn.BorderSizePixel = 1
cancelBtn.BorderColor3 = Color3.fromRGB(50, 50, 50)
cancelBtn.Font = Enum.Font.GothamBold
cancelBtn.Parent = actionFrame

cancelBtn.MouseButton1Click:Connect(function()
    print("[ CANCEL ] Нажат!")
    gui:Destroy()
end)

print("✅ GID_HUB v9.0 (Профессиональный) загружен!")
