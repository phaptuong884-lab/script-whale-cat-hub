do
    print("Script Blox Fruits Loaded Successfully")
    ply = game.Players
    plr = ply.LocalPlayer
    replicated = game:GetService("ReplicatedStorage")
    TeleportService = game:GetService("TeleportService")
    TW = game:GetService("TweenService")
    Lighting = game:GetService("Lighting")
    Enemies = workspace:WaitForChild("Enemies")
    vim1 = game:GetService("VirtualInputManager")
    vim2 = game:GetService("VirtualUser")
    RunSer = game:GetService("RunService")
    
    Boss = {}
    shouldTween = false
    PosMon = nil
    _G.AutoFarm = true
    _G.SelectWeapon = _G.SelectWeapon or "Melee"
end

repeat task.wait() until plr.PlayerGui:WaitForChild("Main", 5):WaitForChild("Loading", 5) and game:IsLoaded()

World1 = game.PlaceId == 2753915549
World2 = game.PlaceId == 4442272183
World3 = game.PlaceId == 7449423635

-- [Bảo vệ Character & Hook Functional]
pcall(function()
    hookfunction(require(game:GetService("ReplicatedStorage").Effect.Container.Death), function() end)
    hookfunction(require(game:GetService("ReplicatedStorage"):WaitForChild("GuideModule")).ChangeDisplayedNPC, function() end)
end)

local Rock = workspace:FindFirstChild("Rocks")
if Rock then Rock:Destroy() end

-- [Part Bypass Tween Anti-Cheat]
local block = Instance.new("Part")
block.Size = Vector3.new(1, 1, 1)
block.Name = "Bypass_Part"
block.Anchored = true
block.CanCollide = false
block.CanTouch = false
block.Transparency = 1
block.Parent = workspace

task.spawn(function()
    repeat task.wait() until plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    block.CFrame = plr.Character.HumanoidRootPart.CFrame
    while task.wait() do
        pcall(function()
            if shouldTween and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local b = plr.Character.HumanoidRootPart
                if (b.Position - block.Position).Magnitude <= 200 then
                    b.CFrame = block.CFrame
                else
                    block.CFrame = b.CFrame
                end
                for _, e in pairs(plr.Character:GetChildren()) do
                    if e:IsA("BasePart") then e.CanCollide = false end
                end
            end
        end)
    end
end)

_tp = function(target)
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
    shouldTween = true
    local distance = (target.Position - block.Position).Magnitude
    local tweenInfo = TweenInfo.new(distance / 300, Enum.EasingStyle.Linear)
    local tween = TW:Create(block, tweenInfo, {CFrame = target})
    tween:Play()
end

EquipWeapon = function(text)
    if not text then return end
    if plr.Backpack:FindFirstChild(text) then
        plr.Character.Humanoid:EquipTool(plr.Backpack:FindFirstChild(text))
    end
end

-- [Gom Quái & Attack Framework]
BringEnemy = function()
    if not PosMon then return end
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            if (v.HumanoidRootPart.Position - PosMon).Magnitude <= 300 then
                v.HumanoidRootPart.CFrame = CFrame.new(PosMon)
                v.HumanoidRootPart.CanCollide = false
                v.Humanoid.WalkSpeed = 0
                v.Humanoid.JumpPower = 0
                if v.Humanoid:FindFirstChild("Animator") then
                    v.Humanoid.Animator:Destroy()
                end
                plr.SimulationRadius = math.huge
            end
        end
    end
end

KillEnemy = function(model)
    if model and model:FindFirstChild("HumanoidRootPart") then
        if not model:GetAttribute("Locked") then
            model:SetAttribute("Locked", model.HumanoidRootPart.CFrame)
        end
        PosMon = model:GetAttribute("Locked").Position
        BringEnemy()
        EquipWeapon(_G.SelectWeapon)
        
        local Equipped = plr.Character:FindFirstChildOfClass("Tool")
        local ToolTip = Equipped and Equipped.ToolTip or ""
        
        if ToolTip == "Blox Fruit" then
            _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0) * CFrame.Angles(0, math.rad(90), 0))
        else
            _tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0) * CFrame.Angles(0, math.rad(180), 0))
        end
        
        -- Auto Click / Fast Attack
        vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end
