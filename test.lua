-- Загрузка библиотеки Kavo UI Library (ИСПРАВЛЕННАЯ ССЫЛКА)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/7b0x/Synapse-UI-Libraries/main/Kavo%20UI%20Library.lua"))()

-- Установка красно-черной темы BloodSystem
local Window = Library.CreateLib("GOTHBEACH DEEPWOKEN v2.0 [RAGE]", "BloodSystem")

-- ПЕРЕМЕННЫЕ ИГРОКА
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- Обновление персонажа при возрождении (ФИКС)
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hum = newChar:WaitForChild("Humanoid")
    root = newChar:WaitForChild("HumanoidRootPart")
    
    if noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- ПЕРЕМЕННЫЕ ФУНКЦИЙ
local noclip = false
local espEnabled = false
local infJump = false
local autoParry = false
local rageSpeed = false
local espList = {}

-- СОЗДАНИЕ ВКЛАДОК И СЕКЦИЙ
local RageTab = Window:NewTab("🔴 DEEP RAGE 🔴")
local RageSection = RageTab:NewSection("Deepwoken Rage Функции")

local MainTab = Window:NewTab("Главное")
local MainSection = MainTab:NewSection("Основные функции")

local VisualsTab = Window:NewTab("Визуалы")
local VisualsSection = VisualsTab:NewSection("ESP / Подсветка")

-- =========================================================
-- ВКЛАДКА "DEEP RAGE"
-- =========================================================

RageSection:NewToggle("Auto-Parry / Block", "Автоматически парирует атаки врагов и монстров", function(state)
    autoParry = state
end)

RageSection:NewToggle("Bypass Rage Speed", "Агрессивная скорость без моментального кика античитом", function(state)
    rageSpeed = state
end)

RageSection:NewButton("TP Behind Nearest Player", "Телепорт за спину ближайшего игрока для бэкстаба", function()
    local closestBtn = nil
    local maxDist = math.huge
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if dist < maxDist then
                maxDist = dist
                closestBtn = p.Character.HumanoidRootPart
            end
        end
    end
    if closestBtn and root then
        root.CFrame = closestBtn.CFrame * CFrame.new(0, 0, 3)
    end
end)

-- =========================================================
-- ВКЛАДКА "ГЛАВНОЕ"
-- =========================================================

MainSection:NewButton("Скорость 80 / Прыжок 120", "Увеличивает скорость бега и высоту прыжка", function()
    if hum then
        hum.WalkSpeed = 80
        hum.JumpPower = 120
    end
end)

MainSection:NewToggle("Ноклип (Проход сквозь стены)", "Позволяет ходить сквозь любые объекты", function(state)
    noclip = state
end)

MainSection:NewToggle("Бесконечные прыжки", "Позволяет прыгать в воздухе без остановки", function(state)
    infJump = state
end)

-- =========================================================
-- ВКЛАДКА "ВИЗУАЛЫ" (ИСПРАВЛЕННЫЙ ESP)
-- =========================================================

local function createESP()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            if not head:FindFirstChild("BillboardGui") then
                local bill = Instance.new("BillboardGui")
                bill.Size = UDim2.new(0, 200, 0, 40)
                bill.StudsOffset = Vector3.new(0, 2.5, 0)
                bill.AlwaysOnTop = true
                bill.Parent = head

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = plr.Name
                label.TextColor3 = Color3.fromRGB(255, 50, 50)
                label.TextScaled = true
                label.Parent = bill
                table.insert(espList, bill)
            end
        end
    end
end

local function removeESP()
    for _, bill in pairs(espList) do if bill then bill:Destroy() end end
    espList = {}
end

VisualsSection:NewToggle("Включить ESP ники", "Показывает ники игроков сквозь стены", function(state)
    espEnabled = state
    if espEnabled then createESP() else removeESP() end
end)

-- =========================================================
-- ЛОГИКА РАБОТЫ ФУНКЦИЙ И ЦИКЛЫ
-- =========================================================

game:GetService("RunService").Stepped:Connect(function()
    -- Ноклип loop
    if noclip and char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    
    -- Обход скорости под Дипвокен
    if rageSpeed and root and hum and hum.MoveDirection.Magnitude > 0 then
        root.CFrame = root.CFrame + (hum.MoveDirection * 1.5)
    end
    
    -- Авто-парирование
    if autoParry and root then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("AnimationTrack") or (obj:IsA("BasePart") and obj.Name:lower():find("attack")) then
                local creator = obj.Parent
                if creator and creator:FindFirstChild("HumanoidRootPart") and creator ~= char then
                    local distance = (root.Position - creator.HumanoidRootPart.Position).Magnitude
                    if distance <= 12 then
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)
                        task.wait(0.05)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.F, false, game)
                    end
                end
            end
        end
    end
end)

-- Обновление ESP для новых игроков (ФИКС)
game.Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() if espEnabled then task.wait(1) createESP() end end)
end)

for _, p in pairs(game.Players:GetPlayers()) do
    if p ~= player then
        p.CharacterAdded:Connect(function() if espEnabled then task.wait(1) createESP() end end)
    end
end

-- Бесконечные прыжки
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump and hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- 📱 КНОПКА ОТКРЫТИЯ/ЗАКРЫТИЯ ДЛЯ ТЕЛЕФОНА
local MobileToggle = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

MobileToggle.Name = "MobileToggleGui"
MobileToggle.Parent = game.CoreGui or player.PlayerGui

ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MobileToggle
ToggleBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ToggleBtn.Text = "MENU"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 12
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Active = true
ToggleBtn.Draggable = true

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function() Library:ToggleUI() end)

print("Финальный GOTHBEACH DEEPWOKEN скрипт с меню успешно запущен!")
