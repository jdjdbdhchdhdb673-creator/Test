-- ОЧИСТКА ДУБЛИКАТОВ ИНТЕРФЕЙСА
for _, name in pairs({"LamboUILib", "MobileToggleGui", "KavoUILib"}) do
    local old = game.Players.LocalPlayer.PlayerGui:FindFirstChild(name)
    if old then old:Destroy() end
end

local KavoLambo = {}
local TweenService = game:GetService("TweenService")

function KavoLambo.CreateLib(titleText)
    local UI = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
    UI.Name = "LamboUILib"
    UI.ResetOnSpawn = false

    local Main = Instance.new("Frame", UI)
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 420, 0, 240)
    Main.Position = UDim2.new(0.5, -210, 0.5, -120)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
    Main.BorderSizePixel = 0

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

    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -135, 1, -45)
    Container.Position = UDim2.new(0, 125, 0, 38)
    Container.BackgroundTransparency = 1

    local currentTab = nil
    local libObj = {}

    function libObj:NewTab(tabName)
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 26)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Color3.fromRGB(140, 140, 145)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 10
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 5)

        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 0
        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.Padding = UDim.new(0, 4)

        if not currentTab then
            currentTab = Page
            Page.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabBtn.BackgroundColor3 = Color3.fromRGB(200, 15, 15)
        end

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
                Btn.Size = UDim2.new(1, -5, 0, 30)
                Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
                Btn.Text = "   " .. text
                Btn.TextColor3 = Color3.fromRGB(230, 230, 235)
                Btn.TextXAlignment = Enum.TextXAlignment.Left
                Btn.Font = Enum.Font.GothamSemibold
                Btn.TextSize = 10
                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
                Btn.MouseButton1Click:Connect(callback)
            end

            function secObj:NewToggle(text, desc, callback)
                local TglFrame = Instance.new("Frame", Page)
                TglFrame.Size = UDim2.new(1, -5, 0, 30)
                TglFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
                Instance.new("UICorner", TglFrame).CornerRadius = UDim.new(0, 5)

                local TglLabel = Instance.new("TextLabel", TglFrame)
                TglLabel.Size = UDim2.new(1, -60, 1, 0)
                TglLabel.Position = UDim2.new(0, 12, 0, 0)
                TglLabel.Text = text
                TglLabel.TextColor3 = Color3.fromRGB(230, 230, 235)
                TglLabel.TextXAlignment = Enum.TextXAlignment.Left
                TglLabel.Font = Enum.Font.GothamSemibold
                TglLabel.TextSize = 10
                TglLabel.BackgroundTransparency = 1

                local ToggleBg = Instance.new("TextButton", TglFrame)
                ToggleBg.Size = UDim2.new(0, 30, 0, 14)
                ToggleBg.Position = UDim2.new(1, -40, 0.5, -7)
                ToggleBg.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                ToggleBg.Text = ""
                Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

                local Circle = Instance.new("Frame", ToggleBg)
                Circle.Size = UDim2.new(0, 10, 0, 10)
                Circle.Position = UDim2.new(0, 2, 0.5, -5)
                Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

                local enabled = false
                ToggleBg.MouseButton1Click:Connect(function()
                    enabled = not enabled
                    if enabled then
                        ToggleBg.BackgroundColor3 = Color3.fromRGB(230, 15, 15)
                        Circle.Position = UDim2.new(1, -12, 0.5, -5)
                    else
                        ToggleBg.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                        Circle.Position = UDim2.new(0, 2, 0.5, -5)
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

-- ИНИЦИАЛИЗАЦИЯ И ПОДКЛЮЧЕНИЕ ФУНКЦИЙ К ЛАМБЕ
local Window = KavoLambo.CreateLib("GothBeach Ultra v2.0")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

player.CharacterAdded:Connect(function(newChar) char = newChar hum = newChar:WaitForChild("Humanoid") end)
local noclip, espEnabled, infJump, autoSwing, autoSell = false, false, false, false, false
local espList = {}

local MainTab = Window:NewTab("Главное")
local MainSection = MainTab:NewSection()
local FarmTab = Window:NewTab("Автофарм")
local FarmSection = FarmTab:NewSection()
local VisualsTab = Window:NewTab("Визуалы")
local VisualsSection = VisualsTab:NewSection()

MainSection:NewButton("Скорость 80 / Прыжок 120", "", function() if hum then hum.WalkSpeed = 80 hum.JumpPower = 120 end end)
MainSection:NewToggle("Ноклип (Сквозь стены)", "", function(state) noclip = state end)
MainSection:NewToggle("Бесконечные прыжки", "", function(state) infJump = state end)

FarmSection:NewToggle("Авто-удары (Auto Swing)", "", function(state) autoSwing = state end)
FarmSection:NewToggle("Авто-продажа (Auto Sell)", "", function(state) autoSell = state end)
FarmSection:NewButton("Скорость х150 (Rage Mode)", "", function() if hum then hum.WalkSpeed = 150 end end)

local function createESP()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            if not head:FindFirstChild("BillboardGui") then
                local bill = Instance.new("BillboardGui", head)
                bill.Size = UDim2.new(0, 130, 0, 22)
                bill.StudsOffset = Vector3.new(0, 2.2, 0)
                bill.AlwaysOnTop = true
                local label = Instance.new("TextLabel", bill)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = plr.Name
                label.TextColor3 = Color3.fromRGB(230, 15, 15)
                label.TextScaled = true
                label.Font = Enum.Font.GothamBold
                table.insert(espList, bill)
            end
        end
    end
end

local function removeESP()
    for _, bill in pairs(espList) do if bill then bill:Destroy() end end
    espList = {}
end

VisualsSection:NewToggle("Включить ESP ники", "", function(state)
    espEnabled = state
    if espEnabled then createESP() else removeESP() end
end)

task.spawn(function()
    while task.wait(0.1) do
        if autoSwing then game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("swingKatana") end
        if autoSell then game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("sellNinjaToins") end
    end
end)
game:GetService("RunService").Stepped:Connect(function() if noclip and char then for _, part in pairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end end end)
game:GetService("UserInputService").JumpRequest:Connect(function() if infJump and hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end)

-- ИСПРАВЛЕННАЯ АККУРАТНАЯ КНОПКА МЕНЮ
local MobileToggle = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
