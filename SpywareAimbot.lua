-- SpywareAimbot.lua - BASİT VE ÇALIŞAN VERSİYON (UI KÜTÜPHANESİZ)

-- AYARLAR (Bunları değiştirebilirsin)
local Settings = {
    Enabled = false,
    TargetPart = "Head", -- "Head" veya "HumanoidRootPart"
    AimRadius = 200,
    AutoFire = true
}

-- MENÜ OLUŞTURMA (Roblox'un kendi UI'si ile)
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

-- Ana Çerçeve
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Başlık
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Spyware Aimbot"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextScaled = true
title.Font = Enum.Font.GothamSemibold
title.Parent = mainFrame

-- Durum (Açık/Kapalı)
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0, 40)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Durum: Kapalı (Sağ Shift)"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.Parent = mainFrame

-- Aimbot Aç/Kapa Butonu
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
toggleBtn.Position = UDim2.new(0.1, 0, 0, 80)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
toggleBtn.Text = "Aimbot: KAPALI"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamSemibold
toggleBtn.Parent = mainFrame

toggleBtn.MouseButton1Click:Connect(function()
    Settings.Enabled = not Settings.Enabled
    if Settings.Enabled then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        toggleBtn.Text = "Aimbot: AÇIK"
        statusLabel.Text = "Durum: Açık (Sağ Shift)"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        toggleBtn.Text = "Aimbot: KAPALI"
        statusLabel.Text = "Durum: Kapalı (Sağ Shift)"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- Menzil Ayarı (Kaydırıcı)
local radiusLabel = Instance.new("TextLabel")
radiusLabel.Size = UDim2.new(0.8, 0, 0, 20)
radiusLabel.Position = UDim2.new(0.1, 0, 0, 130)
radiusLabel.BackgroundTransparency = 1
radiusLabel.Text = "Menzil: 200"
radiusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
radiusLabel.TextScaled = true
radiusLabel.Font = Enum.Font.GothamMedium
radiusLabel.Parent = mainFrame

local radiusSlider = Instance.new("Frame")
radiusSlider.Size = UDim2.new(0.8, 0, 0, 10)
radiusSlider.Position = UDim2.new(0.1, 0, 0, 155)
radiusSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
radiusSlider.BorderSizePixel = 0
radiusSlider.Parent = mainFrame

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.4, 0, 1, 0) -- %40 = 200 menzil (50-500 arası)
sliderFill.Position = UDim2.new(0, 0, 0, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = radiusSlider

-- Menzil değiştirme (basitçe tıklayarak)
radiusSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local x = input.Position.X - radiusSlider.AbsolutePosition.X
        local percent = math.clamp(x / radiusSlider.AbsoluteSize.X, 0, 1)
        local value = math.round(50 + percent * 450)
        Settings.AimRadius = value
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        radiusLabel.Text = "Menzil: " .. tostring(value)
    end
end)

radiusSlider.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and input.Position then
        -- Sürüklemek için (isteğe bağlı)
    end
end)

-- Hedef Kısım Seçimi (Dropdown basit)
local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(0.8, 0, 0, 20)
targetLabel.Position = UDim2.new(0.1, 0, 0, 175)
targetLabel.BackgroundTransparency = 1
targetLabel.Text = "Hedef: Kafa"
targetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
targetLabel.TextScaled = true
targetLabel.Font = Enum.Font.GothamMedium
targetLabel.Parent = mainFrame

local targetBtn = Instance.new("TextButton")
targetBtn.Size = UDim2.new(0.8, 0, 0, 30)
targetBtn.Position = UDim2.new(0.1, 0, 0, 200)
targetBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
targetBtn.Text = "Kafa (Değiştir)"
targetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
targetBtn.TextScaled = true
targetBtn.Font = Enum.Font.GothamMedium
targetBtn.Parent = mainFrame

targetBtn.MouseButton1Click:Connect(function()
    if Settings.TargetPart == "Head" then
        Settings.TargetPart = "HumanoidRootPart"
        targetLabel.Text = "Hedef: Gövde"
        targetBtn.Text = "Gövde (Değiştir)"
    else
        Settings.TargetPart = "Head"
        targetLabel.Text = "Hedef: Kafa"
        targetBtn.Text = "Kafa (Değiştir)"
    end
end)

-- Otomatik Ateş Toggle
local autoFireBtn = Instance.new("TextButton")
autoFireBtn.Size = UDim2.new(0.8, 0, 0, 30)
autoFireBtn.Position = UDim2.new(0.1, 0, 0, 240)
autoFireBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
autoFireBtn.Text = "Otomatik Ateş: AÇIK"
autoFireBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoFireBtn.TextScaled = true
autoFireBtn.Font = Enum.Font.GothamMedium
autoFireBtn.Parent = mainFrame

autoFireBtn.MouseButton1Click:Connect(function()
    Settings.AutoFire = not Settings.AutoFire
    if Settings.AutoFire then
        autoFireBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        autoFireBtn.Text = "Otomatik Ateş: AÇIK"
    else
        autoFireBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        autoFireBtn.Text = "Otomatik Ateş: KAPALI"
    end
end)

-- Kapatma Butonu
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0.2, 0, 0, 30)
closeBtn.Position = UDim2.new(0.4, 0, 0, 280)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.Text = "KAPAT"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamSemibold
closeBtn.Parent = mainFrame

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    print("Spyware Aimbot kapatıldı.")
end)

-- ANA DÖNGÜ (Aimbot)
game:GetService("RunService").RenderStepped:Connect(function()
    if not Settings.Enabled then return end

    local character = player.Character
    if not character or not character.PrimaryPart then return end

    local target = nil
    local shortestDistance = math.huge

    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player then
            local otherChar = otherPlayer.Character
            if otherChar and otherChar.PrimaryPart then
                local distance = (otherChar.PrimaryPart.Position - character.PrimaryPart.Position).Magnitude
                if distance < Settings.AimRadius and distance < shortestDistance then
                    shortestDistance = distance
                    target = otherChar
                end
            end
        end
    end

    if target then
        local targetPart = target:FindFirstChild(Settings.TargetPart)
        if targetPart then
            local vector, onScreen = workspace.CurrentCamera:WorldToScreenPoint(targetPart.Position)
            if onScreen then
                mouse.Move(vector.X, vector.Y)
                if Settings.AutoFire then
                    mouse.Button1Down()
                    task.wait(0.05)
                    mouse.Button1Up()
                end
            end
        end
    end
end)

-- Sağ Shift ile Menüyü Gizle/Göster
local menuVisible = true
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        menuVisible = not menuVisible
        screenGui.Enabled = menuVisible
    end
end)

print("✅ Spyware Aimbot yüklendi! Sağ Shift ile menüyü aç/kapat.")