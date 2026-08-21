-- SpywareAimbot.lua - Arsenal Uyumlu + ESP
-- Çalışan Versiyon (Krnl / Synapse / Fluxus)

-- ============================================
-- 1. UI KÜTÜPHANESİ (Kendimiz yapıyoruz, bağımlılık yok)
-- ============================================
local Library = {
    Window = nil,
    Toggles = {},
    Callbacks = {}
}

function Library:CreateWindow(title)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.CoreGui
    screenGui.Name = "SpywareUI"

    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BackgroundTransparency = 0.15
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true

    -- Başlık
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = mainFrame
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamSemibold

    -- Kapatma butonu
    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = mainFrame
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -30, 0, 2)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- İçerik Frame
    local content = Instance.new("Frame")
    content.Parent = mainFrame
    content.Size = UDim2.new(1, 0, 1, -30)
    content.Position = UDim2.new(0, 0, 0, 30)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0

    self.Window = {
        Frame = mainFrame,
        Content = content,
        ScreenGui = screenGui,
        Toggles = {},
        Dropdowns = {},
        Sliders = {}
    }

    return self.Window
end

function Library:CreateToggle(window, config)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Parent = window.Content
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel")
    label.Parent = toggleFrame
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = config.Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = toggleFrame
    toggleBtn.Size = UDim2.new(0, 50, 1, 0)
    toggleBtn.Position = UDim2.new(0.8, 0, 0, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextScaled = true
    toggleBtn.Font = Enum.Font.GothamBold

    local state = config.CurrentValue or false
    getgenv()[config.Flag] = state

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        getgenv()[config.Flag] = state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(50, 50, 70)
        if config.Callback then
            config.Callback(state)
        end
    end)

    if state then
        toggleBtn.Text = "ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    end

    table.insert(window.Toggles, toggleFrame)
end

function Library:CreateDropdown(window, config)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Parent = window.Content
    dropdownFrame.Size = UDim2.new(1, 0, 0, 30)
    dropdownFrame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel")
    label.Parent = dropdownFrame
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = config.Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham

    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Parent = dropdownFrame
    dropdownBtn.Size = UDim2.new(0.4, 0, 1, 0)
    dropdownBtn.Position = UDim2.new(0.6, 0, 0, 0)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Text = config.Default or "Seç"
    dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownBtn.TextScaled = true
    dropdownBtn.Font = Enum.Font.Gotham

    local currentIndex = 1
    for i, opt in ipairs(config.Options) do
        if opt == config.Default then
            currentIndex = i
            break
        end
    end
    getgenv()[config.Flag] = config.Options[currentIndex]

    dropdownBtn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex % #config.Options + 1
        local selected = config.Options[currentIndex]
        dropdownBtn.Text = selected
        getgenv()[config.Flag] = selected
        if config.Callback then
            config.Callback(selected)
        end
    end)

    table.insert(window.Dropdowns, dropdownFrame)
end

function Library:CreateSlider(window, config)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Parent = window.Content
    sliderFrame.Size = UDim2.new(1, 0, 0, 40)
    sliderFrame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel")
    label.Parent = sliderFrame
    label.Size = UDim2.new(0.6, 0, 0.5, 0)
    label.BackgroundTransparency = 1
    label.Text = config.Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = sliderFrame
    valueLabel.Size = UDim2.new(0.3, 0, 0.5, 0)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(config.Default or 100)
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.TextScaled = true
    valueLabel.Font = Enum.Font.Gotham

    local slider = Instance.new("Frame")
    slider.Parent = sliderFrame
    slider.Size = UDim2.new(1, 0, 0, 10)
    slider.Position = UDim2.new(0, 0, 0, 25)
    slider.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    slider.BorderSizePixel = 0

    local fill = Instance.new("Frame")
    fill.Parent = slider
    fill.Size = UDim2.new(0.5, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.BorderSizePixel = 0

    local dragging = false
    local min = config.Min or 0
    local max = config.Max or 500
    local value = config.Default or 100
    getgenv()[config.Flag] = value
    valueLabel.Text = tostring(value)
    fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)

    slider.MouseButton1Down:Connect(function()
        dragging = true
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging then
            local mousePos = game.Players.LocalPlayer:GetMouse().X
            local sliderPos = slider.AbsolutePosition.X
            local sliderSize = slider.AbsoluteSize.X
            local percent = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            value = math.floor(min + (max - min) * percent)
            getgenv()[config.Flag] = value
            valueLabel.Text = tostring(value)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            if config.Callback then
                config.Callback(value)
            end
        end
    end)
end

-- ============================================
-- 2. ANA MENÜ
-- ============================================
local Window = Library:CreateWindow("Spyware Aimbot")

-- Toggle: Aimbot Aktif
Library:CreateToggle(Window, {
    Name = "Aimbot Aktif",
    CurrentValue = false,
    Flag = "AimbotEnabled",
    Callback = function(v) print("Aimbot: " .. tostring(v)) end
})

-- Dropdown: Hedef Kısım
Library:CreateDropdown(Window, {
    Name = "Hedef Kısım",
    Options = {"Kafa", "Gövde"},
    Default = "Kafa",
    Flag = "TargetPart",
    Callback = function(v) print("Hedef: " .. v) end
})

-- Slider: Menzil
Library:CreateSlider(Window, {
    Name = "Menzil",
    Min = 50,
    Max = 500,
    Default = 200,
    Flag = "AimRadius",
    Callback = function(v) print("Menzil: " .. v) end
})

-- Toggle: Otomatik Ateş
Library:CreateToggle(Window, {
    Name = "Otomatik Ateş Et",
    CurrentValue = true,
    Flag = "AutoFire",
    Callback = function(v) print("Otomatik Ateş: " .. tostring(v)) end
})

-- Toggle: ESP (Takım Renkleri)
Library:CreateToggle(Window, {
    Name = "ESP (Takım Renkleri)",
    CurrentValue = true,
    Flag = "ESPEnabled",
    Callback = function(v) print("ESP: " .. tostring(v)) end
})

-- ============================================
-- 3. AİMBOT + OTOMATİK ATEŞ (Arsenal Uyumlu)
-- ============================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local camera = Workspace.CurrentCamera

RunService.RenderStepped:Connect(function()
    -- Aimbot
    if getgenv().AimbotEnabled then
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
    end

    -- ESP (Takım Renkleri)
    if getgenv().ESPEnabled then
        local myTeam = localPlayer.Team
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                local character = player.Character
                if character and character.PrimaryPart then
                    local head = character:FindFirstChild("Head")
                    if head then
                        local esp = head:FindFirstChild("ESP_Label")
                        if not esp then
                            esp = Instance.new("BillboardGui")
                            esp.Name = "ESP_Label"
                            esp.Parent = head
                            esp.Size = UDim2.new(0, 100, 0, 30)
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

                        -- Takım rengine göre renk
                        local color = Color3.fromRGB(255, 0, 0) -- kırmızı (rakip)
                        if player.Team == myTeam then
                            color = Color3.fromRGB(0, 255, 0) -- yeşil (takım)
                        end
                        esp.Label.TextColor3 = color
                    end
                end
            end
        end
    else
        -- ESP kapalıysa temizle
        for _, player in pairs(Players:GetPlayers()) do
            local char = player.Character
            if char then
                local head = char:FindFirstChild("Head")
                if head then
                    local esp = head:FindFirstChild("ESP_Label")
                    if esp then
                        esp:Destroy()
                    end
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