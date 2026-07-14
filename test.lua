-- ЖЕСТКАЯ ОЧИСТКА ПАМЯТИ ОТ ПУСТЫХ СТАРЫХ МЕНЮ
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
    Main.Size = UDim2.new(0, 420, 0, 240)
    Main.Position = UDim2.new(0.5, -210, 0.5, -120)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    Main.BorderSizePixel = 0
    Main.Active = true

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(230, 15, 15)
    Stroke.Thickness = 1.2
    Stroke.Transparency = 0.2

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

            function secObj:NewDropdown(text, list, callback)
                local DropFrame = Instance.new("Frame", Page)
                DropFrame.Size = UDim2.new(1, -5, 0, 30)
                DropFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
                Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 5)

                local DropLabel = Instance.new("TextLabel", DropFrame)
                DropLabel.Size = UDim2.new(1, -100, 1, 0)
                DropLabel.Position = UDim2.new(0, 12, 0, 0)
                DropLabel.Text = text
                DropLabel.TextColor3 = Color3.fromRGB(230, 230, 235)
                DropLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropLabel.Font = Enum.Font.GothamSemibold
                DropLabel.TextSize = 10
                DropLabel.BackgroundTransparency = 1

                local MainBtn = Instance.new("TextButton", DropFrame)
                MainBtn.Size = UDim2.new(0, 80, 0, 20)
                MainBtn.Position = UDim2.new(1, -90, 0.5, -10)
                MainBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                MainBtn.Text = "Выбрать"
                MainBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                MainBtn.Font = Enum.Font.Gotham
                MainBtn.TextSize = 9
                Instance.new("UICorner", MainBtn).CornerRadius = UDim.new(0, 4)

                local SubList = Instance.new("Frame", UI)
                SubList.Size = UDim2.new(0, 100, 0, #list * 22)
                SubList.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
                SubList.Visible = false
                SubList.ZIndex = 10
                Instance.new("UICorner", SubList).CornerRadius = UDim.new(0, 4)
                Instance.new("UIStroke", SubList).Color = Color3.fromRGB(200, 0, 0)

                local ListLayout = Instance.new("UIListLayout", SubList)

                for _, val in pairs(list) do
                    local Opt = Instance.new("TextButton", SubList)
                    Opt.Size = UDim2.new(1, 0, 0, 22)
                    Opt.BackgroundTransparency = 1
                    Opt.Text = tostring(val)
                    Opt.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Opt.Font = Enum.Font.Gotham
                    Opt.TextSize = 9
                    Opt.ZIndex = 11

                    Opt.MouseButton1Click:Connect(function()
                        MainBtn.Text = tostring(val)
                        SubList.Visible = false
                        callback(val)
                    end)
                end

                MainBtn.MouseButton1Click:Connect(function()
                    SubList.Visible = not SubList.Visible
                    SubList.Position = UDim2.new(0, MainBtn.AbsolutePosition.X - 10, 0, MainBtn.AbsolutePosition.Y + 25)
                end)
            end
            return secObj
        end
        return pageObj
    end

    function libObj:ToggleUI() Main.Visible = not Main.Visible end
    return libObj
end

-- СБОРКА И ПРИВЯЗКА ФУНКЦИЙ
local Window = KavoLambo.CreateLib("GothBeach Ultra v2.0")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

