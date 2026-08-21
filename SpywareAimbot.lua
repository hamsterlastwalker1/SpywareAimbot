-- SpywareAimbot.lua - Düzenli UI + Animasyon + ESP
-- hamster & spyware tarafından oluşturulmuştur

-- ============================================
-- 1. UI KÜTÜPHANESİ (Sıfırdan, Düzenli)
-- ============================================
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local Library = {}

function Library:CreateWindow(title)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.CoreGui
    screenGui.Name = "SpywareUI"
    screenGui.ResetOnSpawn = false

    -- Ana Frame (menü)
    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 320, 0, 480)
    mainFrame.Position = UDim2.new(0.5, -160, 0.5, -240)
    mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Active = true
    mainFrame.Draggable = true

    -- Giriş Animasyonu (Ölçek ve Opaklık)
    mainFrame.Scale = 0.8
    mainFrame.BackgroundTransparency = 1
    local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local tweenScale = TweenService:Create(mainFrame, tweenInfo, {Scale = 1})
    local tweenOpacity = TweenService:Create(mainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.1})
    tweenScale:Play()
    tweenOpacity:Play()

    -- Gölge efekti (arka plan)
    local shadow = Instance.new("Frame")
    shadow.Parent = mainFrame
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.6
    shadow.BorderSizePixel = 0
    shadow.ZIndex = -1

    -- Başlık çubuğu
    local titleBar = Instance.new("Frame")
    titleBar.Parent = mainFrame
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    titleBar.BorderSizePixel = 0

    -- Başlık yazısı
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = titleBar
    titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
    titleLabel.Position = UDim2.new(0.05, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    titleLabel.TextScaled = true
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamSemibold

    -- Alt başlık (hamster & spyware)
    local subLabel = Instance.new("TextLabel")
    subLabel.Parent = titleBar
    subLabel.Size = UDim2.new(0.8, 0, 0.6, 0)
    subLabel.Position = UDim2.new(0.05, 0, 0.5, 0)
    subLabel.BackgroundTransparency = 1
    subLabel.Text = "• hamster & spyware tarafından oluşturulmuştur"
    subLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    subLabel.TextScaled = true
    subLabel.TextXAlignment = Enum.TextXAlignment.Left
    subLabel.Font = Enum.Font.Gotham
    subLabel.TextSize = 12

    -- Kapatma butonu
    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = titleBar
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 8)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Scroll Frame (içerik)
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Parent = mainFrame
    scrollFrame.Size = UDim2.new(1, 0, 1, -45)
    scrollFrame.Position = UDim2.new(0, 0, 0, 45)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 120)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

    -- İçerik düzeni (UIListLayout)
    local layout = Instance.new("UIListLayout")
    layout.Parent = scrollFrame
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)

    self.Window = {
        Frame = mainFrame,
        ScreenGui = screenGui,
        ScrollFrame = scrollFrame,
        Layout = layout,
        Elements = {}
    }

    return self.Window
end

-- TOGGLE
function Library:CreateToggle(window, config)
    local frame = Instance.new("Frame")
    frame.Parent = window.ScrollFrame
    frame.Size = UDim2.new(0.95, 0, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
    frame.BorderSizePixel = 0

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.Name
    label.TextColor3 = Color3.fromRGB(220, 220, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham

    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.Size = UDim2.new(0, 60, 0, 26)
    btn.Position = UDim2.new(0.85, 0, 0.5, -13)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    btn.BorderSizePixel = 0
    btn.Text = "KAPALI"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold

    local state = config.CurrentValue or false
    getgenv()[config.Flag] = state
    if state then
        btn.Text = "AÇIK"
        btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    end

    btn.MouseButton1Click:Connect(function()
        state = not state
        getgenv()[config.Flag] = state
        btn.Text = state and "AÇIK" or "KAPALI"
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 80)
        if config.Callback then config.Callback(state) end
    end)

    table.insert(window.Elements, frame)
    window.CanvasSize = window.CanvasSize + UDim2.new(0, 0, 0, 32 + 6)
    window.ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, window.CanvasSize.Y)
end

-- DROPDOWN
function Library:CreateDropdown(window, config)
    local frame = Instance.new("Frame")
    frame.Parent = window.ScrollFrame
    frame.Size = UDim2.new(0.95, 0, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
    frame.BorderSizePixel = 0

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.Name
    label.TextColor3 = Color3.fromRGB(220, 220, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham

    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.Size = UDim2.new(0.35, 0, 0, 26)
    btn.Position = UDim2.new(0.6, 0, 0.5, -13)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.BorderSizePixel = 0
    btn.Text = config.Default or "Seç"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham

    local options = config.Options
    local currentIndex = 1
    for i, opt in ipairs(options) do
        if opt == config.Default then currentIndex = i break end
    end
    getgenv()[config.Flag] = options[currentIndex]

    btn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex % #options + 1
        local selected = options[currentIndex]
        btn.Text = selected
        getgenv()[config.Flag] = selected
        if config.Callback then config.Callback(selected) end
    end)

    table.insert(window.Elements, frame)
    window.CanvasSize = window.CanvasSize + UDim2.new(0, 0, 0, 32 + 6)
    window.ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, window.CanvasSize.Y)
end

