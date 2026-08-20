-- SpywareAimbot.lua - Çalışan Versiyon
-- AeroUI Kütüphanesi ile

-- 1. UI Kütüphanesini Yükle
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AeroScripts/AeroUI/main/source"))()

-- 2. Ana Menü
local Window = Library:CreateWindow("Spyware ve hamster tarafından yapılmıştır")

-- 3. Aimbot Sekmesi
local AimbotTab = Window:CreateTab("Aimbot")

-- 4. Aimbot Aç/Kapa
AimbotTab:CreateToggle({
    Name = "Aimbot Aktif",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AimbotEnabled = Value
    end
})

-- 5. Hedef Kısım (Kafa / Gövde)
AimbotTab:CreateDropdown({
    Name = "Hedef Kısım",
    Options = {"Kafa", "Gövde"},
    Default = "Kafa",
    Callback = function(Option)
        getgenv().TargetPart = Option
    end
})

-- 6. Menzil
AimbotTab:CreateSlider({
    Name = "Menzil",
    Min = 50,
    Max = 500,
    Default = 200,
    Callback = function(Value)
        getgenv().AimRadius = Value
    end
})

-- 7. Otomatik Ateş
AimbotTab:CreateToggle({
    Name = "Otomatik Ateş Et",
    CurrentValue = true,
    Callback = function(Value)
        getgenv().AutoFire = Value
    end
})

-- 8. ANA DÖNGÜ
game:GetService("RunService").RenderStepped:Connect(function()
    if not getgenv().AimbotEnabled then return end

    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character or not character.PrimaryPart then return end

    local target = nil
    local shortestDistance = math.huge
    local aimRadius = getgenv().AimRadius or 200

    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
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
        local targetPart
        if getgenv().TargetPart == "Kafa" then
            targetPart = target:FindFirstChild("Head")
        else
            targetPart = target:FindFirstChild("HumanoidRootPart")
        end

        if targetPart then
            local mouse = player:GetMouse()
            local vector, onScreen = workspace.CurrentCamera:WorldToScreenPoint(targetPart.Position)
            if onScreen then
                mouse.Move(vector.X, vector.Y)
                if getgenv().AutoFire then
                    mouse.Button1Down()
                    task.wait(0.1)
                    mouse.Button1Up()
                end
            end
        end
    end
end)

-- 9. Sağ Shift ile Menüyü Aç/Kapa
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Window:Toggle()
    end
end)

print("✅ Spyware Aimbot yüklendi! Sağ Shift ile menüyü aç/kapat.")
