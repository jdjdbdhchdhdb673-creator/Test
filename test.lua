local Kavo = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
function Kavo.CreateLib(titleText, theme)
    local UI = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
    UI.Name = "KavoUILib"
    UI.ResetOnSpawn = false
    local Main = Instance.new("Frame", UI)
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 525, 0, 318)
    Main.Position = UDim2.new(0.5, -262, 0.5, -159)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.BorderSizePixel = 0
    Main.Active = true
    local TopLine = Instance.new("Frame", Main)
    TopLine.Size = UDim2.new(1, 0, 0, 3)
    TopLine.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    TopLine.BorderSizePixel = 0
    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(0, 200, 0, 30)
    Title.Position = UDim2.new(0, 15, 0, 5)
    Title.Text = titleText
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 18
    Title.BackgroundTransparency = 1
    local Sidebar = Instance.new("ScrollingFrame", Main)
    Sidebar.Size = UDim2.new(0, 140, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 2
    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.Padding = UDim.new(0, 5)
    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -150, 1, -40)
    Container.Position = UDim2.new(0, 145, 0, 40)
    Container.BackgroundTransparency = 1
    local currentTab = nil
    local libObj = {}
    function libObj:NewTab(tabName)
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabBtn.BorderSizePixel = 0
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Font = Enum.Font.SourceSans
        TabBtn.TextSize = 14
        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 3
        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.Padding = UDim.new(0, 6)
        if not currentTab then
            currentTab = Page
            Page.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(200, 0, 0)
        end
        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(Container:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, btn in pairs(Sidebar:GetChildren()) do
                if btn:IsA("TextButton") then btn.TextColor3 = Color3.fromRGB(200, 200, 200) end
            end
            Page.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(200, 0, 0)
        end)
        local pageObj = {}
        function pageObj:NewSection()
            local secObj = {}
            function secObj:NewButton(text, desc, callback)
                local Btn = Instance.new("TextButton", Page)
                Btn.Size = UDim2.new(1, -10, 0, 35)
                Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                Btn.BorderSizePixel = 0
                Btn.Text = "  " .. text
                Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                Btn.TextXAlignment = Enum.TextXAlignment.Left
                Btn.Font = Enum.Font.SourceSans
                Btn.TextSize = 14
                local Corner = Instance.new("UICorner", Btn)
                Corner.CornerRadius = UDim.new(0, 4)
                Btn.MouseButton1Click:Connect(callback)
            end
            function secObj:NewToggle(text, desc, callback)
                local TglFrame = Instance.new("Frame", Page)
                TglFrame.Size = UDim2.new(1, -10, 0, 35)
                TglFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                TglFrame.BorderSizePixel = 0
                local Corner = Instance.new("UICorner", TglFrame)
                Corner.CornerRadius = UDim.new(0, 4)
                local TglLabel = Instance.new("TextLabel", TglFrame)
                TglLabel.Size = UDim2.new(1, -50, 1, 0)
                TglLabel.Position = UDim2.new(0, 10, 0, 0)
                TglLabel.Text = text
                TglLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                TglLabel.TextXAlignment = Enum.TextXAlignment.Left
                TglLabel.Font = Enum.Font.SourceSans
                TglLabel.TextSize = 14
                TglLabel.BackgroundTransparency = 1
                local TglBtn = Instance.new("TextButton", TglFrame)
                TglBtn.Size = UDim2.new(0, 35, 0, 20)
                TglBtn.Position = UDim2.new(1, -45, 0.5, -10)
                TglBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                TglBtn.Text = ""
                local BtnCorner = Instance.new("UICorner", TglBtn)
                BtnCorner.CornerRadius = UDim.new(0, 4)
                local enabled = false
                TglBtn.MouseButton1Click:Connect(function()
                    enabled = not enabled
                    TglBtn.BackgroundColor3 = enabled and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(40, 40, 40)
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
local Window = Kavo.CreateLib("GOTHBEACH NINJA v2.0", "BloodSystem")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
player.CharacterAdded:Connect(function(newChar) char = newChar hum = newChar:WaitForChild("Humanoid") end)
local noclip, espEnabled, infJump, autoSwing, autoSell = false, false, false, false, false
local espList = {}
local MainTab = Window:NewTab("Главное")
local MainSection = MainTab:NewSection()
local FarmTab = Window:NewTab("🔴 АВТОФАРМ 🔴")
local FarmSection = FarmTab:NewSection()
local VisualsTab = Window:NewTab("Визуалы")
local VisualsSection = VisualsTab:NewSection()
MainSection:NewButton("Скорость 80 / Прыжок 120", "", function() if hum then hum.WalkSpeed = 80 hum.JumpPower = 120 end end)
MainSection:NewToggle("Ноклип (Сквозь стены)", "", function(state) noclip = state end)
MainSection:NewToggle("Бесконечные прыжки", "", function(state) infJump = state end)
FarmSection:NewToggle("Авто-удары (Auto Swing)", "", function(state) autoSwing = state end)
FarmSection:NewToggle("Авто-продажа (Auto Sell)", "", function(state) autoSell = state end)
FarmSection:NewButton("Скорость х150 (Rage)", "", function() if hum then hum.WalkSpeed = 150 end end)
local function createESP()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            if not head:FindFirstChild("BillboardGui") then
                local bill = Instance.new("BillboardGui", head)
                bill.Size = UDim2.new(0, 150, 0, 30)
                bill.StudsOffset = Vector3.new(0, 2.5, 0)
                bill.AlwaysOnTop = true
                local label = Instance.new("TextLabel", bill)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = plr.Name
                label.TextColor3 = Color3.fromRGB(200, 0, 0)
                label.TextScaled = true
                label.Font = Enum.Font.GothamBold
                table.insert(espList, bill)
            end
        end
    end
end
local function removeESP() for _, bill in pairs(espList) do if bill then bill:Destroy() end end espList = {} end
VisualsSection:NewToggle("Включить ESP ники", "", function(state) espEnabled = state if espEnabled then createESP() else removeESP() end end)
task.spawn(function()
    while task.wait(0.1) do
        if autoSwing then game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("swingKatana") end
        if autoSell then game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("sellNinjaToins") end
    end
end)
game:GetService("RunService").Stepped:Connect(function() if noclip and char then for _, part in pairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end end end)
game:GetService("UserInputService").JumpRequest:Connect(function() if infJump and hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end)
local MobileToggle = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
local ToggleBtn = Instance.new("TextButton", MobileToggle)
local UICorner = Instance.new("UICorner", ToggleBtn)
MobileToggle.Name = "MobileToggleGui"
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Position = UDim2.new(0.82, 0, 0.05, 0)
ToggleBtn.Size = UDim2.new(0, 55, 0, 35)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ToggleBtn.Text = "MENU"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 11
UICorner.CornerRadius = UDim.new(0, 6)
ToggleBtn.MouseButton1Click:Connect(function() Window:ToggleUI() end)
