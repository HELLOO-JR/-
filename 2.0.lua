local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

local SETTINGS = {
    AutoFarm = {
        Enabled = false,
        Method = "Quest",
        FastMode = false,
        Distance = 100,
        AutoStats = false,
        Stats = "Melee",
        AutoSkills = false,
        SkillDelay = 1.5,
        CollectDrops = true,
        AutoEquipBest = false,
        MobVacuum = false,
        VacuumRadius = 100,
        SuperRange = false,
        RangeDistance = 200,
    },
    Combat = {
        KillAura = false,
        KillAuraRange = 30,
        FastAttack = false,
        FastAttackSpeed = 0.01,
        FastAttack200x = false,
        AutoCombo = false,
        ComboSkills = {"Z", "X", "C", "V"},
        ComboDelay = 0.5,
        AutoBlock = false,
        Godmode = false,
        InfiniteEnergy = false,
        NoStun = false,
        HitboxExpander = false,
        HitboxSize = 15,
        SuperRange = false,
        RangeMultiplier = 10,
    },
    Quest = {
        Enabled = false,
        SkipDialog = true,
        AutoNext = true,
        AutoStart = true,
    },
    AutoStats = {
        Enabled = false,
        PointsPerUpgrade = 3,
        UpgradeOrder = {"Melee", "Defense", "Sword", "Gun", "BloxFruit"},
    },
    MaterialFarm = {
        Enabled = false,
        Bones = false, Ectoplasm = false, Fragment = false, Candy = false,
        Gems = false, Money = false, Cocoa = false, Cake = false,
        DragonScale = false, LeviathanScale = false, SeaBeastMeat = false,
        MagmaOre = false, IronOre = false, CopperOre = false, GoldOre = false,
        DiamondOre = false, Fish = false, Driftwood = false, Seashell = false,
        StarPieces = false,
    },
    Troll = {
        Enabled = false,
        ServerLag = false,
        LagIntensity = 5,
        KickPlayer = false,
        TargetPlayer = "",
        TeleportPlayer = false,
        TeleportTarget = "",
        TeleportIsland = "Sea1",
        FreezePlayer = false,
        FreezeTarget = "",
        SpamChat = false,
        SpamMessage = "Ryzen AI was here!",
        SpamInterval = 0.5,
        CrashPlayer = false,
        CrashTarget = "",
        StealFruit = false,
        StealTarget = "",
        RandomTroll = false,
    },
    FixLag = {
        Enabled = false,
        SimplifyVFX = true,
        FlatTextures = true,
        LowQualityTextures = true,
        ReduceVRAM = true,
        AggressiveCleanup = true,
        NoEffects = true,
        BrownCharacters = true,
        RemoveSky = true,
        RemoveWater = false,
        SuperLowGraphics = true,
        MaxRenderDistance = 300,
    },
}

local State = {
    IsFarming = false, CurrentTarget = nil, LastAttack = 0,
    FastAttackThread = nil, KillAuraThread = nil, AutoFarmThread = nil,
    ComboThread = nil, MaterialFarmThread = nil, MobVacuumThread = nil,
    SuperRangeThread = nil, TrollThread = nil, FixLagThread = nil,
    ServerLagThread = nil, FrozenPlayers = {}, VacuumParts = {},
}

local function notify(title, text, duration)
    duration = duration or 3
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = duration})
    end)
end

