-- Загрузка библиотеки Kavo UI через альтернативный стабильный источник
local Library = loadstring(game:HttpGet("https://pastebin.com"))()

-- Создание окна с красно-черной темой BloodSystem
local Window = Library.CreateLib("GOTHBEACH ULTRA v2.0", "BloodSystem")

-- ПЕРЕМЕННЫЕ ИГРОКА
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- Обновление персонажа при смерти
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
local autoSwing = false
local autoSell = false
local espList = {}

-- СОЗДАНИЕ ВКЛАДОК (ЛЕВОЕ МЕНЮ)
local MainTab = Window:NewTab("Главное")
local MainSection = MainTab:NewSection("Основные функции")

local FarmTab = Window:NewTab("🔴 АВТОФАРМ 🔴")
local FarmSection = FarmTab:NewSection("Фарм для Ninja Legends")

local VisualsTab = Window:NewTab("Визуалы")
local VisualsSection = VisualsTab:NewSection("ESP / Подсветка")

-- ЭЛЕМЕНТЫ ВКЛАДКИ ГЛАВНОЕ
MainSection:NewButton("Скорость 80 / Прыжок 120", "Увеличивает скорость и прыжок", function()
    if hum then
        hum.WalkSpeed = 80
        hum.JumpPower = 120
    end
end)

MainSection:NewToggle("Ноклип (Сквозь стены)", "Позволяет ходить сквозь любые объекты", function(state)
    noclip = state
end)

MainSection:NewToggle("Бесконечные прыжки", "Позволяет прыгать в воздухе без остановки", function(state)
    infJump = state
end)

-- ЭЛЕМЕНТЫ ВКЛАДКИ АВТОФАРМ (Для Ninja Legends, как на скрине)
FarmSection:NewToggle("Авто-удары (Auto Swing)", "Сам качает Ниндзюцу", function(state)
    autoSwing = state
end)

FarmSection:NewToggle("Авто-продажа (Auto Sell)", "Продает ниндзюцу, когда рюкзак полон", function(state)
    autoSell = state
end)

FarmSection:NewButton("Скорость х150 (Rage)", "Очень быстрый бег", function()
    if hum then hum.WalkSpeed = 150 end
end)

-- ЭЛЕМЕНТЫ ВКЛАДКИ ВИЗУАЛЫ
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

-- РАБОЧИЕ ЦИКЛЫ
task.spawn(function()
    while task.wait() do
        if autoSwing then
            game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("swingKatana")
        end
        if autoSell then
            game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("sellNinjaToins")
        end
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    if noclip and char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump and hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- КНОПКА МЕНЮ ДЛЯ ТЕЛЕФОНА
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
