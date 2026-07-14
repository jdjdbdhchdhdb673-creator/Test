-- ИСПРАВЛЕННЫЙ ДВИЖОК С АВТО-РЕНДЕРОМ ВКЛАДОК (ФИКС ПУСТОГО ЭКРАНА)
for _, name in pairs({"LamboUILib", "MobileToggleGui", "KavoUILib", "KavoAnimateLib"}) do
    local old = game.Players.LocalPlayer.PlayerGui:FindFirstChild(name)
    if old then old:Destroy() end
end

local KavoLambo = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

function KavoLambo.CreateLib(titleText)
    local UI = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
    UI.Name = "LamboUILib"
    UI.ResetOnSpawn = false

    local Main = Instance.new("Frame", UI)
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 440, 0, 250)
    Main.Position = UDim2.new(0.5, -220, 0.5, -125)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
    Main.BorderSizePixel = 0
    Main.Active = true

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(230, 15, 15)
    Stroke.Thickness = 1.2

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(0, 250, 0, 35)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Text = titleText:upper()
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12
    Title.BackgroundTransparency = 1

    -- Контейнер для вкладок слева (Sidebar)
    local Sidebar = Instance.new("ScrollingFrame", Main)
    Sidebar.Size = UDim2.new(0, 110, 1, -45)
    Sidebar.Position = UDim2.new(0, 8, 0, 38)
    Sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
    Sidebar.BackgroundTransparency = 0.3
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 0
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 6)

    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.Padding = UDim.new(0, 4)

    -- Контейнер для кнопок справа (Main Container)
    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -135, 1, -45)
    Container.Position = UDim2.new(0, 125, 0, 38)
    Container.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    Container.BackgroundTransparency = 0.5
    Container.BorderSizePixel = 0
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)

    local currentTab = nil
    local libObj = {}

    function libObj:NewTab(tabName)
        -- Создание видимой кнопки во фрейме Sidebar
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 28)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabBtn.BorderSizePixel = 0
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Color3.fromRGB(140, 140, 145)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 11
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 5)

        -- Создание страницы для кнопок внутри правого Container
        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, -10, 1, -10)
        Page.Position = UDim2.new(0, 5, 0, 5)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 0
        
        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.Padding = UDim.new(0, 5)

        -- Если это первая вкладка, делаем её активной сразу
        if not currentTab then
            currentTab = Page
            Page.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabBtn.BackgroundColor3 = Color3.fromRGB(200, 15, 15)
        end

        -- Логика переключения
        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(Container:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, btn in pairs(Sidebar:GetChildren()) do
                if btn:IsA("TextButton") then 
                    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                    btn.TextColor3 = Color3.fromRGB(140, 140, 145)
                end
            end
            Page.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(200, 15, 15)
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        local pageObj = {}
        function pageObj:NewSection()
            local secObj = {}
            function secObj:NewButton(text, desc, callback)
                local Btn = Instance.new("TextButton", Page)
                Btn.Size = UDim2.new(1, 0, 0, 32)
                Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
                Btn.BorderSizePixel = 0
                Btn.Text = "   " .. text
                Btn.TextColor3 = Color3.fromRGB(230, 230, 235)
                Btn.TextXAlignment = Enum.TextXAlignment.Left
                Btn.Font = Enum.Font.GothamSemibold
                Btn.TextSize = 11
                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
                Btn.MouseButton1Click:Connect(callback)
            end

            function secObj:NewToggle(text, desc, callback)
                local TglFrame = Instance.new("Frame", Page)
                TglFrame.Size = UDim2.new(1, 0, 0, 32)
                TglFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
                TglFrame.BorderSizePixel = 0
                Instance.new("UICorner", TglFrame).CornerRadius = UDim.new(0, 5)

                local TglLabel = Instance.new("TextLabel", TglFrame)
                TglLabel.Size = UDim2.new(1, -60, 1, 0)
                TglLabel.Position = UDim2.new(0, 12, 0, 0)
                TglLabel.Text = text
                TglLabel.TextColor3 = Color3.fromRGB(230, 230, 235)
                TglLabel.TextXAlignment = Enum.TextXAlignment.Left
                TglLabel.Font = Enum.Font.GothamSemibold
                TglLabel.TextSize = 11
                TglLabel.BackgroundTransparency = 1

                local ToggleBg = Instance.new("TextButton", TglFrame)
                ToggleBg.Size = UDim2.new(0, 32, 0, 16)
                ToggleBg.Position = UDim2.new(1, -42, 0.5, -8)
                ToggleBg.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                ToggleBg.Text = ""
                Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

                local Circle = Instance.new("Frame", ToggleBg)
                Circle.Size = UDim2.new(0, 10, 0, 10)
                Circle.Position = UDim2.new(0, 3, 0.5, -5)
                Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

                local enabled = false
                ToggleBg.MouseButton1Click:Connect(function()
                    enabled = not enabled
                    if enabled then
                        ToggleBg.BackgroundColor3 = Color3.fromRGB(230, 15, 15)
                        Circle.Position = UDim2.new(1, -13, 0.5, -5)
                    else
                        ToggleBg.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                        Circle.Position = UDim2.new(0, 3, 0.5, -5)
                    end
                    callback(enabled)
                end)
            end
            return secObj
        end
        return pageObj
    end

    function libObj:ToggleUI() Main.Visible = not Main.Visible end
    return libObj
end

-- ИНИЦИАЛИЗАЦИЯ МЕНЮ
local Window = KavoLambo.CreateLib("GothBeach Ultra v2.0")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

player.CharacterAdded:Connect(function(newChar) char = newChar hum = newChar:WaitForChild("Humanoid") end)
local noclip, espEnabled, infJump, autoSwing, autoSell, chamsEnabled = false, false, false, false, false, false
local espList = {}
local chamsList = {}
local currentGlowColor = Color3.fromRGB(255, 0, 0)

-- СОЗДАНИЕ СЕКЦИЙ И СТРУКТУРЫ
local MainTab = Window:NewTab("Главное")
local MainSection = MainTab:NewSection()

local FarmTab = Window:NewTab("Автофарм")
local FarmSection = FarmTab:NewSection()

local VisualsTab = Window:NewTab("Визуалы")
local VisualsSection = VisualsTab:NewSection()

-- НАПОЛНЕНИЕ КНОПКАМИ
MainSection:NewButton("Скорость 80 / Прыжок 120", "", function() if hum then hum.WalkSpeed = 80 hum.JumpPower = 120 end end)
MainSection:NewToggle("Ноклип (Сквозь стены)", "", function(state) noclip = state end)
MainSection:NewToggle("Бесконечные прыжки", "", function(state) infJump = state end)

FarmSection:NewToggle("Авто-удары (Auto Swing)", "", function(state) autoSwing = state end)
FarmSection:NewToggle("Авто-продажа (Auto Sell)", "", function(state) autoSell = state end)
FarmSection:NewButton("Скорость х150 (Rage Mode)", "", function() if hum then hum.WalkSpeed = 150 end end)

-- ВИЗУАЛЫ ДВИЖОК
local function createESP()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            local bill = head:FindFirstChild("LamboESP")
            if not bill then
                bill = Instance.new("BillboardGui", head)
                bill.Name = "LamboESP"
                bill.Size = UDim2.new(0, 130, 0, 22)
                bill.StudsOffset = Vector3.new(0, 2.2, 0)
                bill.AlwaysOnTop = true
                local label = Instance.new("TextLabel", bill)
                label.Name = "Label"
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = plr.Name
                label.TextScaled = true
                label.Font = Enum.Font.GothamBold
                table.insert(espList, bill)
      end
      