local function getNearestEnemy(distance)
    distance = distance or math.huge
    local nearest = nil
    local nearestDist = distance
    for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
            local hrp = enemy.HumanoidRootPart
            if hrp and hrp:IsA("BasePart") then
                local dist = (RootPart.Position - hrp.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = enemy
                end
            end
        end
    end
    return nearest, nearestDist
end

local function getNearestBoss()
    local bosses = {
        "Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral",
        "Greybeard", "rip_indra", "Tide Keeper", "Beautiful Pirate",
        "Longma", "Cursed Captain", "Captain Elephant", "Stone",
        "Island Empress", "Warden", "Chief Warden", "Magma Admiral",
        "Fishman Lord", "Vice Admiral", "Ice Admiral", "Tank", "Spy",
        "Hydra Leader"
    }
    local nearest = nil
    local nearestDist = math.huge
    for _, bossName in ipairs(bosses) do
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name == bossName or obj.Name:lower():find(bossName:lower()) then
                local humanoid = obj:FindFirstChild("Humanoid")
                local hrp = obj:FindFirstChild("HumanoidRootPart")
                if humanoid and humanoid.Health > 0 and hrp and hrp:IsA("BasePart") then
                    local dist = (RootPart.Position - hrp.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearest = obj
                    end
                end
            end
        end
    end
    return nearest, nearestDist
end

local function teleportTo(targetPosition, instant)
    if not targetPosition then return end
    if not Character or not Character.Parent or not RootPart or not RootPart:IsA("BasePart") then return end
    if typeof(targetPosition) == "CFrame" then targetPosition = targetPosition.Position end
    if instant then
        pcall(function() RootPart.CFrame = CFrame.new(targetPosition) end)
    else
        pcall(function()
            local tween = TweenService:Create(RootPart, TweenInfo.new((RootPart.Position - targetPosition).Magnitude / 250, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPosition)})
            tween:Play()
            tween.Completed:Wait()
        end)
    end
end

local function collectItem(item)
    if not item then return end
    if item:IsA("Tool") then
        pcall(function()
            firetouchinterest(item:FindFirstChild("Handle") or item, RootPart, 1)
            task.wait(0.1)
            firetouchinterest(item:FindFirstChild("Handle") or item, RootPart, 0)
        end)
    elseif item:IsA("BasePart") then
        pcall(function()
            firetouchinterest(item, RootPart, 1)
            task.wait(0.1)
            firetouchinterest(item, RootPart, 0)
        end)
    end
end

local function attackTarget(target)
    if not target then return end
    local humanoid = target:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    local hrp = target:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local distance = (RootPart.Position - hrp.Position).Magnitude
    local maxDist = SETTINGS.AutoFarm.SuperRange and SETTINGS.AutoFarm.RangeDistance or 15

    if distance > maxDist then
        teleportTo(hrp.Position, true)
        task.wait(0.2)
    end

    if SETTINGS.Combat.SuperRange and distance > 15 then
        pcall(function()
            local args = {[1] = "M1", [2] = hrp.Position}
            if ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Attack") then
                ReplicatedStorage.Remotes.Attack:FireServer(unpack(args))
            end
        end)
    else
        pcall(function()
            VirtualInputManager:SendKeyEvent(true, "M1", false, game)
            task.wait(0.02)
            VirtualInputManager:SendKeyEvent(false, "M1", false, game)
        end)
    end

    if SETTINGS.AutoFarm.AutoSkills then
        task.spawn(function()
            for i = 1, 4 do
                pcall(function()
                    local tool = Backpack:FindFirstChildOfClass("Tool") or Character:FindFirstChildOfClass("Tool")
                    if tool then
                        Humanoid:EquipTool(tool)
                        tool:Activate()
                    end
                end)
                task.wait(SETTINGS.AutoFarm.SkillDelay)
            end
        end)
    end

    State.LastAttack = tick()
end

local function startMobVacuum()
    if State.MobVacuumThread then
        task.cancel(State.MobVacuumThread)
        State.MobVacuumThread = nil
    end

    if not SETTINGS.AutoFarm.MobVacuum then
        for _, part in ipairs(State.VacuumParts) do
            pcall(function() part:Destroy() end)
        end
        State.VacuumParts = {}
        return
    end

    State.MobVacuumThread = task.spawn(function()
        while SETTINGS.AutoFarm.MobVacuum do
            pcall(function()
                local vacuumPos = RootPart.Position
                local radius = SETTINGS.AutoFarm.VacuumRadius

                for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                        local hrp = enemy.HumanoidRootPart
                        local dist = (vacuumPos - hrp.Position).Magnitude
                        if dist <= radius and dist > 5 then
                            local direction = (vacuumPos - hrp.Position).Unit
                            local newPos = hrp.Position + direction * (dist * 0.3)
                            hrp.CFrame = CFrame.new(newPos)
                        end
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end

local function startSuperRange()
    if State.SuperRangeThread then
        task.cancel(State.SuperRangeThread)
        State.SuperRangeThread = nil
    end

    if not SETTINGS.Combat.SuperRange then return end

    State.SuperRangeThread = task.spawn(function()
        while SETTINGS.Combat.SuperRange do
            pcall(function()
                if Character then
                    for _, part in ipairs(Character:GetChildren()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.Size = Vector3.new(SETTINGS.Combat.RangeMultiplier * 5, SETTINGS.Combat.RangeMultiplier * 5, SETTINGS.Combat.RangeMultiplier * 5)
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end

local function startTrollFeatures()
    if State.TrollThread then
        task.cancel(State.TrollThread)
        State.TrollThread = nil
    end

    if not SETTINGS.Troll.Enabled then return end

    State.TrollThread = task.spawn(function()
        while SETTINGS.Troll.Enabled do
            if SETTINGS.Troll.ServerLag then
                task.spawn(function()
                    for _ = 1, SETTINGS.Troll.LagIntensity * 10 do
                        pcall(function()
                            local part = Instance.new("Part")
                            part.Size = Vector3.new(10, 10, 10)
                            part.Position = RootPart.Position + Vector3.new(math.random(-50, 50), math.random(0, 50), math.random(-50, 50))
                            part.Anchored = false
                            part.Parent = Workspace
                            Debris:AddItem(part, 0.5)
                        end)
                    end
                end)
            end

            if SETTINGS.Troll.KickPlayer and SETTINGS.Troll.TargetPlayer ~= "" then
                pcall(function()
                    local target = Players:FindFirstChild(SETTINGS.Troll.TargetPlayer)
                    if target then
                        if syn and syn.kick then
                            syn.kick(target)
                        end
                    end
                end)
            end

            if SETTINGS.Troll.TeleportPlayer and SETTINGS.Troll.TeleportTarget ~= "" then
                pcall(function()
                    local target = Players:FindFirstChild(SETTINGS.Troll.TeleportTarget)
                    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                        local islandPositions = {
                            Sea1 = Vector3.new(1000, 50, 1000),
                            Sea2 = Vector3.new(-5000, 50, -3000),
                            Sea3 = Vector3.new(-12000, 100, 8000),
                            Random = Vector3.new(math.random(-15000, 15000), 50, math.random(-15000, 15000)),
                        }
                        local targetPos = islandPositions[SETTINGS.Troll.TeleportIsland] or islandPositions.Random
                        target.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
                    end
                end)
            end

            if SETTINGS.Troll.FreezePlayer and SETTINGS.Troll.FreezeTarget ~= "" then
                pcall(function()
                    local target = Players:FindFirstChild(SETTINGS.Troll.FreezeTarget)
                    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                        if not State.FrozenPlayers[target.Name] then
                            State.FrozenPlayers[target.Name] = target.Character.HumanoidRootPart.CFrame
                        end
                        target.Character.HumanoidRootPart.Anchored = true
                    end
                end)
            end

            if SETTINGS.Troll.SpamChat then
                pcall(function()
                    ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                        SETTINGS.Troll.SpamMessage, "All"
                    )
                end)
                task.wait(SETTINGS.Troll.SpamInterval)
            end

            if SETTINGS.Troll.CrashPlayer and SETTINGS.Troll.CrashTarget ~= "" then
                pcall(function()
                    local target = Players:FindFirstChild(SETTINGS.Troll.CrashTarget)
                    if target then
                        for _ = 1, 100 do
                            pcall(function()
                                ReplicatedStorage.Remotes.Team:FireServer("Crash", target)
                            end)
                        end
                    end
                end)
            end

            if SETTINGS.Troll.RandomTroll then
                local players = Players:GetPlayers()
                if #players > 1 then
                    local randomPlayer = players[math.random(1, #players)]
                    if randomPlayer ~= LocalPlayer and randomPlayer.Character and randomPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        randomPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                            RootPart.Position + Vector3.new(math.random(-100, 100), 50, math.random(-100, 100))
                        )
                    end
                end
            end

            task.wait(SETTINGS.Troll.SpamInterval > 0 and SETTINGS.Troll.SpamInterval or 1)
        end
    end)
end

local function startFixLag()
    if State.FixLagThread then
        task.cancel(State.FixLagThread)
        State.FixLagThread = nil
    end

    if not SETTINGS.FixLag.Enabled then return end

    State.FixLagThread = task.spawn(function()
        pcall(function()
            if SETTINGS.FixLag.SuperLowGraphics then
                settings().Rendering.QualityLevel = 1
                settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level1
                settings().Rendering.FrameRateManager = Enum.FrameRateManager.Default
                setfpscap(240)
            end
            if SETTINGS.FixLag.NoEffects then
                SoundService.Volume = 0
                Lighting.GlobalShadows = false
                Lighting.ShadowSoftness = 0
                Lighting.Brightness = 2
                Lighting.ExposureCompensation = 0
                Lighting.Ambient = Color3.new(1, 1, 1)
                Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
                Lighting.Bloom.Intensity = 0
                Lighting.DepthOfField.Enabled = false
                Lighting.MotionBlur.Enabled = false
                Lighting.ColorCorrection.Enabled = false
                Lighting.SunRays.Enabled = false
            end
            if SETTINGS.FixLag.RemoveSky then
                Lighting.Sky.Parent = nil
            end
            if SETTINGS.FixLag.RemoveWater then
                Workspace.Terrain.WaterWaveSize = 0
                Workspace.Terrain.WaterWaveSpeed = 0
                Workspace.Terrain.WaterReflectance = 0
                Workspace.Terrain.WaterTransparency = 1
            end
        end)

        while SETTINGS.FixLag.Enabled do
            pcall(function()
                if SETTINGS.FixLag.SimplifyVFX then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or 
                           obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Beam") then
                            obj.Enabled = false
                        end
                        if obj:IsA("Explosion") then
                            obj.Visible = false
                        end
                    end
                end

                if SETTINGS.FixLag.FlatTextures then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and obj.Transparency < 1 then
                            if obj.Material == Enum.Material.SmoothPlastic then
                                obj.Material = Enum.Material.Plastic
                            end
                            obj.Reflectance = 0
                        end
                    end
                end

                if SETTINGS.FixLag.LowQualityTextures then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("Decal") or obj:IsA("Texture") then
                            obj:Destroy()
                        end
                    end
                end

                if SETTINGS.FixLag.ReduceVRAM then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and obj:IsDescendantOf(Workspace) then
                            local dist = (RootPart.Position - obj.Position).Magnitude
                            if dist > SETTINGS.FixLag.MaxRenderDistance then
                                obj.Transparency = 0.99
                            end
                        end
                    end
                    collectgarbage("collect")
                end

                if SETTINGS.FixLag.AggressiveCleanup then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("Model") and #obj:GetChildren() == 0 then
                            pcall(function() obj:Destroy() end)
                        end
                        if (obj.Name == "Rock" or obj.Name == "Bush" or obj.Name == "Grass" or obj.Name == "Tree") and obj:IsA("BasePart") then
                            obj.Transparency = 0.95
                        end
                    end
                end

                if SETTINGS.FixLag.BrownCharacters then
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player.Character then
                            for _, part in ipairs(player.Character:GetChildren()) do
                                if part:IsA("BasePart") and part.Transparency < 1 then
                                    part.Material = Enum.Material.SmoothPlastic
                                    part.BrickColor = BrickColor.new("Brown")
                                    part.Color = Color3.fromRGB(139, 69, 19)
                                    part.Reflectance = 0
                                    part.TextureID = ""
                                end
                            end
                            local humanoid = player.Character:FindFirstChild("Humanoid")
                            if humanoid then
                                for _, acc in ipairs(humanoid:GetAccessories()) do
                                    pcall(function() acc:Destroy() end)
                                end
                            end
                        end
                    end
                    for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
                        for _, part in ipairs(enemy:GetChildren()) do
                            if part:IsA("BasePart") and part.Transparency < 1 then
                                part.Material = Enum.Material.SmoothPlastic
                                part.BrickColor = BrickColor.new("Brown")
                                part.Color = Color3.fromRGB(139, 69, 19)
                            end
                        end
                    end
                end

                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                        obj.Enabled = false
                    end
                    if obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("SunRaysEffect") or obj:IsA("ColorCorrectionEffect") then
                        obj.Enabled = false
                    end
                end
            end)
            task.wait(10)
        end
    end)
end

local function findNearestMaterial(materialType)
    local radius = 200
    local nearest = nil
    local nearestDist = radius

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if (obj:IsA("Tool") or obj:IsA("BasePart")) and obj:IsDescendantOf(Workspace) then
            local name = obj.Name:lower()
            local collect = false
            local part = obj:IsA("Tool") and obj:FindFirstChild("Handle") or obj
            if not part or not part:IsA("BasePart") then continue end

            local materialMap = {
                Bones = {"bone", "skeleton"},
                Ectoplasm = {"ectoplasm", "ghost"},
                Fragment = {"fragment"},
                Candy = {"candy"},
                Gems = {"gem", "diamond", "ruby"},
                Money = {"beli", "coin", "money"},
                Cocoa = {"cocoa"},
                Cake = {"cake"},
                DragonScale = {"dragon scale"},
                LeviathanScale = {"leviathan scale"},
                SeaBeastMeat = {"sea beast meat"},
                MagmaOre = {"magma ore"},
                IronOre = {"iron ore"},
                CopperOre = {"copper ore"},
                GoldOre = {"gold ore"},
                DiamondOre = {"diamond ore"},
                Fish = {"fish", "shark", "tuna"},
                Driftwood = {"driftwood"},
                Seashell = {"seashell"},
                StarPieces = {"star piece"},
            }

            if materialMap[materialType] then
                for _, keyword in ipairs(materialMap[materialType]) do
                    if name:find(keyword) then
                        collect = true
                        break
                    end
                end
            end

            if collect then
                local dist = (RootPart.Position - part.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = part
                end
            end
        end
    end
    return nearest, nearestDist
end

local function startMaterialFarm()
    if State.MaterialFarmThread then
        task.cancel(State.MaterialFarmThread)
        State.MaterialFarmThread = nil
    end

    if not SETTINGS.MaterialFarm.Enabled then return end

    State.MaterialFarmThread = task.spawn(function()
        while SETTINGS.MaterialFarm.Enabled do
            if not Character or not Character.Parent then
                Character = LocalPlayer.CharacterAdded:Wait()
                Humanoid = Character:WaitForChild("Humanoid")
                RootPart = Character:WaitForChild("HumanoidRootPart")
            end

            local foundAny = false
            for materialName, enabled in pairs(SETTINGS.MaterialFarm) do
                if enabled and materialName ~= "Enabled" and typeof(SETTINGS.MaterialFarm[materialName]) == "boolean" then
                    local material, dist = findNearestMaterial(materialName)
                    if material and dist < 200 then
                        foundAny = true
                        teleportTo(material.Position, true)
                        task.wait(0.2)
                        collectItem(material.Parent or material)
                        task.wait(0.5)
                        break
                    end
                end
            end

            if not foundAny then
                task.wait(2)
            end
            task.wait(0.5)
        end
    end)
end

local function startAutoFarm()
    if State.AutoFarmThread then
        task.cancel(State.AutoFarmThread)
        State.AutoFarmThread = nil
    end

    if not SETTINGS.AutoFarm.Enabled then return end

    State.AutoFarmThread = task.spawn(function()
        while SETTINGS.AutoFarm.Enabled do
            if not Character or not Character.Parent then
                Character = LocalPlayer.CharacterAdded:Wait()
                Humanoid = Character:WaitForChild("Humanoid")
                RootPart = Character:WaitForChild("HumanoidRootPart")
            end

            if Humanoid.Health <= 0 then
                task.wait(3)
                continue
            end

            local target = nil
            if SETTINGS.AutoFarm.Method == "Quest" or SETTINGS.AutoFarm.Method == "Nearest" then
                target, _ = getNearestEnemy(SETTINGS.AutoFarm.Distance)
            elseif SETTINGS.AutoFarm.Method == "Boss" then
                target, _ = getNearestBoss()
            elseif SETTINGS.AutoFarm.Method == "Material" then
                task.wait(0.5)
                continue
            end

            if target then
                State.IsFarming = true
                State.CurrentTarget = target
                attackTarget(target)

                if SETTINGS.AutoFarm.CollectDrops then
                    task.spawn(function()
                        pcall(function()
                            for _, drop in ipairs(Workspace:GetChildren()) do
                                if drop.Name:lower():find("drop") or drop:IsA("Tool") then
                                    if (RootPart.Position - drop.Position).Magnitude <= 50 then
                                        collectItem(drop)
                                    end
                                end
                            end
                        end)
                    end)
                end
            else
                State.IsFarming = false
                State.CurrentTarget = nil
                task.wait(1)
            end

            if SETTINGS.AutoFarm.FastMode then
                task.wait(0.05)
            else
                task.wait(0.3)
            end
        end
    end)
end

local function startFastAttack()
    if State.FastAttackThread then task.cancel(State.FastAttackThread); State.FastAttackThread = nil end
    if SETTINGS.Combat.FastAttack then
        State.FastAttackThread = task.spawn(function()
            while SETTINGS.Combat.FastAttack do
                pcall(function()
                    VirtualInputManager:SendKeyEvent(true, "M1", false, game)
                    VirtualInputManager:SendKeyEvent(false, "M1", false, game)
                end)
                task.wait(SETTINGS.Combat.FastAttackSpeed)
            end
        end)
    end
end

local function startFastAttack200x()
    if State.FastAttackThread then task.cancel(State.FastAttackThread); State.FastAttackThread = nil end
    if SETTINGS.Combat.FastAttack200x then
        SETTINGS.Combat.FastAttack = false
        State.FastAttackThread = task.spawn(function()
            while SETTINGS.Combat.FastAttack200x do
                pcall(function()
                    VirtualInputManager:SendKeyEvent(true, "M1", false, game)
                    VirtualInputManager:SendKeyEvent(false, "M1", false, game)
                end)
                task.wait(0.005)
            end
        end)
    end
end

local function startKillAura()
    if State.KillAuraThread then task.cancel(State.KillAuraThread); State.KillAuraThread = nil end
    if SETTINGS.Combat.KillAura then
        State.KillAuraThread = task.spawn(function()
            while SETTINGS.Combat.KillAura do
                if not SETTINGS.AutoFarm.Enabled then task.wait(0.3); continue end
                local nearest, dist = getNearestEnemy(SETTINGS.Combat.KillAuraRange)
                if nearest and dist <= SETTINGS.Combat.KillAuraRange then
                    attackTarget(nearest)
                end
                task.wait(0.1)
            end
        end)
    end
end

local function startCombo()
    if State.ComboThread then task.cancel(State.ComboThread); State.ComboThread = nil end
    if SETTINGS.Combat.AutoCombo then
        State.ComboThread = task.spawn(function()
            while SETTINGS.Combat.AutoCombo do
                if SETTINGS.AutoFarm.Enabled and State.CurrentTarget then
                    local target = State.CurrentTarget
                    local hrp = target:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        if (RootPart.Position - hrp.Position).Magnitude > 15 then
                            teleportTo(hrp.Position, true)
                            task.wait(0.2)
                        end
                        for _, skill in ipairs(SETTINGS.Combat.ComboSkills) do
                            if not SETTINGS.Combat.AutoCombo then break end
                            if not target or not target:FindFirstChild("Humanoid") or target.Humanoid.Health <= 0 then break end
                            pcall(function()
                                VirtualInputManager:SendKeyEvent(true, skill, false, game)
                                task.wait(0.05)
                                VirtualInputManager:SendKeyEvent(false, skill, false, game)
                            end)
                            task.wait(SETTINGS.Combat.ComboDelay)
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end

local function startCombatUtilities()
    task.spawn(function() while SETTINGS.Combat.Godmode do pcall(function() if Humanoid then Humanoid.Health = Humanoid.MaxHealth end end); task.wait(0.05) end end)
    task.spawn(function() while SETTINGS.Combat.InfiniteEnergy do pcall(function() if Character then local e = Character:FindFirstChild("Energy"); if e then e.Value = e.MaxValue end end end); task.wait(0.05) end end)
    task.spawn(function() while SETTINGS.Combat.NoStun do pcall(function() if Humanoid then Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false); Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false) end end); task.wait(0.3) end end)
end

local function startQuestSystem()
    if not SETTINGS.Quest.Enabled then return end
    task.spawn(function()
        while SETTINGS.Quest.Enabled do
            pcall(function()
                for _, npc in ipairs(Workspace.NPCs:GetChildren()) do
                    if npc:FindFirstChild("ProximityPrompt") and npc.ProximityPrompt.Enabled then
                        if SETTINGS.Quest.AutoStart then
                            fireproximityprompt(npc.ProximityPrompt)
                            task.wait(1)
                            if SETTINGS.Quest.SkipDialog then
                                fireproximityprompt(npc.ProximityPrompt)
                                task.wait(1)
                            end
                        end
                        break
                    end
                end
            end)
            task.wait(10)
        end
    end)
end

local function startAutoStats()
    if not SETTINGS.AutoStats.Enabled then return end
    task.spawn(function()
        while SETTINGS.AutoStats.Enabled do
            pcall(function()
                local args = {[1] = "AddPoint", [2] = SETTINGS.AutoFarm.Stats, [3] = SETTINGS.AutoStats.PointsPerUpgrade}
                if ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Stat") then
                    ReplicatedStorage.Remotes.Stat:FireServer(unpack(args))
                end
            end)
            task.wait(3)
        end
    end)
end

local function createGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RyzenAI_UltimateGUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 350, 0, 520)
    MainFrame.Position = UDim2.new(0, 20, 0.5, -260)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(0, 255, 200)
    UIStroke.Thickness = 1
    UIStroke.Transparency = 0.5
    UIStroke.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.BackgroundColor3 = Color3.fromRGB(18, 18, 30)
    Title.TextColor3 = Color3.fromRGB(0, 255, 200)
    Title.Text = "⚡ RYZEN AI v4.0 - ULTIMATE"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 15
    Title.Parent = MainFrame

    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, 0, 0, 30)
    TabContainer.Position = UDim2.new(0, 0, 0, 35)
    TabContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 30)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame

    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -10, 1, -75)
    ContentFrame.Position = UDim2.new(0, 5, 0, 70)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 200)
    ContentFrame.Parent = MainFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = ContentFrame

    local TabPages = {}
    local currentTab = "Farm"

    local tabs = {"Farm", "Combat", "Materials", "Troll", "FixLag"}
    for i, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 65, 0, 25)
        btn.Position = UDim2.new(0, 5 + (i-1)*68, 0, 2)
        btn.BackgroundColor3 = tabName == currentTab and Color3.fromRGB(0, 200, 150) or Color3.fromRGB(30, 30, 40)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Text = tabName
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = TabContainer
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = btn

        local page = Instance.new("Frame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.Visible = (tabName == currentTab)
        page.Parent = ContentFrame
        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Padding = UDim.new(0, 5)
        pageLayout.Parent = page
        TabPages[tabName] = page

        btn.MouseButton1Click:Connect(function()
            currentTab = tabName
            for _, p in pairs(TabPages) do p.Visible = false end
            page.Visible = true
            for _, b in ipairs(TabContainer:GetChildren()) do
                if b:IsA("TextButton") then
                    b.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                end
            end
            btn.BackgroundColor3 = Color3.fromRGB(0, 200, 150)
        end)
    end

    local function addToggle(parent, text, configTable, configKey, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 28)
        container.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        container.BorderSizePixel = 0
        container.Parent = parent

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.Position = UDim2.new(0, 8, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(0.9, 0.9, 0.9)
        label.Text = text
        label.Font = Enum.Font.Gotham
        label.TextSize = 10
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container

        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 36, 0, 18)
        toggleBtn.Position = UDim2.new(1, -46, 0.5, -9)
        toggleBtn.BackgroundColor3 = configTable[configKey] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(150, 0, 0)
        toggleBtn.TextColor3 = Color3.new(1, 1, 1)
        toggleBtn.Text = configTable[configKey] and "ON" or "OFF"
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.TextSize = 9
        toggleBtn.BorderSizePixel = 0
        toggleBtn.AutoButtonColor = false
        toggleBtn.Parent = container
        local tc = Instance.new("UICorner"); tc.CornerRadius = UDim.new(0, 3); tc.Parent = toggleBtn

        toggleBtn.MouseButton1Click:Connect(function()
            configTable[configKey] = not configTable[configKey]
            toggleBtn.BackgroundColor3 = configTable[configKey] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(150, 0, 0)
            toggleBtn.Text = configTable[configKey] and "ON" or "OFF"
            if callback then callback(configTable[configKey]) end
        end)
    end

    local function addSection(parent, text)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 18)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(0, 255, 200)
        label.Text = "▸ " .. text
        label.Font = Enum.Font.GothamBold
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = parent
    end

    addSection(TabPages["Farm"], "Auto Farm")
    addToggle(TabPages["Farm"], "Auto Farm", SETTINGS.AutoFarm, "Enabled", function(v) if v then startAutoFarm() else if State.AutoFarmThread then task.cancel(State.AutoFarmThread) end end end)
    addToggle(TabPages["Farm"], "Fast Mode", SETTINGS.AutoFarm, "FastMode")
    addToggle(TabPages["Farm"], "Auto Skills", SETTINGS.AutoFarm, "AutoSkills")
    addToggle(TabPages["Farm"], "Collect Drops", SETTINGS.AutoFarm, "CollectDrops")
    addToggle(TabPages["Farm"], "Auto Equip Best", SETTINGS.AutoFarm, "AutoEquipBest")
    addToggle(TabPages["Farm"], "Mob Vacuum (Hút quái)", SETTINGS.AutoFarm, "MobVacuum", function(v) startMobVacuum() end)
    addToggle(TabPages["Farm"], "Super Range (Đánh xa)", SETTINGS.AutoFarm, "SuperRange")
    addSection(TabPages["Farm"], "Quest & Stats")
    addToggle(TabPages["Farm"], "Auto Quest", SETTINGS.Quest, "Enabled", function(v) if v then startQuestSystem() end end)
    addToggle(TabPages["Farm"], "Auto Stats", SETTINGS.AutoStats, "Enabled", function(v) if v then startAutoStats() end end)

    addSection(TabPages["Combat"], "Attack")
    addToggle(TabPages["Combat"], "Kill Aura", SETTINGS.Combat, "KillAura", function(v) startKillAura() end)
    addToggle(TabPages["Combat"], "Fast Attack", SETTINGS.Combat, "FastAttack", function(v) startFastAttack() end)
    addToggle(TabPages["Combat"], "Fast Attack 200x", SETTINGS.Combat, "FastAttack200x", function(v) startFastAttack200x() end)
    addToggle(TabPages["Combat"], "Auto Combo", SETTINGS.Combat, "AutoCombo", function(v) startCombo() end)
    addToggle(TabPages["Combat"], "Super Range (Siêu xa)", SETTINGS.Combat, "SuperRange", function(v) startSuperRange() end)
    addSection(TabPages["Combat"], "Defense")
    addToggle(TabPages["Combat"], "Godmode", SETTINGS.Combat, "Godmode")
    addToggle(TabPages["Combat"], "Infinite Energy", SETTINGS.Combat, "InfiniteEnergy")
    addToggle(TabPages["Combat"], "No Stun", SETTINGS.Combat, "NoStun")

    addSection(TabPages["Materials"], "Material Farm")
    addToggle(TabPages["Materials"], "Enable Material Farm", SETTINGS.MaterialFarm, "Enabled", function(v) if v then startMaterialFarm() else if State.MaterialFarmThread then task.cancel(State.MaterialFarmThread) end end end)
    local materials = {"Bones", "Ectoplasm", "Fragment", "Candy", "Gems", "Money", "Cocoa", "Cake", "DragonScale", "LeviathanScale", "SeaBeastMeat", "MagmaOre", "IronOre", "CopperOre", "GoldOre", "DiamondOre", "Fish", "Driftwood", "Seashell", "StarPieces"}
    for _, mat in ipairs(materials) do
        addToggle(TabPages["Materials"], mat, SETTINGS.MaterialFarm, mat)
    end

    addSection(TabPages["Troll"], "Troll Features (RỦI RO CAO!)")
    addToggle(TabPages["Troll"], "Enable Troll", SETTINGS.Troll, "Enabled", function(v) startTrollFeatures() end)
    addToggle(TabPages["Troll"], "Server Lag", SETTINGS.Troll, "ServerLag")
    addToggle(TabPages["Troll"], "Kick Player", SETTINGS.Troll, "KickPlayer")
    addToggle(TabPages["Troll"], "Teleport Player", SETTINGS.Troll, "TeleportPlayer")
    addToggle(TabPages["Troll"], "Freeze Player", SETTINGS.Troll, "FreezePlayer")
    addToggle(TabPages["Troll"], "Spam Chat", SETTINGS.Troll, "SpamChat")
    addToggle(TabPages["Troll"], "Crash Player", SETTINGS.Troll, "CrashPlayer")
    addToggle(TabPages["Troll"], "Random Troll", SETTINGS.Troll, "RandomTroll")

    addSection(TabPages["FixLag"], "SUPER FIX LAG")
    addToggle(TabPages["FixLag"], "Enable Fix Lag", SETTINGS.FixLag, "Enabled", function(v) startFixLag() end)
    addToggle(TabPages["FixLag"], "Simplify VFX", SETTINGS.FixLag, "SimplifyVFX")
    addToggle(TabPages["FixLag"], "Flat Textures", SETTINGS.FixLag, "FlatTextures")
    addToggle(TabPages["FixLag"], "Low Quality Textures", SETTINGS.FixLag, "LowQualityTextures")
    addToggle(TabPages["FixLag"], "Reduce VRAM", SETTINGS.FixLag, "ReduceVRAM")
    addToggle(TabPages["FixLag"], "Aggressive Cleanup", SETTINGS.FixLag, "AggressiveCleanup")
    addToggle(TabPages["FixLag"], "No Effects", SETTINGS.FixLag, "NoEffects")
    addToggle(TabPages["FixLag"], "Brown Characters", SETTINGS.FixLag, "BrownCharacters")
    addToggle(TabPages["FixLag"], "Remove Sky", SETTINGS.FixLag, "RemoveSky")
    addToggle(TabPages["FixLag"], "Remove Water", SETTINGS.FixLag, "RemoveWater")
    addToggle(TabPages["FixLag"], "Super Low Graphics", SETTINGS.FixLag, "SuperLowGraphics")
end

local function initialize()
    notify("Ryzen AI v4.0", "Ultimate Script Loaded!", 5)
    createGUI()
    startAutoFarm()
    startMaterialFarm()
    startMobVacuum()
    startSuperRange()
    startKillAura()
    startFastAttack()
    startFastAttack200x()
    startCombo()
    startQuestSystem()
    startAutoStats()
    startCombatUtilities()
    startTrollFeatures()
    startFixLag()

    LocalPlayer.CharacterAdded:Connect(function(newCharacter)
        Character = newCharacter
        Humanoid = Character:WaitForChild("Humanoid")
        RootPart = Character:WaitForChild("HumanoidRootPart")
        task.wait(1)
    end)

    print("[Ryzen AI v4.0] All Systems Online!")
end

initialize()
return true