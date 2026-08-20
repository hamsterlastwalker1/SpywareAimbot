-- SpywareAimbot.lua
-- Bu script, otomatik nişan alma ve ateş etme özelliği + GUI menü sağlar.

-- Kütüphaneyi yükle (Infinite Yield'in UI kütüphanesi)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()

-- Ana Menü
local Window = Library:CreateWindow("Spyware ve hamster tarafından yapılmıştır")

-- Aimbot Sekmesi
local AimbotTab = Window:CreateTab("Aimbot")

-- Aimbot Aç/Kapa
AimbotTab:CreateToggle({
    Name = "Aimbot Aktif",
    CurrentValue = false,
    Flag = "AimbotEnabled",
    Callback = function(Value)
        getgenv().AimbotEnabled = Value
        print("Aimbot: " .. tostring(Value))
    end
})

-- Hedef Kısmı Seç (Kafa / Gövde)
AimbotTab:CreateDropdown({
    Name = "Hedef Kısım",
    Options = {"Kafa", "Gövde"},
    CurrentOption = "Kafa",
    Flag = "TargetPart",
    Callback = function(Option)
        getgenv().TargetPart = Option
    end
})

-- Nişan Alma Menzili (Alanı Büyüt)
AimbotTab:CreateSlider({
    Name = "Nişan Alma Menzili",
    Min = 50,
    Max = 500,
    Default = 200,
    Flag = "AimRadius",
    Callback = function(Value)
        getgenv().AimRadius = Value
    end
})

-- Otomatik Ateş Etme (Aç/Kapa)
AimbotTab:CreateToggle({
    Name = "Otomatik Ateş Et",
    CurrentValue = true,
    Flag = "AutoFire",
    Callback = function(Value)
        getgenv().AutoFire = Value
    end
})

-- ANA DÖNGÜ (Aimbot + Otomatik Ateş)
game:GetService("RunService").RenderStepped:Connect(function()
    if not getgenv().AimbotEnabled then return end

    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    if not character or not character.PrimaryPart then return end

    local target = nil
    local shortestDistance = math.huge
    local aimRadius = getgenv().AimRadius or 200

    -- En Yakın Düşmanı Bul (Menzil içinde)
    for _, otherPlayer in pairs(game:GetService("Players"):GetPlayers()) do
        if otherPlayer ~= player then
            local otherChar = otherPlayer.Character
            if otherChar and otherChar.PrimaryPart then
                local distance = (otherChar.PrimaryPart.Position - character.PrimaryPart.Position).Magnitude
                if distance < aimRadius and distance < shortestDistance then
                    shortestDistance = distance
                    target = otherChar
                end
            end
        end
    end

    if target then
        -- Hedefin Kafasını veya Gövdesini Bul
        local targetPart
        if getgenv().TargetPart == "Kafa" then
            targetPart = target:FindFirstChild("Head")
        else
            targetPart = target:FindFirstChild("HumanoidRootPart")
        end

        if targetPart then
            -- Mouse'u Hedefe Yönlendir
            local mouse = player:GetMouse()
            local vector, onScreen = game:GetService("Workspace").CurrentCamera:WorldToScreenPoint(targetPart.Position)
            if onScreen then
                mouse.Move(vector.X, vector.Y)

                -- Otomatik Ateş Et (Açıksa)
                if getgenv().AutoFire then
                    mouse.Button1Down()
                    task.wait(0.1)
                    mouse.Button1Up()
                end
            end
        end
    end
end)

-- GUI'yi Gizle/Göster (Enter'ın altındaki Shift tuşu)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Window:Toggle()
    end
end)

print("✅ Spyware Aimbot yüklendi! Sağ Shift ile menüyü aç/kapat.")