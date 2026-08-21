-- SpywareAimbot.lua - SON VERSİYON (Sadece Title Bar'dan Sürükle)
-- hamster & spyware tarafından oluşturulmuştur

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- ============================================
-- 1. MENÜ OLUŞTURMA
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui
screenGui.Name = "SpywareUI"
screenGui.ResetOnSpawn = false

-- Ana Frame (Menü)
local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 300, 0, 420)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 26)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true

-- ANİMASYON
mainFrame.Scale = 0.7
mainFrame.BackgroundTransparency = 0.8
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenScale = TweenService:Create(mainFrame, tweenInfo, {Scale = 1})
local tweenOpacity = TweenService:Create(mainFrame, TweenInfo.new(0.4), {BackgroundTransparency = 0.15})
tweenScale:Play()
tweenOpacity:Play()

-- ============================================
-- 2. BAŞLIK ÇUBUĞU (SADECE BURADAN SÜRÜKLENECEK)
-- ============================================
local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 10

-- Başlık
local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = titleBar
titleLabel.Size = UDim2.new(0.85, 0, 0.55, 0)
titleLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Spyware Aimbot"
titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamSemibold

-- Alt başlık
local subLabel = Instance.new("TextLabel")
subLabel.Parent = titleBar
subLabel.Size = UDim2.new(0.85, 0, 0.35, 0)
subLabel.Position = UDim2.new(0.05, 0, 0.6, 0)
subLabel.BackgroundTransparency = 1
subLabel.Text = "• hamster & spyware tarafından"
subLabel.TextColor3 = Color3.fromRGB(160, 160, 200)
subLabel.TextXAlignment = Enum.TextXAlignment.Left
subLabel.TextScaled = true
subLabel.Font = Enum.Font.Gotham
subLabel.TextSize = 12

-- Kapatma butonu
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = titleBar
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 11)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- ============================================
-- 3. SADECE TITLE BAR'DAN SÜRÜKLEME KODU
-- ============================================
local dragging = false
local dragStart = nil
local frameStart = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        frameStart = mainFrame.Position
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInput.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            frameStart.X.Scale,
            frameStart.X.Offset + delta.X,
            frameStart.Y.Scale,
            frameStart.Y.Offset + delta.Y
        )
    end
end)

-- ============================================
-- 4. İÇERİK (Kontroller)
-- ============================================
local content = Instance.new("Frame")
content.Parent = mainFrame
content.Size = UDim2.new(1, 0, 1, -50)
content.Position = UDim2.new(0, 0, 0, 50)
content.BackgroundTransparency = 1

local function createToggle(text, flag, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Parent = content
    frame.Size = UDim2.new(0.94, 0, 0, 34)
    frame.Position = UDim2.new(0.03, 0, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    frame.BorderSizePixel = 0

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0.04, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham

    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.Size = UDim2.new(0, 60, 0, 26)
    btn.Position = UDim2.new(0.82, 0, 0.5, -13)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    btn.BorderSizePixel = 0
    btn.Text = "KAPALI"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold

    local state = defaultVal or false
    getgenv()[flag] = state
    if state then
        btn.Text = "AÇIK"
        btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    end

    btn.MouseButton1Click:Connect(function()
        state = not state
        getgenv()[flag] = state
        btn.Text = state and "AÇIK" or "KAPALI"
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 80)
        if callback then callback(state) end
    end)

    return frame
end

local function createDropdown(text, flag, options, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Parent = content
    frame.Size = UDim2.new(0.94, 0, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    frame.BorderSizePixel = 0

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0.04, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
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
    btn.Text = defaultVal or "Seç"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham

    local currentIndex = 1
    for i, opt in ipairs(options) do
        if opt == defaultVal then currentIndex = i break end
    end
    getgenv()[flag] = options[currentIndex]

    btn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex % #options + 1
        local selected = options[currentIndex]
        btn.Text = selected
        getgenv()[flag] = selected
        if callback then callback(selected) end
    end)

    return frame
end

local function createSlider(text, flag, minVal, maxVal, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Parent = content
    frame.Size = UDim2.new(0.94, 0, 0, 48)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    frame.BorderSizePixel = 0

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.5, 0, 0.5, 0)
    label.Position = UDim2.new(0.04, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = frame
    valueLabel.Size = UDim2.new(0.3, 0, 0.5, 0)
    valueLabel.Position = UDim2.new(0.65, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultVal or 100)
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.TextScaled = true
    valueLabel.Font = Enum.Font.Gotham

    local sliderBg = Instance.new("Frame")
    sliderBg.Parent = frame
    sliderBg.Size = UDim2.new(0.9, 0, 0, 10)
    sliderBg.Position = UDim2.new(0.05, 0, 0, 32)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    sliderBg.BorderSizePixel = 0

    local fill = Instance.new("Frame")
    fill.Parent = sliderBg
    fill.Size = UDim2.new(0.5, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.BorderSizePixel = 0

    local min = minVal or 0
    local max = maxVal or 500
    local value = defaultVal or 100
    getgenv()[flag] = value
    valueLabel.Text = tostring(value)
    fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)

    local draggingSlider = false
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = true
        end
    end)
    UserInput.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = false
        end
    end)

    RunService.RenderStepped:Connect(function()
        if draggingSlider then
            local mousePos = localPlayer:GetMouse().X
            local sliderPos = sliderBg.AbsolutePosition.X
            local sliderSize = sliderBg.AbsoluteSize.X
            local percent = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            value = math.floor(min + (max - min) * percent)
            getgenv()[flag] = value
            valueLabel.Text = tostring(value)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            if callback then callback(value) end
        end
    end)

    return frame
end

-- ============================================
-- 5. KONTROLLERİ EKLE
-- ============================================
local yOffset = 6
local spacing = 6

local function addElement(element)
    element.Position = UDim2.new(0.03, 0, 0, yOffset)
    yOffset = yOffset + element.Size.Y.Offset + spacing
    content.Size = UDim2.new(1, 0, 0, yOffset + 10)
end

addElement(createToggle("Aimbot Aktif", "AimbotEnabled", false))
addElement(createDropdown("Hedef Kısım", "TargetPart", {"Kafa", "Gövde"}, "Kafa"))
addElement(createSlider("Menzil", "AimRadius", 50, 500, 200))
addElement(createToggle("Otomatik Ateş", "AutoFire", true))
addElement(createToggle("ESP (Takım Renkleri)", "ESPEnabled", true))

-- ============================================
-- 6. AİMBOT
-- ============================================
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

-- ============================================
-- 7. ESP (Takım Renkleri)
-- ============================================
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
-- 8. SAĞ SHIFT İLE AÇ/KAPA
-- ============================================
local menuVisible = true
UserInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        menuVisible = not menuVisible
        mainFrame.Visible = menuVisible
    end
end)

print("✅ Spyware Aimbot yüklendi! Sağ Shift ile menüyü aç/kapat.")