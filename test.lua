-- ТОТ САМЫЙ РАБОЧИЙ ВАРИАНТ "ЛАМБЫ" С ИСПРАВЛЕННЫМИ СЕКЦИЯМИ
for _, name in pairs({"LamboUILib", "MobileToggleGui", "KavoUILib"}) do
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
    Main.Size = UDim2.new(0, 440, 0, 260)
    Main.Position = UDim2.new(0.5, -220, 0.5, -130)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    Main.BorderSizePixel = 0
    Main.Active = true

    local MainCorner = Instance.new("UICorner", Main)
    MainCorner.CornerRadius = UDim.new(0, 8)

    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(230, 15, 15)
    Stroke.Thickness = 1.2
    Stroke.Transparency = 0.2

    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundTransparency = 1

    local Title = Instance.new("TextLabel", TopBar)
    Title.Size = UDim2.new(0, 300, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Text = titleText:upper()
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12
    Title.BackgroundTransparency = 1

    local Sidebar = Instance.new("ScrollingFrame", Main)
    Sidebar.Size = UDim2.new(0, 120, 1, -45)
    Sidebar.Position = UDim2.new(0, 8, 0, 38)
    Sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
    Sidebar.BackgroundTransparency = 0.3
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 0
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 6)

    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.Padding = UDim.new(0, 4)

    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -145, 1, -45)
    Container.Position = UDim2.new(0, 135, 0, 38)
    Container.BackgroundTransparency = 1

    local currentTab = nil
    local libObj = {}

    function libObj:NewTab(tabName)
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 28)
        TabBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Color3.fromRGB(140, 140, 145)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 11
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 5)

        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 0

        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.Padding = UDim.new(0, 5)

        if not currentTab then
            currentTab = Page
            Page.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabBtn.BackgroundTransparency = 0.1
            TabBtn.BackgroundColor3 = Color3.fromRGB(200, 15, 15)
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(Container:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, btn in pairs(Sidebar:GetChildren()) do
                if btn:IsA("TextButton") then 
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(140, 140, 145)}):Play()
                end
            end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.1, BackgroundColor3 = Color3.fromRGB(200, 15, 15), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)

        local pageObj = {}
        function pageObj:NewSection()
            local secObj = {}
            
            function secObj:NewButton(text, desc, callback)
                local Btn = Instance.new("TextButton", Page)
                Btn.Size = UDim2.new(1, -5, 0, 32)
                Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
                Btn.Text = "   " .. text
                Btn.TextColor3 = Color3.fromRGB(230, 230, 235)
                Btn.TextXAlignment = Enum.TextXAlignment.Left
                Btn.Font = Enum.Font.GothamSemibold
                Btn.TextSize = 11
                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)

                Btn.MouseButton1Click:Connect(function()
                    TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 15, 15)}):Play()
                    task.wait(0.1)
                    TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 25)}):Play()
                    callback()
                end)
            end

            function secObj:NewToggle(text, desc, callback)
                local TglFrame = Instance.new("Frame", Page)
                TglFrame.Size = UDim2.new(1, -5, 0, 32)
                TglFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
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
                ToggleBg.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
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
                        TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(230, 15, 15)}):Play()
                        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -13, 0.5, -5)}):Play()
                    else
                        TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
                        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -5)}):Play()
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

-- СБОРКА ИГРОКА И МЕНЮ
local Window = KavoLambo.CreateLib("GothBeach Ultra v2.0")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

player.CharacterAdded:Connect(function(newChar) char = newChar hum = newChar:WaitForChild("Humanoid") end)
local noclip, espEnabled, infJump, autoSwing, autoSell, chamsEnabled = false, false, false, false, false, false
local espList = {}
local chamsList = {}
local currentGlowColor = Color3.fromRGB(255, 0, 0)

-- ИСПРАВЛЕННЫЙ ВЫЗОВ СЕКЦИЙ (ЗДЕСЬ БЫЛ БАГ)
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