end

-- [Bảng Quest Data Chi Tiết Tất Cả Level]
QuestCheck = function()
    local Lvl = plr.Data.Level.Value
    local Mon, Qdata, Qname, NameMon, PosQ, PosM

    if World1 then
        if Lvl >= 1 and Lvl <= 9 then
            Mon = "Bandit"; Qdata = 1; Qname = "BanditQuest1"; NameMon = "Bandit"
            PosQ = CFrame.new(1059.37, 15.44, 1550.42); PosM = CFrame.new(1045.96, 27.00, 1560.82)
        elseif Lvl >= 10 and Lvl <= 14 then
            Mon = "Monkey"; Qdata = 1; Qname = "JungleQuest"; NameMon = "Monkey"
            PosQ = CFrame.new(-1598.08, 35.55, 153.37); PosM = CFrame.new(-1448.51, 67.85, 11.46)
        elseif Lvl >= 15 and Lvl <= 29 then
            Mon = "Gorilla"; Qdata = 2; Qname = "JungleQuest"; NameMon = "Gorilla"
            PosQ = CFrame.new(-1598.08, 35.55, 153.37); PosM = CFrame.new(-1129.88, 40.46, -525.42)
        elseif Lvl >= 30 and Lvl <= 39 then
            Mon = "Pirate"; Qdata = 1; Qname = "BuggyQuest1"; NameMon = "Pirate"
            PosQ = CFrame.new(-1140.16, 4.75, 3827.42); PosM = CFrame.new(-1201.08, 40.52, 3857.58)
        elseif Lvl >= 40 and Lvl <= 59 then
            Mon = "Brute"; Qdata = 2; Qname = "BuggyQuest1"; NameMon = "Brute"
            PosQ = CFrame.new(-1140.16, 4.75, 3827.42); PosM = CFrame.new(-1375.22, 14.50, 4279.36)
        elseif Lvl >= 60 and Lvl <= 74 then
            Mon = "Desert Bandit"; Qdata = 1; Qname = "DesertQuest"; NameMon = "Desert Bandit"
            PosQ = CFrame.new(894.48, 6.44, 4384.58); PosM = CFrame.new(998.11, 6.44, 4426.24)
        elseif Lvl >= 75 and Lvl <= 89 then
            Mon = "Desert Officer"; Qdata = 2; Qname = "DesertQuest"; NameMon = "Desert Officer"
            PosQ = CFrame.new(894.48, 6.44, 4384.58); PosM = CFrame.new(1582.43, 4.41, 4367.82)
        elseif Lvl >= 90 and Lvl <= 99 then
            Mon = "Snow Bandit"; Qdata = 1; Qname = "SnowQuest"; NameMon = "Snow Bandit"
            PosQ = CFrame.new(1385.84, 87.27, -1298.61); PosM = CFrame.new(1287.16, 105.77, -1428.16)
        elseif Lvl >= 100 and Lvl <= 119 then
            Mon = "Snowman"; Qdata = 2; Qname = "SnowQuest"; NameMon = "Snowman"
            PosQ = CFrame.new(1385.84, 87.27, -1298.61); PosM = CFrame.new(1287.16, 105.77, -1428.16)
        elseif Lvl >= 120 and Lvl <= 149 then
            Mon = "Chief Petty Officer"; Qdata = 1; Qname = "MarineFordQuest2"; NameMon = "Chief Petty Officer"
            PosQ = CFrame.new(-5039.58, 28.65, 4324.68); PosM = CFrame.new(-4881.38, 21.65, 4252.01)
        elseif Lvl >= 150 and Lvl <= 174 then
            Mon = "Sky Bandit"; Qdata = 1; Qname = "SkyQuest"; NameMon = "Sky Bandit"
            PosQ = CFrame.new(-4839.53, 717.67, -2619.44); PosM = CFrame.new(-4972.57, 717.67, -2846.80)
        elseif Lvl >= 175 and Lvl <= 189 then
            Mon = "Dark Master"; Qdata = 2; Qname = "SkyQuest"; NameMon = "Dark Master"
            PosQ = CFrame.new(-4839.53, 717.67, -2619.44); PosM = CFrame.new(-5223.10, 430.52, -2280.50)
        elseif Lvl >= 190 and Lvl <= 209 then
            Mon = "Prisoner"; Qdata = 1; Qname = "PrisonerQuest"; NameMon = "Prisoner"
            PosQ = CFrame.new(530.43, 1.66, 474.07); PosM = CFrame.new(538.77, 1.66, 474.07)
        elseif Lvl >= 210 and Lvl <= 249 then
            Mon = "Dangerous Prisoner"; Qdata = 2; Qname = "PrisonerQuest"; NameMon = "Dangerous Prisoner"
            PosQ = CFrame.new(530.43, 1.66, 474.07); PosM = CFrame.new(538.77, 1.66, 474.07)
        elseif Lvl >= 250 and Lvl <= 274 then
            Mon = "Toga Warrior"; Qdata = 1; Qname = "ColosseumQuest"; NameMon = "Toga Warrior"
            PosQ = CFrame.new(-1580.05, 7.30, -2982.07); PosM = CFrame.new(-1818.82, 50.00, -2730.00)
        elseif Lvl >= 275 and Lvl <= 299 then
            Mon = "Gladiator"; Qdata = 2; Qname = "ColosseumQuest"; NameMon = "Gladiator"
            PosQ = CFrame.new(-1580.05, 7.30, -2982.07); PosM = CFrame.new(-1330.00, 50.00, -3300.00)
        elseif Lvl >= 300 and Lvl <= 324 then
            Mon = "Military Soldier"; Qdata = 1; Qname = "MagmaQuest"; NameMon = "Military Soldier"
            PosQ = CFrame.new(-5313.37, 12.24, 8515.29); PosM = CFrame.new(-5400.00, 50.00, 8500.00)
        elseif Lvl >= 325 and Lvl <= 374 then
            Mon = "Military Spy"; Qdata = 2; Qname = "MagmaQuest"; NameMon = "Military Spy"
            PosQ = CFrame.new(-5313.37, 12.24, 8515.29); PosM = CFrame.new(-5800.00, 70.00, 8800.00)
        elseif Lvl >= 375 and Lvl <= 399 then
            Mon = "Fishman Warrior"; Qdata = 1; Qname = "FishmanQuest"; NameMon = "Fishman Warrior"
            PosQ = CFrame.new(60901.40, 18.52, 1530.00); PosM = CFrame.new(60800.00, 50.00, 1500.00)
        elseif Lvl >= 400 and Lvl <= 449 then
            Mon = "Fishman Commando"; Qdata = 2; Qname = "FishmanQuest"; NameMon = "Fishman Commando"
            PosQ = CFrame.new(60901.40, 18.52, 1530.00); PosM = CFrame.new(61800.00, 50.00, 1500.00)
        elseif Lvl >= 450 and Lvl <= 474 then
            Mon = "God's Guard"; Qdata = 1; Qname = "SkyExp1Quest"; NameMon = "God's Guard"
            PosQ = CFrame.new(-4721.89, 845.28, -1949.96); PosM = CFrame.new(-4700.00, 850.00, -1900.00)
        elseif Lvl >= 475 and Lvl <= 524 then
            Mon = "Shandora Warrior"; Qdata = 2; Qname = "SkyExp1Quest"; NameMon = "Shandora Warrior"
            PosQ = CFrame.new(-4721.89, 845.28, -1949.96); PosM = CFrame.new(-5200.00, 1000.00, -2000.00)
        elseif Lvl >= 525 and Lvl <= 549 then
            Mon = "Royal Squad"; Qdata = 1; Qname = "SkyExp2Quest"; NameMon = "Royal Squad"
            PosQ = CFrame.new(-7906.82, 5635.96, -1411.99); PosM = CFrame.new(-7700.00, 5600.00, -1400.00)
        elseif Lvl >= 550 and Lvl <= 624 then
            Mon = "Royal Soldier"; Qdata = 2; Qname = "SkyExp2Quest"; NameMon = "Royal Soldier"
            PosQ = CFrame.new(-7906.82, 5635.96, -1411.99); PosM = CFrame.new(-7800.00, 5600.00, -1600.00)
        elseif Lvl >= 625 and Lvl <= 649 then
            Mon = "Galley Pirate"; Qdata = 1; Qname = "FountainQuest"; NameMon = "Galley Pirate"
            PosQ = CFrame.new(5259.81, 37.35, 4050.02); PosM = CFrame.new(5500.00, 50.00, 4000.00)
        elseif Lvl >= 650 then
            Mon = "Galley Captain"; Qdata = 2; Qname = "FountainQuest"; NameMon = "Galley Captain"
            PosQ = CFrame.new(5259.81, 37.35, 4050.02); PosM = CFrame.new(5441.95, 42.50, 4950.09)
        end
    elseif World2 then
        if Lvl >= 700 and Lvl <= 724 then
            Mon = "Raider"; Qdata = 1; Qname = "Area1Quest"; NameMon = "Raider"
            PosQ = CFrame.new(-429.54, 71.76, 1836.18); PosM = CFrame.new(-728.32, 52.77, 2345.77)
        elseif Lvl >= 725 and Lvl <= 774 then
            Mon = "Mercenary"; Qdata = 2; Qname = "Area1Quest"; NameMon = "Mercenary"
            PosQ = CFrame.new(-429.54, 71.76, 1836.18); PosM = CFrame.new(-960.00, 70.00, 1500.00)
        elseif Lvl >= 775 and Lvl <= 799 then
            Mon = "Swan Pirate"; Qdata = 1; Qname = "Area2Quest"; NameMon = "Swan Pirate"
            PosQ = CFrame.new(638.44, 73.06, 918.39); PosM = CFrame.new(870.00, 120.00, 1200.00)
        elseif Lvl >= 800 and Lvl <= 874 then
            Mon = "Factory Staff"; Qdata = 2; Qname = "Area2Quest"; NameMon = "Factory Staff"
            PosQ = CFrame.new(638.44, 73.06, 918.39); PosM = CFrame.new(300.00, 130.00, -400.00)
        elseif Lvl >= 875 and Lvl <= 899 then
            Mon = "Marine Lieutenant"; Qdata = 1; Qname = "MarineQuest2"; NameMon = "Marine Lieutenant"
            PosQ = CFrame.new(-2440.79, 73.02, -3216.12); PosM = CFrame.new(-2800.00, 70.00, -3000.00)
        elseif Lvl >= 900 and Lvl <= 949 then
            Mon = "Marine Captain"; Qdata = 2; Qname = "MarineQuest2"; NameMon = "Marine Captain"
            PosQ = CFrame.new(-2440.79, 73.02, -3216.12); PosM = CFrame.new(-1800.00, 80.00, -3300.00)
        elseif Lvl >= 950 and Lvl <= 974 then
            Mon = "Zombie"; Qdata = 1; Qname = "ZombieQuest"; NameMon = "Zombie"
            PosQ = CFrame.new(-5497.06, 48.52, -795.22); PosM = CFrame.new(-5600.00, 50.00, -700.00)
        elseif Lvl >= 975 and Lvl <= 999 then
            Mon = "Vampire"; Qdata = 2; Qname = "ZombieQuest"; NameMon = "Vampire"
            PosQ = CFrame.new(-5497.06, 48.52, -795.22); PosM = CFrame.new(-6000.00, 100.00, -1300.00)
        elseif Lvl >= 1000 and Lvl <= 1049 then
            Mon = "Snow Trooper"; Qdata = 1; Qname = "SnowMountainQuest"; NameMon = "Snow Trooper"
            PosQ = CFrame.new(609.85, 401.55, -5372.26); PosM = CFrame.new(500.00, 400.00, -5500.00)
        elseif Lvl >= 1050 and Lvl <= 1099 then
            Mon = "Winter Warrior"; Qdata = 2; Qname = "SnowMountainQuest"; NameMon = "Winter Warrior"
            PosQ = CFrame.new(609.85, 401.55, -5372.26); PosM = CFrame.new(1200.00, 450.00, -5200.00)
        elseif Lvl >= 1100 and Lvl <= 1124 then
            Mon = "Lab Subordinate"; Qdata = 1; Qname = "IceSideQuest"; NameMon = "Lab Subordinate"
            PosQ = CFrame.new(-6064.00, 16.00, -4900.00); PosM = CFrame.new(-5800.00, 20.00, -4800.00)
        elseif Lvl >= 1125 and Lvl <= 1174 then
            Mon = "Horned Warrior"; Qdata = 2; Qname = "IceSideQuest"; NameMon = "Horned Warrior"
            PosQ = CFrame.new(-6064.00, 16.00, -4900.00); PosM = CFrame.new(-6400.00, 20.00, -5800.00)
        elseif Lvl >= 1175 and Lvl <= 1199 then
            Mon = "Magma Ninja"; Qdata = 1; Qname = "FireSideQuest"; NameMon = "Magma Ninja"
            PosQ = CFrame.new(-5430.00, 16.00, -5294.00); PosM = CFrame.new(-5400.00, 20.00, -5800.00)
        elseif Lvl >= 1200 and Lvl <= 1249 then
            Mon = "Lava Pirate"; Qdata = 2; Qname = "FireSideQuest"; NameMon = "Lava Pirate"
            PosQ = CFrame.new(-5430.00, 16.00, -5294.00); PosM = CFrame.new(-5200.00, 20.00, -4800.00)
        elseif Lvl >= 1250 and Lvl <= 1274 then
            Mon = "Ship Deckhand"; Qdata = 1; Qname = "ShipQuest1"; NameMon = "Ship Deckhand"
            PosQ = CFrame.new(1038.00, 125.00, 32911.00); PosM = CFrame.new(1100.00, 130.00, 33000.00)
        elseif Lvl >= 1275 and Lvl <= 1299 then
            Mon = "Ship Engineer"; Qdata = 2; Qname = "ShipQuest1"; NameMon = "Ship Engineer"
            PosQ = CFrame.new(1038.00, 125.00, 32911.00); PosM = CFrame.new(900.00, 130.00, 32800.00)
        elseif Lvl >= 1300 and Lvl <= 1324 then
            Mon = "Ship Steward"; Qdata = 1; Qname = "ShipQuest2"; NameMon = "Ship Steward"
            PosQ = CFrame.new(968.80, 125.09, 33244.12); PosM = CFrame.new(900.00, 130.00, 33400.00)
        elseif Lvl >= 1325 and Lvl <= 1349 then
            Mon = "Ship Officer"; Qdata = 2; Qname = "ShipQuest2"; NameMon = "Ship Officer"
            PosQ = CFrame.new(968.80, 125.09, 33244.12); PosM = CFrame.new(1036.01, 181.43, 33315.72)
        elseif Lvl >= 1350 and Lvl <= 1374 then
            Mon = "Arctic Warrior"; Qdata = 1; Qname = "FrostQuest"; NameMon = "Arctic Warrior"
            PosQ = CFrame.new(5667.00, 28.00, -6486.00); PosM = CFrame.new(6000.00, 50.00, -6200.00)
        elseif Lvl >= 1375 and Lvl <= 1424 then
            Mon = "Snow Lurker"; Qdata = 2; Qname = "FrostQuest"; NameMon = "Snow Lurker"
            PosQ = CFrame.new(5667.00, 28.00, -6486.00); PosM = CFrame.new(5500.00, 50.00, -6800.00)
        elseif Lvl >= 1425 and Lvl <= 1449 then
            Mon = "Sea Soldier"; Qdata = 1; Qname = "ForgottenQuest"; NameMon = "Sea Soldier"
            PosQ = CFrame.new(-3054.00, 235.00, -10142.00); PosM = CFrame.new(-3000.00, 240.00, -9800.00)
        elseif Lvl >= 1450 then
            Mon = "Water Fighter"; Qdata = 2; Qname = "ForgottenQuest"; NameMon = "Water Fighter"
            PosQ = CFrame.new(-3054.00, 235.00, -10142.00); PosM = CFrame.new(-3300.00, 240.00, -10500.00)
        end
    elseif World3 then
        if Lvl >= 1500 and Lvl <= 1524 then
            Mon = "Pirate Millionaire"; Qdata = 1; Qname = "PiratePortQuest"; NameMon = "Pirate Millionaire"
            PosQ = CFrame.new(-290.00, 44.00, 5580.00); PosM = CFrame.new(-712.82, 98.57, 5711.95)
        elseif Lvl >= 1525 and Lvl <= 1574 then
            Mon = "Pistol Billionaire"; Qdata = 2; Qname = "PiratePortQuest"; NameMon = "Pistol Billionaire"
            PosQ = CFrame.new(-290.00, 44.00, 5580.00); PosM = CFrame.new(-300.00, 100.00, 6000.00)
        elseif Lvl >= 1575 and Lvl <= 1599 then
            Mon = "Dragon Crew Warrior"; Qdata = 1; Qname = "AmazonQuest"; NameMon = "Dragon Crew Warrior"
            PosQ = CFrame.new(5833.00, 52.00, -1105.00); PosM = CFrame.new(6400.00, 100.00, -800.00)
        elseif Lvl >= 1600 and Lvl <= 1624 then
            Mon = "Dragon Crew Archer"; Qdata = 2; Qname = "AmazonQuest"; NameMon = "Dragon Crew Archer"
            PosQ = CFrame.new(5833.00, 52.00, -1105.00); PosM = CFrame.new(6800.00, 350.00, -300.00)
        elseif Lvl >= 1625 and Lvl <= 1649 then
            Mon = "Female Islander"; Qdata = 1; Qname = "AmazonQuest2"; NameMon = "Female Islander"
            PosQ = CFrame.new(5446.00, 601.00, 748.00); PosM = CFrame.new(5800.00, 600.00, 1000.00)
        elseif Lvl >= 1650 and Lvl <= 1699 then
            Mon = "Giant Islander"; Qdata = 2; Qname = "AmazonQuest2"; NameMon = "Giant Islander"
            PosQ = CFrame.new(5446.00, 601.00, 748.00); PosM = CFrame.new(5000.00, 600.00, 700.00)
        elseif Lvl >= 1700 and Lvl <= 1724 then
            Mon = "Marine Commodore"; Qdata = 1; Qname = "MarineTreeIslandQuest"; NameMon = "Marine Commodore"
            PosQ = CFrame.new(2180.00, 29.00, -6740.00); PosM = CFrame.new(2400.00, 70.00, -6800.00)
        elseif Lvl >= 1725 and Lvl <= 1749 then
            Mon = "Marine Rear Admiral"; Qdata = 2; Qname = "MarineTreeIslandQuest"; NameMon = "Marine Rear Admiral"
            PosQ = CFrame.new(2180.00, 29.00, -6740.00); PosM = CFrame.new(3000.00, 80.00, -6800.00)
        elseif Lvl >= 1750 and Lvl <= 1774 then
            Mon = "Fishman Raider"; Qdata = 1; Qname = "DeepForestIslandQuest"; NameMon = "Fishman Raider"
            PosQ = CFrame.new(-13274.00, 332.00, -7630.00); PosM = CFrame.new(-13000.00, 330.00, -8000.00)
        elseif Lvl >= 1775 and Lvl <= 1799 then
            Mon = "Fishman Captain"; Qdata = 2; Qname = "DeepForestIslandQuest"; NameMon = "Fishman Captain"
            PosQ = CFrame.new(-13274.00, 332.00, -7630.00); PosM = CFrame.new(-13500.00, 330.00, -8000.00)
        elseif Lvl >= 1800 and Lvl <= 1824 then
            Mon = "Forest Pirate"; Qdata = 1; Qname = "DeepForestIslandQuest2"; NameMon = "Forest Pirate"
            PosQ = CFrame.new(-13274.00, 332.00, -7630.00); PosM = CFrame.new(-13300.00, 330.00, -8400.00)
        elseif Lvl >= 1825 and Lvl <= 1849 then
            Mon = "Mythological Pirate"; Qdata = 2; Qname = "DeepForestIslandQuest2"; NameMon = "Mythological Pirate"
            PosQ = CFrame.new(-13274.00, 332.00, -7630.00); PosM = CFrame.new(-13500.00, 480.00, -6900.00)
        elseif Lvl >= 1850 and Lvl <= 1899 then
            Mon = "Jungle Pirate"; Qdata = 1; Qname = "DeepForestIslandQuest3"; NameMon = "Jungle Pirate"
            PosQ = CFrame.new(-12680.00, 390.00, -9900.00); PosM = CFrame.new(-12100.00, 330.00, -10500.00)
        elseif Lvl >= 1900 and Lvl <= 1924 then
            Mon = "Musketeer Pirate"; Qdata = 2; Qname = "DeepForestIslandQuest3"; NameMon = "Musketeer Pirate"
            PosQ = CFrame.new(-12680.00, 390.00, -9900.00); PosM = CFrame.new(-13200.00, 330.00, -9800.00)
        elseif Lvl >= 1925 and Lvl <= 1974 then
            Mon = "Reborn Skeleton"; Qdata = 1; Qname = "HauntedQuest1"; NameMon = "Reborn Skeleton"
            PosQ = CFrame.new(-9480.00, 142.00, 5520.00); PosM = CFrame.new(-8800.00, 140.00, 6000.00)
        elseif Lvl >= 1975 and Lvl <= 1999 then
            Mon = "Living Zombie"; Qdata = 2; Qname = "HauntedQuest1"; NameMon = "Living Zombie"
            PosQ = CFrame.new(-9480.00, 142.00, 5520.00); PosM = CFrame.new(-10100.00, 140.00, 5900.00)
        elseif Lvl >= 2000 and Lvl <= 2024 then
            Mon = "Demonic Soul"; Qdata = 1; Qname = "HauntedQuest2"; NameMon = "Demonic Soul"
            PosQ = CFrame.new(-9513.00, 172.00, 6070.00); PosM = CFrame.new(-9500.00, 170.00, 6150.00)
        elseif Lvl >= 2025 and Lvl <= 2074 then
            Mon = "Posessed Mummy"; Qdata = 2; Qname = "HauntedQuest2"; NameMon = "Posessed Mummy"
            PosQ = CFrame.new(-9513.00, 172.00, 6070.00); PosM = CFrame.new(-9500.00, 140.00, 6300.00)
        elseif Lvl >= 2075 and Lvl <= 2099 then
            Mon = "Peanut Scout"; Qdata = 1; Qname = "NutsIslandQuest"; NameMon = "Peanut Scout"
            PosQ = CFrame.new(-2104.00, 38.00, -10194.00); PosM = CFrame.new(-2000.00, 50.00, -10300.00)
        elseif Lvl >= 2100 and Lvl <= 2124 then
            Mon = "Peanut President"; Qdata = 2; Qname = "NutsIslandQuest"; NameMon = "Peanut President"
            PosQ = CFrame.new(-2104.00, 38.00, -10194.00); PosM = CFrame.new(-2200.00, 50.00, -10500.00)
        elseif Lvl >= 2125 and Lvl <= 2199 then
            Mon = "Ice Cream Chef"; Qdata = 1; Qname = "IceCreamIslandQuest"; NameMon = "Ice Cream Chef"
            PosQ = CFrame.new(-820.00, 65.00, -10965.00); PosM = CFrame.new(-600.00, 70.00, -11100.00)
        elseif Lvl >= 2200 and Lvl <= 2224 then
            Mon = "Cookie Crafter"; Qdata = 1; Qname = "CakeQuest1"; NameMon = "Cookie Crafter"
            PosQ = CFrame.new(-2020.00, 38.00, -12025.00); PosM = CFrame.new(-2300.00, 40.00, -12100.00)
        elseif Lvl >= 2225 and Lvl <= 2249 then
            Mon = "Cake Guard"; Qdata = 2; Qname = "CakeQuest1"; NameMon = "Cake Guard"
            PosQ = CFrame.new(-2020.00, 38.00, -12025.00); PosM = CFrame.new(-1600.00, 40.00, -12300.00)
        elseif Lvl >= 2250 and Lvl <= 2299 then
            Mon = "Baking Staff"; Qdata = 1; Qname = "CakeQuest2"; NameMon = "Baking Staff"
            PosQ = CFrame.new(-1925.00, 38.00, -12850.00); PosM = CFrame.new(-1800.00, 40.00, -13000.00)
        elseif Lvl >= 2300 and Lvl <= 2324 then
            Mon = "Head Baker"; Qdata = 2; Qname = "CakeQuest2"; NameMon = "Head Baker"
            PosQ = CFrame.new(-1925.00, 38.00, -12850.00); PosM = CFrame.new(-2100.00, 40.00, -13000.00)
        elseif Lvl >= 2325 and Lvl <= 2374 then
            Mon = "Cocoa Warrior"; Qdata = 1; Qname = "ChocQuest1"; NameMon = "Cocoa Warrior"
            PosQ = CFrame.new(230.00, 25.00, -12200.00); PosM = CFrame.new(300.00, 30.00, -12400.00)
        elseif Lvl >= 2375 and Lvl <= 2399 then
            Mon = "Chocolate Bar Battler"; Qdata = 2; Qname = "ChocQuest1"; NameMon = "Chocolate Bar Battler"
            PosQ = CFrame.new(230.00, 25.00, -12200.00); PosM = CFrame.new(100.00, 30.00, -12600.00)
        elseif Lvl >= 2400 and Lvl <= 2449 then
            Mon = "Candy Rebel"; Qdata = 1; Qname = "CandyQuest1"; NameMon = "Candy Rebel"
            PosQ = CFrame.new(130.00, 25.00, -12800.00); PosM = CFrame.new(200.00, 30.00, -13000.00)
        elseif Lvl >= 2450 then
            Mon = "Candy Pirate"; Qdata = 2; Qname = "CandyQuest1"; NameMon = "Candy Pirate"
            PosQ = CFrame.new(130.00, 25.00, -12800.00); PosM = CFrame.new(-100.00, 30.00, -13200.00)
        end
    end
    return Mon, Qdata, Qname, NameMon, PosQ, PosM
end

-- [Main Loop Engine]
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFarm then
            pcall(function()
                local Mon, Qdata, Qname, NameMon, PosQ, PosM = QuestCheck()
                local mainGui = plr.PlayerGui:FindFirstChild("Main")
                
                -- Nếu chưa nhận Quest
                if mainGui and mainGui:FindFirstChild("Quest") and not mainGui.Quest.Visible then
                    _tp(PosQ)
                    if (plr.Character.HumanoidRootPart.Position - PosQ.Position).Magnitude <= 15 then
                        replicated.Remotes.CommF_:InvokeServer("StartQuest", Qname, Qdata)
                    end
                else
                    -- Đã có Quest: Đi săn quái
                    local targetMon = workspace.Enemies:FindFirstChild(NameMon)
                    if targetMon and targetMon:FindFirstChild("HumanoidRootPart") and targetMon:FindFirstChild("Humanoid") and targetMon.Humanoid.Health > 0 then
                        KillEnemy(targetMon)
                    else
                        _tp(PosM)
                    end
                end
            end)
        end
    end
end)
