-- Очистка старых интерфейсов
if game.Players.LocalPlayer.PlayerGui:FindFirstChild("KavoAnimateLib") then game.Players.LocalPlayer.PlayerGui.KavoAnimateLib:Destroy() end
if game.Players.LocalPlayer.PlayerGui:FindFirstChild("MobileToggleGui") then game.Players.LocalPlayer.PlayerGui.MobileToggleGui:Destroy() end

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local KavoAnimate = {}
function KavoAnimate.CreateLib(titleText)
    local UI = Instance.new("ScreenGui")
    UI.Name = "KavoAnimateLib"
    UI.Parent = game.Players.LocalPlayer.PlayerGui
    UI.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 500, 0, 300)
    Main.Position = UDim2.new(0.5, -250, 0.5, -150)
    Main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = UI
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 6)
    MainCorner.Parent = Main

    -- Анимация плавного появления меню
    Main.Size = UDim2.new(0, 500, 0, 0)
    TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 500, 0, 300)}):Play()

    local TopLine = Instance.new("Frame")
    TopLine.Size = UDim2.new(1, 0, 0, 3)
    TopLine.BackgroundColor3 = Color3.fromRGB(219, 13, 13)
    TopLine.BorderSizePixel = 0
    TopLine.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 250, 0, 35)
    Title.Position = UDim2.new(0, 15, 0, 5)
    Title.Text = titleText
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 15
    Title.BackgroundTransparency = 1
    Title.Parent = Main

    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, 130, 1, -45)
    Sidebar.Position = UDim2.new(0, 5, 0, 40)
    Sidebar.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 0
    Sidebar.Parent = Main

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Padding = UDim.new(0, 4)
    SidebarLayout.Parent = Sidebar

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -150, 1, -45)
    Container.Position = UDim2.new(0, 145, 0, 40)
    Container.BackgroundTransparency = 1
    Container.Parent = Main

    local currentTab = nil
    local libObj = {}

    function libObj:NewTab(tabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 34)
        TabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 12
        TabBtn.Parent = Sidebar
        
        local BtnCrn = Instance.new("UICorner")
        BtnCrn.CornerRadius = UDim.new(0, 4)
        BtnCrn.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(219, 13, 13)
        Page.Parent = Container

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 5)
        PageLayout.Parent = Page

        if not currentTab then
            currentTab = Page
            Page.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabBtn.BackgroundColor3 = Color3.fromRGB(219, 13, 13)
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(Container:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, btn in pairs(Sidebar:GetChildren()) do
                if btn:IsA("TextButton") then
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 22, 22), TextColor3 = Color3.fromRGB(160, 160, 160)}):Play()
                end
            end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(219, 13, 13), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)

        local pageObj = {}
        function pageObj:NewSection()
            local secObj = {}
            
            function secObj:NewButton(text, desc, callback)
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, -5, 0, 38)
                Btn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
                Btn.Text = "   " .. text
                Btn.TextColor3 = Color3.fromRGB(240, 240, 240)
                Btn.TextXAlignment = Enum.TextXAlignment.Left
                Btn.Font = Enum.Font.Gotham
                Btn.TextSize = 12
                Btn.Parent = Page
                
                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 5)
                Corner.Parent = Btn

                Btn.MouseButton1Click:Connect(function()
                    local oldColor = Btn.BackgroundColor3
                    TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                    task.wait(0.1)
                    TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = oldColor}):Play()
                    callback()
                end)
            end

            function secObj:NewToggle(text, desc, callback)
                local TglFrame = Instance.new("Frame")
                TglFrame.Size = UDim2.new(1, -5, 0, 38)
                TglFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
                TglFrame.Parent = Page

                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 5)
                Corner.Parent = TglFrame

                local TglLabel = Instance.new("TextLabel")
                TglLabel.Size = UDim2.new(1, -60, 1, 0)
                TglLabel.Position = UDim2.new(0, 12, 0, 0)
                TglLabel.Text = text
                TglLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
                TglLabel.TextXAlignment = Enum.TextXAlignment.Left
                TglLabel.Font = Enum.Font.Gotham
                TglLabel.TextSize = 12
                TglLabel.BackgroundTransparency = 1
                TglLabel.Parent = TglFrame

                local ToggleBg = Instance.new("TextButton")
                ToggleBg.Size = UDim2.new(0, 40, 0, 22)
                ToggleBg.Position = UDim2.new(1, -52, 0.5, -11)
                ToggleBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                ToggleBg.Text = ""
                ToggleBg.Parent = TglFrame
                
                local TglCrn = Instance.new("UICorner")
                TglCrn.CornerRadius = UDim.new(1, 0)
                TglCrn.Parent = ToggleBg

                local Circle = Instance.new("Frame")
                Circle.Size = UDim2.new(0, 16, 0, 16)
                Circle.Position = UDim2.new(0, 3, 0.5, -8)
                Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Circle.Parent = ToggleBg
                
                local CircleCrn = Instance.new("UICorner")
                CircleCrn.CornerRadius = UDim.new(1, 0)
                CircleCrn.Parent = Circle

                local enabled = false
                ToggleBg.MouseButton1Click:Connect(function()
                    enabled = not enabled
                    if enabled then
                        TweenService:Create(ToggleBg, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundColor3 = Color3.fromRGB(219, 13, 13)}):Play()
                        TweenService:Create(Circle, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -19, 0.5, -8)}):Play()
                    else
                        TweenService:Create(ToggleBg, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                        TweenService:Create(Circle, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Position = UDim2.new(0, 3, 0.5, -8)}):Play()
                    end
                    callback(enabled)
                end)
            end
            return secObj
        end
        return pageObj
    end

    function libObj:ToggleUI()
        if Main.Visible then
            local tw = TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 500, 0, 0)})
            tw:Play()
            tw.Completed:Connect(function() Main.Visible = false end)
        else
            Main.Visible = true
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 500, 0, 300)}):Play()
        end
    end
    return libObj
end

-- ЗАПУСК ТВОЕГО СОФТА
local Window = KavoAnimate.CreateLib("GOTHBEACH NINJA v2.0")

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hum = newChar:WaitForChild("Humanoid")
end)

local noclip = false
local espEnabled = false
local infJump = false
local autoSwing = false
local autoSell = false
local espList = {}

local MainTab = Window:NewTab("Главное")
local MainSection = MainTab:NewSection()

local FarmTab = Window:NewTab("🔴 АВТОФАРМ 🔴")
local FarmSection = FarmTab:NewSection()

local VisualsTab = Window:NewTab("Визуалы")
local VisualsSection = VisualsTab:NewSection()

-- КНОПКИ
MainSection:NewButton("Скорость 80 / Прыжок 120", "", function()
    