-- SLIDER
function Library:CreateSlider(window, config)
    local frame = Instance.new("Frame")
    frame.Parent = window.ScrollFrame
    frame.Size = UDim2.new(0.95, 0, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
    frame.BorderSizePixel = 0

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.5, 0, 0.5, 0)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.Name
    label.TextColor3 = Color3.fromRGB(220, 220, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = frame
    valueLabel.Size = UDim2.new(0.3, 0, 0.5, 0)
    valueLabel.Position = UDim2.new(0.65, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(config.Default or 100)
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.TextScaled = true
    valueLabel.Font = Enum.Font.Gotham

    local sliderBg = Instance.new("Frame")
    sliderBg.Parent = frame
    sliderBg.Size = UDim2.new(0.9, 0, 0, 10)
    sliderBg.Position = UDim2.new(0.05, 0, 0, 30)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    sliderBg.BorderSizePixel = 0

    local fill = Instance.new("Frame")
    fill.Parent = sliderBg
    fill.Size = UDim2.new(0.5, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.BorderSizePixel = 0

    local min = config.Min or 0
    local max = config.Max or 500
    local value = config.Default or 100
    getgenv()[config.Flag] = value
    valueLabel.Text = tostring(value)
    fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)

    local dragging = false
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    UserInput.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging then
            local mousePos = localPlayer:GetMouse().X
            local sliderPos = sliderBg.AbsolutePosition.X
            local sliderSize = sliderBg.AbsoluteSize.X
            local percent = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            value = math.floor(min + (max - min) * percent)
            getgenv()[config.Flag] = value
            valueLabel.Text = tostring(value)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            if config.Callback then config.Callback(value) end
        end
    end)

    table.insert(window.Elements, frame)
    window.CanvasSize = window.CanvasSize + UDim2.new(0, 0, 0, 44 + 6)
    window.ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, window.CanvasSize.Y)
end

-- ============================================
-- 2. ANA MENÜ
-- ============================================
local Window = Library:CreateWindow("Spyware Aimbot")

Library:CreateToggle(Window, {
    Name = "Aimbot Aktif",
    CurrentValue = false,
    Flag = "AimbotEnabled",
    Callback = function(v) end
})

Library:CreateDropdown(Window, {
    Name = "Hedef Kısım",
    Options = {"Kafa", "Gövde"},
    Default = "Kafa",
    Flag = "TargetPart",
    Callback = function(v) end
})

Library:CreateSlider(Window, {
    Name = "Menzil",
    Min = 50,
    Max = 500,
    Default = 200,
    Flag = "AimRadius",
    Callback = function(v) end
})

Library:CreateToggle(Window, {
    Name = "Otomatik Ateş",
    CurrentValue = true,
    Flag = "AutoFire",
    Callback = function(v) end
})

Library:CreateToggle(Window, {
    Name = "ESP (Takım Renkleri)",
    CurrentValue = true,
    Flag = "ESPEnabled",
    Callback = function(v) end
})

-- ============================================
-- 3. AİMBOT + ESP
-- ============================================

-- Aimbot
RunService.RenderStepped:Connect(function()
    if not getgenv().AimbotEnabled then return end

    local char = localPlayer.Character
    if not char or not char.PrimaryPart then return end

    local target = nil
    local shortestDist = math.huge
    local aimRadius = getgenv().AimRadius or 200

    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= localPlayer then
            local otherChar = otherPlayer.Character
            if otherChar and otherChar.PrimaryPart then
                local dist = (otherChar.PrimaryPart.Position - char.PrimaryPart.Position).Magnitude
                if dist < aimRadius and dist < shortestDist then
                    shortestDist = dist
                    target = otherChar
                end
            end
        end
    end

    if target then
        local targetPart
        if getgenv().TargetPart == "Kafa" then
            targetPart = target:FindFirstChild("Head")
        else
            targetPart = target:FindFirstChild("HumanoidRootPart")
        end

        if targetPart then
            local vector, onScreen = camera:WorldToScreenPoint(targetPart.Position)
            if onScreen then
                local mouse = localPlayer:GetMouse()
                mouse.Move(vector.X, vector.Y)
                if getgenv().AutoFire then
                    mouse.Button1Down()
                    task.wait(0.05)
                    mouse.Button1Up()
                end
            end
        end
    end
end)

-- ESP
RunService.RenderStepped:Connect(function()
    if getgenv().ESPEnabled then
        local myTeam = localPlayer.Team
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                local char = player.Character
                if char and char.PrimaryPart then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local esp = head:FindFirstChild("ESP_Label")
                        if not esp then
                            esp = Instance.new("BillboardGui")
                            esp.Name = "ESP_Label"
                            esp.Parent = head
                            esp.Size = UDim2.new(0, 120, 0, 30)
                            esp.AlwaysOnTop = true
                            esp.Adornee = head

                            local label = Instance.new("TextLabel")
                            label.Parent = esp
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.TextScaled = true
                            label.Font = Enum.Font.GothamBold
                            label.Text = player.Name
                            esp.Label = label
                        end
                        local color = player.Team == myTeam and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
                        esp.Label.TextColor3 = color
                    end
                end
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            local char = player.Character
            if char then
                local head = char:FindFirstChild("Head")
                if head then
                    local esp = head:FindFirstChild("ESP_Label")
                    if esp then esp:Destroy() end
                end
            end
        end
    end
end)

-- ============================================
-- 4. SAĞ SHIFT İLE MENÜYÜ AÇ/KAPA
-- ============================================
local menuVisible = true
UserInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        menuVisible = not menuVisible
        Window.Frame.Visible = menuVisible
    end
end)

print("✅ Spyware Aimbot yüklendi! Sağ Shift ile menüyü aç/kapat.")