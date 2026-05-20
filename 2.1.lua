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
local Drawing = Drawing or {}

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
        AutoClick = false,
        AutoClickSpeed = 0.02,
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
    AutoRaid = {
        Enabled = false,
        Type = "Flame",
        AutoBuyChip = false,
        AutoNext = false,
        AutoClear = false,
        Awaken = false,
    },
    AutoAwaken = {
        Enabled = false,
        TargetFruit = "",
    },
    AutoRace = {
        Enabled = false,
        Version = "V2",
    },
    AutoHaki = {
        Enabled = false,
        BuyAll = true,
    },
    AutoMastery = {
        Enabled = false,
        Weapon = "Sword",
        AutoSwitch = false,
    },
    AutoDungeon = {
        Enabled = false,
        AutoStart = false,
    },
    AutoSeaEvents = {
        Enabled = false,
        SeaBeast = false,
        ShipRaid = false,
    },
    AutoEliteHunter = {
        Enabled = false,
        AutoReward = false,
    },
    AutoFactory = {
        Enabled = false,
        AutoCollectCore = false,
    },
    AutoBountyHunt = {
        Enabled = false,
        MinBounty = 500000,
    },
    FruitSniper = {
        Enabled = false,
        AutoEat = false,
        AutoStore = false,
        Webhook = false,
        WebhookURL = "",
    },
    AutoSpin = {
        Enabled = false,
        SpinCount = 10,
    },
    AutoBuyFruit = {
        Enabled = false,
        Budget = 5000000,
        TargetFruit = "",
    },
    TeleportToPlayer = {
        Enabled = false,
        TargetPlayer = "",
    },
    SpectatePlayer = {
        Enabled = false,
        TargetPlayer = "",
    },
    AutoPuzzle = {
        Enabled = false,
        SoulGuitar = false,
        MirrorFractal = false,
        Yama = false,
        Tushita = false,
    },
    DiscordWebhook = {
        Enabled = false,
        URL = "",
        NotifyFruit = false,
        NotifyBoss = false,
        NotifyRaid = false,
    },
    SaveConfig = {
        Enabled = false,
    },
    AutoChat = {
        Enabled = false,
        Messages = {"Hello!", "Good game!", "Ryzen AI"},
        Interval = 60,
    },
    AutoHopRegions = {
        Enabled = false,
        MinPlayers = 1,
        MaxPlayers = 20,
    },
    FPSBoostPro = {
        Enabled = false,
        RemoveTerrain = false,
        DisableAnimations = false,
    },
    AutoDress = {
        Enabled = false,
    },
    AutoTitle = {
        Enabled = false,
        TitleName = "",
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
    AutoSell = {
        Enabled = false,
        Threshold = 500000,
    },
    AutoBuy = {
        Enabled = false,
        Swords = {"Saber", "Rengoku", "True Triple Katana"},
    },
    AutoServerHop = {
        Enabled = false,
        MinPlayers = 5,
        MaxPlayers = 30,
        HopDelay = 10,
    },
    ESP = {
        Enabled = false,
        PlayerESP = true,
        FruitESP = true,
        EnemyESP = true,
        ChestESP = true,
        ItemESP = true,
        VehicleESP = true,
        ProjectileESP = true,
        ESPDistance = 2000,
        Box3D = true,
        Skeleton = true,
        Line2D = true,
        Glow = true,
        Chams = true,
        HealthBar = true,
        ShowDistance = true,
        ShowName = true,
        Weapon = true,
        ViewLine = true,
        Radar = true,
    },
    Misc = {
        FPSBoost = false,
    },
}

local State = {
    IsFarming = false, CurrentTarget = nil, LastAttack = 0,
    FastAttackThread = nil, KillAuraThread = nil, AutoFarmThread = nil,
    AutoClickThread = nil, ComboThread = nil, MaterialFarmThread = nil,
    MobVacuumThread = nil, SuperRangeThread = nil, TrollThread = nil,
    FixLagThread = nil, AutoSellThread = nil, AutoBuyThread = nil,
    AutoServerHopThread = nil, ESPThread = nil, RadarFrame = nil,
    RadarDots = {}, FrozenPlayers = {}, VacuumParts = {}, ESPObjects = {},
    IsMenuOpen = false,
    AutoRaidThread = nil, AutoAwakenThread = nil, AutoRaceThread = nil,
    AutoHakiThread = nil, AutoMasteryThread = nil, AutoDungeonThread = nil,
    AutoSeaEventsThread = nil, AutoEliteHunterThread = nil, AutoFactoryThread = nil,
    AutoBountyHuntThread = nil, FruitSniperThread = nil, AutoSpinThread = nil,
    AutoBuyFruitThread = nil, AutoPuzzleThread = nil, DiscordWebhookThread = nil,
    AutoChatThread = nil, AutoHopRegionsThread = nil, FPSBoostProThread = nil,
}

local function notify(title, text, duration)
    duration = duration or 3
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = duration})
    end)
end

local function sendWebhook(url, title, description, color)
    pcall(function()
        local embed = {title = title, description = description, color = color or 16711680, timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")}
        local payload = HttpService:JSONEncode({embeds = {embed}})
        HttpService:PostAsync(url, payload, Enum.HttpContentType.ApplicationJson)
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

local function startAutoClick()
    if State.AutoClickThread then
        task.cancel(State.AutoClickThread)
        State.AutoClickThread = nil
    end

    if not SETTINGS.Combat.AutoClick then return end

    State.AutoClickThread = task.spawn(function()
        while SETTINGS.Combat.AutoClick do
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, "M1", false, game)
                VirtualInputManager:SendKeyEvent(false, "M1", false, game)
            end)
            task.wait(SETTINGS.Combat.AutoClickSpeed)
        end
    end)
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

local function startAutoRaid()
    if State.AutoRaidThread then task.cancel(State.AutoRaidThread); State.AutoRaidThread = nil end
    if not SETTINGS.AutoRaid.Enabled then return end
    State.AutoRaidThread = task.spawn(function()
        while SETTINGS.AutoRaid.Enabled do
            pcall(function()
                local raidName = SETTINGS.AutoRaid.Type
                if SETTINGS.AutoRaid.AutoBuyChip then
                    ReplicatedStorage.Remotes.Team:FireServer("BuyChip", raidName)
                    task.wait(2)
                end
                if SETTINGS.AutoRaid.AutoClear then
                    ReplicatedStorage.Remotes.Team:FireServer("StartRaid", raidName)
                    for i = 1, 5 do
                        local enemy = getNearestEnemy(200)
                        if enemy then attackTarget(enemy) end
                        task.wait(2)
                    end
                end
                if SETTINGS.AutoRaid.AutoNext then
                    ReplicatedStorage.Remotes.Team:FireServer("NextRaid")
                end
                if SETTINGS.AutoRaid.Awaken then
                    ReplicatedStorage.Remotes.Team:FireServer("AwakenFruit")
                end
            end)
            task.wait(30)
        end
    end)
end

local function startAutoAwaken()
    if State.AutoAwakenThread then task.cancel(State.AutoAwakenThread); State.AutoAwakenThread = nil end
    if not SETTINGS.AutoAwaken.Enabled then return end
    State.AutoAwakenThread = task.spawn(function()
        while SETTINGS.AutoAwaken.Enabled do
            pcall(function()
                ReplicatedStorage.Remotes.Team:FireServer("Awaken", SETTINGS.AutoAwaken.TargetFruit)
            end)
            task.wait(10)
        end
    end)
end

local function startAutoRace()
    if State.AutoRaceThread then task.cancel(State.AutoRaceThread); State.AutoRaceThread = nil end
    if not SETTINGS.AutoRace.Enabled then return end
    State.AutoRaceThread = task.spawn(function()
        while SETTINGS.AutoRace.Enabled do
            pcall(function()
                ReplicatedStorage.Remotes.Team:FireServer("RaceUpgrade", SETTINGS.AutoRace.Version)
            end)
            task.wait(15)
        end
    end)
end

local function startAutoHaki()
    if State.AutoHakiThread then task.cancel(State.AutoHakiThread); State.AutoHakiThread = nil end
    if not SETTINGS.AutoHaki.Enabled then return end
    State.AutoHakiThread = task.spawn(function()
        while SETTINGS.AutoHaki.Enabled do
            pcall(function()
                local hakis = {"Enhancement", "Skyjump", "FlashStep", "Observation"}
                for _, haki in ipairs(hakis) do
                    ReplicatedStorage.Remotes.Team:FireServer("BuyHaki", haki)
                    task.wait(0.5)
                end
            end)
            task.wait(30)
        end
    end)
end

local function startAutoMastery()
    if State.AutoMasteryThread then task.cancel(State.AutoMasteryThread); State.AutoMasteryThread = nil end
    if not SETTINGS.AutoMastery.Enabled then return end
    State.AutoMasteryThread = task.spawn(function()
        while SETTINGS.AutoMastery.Enabled do
            pcall(function()
                if SETTINGS.AutoMastery.AutoSwitch then
                    local weapon = Backpack:FindFirstChild(SETTINGS.AutoMastery.Weapon) or Character:FindFirstChild(SETTINGS.AutoMastery.Weapon)
                    if weapon then
                        Humanoid:EquipTool(weapon)
                    end
                end
                local enemy = getNearestEnemy(100)
                if enemy then attackTarget(enemy) end
            end)
            task.wait(1)
        end
    end)
end

local function startAutoDungeon()
    if State.AutoDungeonThread then task.cancel(State.AutoDungeonThread); State.AutoDungeonThread = nil end
    if not SETTINGS.AutoDungeon.Enabled then return end
    State.AutoDungeonThread = task.spawn(function()
        while SETTINGS.AutoDungeon.Enabled do
            pcall(function()
                ReplicatedStorage.Remotes.Team:FireServer("EnterDungeon")
                task.wait(5)
                for i = 1, 10 do
                    local enemy = getNearestEnemy(200)
                    if enemy then attackTarget(enemy) end
                    task.wait(1)
                end
            end)
            task.wait(60)
        end
    end)
end

local function startAutoSeaEvents()
    if State.AutoSeaEventsThread then task.cancel(State.AutoSeaEventsThread); State.AutoSeaEventsThread = nil end
    if not SETTINGS.AutoSeaEvents.Enabled then return end
    State.AutoSeaEventsThread = task.spawn(function()
        while SETTINGS.AutoSeaEvents.Enabled do
            if SETTINGS.AutoSeaEvents.SeaBeast then
                pcall(function()
                    ReplicatedStorage.Remotes.Team:FireServer("SummonSeaBeast")
                end)
                task.wait(5)
            end
            if SETTINGS.AutoSeaEvents.ShipRaid then
                pcall(function()
                    ReplicatedStorage.Remotes.Team:FireServer("StartShipRaid")
                end)
                task.wait(5)
            end
            task.wait(60)
        end
    end)
end

local function startAutoEliteHunter()
    if State.AutoEliteHunterThread then task.cancel(State.AutoEliteHunterThread); State.AutoEliteHunterThread = nil end
    if not SETTINGS.AutoEliteHunter.Enabled then return end
    State.AutoEliteHunterThread = task.spawn(function()
        while SETTINGS.AutoEliteHunter.Enabled do
            pcall(function()
                ReplicatedStorage.Remotes.Team:FireServer("HuntElite")
                if SETTINGS.AutoEliteHunter.AutoReward then
                    ReplicatedStorage.Remotes.Team:FireServer("ClaimEliteReward")
                end
            end)
            task.wait(120)
        end
    end)
end

local function startAutoFactory()
    if State.AutoFactoryThread then task.cancel(State.AutoFactoryThread); State.AutoFactoryThread = nil end
    if not SETTINGS.AutoFactory.Enabled then return end
    State.AutoFactoryThread = task.spawn(function()
        while SETTINGS.AutoFactory.Enabled do
            pcall(function()
                ReplicatedStorage.Remotes.Team:FireServer("StartFactory")
                if SETTINGS.AutoFactory.AutoCollectCore then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj.Name:lower():find("core") and obj:IsA("BasePart") then
                            teleportTo(obj.Position, true)
                            collectItem(obj)
                            break
                        end
                    end
                end
            end)
            task.wait(300)
        end
    end)
end

local function startAutoBountyHunt()
    if State.AutoBountyHuntThread then task.cancel(State.AutoBountyHuntThread); State.AutoBountyHuntThread = nil end
    if not SETTINGS.AutoBountyHunt.Enabled then return end
    State.AutoBountyHuntThread = task.spawn(function()
        while SETTINGS.AutoBountyHunt.Enabled do
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local bounty = player.Character:FindFirstChild("Bounty")
                    if bounty and bounty.Value >= SETTINGS.AutoBountyHunt.MinBounty then
                        teleportTo(player.Character.HumanoidRootPart.Position, true)
                        attackTarget(player.Character)
                        break
                    end
                end
            end
            task.wait(10)
        end
    end)
end

local function startFruitSniper()
    if State.FruitSniperThread then task.cancel(State.FruitSniperThread); State.FruitSniperThread = nil end
    if not SETTINGS.FruitSniper.Enabled then return end
    State.FruitSniperThread = task.spawn(function()
        while SETTINGS.FruitSniper.Enabled do
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.Enabled and obj.Parent and obj.Parent:IsA("BasePart") then
                    local fruit = obj.Parent
                    teleportTo(fruit.Position, true)
                    task.wait(0.2)
                    if SETTINGS.FruitSniper.AutoEat then
                        fireproximityprompt(obj)
                    else
                        collectItem(fruit)
                    end
                    if SETTINGS.FruitSniper.Webhook then
                        sendWebhook(SETTINGS.FruitSniper.WebhookURL, "Fruit Found", fruit.Name, 16711680)
                    end
                    break
                end
            end
            task.wait(5)
        end
    end)
end

local function startAutoSpin()
    if State.AutoSpinThread then task.cancel(State.AutoSpinThread); State.AutoSpinThread = nil end
    if not SETTINGS.AutoSpin.Enabled then return end
    State.AutoSpinThread = task.spawn(function()
        while SETTINGS.AutoSpin.Enabled do
            pcall(function()
                for _ = 1, SETTINGS.AutoSpin.SpinCount do
                    ReplicatedStorage.Remotes.Team:FireServer("SpinFruit")
                    task.wait(1)
                end
            end)
            task.wait(60)
        end
    end)
end

local function startAutoBuyFruit()
    if State.AutoBuyFruitThread then task.cancel(State.AutoBuyFruitThread); State.AutoBuyFruitThread = nil end
    if not SETTINGS.AutoBuyFruit.Enabled then return end
    State.AutoBuyFruitThread = task.spawn(function()
        while SETTINGS.AutoBuyFruit.Enabled do
            pcall(function()
                ReplicatedStorage.Remotes.Team:FireServer("BuyFruit", SETTINGS.AutoBuyFruit.TargetFruit, SETTINGS.AutoBuyFruit.Budget)
            end)
            task.wait(60)
        end
    end)
end

local function startAutoPuzzle()
    if State.AutoPuzzleThread then task.cancel(State.AutoPuzzleThread); State.AutoPuzzleThread = nil end
    if not SETTINGS.AutoPuzzle.Enabled then return end
    State.AutoPuzzleThread = task.spawn(function()
        while SETTINGS.AutoPuzzle.Enabled do
            if SETTINGS.AutoPuzzle.SoulGuitar then
                pcall(function() ReplicatedStorage.Remotes.Team:FireServer("SolveSoulGuitar") end)
            end
            if SETTINGS.AutoPuzzle.MirrorFractal then
                pcall(function() ReplicatedStorage.Remotes.Team:FireServer("SolveMirrorFractal") end)
            end
            if SETTINGS.AutoPuzzle.Yama then
                pcall(function() ReplicatedStorage.Remotes.Team:FireServer("SolveYama") end)
            end
            if SETTINGS.AutoPuzzle.Tushita then
                pcall(function() ReplicatedStorage.Remotes.Team:FireServer("SolveTushita") end)
            end
            task.wait(10)
        end
    end)
end

local function startDiscordWebhook()
    if State.DiscordWebhookThread then task.cancel(State.DiscordWebhookThread); State.DiscordWebhookThread = nil end
    if not SETTINGS.DiscordWebhook.Enabled then return end
    State.DiscordWebhookThread = task.spawn(function()
        while SETTINGS.DiscordWebhook.Enabled do
            if SETTINGS.DiscordWebhook.NotifyBoss then
                local boss = getNearestBoss()
                if boss then
                    sendWebhook(SETTINGS.DiscordWebhook.URL, "Boss Spawned", boss.Name, 16776960)
                end
            end
            task.wait(30)
        end
    end)
end

local function startAutoChat()
    if State.AutoChatThread then task.cancel(State.AutoChatThread); State.AutoChatThread = nil end
    if not SETTINGS.AutoChat.Enabled then return end
    State.AutoChatThread = task.spawn(function()
        while SETTINGS.AutoChat.Enabled do
            local msg = SETTINGS.AutoChat.Messages[math.random(1, #SETTINGS.AutoChat.Messages)]
            pcall(function()
                ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
            end)
            task.wait(SETTINGS.AutoChat.Interval)
        end
    end)
end

local function startAutoHopRegions()
    if State.AutoHopRegionsThread then task.cancel(State.AutoHopRegionsThread); State.AutoHopRegionsThread = nil end
    if not SETTINGS.AutoHopRegions.Enabled then return end
    State.AutoHopRegionsThread = task.spawn(function()
        while SETTINGS.AutoHopRegions.Enabled do
            local count = #Players:GetPlayers()
            if count < SETTINGS.AutoHopRegions.MinPlayers or count > SETTINGS.AutoHopRegions.MaxPlayers then
                pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
            end
            task.wait(30)
        end
    end)
end

local function startFPSBoostPro()
    if State.FPSBoostProThread then task.cancel(State.FPSBoostProThread); State.FPSBoostProThread = nil end
    if not SETTINGS.FPSBoostPro.Enabled then return end
    State.FPSBoostProThread = task.spawn(function()
        pcall(function()
            if SETTINGS.FPSBoostPro.RemoveTerrain then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj.Name == "Rock" or obj.Name == "Bush" or obj.Name == "Tree" then
                        obj:Destroy()
                    end
                end
            end
            if SETTINGS.FPSBoostPro.DisableAnimations then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("AnimationController") or obj:IsA("Animator") then
                        obj:Destroy()
                    end
                end
            end
            settings().Rendering.QualityLevel = 1
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9999
        end)
    end)
end

local function startAutoDress()
    if not SETTINGS.AutoDress.Enabled then return end
    pcall(function()
        ReplicatedStorage.Remotes.Team:FireServer("EquipBestOutfit")
    end)
end

local function startAutoTitle()
    if not SETTINGS.AutoTitle.Enabled then return end
    pcall(function()
        ReplicatedStorage.Remotes.Team:FireServer("EquipTitle", SETTINGS.AutoTitle.TitleName)
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
                    if target and syn and syn.kick then
                        syn.kick(target)
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

local function startAutoSell()
    if State.AutoSellThread then task.cancel(State.AutoSellThread); State.AutoSellThread = nil end
    if not SETTINGS.AutoSell.Enabled then return end
    State.AutoSellThread = task.spawn(function()
        while SETTINGS.AutoSell.Enabled do
            pcall(function()
                local totalValue = 0
                for _, item in ipairs(Backpack:GetChildren()) do
                    if item:IsA("Tool") and item:FindFirstChild("SellValue") then
                        totalValue = totalValue + item.SellValue.Value
                    end
                end
                if totalValue >= SETTINGS.AutoSell.Threshold then
                    ReplicatedStorage.Remotes.Team:FireServer("SellAll")
                end
            end)
            task.wait(30)
        end
    end)
end

local function startAutoBuy()
    if State.AutoBuyThread then task.cancel(State.AutoBuyThread); State.AutoBuyThread = nil end
    if not SETTINGS.AutoBuy.Enabled then return end
    State.AutoBuyThread = task.spawn(function()
        while SETTINGS.AutoBuy.Enabled do
            pcall(function()
                for _, sword in ipairs(SETTINGS.AutoBuy.Swords) do
                    ReplicatedStorage.Remotes.Team:FireServer("BuySword", sword)
                    task.wait(0.5)
                end
            end)
            task.wait(10)
        end
    end)
end

local function startAutoServerHop()
    if State.AutoServerHopThread then task.cancel(State.AutoServerHopThread); State.AutoServerHopThread = nil end
    if not SETTINGS.AutoServerHop.Enabled then return end
    State.AutoServerHopThread = task.spawn(function()
        while SETTINGS.AutoServerHop.Enabled do
            local playerCount = #Players:GetPlayers()
            if playerCount < SETTINGS.AutoServerHop.MinPlayers or playerCount > SETTINGS.AutoServerHop.MaxPlayers then
                pcall(function()
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                end)
            end
            task.wait(SETTINGS.AutoServerHop.HopDelay)
        end
    end)
end

local function startESP()
    if State.ESPThread then
        task.cancel(State.ESPThread)
        State.ESPThread = nil
    end

    if not SETTINGS.ESP.Enabled then
        for _, obj in ipairs(State.ESPObjects) do
            pcall(function() obj:Destroy() end)
        end
        State.ESPObjects = {}
        if State.RadarFrame then
            State.RadarFrame.Visible = false
            for _, dot in ipairs(State.RadarDots) do dot:Destroy() end
            State.RadarDots = {}
        end
        return
    end

    local espGui = Instance.new("ScreenGui")
    espGui.Name = "ESP_GUI"
    espGui.Parent = CoreGui
    local radarFrame = Instance.new("Frame")
    radarFrame.Size = UDim2.new(0, 150, 0, 150)
    radarFrame.Position = UDim2.new(1, -160, 0, 10)
    radarFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    radarFrame.BackgroundTransparency = 0.7
    radarFrame.BorderSizePixel = 0
    radarFrame.Visible = SETTINGS.ESP.Radar
    radarFrame.Parent = espGui
    local radarCorner = Instance.new("UICorner")
    radarCorner.CornerRadius = UDim.new(1, 0)
    radarCorner.Parent = radarFrame
    State.RadarFrame = radarFrame

    State.ESPThread = task.spawn(function()
        while SETTINGS.ESP.Enabled do
            for _, obj in ipairs(State.ESPObjects) do
                pcall(function() obj:Destroy() end)
            end
            State.ESPObjects = {}

            if not Character or not Character.Parent then
                Character = LocalPlayer.CharacterAdded:Wait()
                Humanoid = Character:WaitForChild("Humanoid")
                RootPart = Character:WaitForChild("HumanoidRootPart")
            end

            local function worldToScreen(pos)
                local point, onScreen = Camera:WorldToScreenPoint(pos)
                return Vector2.new(point.X, point.Y), onScreen
            end

            local function createLine2D(from, to, color, thickness)
                local line = Drawing.new("Line")
                line.From = from
                line.To = to
                line.Color = color
                line.Thickness = thickness
                line.Transparency = 0.5
                line.Visible = true
                table.insert(State.ESPObjects, line)
            end

            local function createBox3D(model, color)
                if not model:FindFirstChild("HumanoidRootPart") then return end
                local box = Instance.new("SelectionBox")
                box.Adornee = model
                box.Color3 = color
                box.LineThickness = 1.5
                box.Transparency = 0.5
                box.Parent = model
                table.insert(State.ESPObjects, box)
            end

            local function createSkeleton(character, color)
                local function getJoint(name)
                    return character:FindFirstChild(name)
                end
                local joints = {
                    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
                    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
                    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
                    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
                    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
                }
                for _, pair in ipairs(joints) do
                    local part1 = getJoint(pair[1])
                    local part2 = getJoint(pair[2])
                    if part1 and part2 then
                        local beam = Instance.new("Beam")
                        beam.Attachment0 = part1:FindFirstChild("Attachment") or Instance.new("Attachment", part1)
                        beam.Attachment1 = part2:FindFirstChild("Attachment") or Instance.new("Attachment", part2)
                        beam.Color = ColorSequence.new(color)
                        beam.Width0 = 0.08
                        beam.Width1 = 0.08
                        beam.Parent = character
                        table.insert(State.ESPObjects, beam)
                    end
                end
            end

            local function createGlow(character, color)
                if character:FindFirstChild("ESP_Glow") then return end
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESP_Glow"
                highlight.FillColor = color
                highlight.FillTransparency = 0.8
                highlight.OutlineColor = color
                highlight.OutlineTransparency = 0
                highlight.Parent = character
                table.insert(State.ESPObjects, highlight)
            end

            local function createChams(character, color)
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Transparency < 1 then
                        if not part:FindFirstChild("ESP_Chams") then
                            local cham = Instance.new("Highlight")
                            cham.Name = "ESP_Chams"
                            cham.FillColor = color
                            cham.FillTransparency = 0.4
                            cham.OutlineTransparency = 1
                            cham.Parent = part
                            table.insert(State.ESPObjects, cham)
                        end
                    end
                end
            end

            local function createHealthBar(character, maxHealth, currentHealth)
                if character:FindFirstChild("Head") then
                    local head = character.Head
                    local billboard = Instance.new("BillboardGui")
                    billboard.Adornee = head
                    billboard.Size = UDim2.new(0, 50, 0, 6)
                    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                    billboard.Parent = head
                    local bg = Instance.new("Frame")
                    bg.Size = UDim2.new(1, 0, 1, 0)
                    bg.BackgroundColor3 = Color3.new(0, 0, 0)
                    bg.BorderSizePixel = 0
                    bg.Parent = billboard
                    local bar = Instance.new("Frame")
                    bar.Size = UDim2.new(currentHealth/maxHealth, 0, 1, 0)
                    bar.BackgroundColor3 = Color3.new(0, 1, 0)
                    bar.BorderSizePixel = 0
                    bar.Parent = billboard
                    table.insert(State.ESPObjects, billboard)
                end
            end

            for _, player in ipairs(Players:GetPlayers()) do
                if player == LocalPlayer then continue end
                local character = player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then continue end
                local hrp = character.HumanoidRootPart
                local humanoid = character:FindFirstChild("Humanoid")
                local dist = (RootPart.Position - hrp.Position).Magnitude
                if dist > SETTINGS.ESP.ESPDistance then continue end

                local isEnemy = Workspace.Enemies:FindFirstChild(character.Name) or (player.Team and LocalPlayer.Team and player.Team ~= LocalPlayer.Team)
                local color = isEnemy and Color3.new(1, 1, 0) or Color3.new(1, 0, 0)
                local screenPos, onScreen = worldToScreen(hrp.Position)

                if (SETTINGS.ESP.PlayerESP and not isEnemy) or (SETTINGS.ESP.EnemyESP and isEnemy) then
                    if SETTINGS.ESP.Box3D then createBox3D(character, color) end
                    if SETTINGS.ESP.Skeleton then createSkeleton(character, color) end
                    if SETTINGS.ESP.Line2D and onScreen then
                        local screenBottom = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        createLine2D(screenBottom, screenPos, color, 1.5)
                    end
                    if SETTINGS.ESP.Glow then createGlow(character, color) end
                    if SETTINGS.ESP.Chams then createChams(character, color) end
                    if SETTINGS.ESP.HealthBar and humanoid then
                        createHealthBar(character, humanoid.MaxHealth, humanoid.Health)
                    end
                    if SETTINGS.ESP.ViewLine then
                        local head = character:FindFirstChild("Head")
                        if head then
                            local direction = head.CFrame.LookVector * 50
                            local endPos = head.Position + direction
                            local startScr, _ = worldToScreen(head.Position)
                            local endScr, _ = worldToScreen(endPos)
                            if startScr and endScr then
                                createLine2D(startScr, endScr, color, 1)
                            end
                        end
                    end

                    if onScreen and (SETTINGS.ESP.ShowName or SETTINGS.ESP.ShowDistance or SETTINGS.ESP.Weapon) then
                        local text = ""
                        if SETTINGS.ESP.ShowName then text = text .. player.Name .. " " end
                        if SETTINGS.ESP.ShowDistance then text = text .. "[" .. math.floor(dist) .. "m] " end
                        if SETTINGS.ESP.Weapon then
                            local tool = character:FindFirstChildOfClass("Tool")
                            if tool then text = text .. "[" .. tool.Name .. "]" end
                        end
                        local billboard = Instance.new("BillboardGui")
                        billboard.Adornee = hrp
                        billboard.Size = UDim2.new(0, 100, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                        billboard.AlwaysOnTop = true
                        billboard.Parent = hrp
                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Text = text
                        label.TextColor3 = Color3.new(1, 1, 1)
                        label.TextStrokeTransparency = 0
                        label.Font = Enum.Font.SourceSansBold
                        label.TextSize = 12
                        label.Parent = billboard
                        table.insert(State.ESPObjects, billboard)
                    end
                end
            end

            if SETTINGS.ESP.FruitESP then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.Enabled and obj.Parent and obj.Parent:IsA("BasePart") then
                        local part = obj.Parent
                        local dist = (RootPart.Position - part.Position).Magnitude
                        if dist <= SETTINGS.ESP.ESPDistance then
                            createBox3D(part, Color3.new(1, 0.65, 0))
                            local billboard = Instance.new("BillboardGui")
                            billboard.Adornee = part
                            billboard.Size = UDim2.new(0, 80, 0, 20)
                            billboard.StudsOffset = Vector3.new(0, 2, 0)
                            billboard.AlwaysOnTop = true
                            billboard.Parent = part
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.Text = "FRUIT [" .. math.floor(dist) .. "m]"
                            label.TextColor3 = Color3.new(1, 0.65, 0)
                            label.Font = Enum.Font.SourceSansBold
                            label.TextSize = 12
                            label.Parent = billboard
                            table.insert(State.ESPObjects, billboard)
                        end
                    end
                end
            end

            if SETTINGS.ESP.ChestESP then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj.Name:lower():find("chest") and obj:IsA("BasePart") then
                        local dist = (RootPart.Position - obj.Position).Magnitude
                        if dist <= SETTINGS.ESP.ESPDistance then
                            createBox3D(obj, Color3.new(0, 1, 0))
                            local billboard = Instance.new("BillboardGui")
                            billboard.Adornee = obj
                            billboard.Size = UDim2.new(0, 80, 0, 20)
                            billboard.StudsOffset = Vector3.new(0, 2, 0)
                            billboard.AlwaysOnTop = true
                            billboard.Parent = obj
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.Text = "CHEST [" .. math.floor(dist) .. "m]"
                            label.TextColor3 = Color3.new(0, 1, 0)
                            label.Font = Enum.Font.SourceSansBold
                            label.TextSize = 12
                            label.Parent = billboard
                            table.insert(State.ESPObjects, billboard)
                        end
                    end
                end
            end

            if SETTINGS.ESP.ItemESP then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if (obj:IsA("Tool") or (obj:IsA("BasePart") and obj.Name:lower():find("loot"))) and obj:IsDescendantOf(Workspace) then
                        local part = obj:IsA("Tool") and obj:FindFirstChild("Handle") or obj
                        if part and part:IsA("BasePart") then
                            local dist = (RootPart.Position - part.Position).Magnitude
                            if dist <= SETTINGS.ESP.ESPDistance then
                                createBox3D(part, Color3.new(0, 1, 1))
                                local billboard = Instance.new("BillboardGui")
                                billboard.Adornee = part
                                billboard.Size = UDim2.new(0, 80, 0, 20)
                                billboard.StudsOffset = Vector3.new(0, 2, 0)
                                billboard.AlwaysOnTop = true
                                billboard.Parent = part
                                local label = Instance.new("TextLabel")
                                label.Size = UDim2.new(1, 0, 1, 0)
                                label.BackgroundTransparency = 1
                                label.Text = obj.Name .. " [" .. math.floor(dist) .. "m]"
                                label.TextColor3 = Color3.new(0, 1, 1)
                                label.Font = Enum.Font.SourceSansBold
                                label.TextSize = 12
                                label.Parent = billboard
                                table.insert(State.ESPObjects, billboard)
                            end
                        end
                    end
                end
            end

            if SETTINGS.ESP.VehicleESP then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and (obj:FindFirstChild("VehicleSeat") or obj:FindFirstChild("Boat")) then
                        local primary = obj:FindFirstChild("VehicleSeat") or obj:FindFirstChild("Boat")
                        if primary and primary:IsA("BasePart") then
                            local dist = (RootPart.Position - primary.Position).Magnitude
                            if dist <= SETTINGS.ESP.ESPDistance then
                                createBox3D(obj, Color3.new(0.5, 0.5, 1))
                                local billboard = Instance.new("BillboardGui")
                                billboard.Adornee = primary
                                billboard.Size = UDim2.new(0, 80, 0, 20)
                                billboard.StudsOffset = Vector3.new(0, 2, 0)
                                billboard.AlwaysOnTop = true
                                billboard.Parent = primary
                                local label = Instance.new("TextLabel")
                                label.Size = UDim2.new(1, 0, 1, 0)
                                label.BackgroundTransparency = 1
                                label.Text = "Vehicle [" .. math.floor(dist) .. "m]"
                                label.TextColor3 = Color3.new(0.5, 0.5, 1)
                                label.Font = Enum.Font.SourceSansBold
                                label.TextSize = 12
                                label.Parent = billboard
                                table.insert(State.ESPObjects, billboard)
                            end
                        end
                    end
                end
            end

            if SETTINGS.ESP.ProjectileESP then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Velocity.Magnitude > 100 and obj:IsDescendantOf(Workspace) then
                        local dist = (RootPart.Position - obj.Position).Magnitude
                        if dist <= SETTINGS.ESP.ESPDistance then
                            local pos, onScreen = worldToScreen(obj.Position)
                            if onScreen then
                                createLine2D(Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y), pos, Color3.new(1, 0, 1), 1)
                            end
                        end
                    end
                end
            end

            if SETTINGS.ESP.Radar then
                State.RadarFrame.Visible = true
                for _, dot in ipairs(State.RadarDots) do dot:Destroy() end
                State.RadarDots = {}
                local radarSize = 150
                local scale = 5
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local pos = player.Character.HumanoidRootPart.Position
                        local rel = pos - RootPart.Position
                        local x = rel.X / scale
                        local y = rel.Z / scale
                        local distance = math.sqrt(x*x + y*y)
                        if distance < radarSize/2 then
                            local dot = Instance.new("Frame")
                            dot.Size = UDim2.new(0, 4, 0, 4)
                            dot.Position = UDim2.new(0, radarSize/2 + x - 2, 0, radarSize/2 + y - 2)
                            dot.BackgroundColor3 = Color3.new(1, 0, 0)
                            dot.BorderSizePixel = 0
                            dot.Parent = State.RadarFrame
                            table.insert(State.RadarDots, dot)
                        end
                    end
                end
            else
                State.RadarFrame.Visible = false
            end

            task.wait(0.3)
        end

        for _, obj in ipairs(State.ESPObjects) do
            pcall(function() obj:Destroy() end)
        end
        State.ESPObjects = {}
        State.RadarFrame.Visible = false
        for _, dot in ipairs(State.RadarDots) do dot:Destroy() end
        State.RadarDots = {}
    end)
end

local function createGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RyzenAI_MainGUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    local ToggleButton = Instance.new("ImageButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 55, 0, 55)
    ToggleButton.Position = UDim2.new(1, -65, 0.5, -27)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
    ToggleButton.BackgroundTransparency = 0.1
    ToggleButton.BorderSizePixel = 0
    ToggleButton.AutoButtonColor = false
    ToggleButton.Image = "rbxassetid://7733960231"
    ToggleButton.ImageColor3 = Color3.fromRGB(0, 255, 200)
    ToggleButton.Parent = ScreenGui
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleButton
    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = Color3.fromRGB(0, 255, 200)
    ToggleStroke.Thickness = 2
    ToggleStroke.Parent = ToggleButton

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 420, 0, 560)
    MainFrame.Position = UDim2.new(-0.5, 0, 0.5, -280)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 14)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(0, 255, 200)
    MainStroke.Thickness = 1.5
    MainStroke.Transparency = 0.3
    MainStroke.Parent = MainFrame

    local DropShadow = Instance.new("ImageLabel")
    DropShadow.Name = "Shadow"
    DropShadow.Size = UDim2.new(1, 30, 1, 30)
    DropShadow.Position = UDim2.new(0, -15, 0, -15)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Image = "rbxassetid://5028857084"
    DropShadow.ImageColor3 = Color3.new(0, 0, 0)
    DropShadow.ImageTransparency = 0.6
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(24, 24, 276, 276)
    DropShadow.Parent = MainFrame

    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 14)
    TitleCorner.Parent = TitleBar

    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(0, 200, 1, 0)
    TitleText.Position = UDim2.new(0, 15, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.TextColor3 = Color3.fromRGB(0, 255, 200)
    TitleText.Text = "⚡ RYZEN AI - ALL IN ONE"
    TitleText.Font = Enum.Font.GothamBlack
    TitleText.TextSize = 16
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -35, 0, 6)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Text = "✕"
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    CloseBtn.BorderSizePixel = 0
    CloseBtn.AutoButtonColor = false
    CloseBtn.Parent = TitleBar
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 14)
    CloseCorner.Parent = CloseBtn
    CloseBtn.MouseButton1Click:Connect(function()
        if State.IsMenuOpen then
            State.IsMenuOpen = false
            local targetPos = UDim2.new(-0.5, 0, 0.5, -280)
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = targetPos}):Play()
            task.delay(0.3, function()
                if not State.IsMenuOpen then MainFrame.Visible = false end
            end)
        end
    end)

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(0, 140, 1, -40)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = MainFrame
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 14)
    TabCorner.Parent = TabContainer

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 3)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Parent = TabContainer

    local ContentArea = Instance.new("ScrollingFrame")
    ContentArea.Size = UDim2.new(1, -145, 1, -50)
    ContentArea.Position = UDim2.new(0, 143, 0, 45)
    ContentArea.BackgroundTransparency = 1
    ContentArea.ScrollBarThickness = 3
    ContentArea.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 200)
    ContentArea.Parent = MainFrame

    local TabPages = {}
    local TabButtons = {}
    local tabs = {"Farm", "Combat", "Raid", "Materials", "ESP", "Troll", "FixLag", "Misc"}

    for i, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -8, 0, 30)
        btn.Position = UDim2.new(0, 4, 0, 0)
        btn.BackgroundColor3 = i == 1 and Color3.fromRGB(0, 255, 200, 0.15) or Color3.fromRGB(18, 18, 28)
        btn.TextColor3 = i == 1 and Color3.fromRGB(0, 255, 200) or Color3.new(0.7, 0.7, 0.7)
        btn.Text = "  " .. tabName
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = TabContainer
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        TabButtons[tabName] = btn

        local page = Instance.new("Frame")
        page.Size = UDim2.new(1, -10, 1, 0)
        page.Position = UDim2.new(0, 5, 0, 0)
        page.BackgroundTransparency = 1
        page.Visible = (i == 1)
        page.Parent = ContentArea
        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Padding = UDim.new(0, 5)
        pageLayout.Parent = page
        TabPages[tabName] = page

        btn.MouseButton1Click:Connect(function()
            for _, p in pairs(TabPages) do p.Visible = false end
            page.Visible = true
            for _, b in pairs(TabButtons) do
                b.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
                b.TextColor3 = Color3.new(0.7, 0.7, 0.7)
            end
            btn.BackgroundColor3 = Color3.fromRGB(0, 255, 200, 0.15)
            btn.TextColor3 = Color3.fromRGB(0, 255, 200)
        end)
    end

    local function addSection(parent, text)
        local sectionLabel = Instance.new("TextLabel")
        sectionLabel.Size = UDim2.new(1, 0, 0, 18)
        sectionLabel.BackgroundTransparency = 1
        sectionLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
        sectionLabel.Text = "▸ " .. text
        sectionLabel.Font = Enum.Font.GothamBlack
        sectionLabel.TextSize = 12
        sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        sectionLabel.Parent = parent
    end

    local function addToggle(parent, text, configTable, configKey, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 30)
        container.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
        container.BorderSizePixel = 0
        container.Parent = parent
        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = UDim.new(0, 4)
        containerCorner.Parent = container

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.58, 0, 1, 0)
        label.Position = UDim2.new(0, 8, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(0.9, 0.9, 0.9)
        label.Text = text
        label.Font = Enum.Font.Gotham
        label.TextSize = 10
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container

        local toggleFrame = Instance.new("TextButton")
        toggleFrame.Size = UDim2.new(0, 40, 0, 20)
        toggleFrame.Position = UDim2.new(1, -48, 0.5, -10)
        toggleFrame.BackgroundColor3 = configTable[configKey] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(60, 60, 60)
        toggleFrame.BorderSizePixel = 0
        toggleFrame.Text = ""
        toggleFrame.AutoButtonColor = false
        toggleFrame.Parent = container
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(1, 0)
        toggleCorner.Parent = toggleFrame

        local toggleKnob = Instance.new("Frame")
        toggleKnob.Size = UDim2.new(0, 16, 0, 16)
        toggleKnob.Position = configTable[configKey] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        toggleKnob.BackgroundColor3 = Color3.new(1, 1, 1)
        toggleKnob.BorderSizePixel = 0
        toggleKnob.Parent = toggleFrame
        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = toggleKnob

        local function updateVisual()
            local targetColor = configTable[configKey] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(60, 60, 60)
            local targetPos = configTable[configKey] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            TweenService:Create(toggleFrame, TweenInfo.new(0.15), {BackgroundColor3 = targetColor}):Play()
            TweenService:Create(toggleKnob, TweenInfo.new(0.15), {Position = targetPos}):Play()
        end

        toggleFrame.MouseButton1Click:Connect(function()
            configTable[configKey] = not configTable[configKey]
            updateVisual()
            if callback then callback(configTable[configKey]) end
        end)
    end

    addSection(TabPages["Farm"], "Auto Farm")
    addToggle(TabPages["Farm"], "Auto Farm", SETTINGS.AutoFarm, "Enabled", function(v) if v then startAutoFarm() else if State.AutoFarmThread then task.cancel(State.AutoFarmThread) end end end)
    addToggle(TabPages["Farm"], "Fast Mode", SETTINGS.AutoFarm, "FastMode")
    addToggle(TabPages["Farm"], "Auto Skills", SETTINGS.AutoFarm, "AutoSkills")
    addToggle(TabPages["Farm"], "Collect Drops", SETTINGS.AutoFarm, "CollectDrops")
    addToggle(TabPages["Farm"], "Mob Vacuum", SETTINGS.AutoFarm, "MobVacuum", function(v) startMobVacuum() end)
    addToggle(TabPages["Farm"], "Super Range", SETTINGS.AutoFarm, "SuperRange")
    addSection(TabPages["Farm"], "Quest & Stats")
    addToggle(TabPages["Farm"], "Auto Quest", SETTINGS.Quest, "Enabled", function(v) if v then startQuestSystem() end end)
    addToggle(TabPages["Farm"], "Auto Stats", SETTINGS.AutoStats, "Enabled", function(v) if v then startAutoStats() end end)
    addSection(TabPages["Farm"], "Shop")
    addToggle(TabPages["Farm"], "Auto Sell", SETTINGS.AutoSell, "Enabled", function(v) if v then startAutoSell() else if State.AutoSellThread then task.cancel(State.AutoSellThread) end end end)
    addToggle(TabPages["Farm"], "Auto Buy Swords", SETTINGS.AutoBuy, "Enabled", function(v) if v then startAutoBuy() else if State.AutoBuyThread then task.cancel(State.AutoBuyThread) end end end)
    addToggle(TabPages["Farm"], "Auto Server Hop", SETTINGS.AutoServerHop, "Enabled", function(v) if v then startAutoServerHop() else if State.AutoServerHopThread then task.cancel(State.AutoServerHopThread) end end end)

    addSection(TabPages["Combat"], "Attack")
    addToggle(TabPages["Combat"], "Kill Aura", SETTINGS.Combat, "KillAura", function(v) startKillAura() end)
    addToggle(TabPages["Combat"], "Fast Attack", SETTINGS.Combat, "FastAttack", function(v) startFastAttack() end)
    addToggle(TabPages["Combat"], "Fast Attack 200x", SETTINGS.Combat, "FastAttack200x", function(v) startFastAttack200x() end)
    addToggle(TabPages["Combat"], "Auto Click (5x)", SETTINGS.Combat, "AutoClick", function(v) startAutoClick() end)
    addToggle(TabPages["Combat"], "Auto Combo", SETTINGS.Combat, "AutoCombo", function(v) startCombo() end)
    addToggle(TabPages["Combat"], "Super Range", SETTINGS.Combat, "SuperRange", function(v) startSuperRange() end)
    addSection(TabPages["Combat"], "Defense")
    addToggle(TabPages["Combat"], "Godmode", SETTINGS.Combat, "Godmode")
    addToggle(TabPages["Combat"], "Infinite Energy", SETTINGS.Combat, "InfiniteEnergy")
    addToggle(TabPages["Combat"], "No Stun", SETTINGS.Combat, "NoStun")

    addSection(TabPages["Raid"], "Auto Raid & More")
    addToggle(TabPages["Raid"], "Auto Raid", SETTINGS.AutoRaid, "Enabled", function(v) startAutoRaid() end)
    addToggle(TabPages["Raid"], "Auto Awaken Fruit", SETTINGS.AutoAwaken, "Enabled", function(v) startAutoAwaken() end)
    addToggle(TabPages["Raid"], "Auto Race", SETTINGS.AutoRace, "Enabled", function(v) startAutoRace() end)
    addToggle(TabPages["Raid"], "Auto Haki", SETTINGS.AutoHaki, "Enabled", function(v) startAutoHaki() end)
    addToggle(TabPages["Raid"], "Auto Mastery", SETTINGS.AutoMastery, "Enabled", function(v) startAutoMastery() end)
    addToggle(TabPages["Raid"], "Auto Dungeon", SETTINGS.AutoDungeon, "Enabled", function(v) startAutoDungeon() end)
    addToggle(TabPages["Raid"], "Auto Sea Events", SETTINGS.AutoSeaEvents, "Enabled", function(v) startAutoSeaEvents() end)
    addToggle(TabPages["Raid"], "Auto Elite Hunter", SETTINGS.AutoEliteHunter, "Enabled", function(v) startAutoEliteHunter() end)
    addToggle(TabPages["Raid"], "Auto Factory", SETTINGS.AutoFactory, "Enabled", function(v) startAutoFactory() end)
    addToggle(TabPages["Raid"], "Auto Bounty Hunt", SETTINGS.AutoBountyHunt, "Enabled", function(v) startAutoBountyHunt() end)
    addToggle(TabPages["Raid"], "Fruit Sniper", SETTINGS.FruitSniper, "Enabled", function(v) startFruitSniper() end)
    addToggle(TabPages["Raid"], "Auto Spin", SETTINGS.AutoSpin, "Enabled", function(v) startAutoSpin() end)
    addToggle(TabPages["Raid"], "Auto Buy Fruit", SETTINGS.AutoBuyFruit, "Enabled", function(v) startAutoBuyFruit() end)
    addToggle(TabPages["Raid"], "Auto Puzzle", SETTINGS.AutoPuzzle, "Enabled", function(v) startAutoPuzzle() end)

    addSection(TabPages["Materials"], "Material Farm")
    addToggle(TabPages["Materials"], "Enable Material Farm", SETTINGS.MaterialFarm, "Enabled", function(v) if v then startMaterialFarm() else if State.MaterialFarmThread then task.cancel(State.MaterialFarmThread) end end end)
    local materials = {"Bones", "Ectoplasm", "Fragment", "Candy", "Gems", "Money", "Cocoa", "Cake", "DragonScale", "LeviathanScale", "SeaBeastMeat", "MagmaOre", "IronOre", "CopperOre", "GoldOre", "DiamondOre", "Fish", "Driftwood", "Seashell", "StarPieces"}
    for _, mat in ipairs(materials) do
        addToggle(TabPages["Materials"], mat, SETTINGS.MaterialFarm, mat)
    end

    addSection(TabPages["ESP"], "ESP")
    addToggle(TabPages["ESP"], "Enable ESP", SETTINGS.ESP, "Enabled", function(v) startESP() end)
    addToggle(TabPages["ESP"], "Player ESP", SETTINGS.ESP, "PlayerESP")
    addToggle(TabPages["ESP"], "Enemy ESP", SETTINGS.ESP, "EnemyESP")
    addToggle(TabPages["ESP"], "Fruit ESP", SETTINGS.ESP, "FruitESP")
    addToggle(TabPages["ESP"], "Chest ESP", SETTINGS.ESP, "ChestESP")
    addToggle(TabPages["ESP"], "Item ESP", SETTINGS.ESP, "ItemESP")
    addToggle(TabPages["ESP"], "Vehicle ESP", SETTINGS.ESP, "VehicleESP")
    addToggle(TabPages["ESP"], "Projectile ESP", SETTINGS.ESP, "ProjectileESP")
    addSection(TabPages["ESP"], "ESP Options")
    addToggle(TabPages["ESP"], "Box 3D", SETTINGS.ESP, "Box3D")
    addToggle(TabPages["ESP"], "Skeleton", SETTINGS.ESP, "Skeleton")
    addToggle(TabPages["ESP"], "2D Line", SETTINGS.ESP, "Line2D")
    addToggle(TabPages["ESP"], "Glow", SETTINGS.ESP, "Glow")
    addToggle(TabPages["ESP"], "Chams", SETTINGS.ESP, "Chams")
    addToggle(TabPages["ESP"], "Health Bar", SETTINGS.ESP, "HealthBar")
    addToggle(TabPages["ESP"], "Show Distance", SETTINGS.ESP, "ShowDistance")
    addToggle(TabPages["ESP"], "Show Name", SETTINGS.ESP, "ShowName")
    addToggle(TabPages["ESP"], "Show Weapon", SETTINGS.ESP, "Weapon")
    addToggle(TabPages["ESP"], "View Line", SETTINGS.ESP, "ViewLine")
    addToggle(TabPages["ESP"], "Radar", SETTINGS.ESP, "Radar")

    addSection(TabPages["Troll"], "Troll Features")
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

    addSection(TabPages["Misc"], "Misc")
    addToggle(TabPages["Misc"], "FPS Boost", SETTINGS.Misc, "FPSBoost", function(v) if v then Lighting.GlobalShadows = false; Lighting.FogEnd = 9999; settings().Rendering.QualityLevel = 1 end end)
    addToggle(TabPages["Misc"], "FPS Boost Pro", SETTINGS.FPSBoostPro, "Enabled", function(v) startFPSBoostPro() end)
    addToggle(TabPages["Misc"], "Auto Dress", SETTINGS.AutoDress, "Enabled", function(v) startAutoDress() end)
    addToggle(TabPages["Misc"], "Auto Title", SETTINGS.AutoTitle, "Enabled", function(v) startAutoTitle() end)
    addToggle(TabPages["Misc"], "Auto Chat", SETTINGS.AutoChat, "Enabled", function(v) startAutoChat() end)
    addToggle(TabPages["Misc"], "Auto Hop Regions", SETTINGS.AutoHopRegions, "Enabled", function(v) startAutoHopRegions() end)
    addToggle(TabPages["Misc"], "Discord Webhook", SETTINGS.DiscordWebhook, "Enabled", function(v) startDiscordWebhook() end)

    local function setMenuState(open)
        State.IsMenuOpen = open
        if open then
            MainFrame.Visible = true
            local targetPos = UDim2.new(0.5, -210, 0.5, -280)
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = targetPos}):Play()
        else
            local targetPos = UDim2.new(-0.5, 0, 0.5, -280)
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = targetPos}):Play()
            task.delay(0.3, function()
                if not State.IsMenuOpen then MainFrame.Visible = false end
            end)
        end
    end

    ToggleButton.MouseButton1Click:Connect(function()
        setMenuState(not State.IsMenuOpen)
    end)
end

local function initialize()
    notify("Ryzen AI v5.0", "ALL-IN-ONE Ultimate Script Loaded!", 5)
    createGUI()
    startAutoFarm()
    startMaterialFarm()
    startMobVacuum()
    startSuperRange()
    startKillAura()
    startFastAttack()
    startFastAttack200x()
    startAutoClick()
    startCombo()
    startQuestSystem()
    startAutoStats()
    startCombatUtilities()
    startAutoRaid()
    startAutoAwaken()
    startAutoRace()
    startAutoHaki()
    startAutoMastery()
    startAutoDungeon()
    startAutoSeaEvents()
    startAutoEliteHunter()
    startAutoFactory()
    startAutoBountyHunt()
    startFruitSniper()
    startAutoSpin()
    startAutoBuyFruit()
    startAutoPuzzle()
    startDiscordWebhook()
    startAutoChat()
    startAutoHopRegions()
    startFPSBoostPro()
    startAutoDress()
    startAutoTitle()
    startTrollFeatures()
    startFixLag()
    startAutoSell()
    startAutoBuy()
    startAutoServerHop()
    startESP()

    LocalPlayer.CharacterAdded:Connect(function(newCharacter)
        Character = newCharacter
        Humanoid = Character:WaitForChild("Humanoid")
        RootPart = Character:WaitForChild("HumanoidRootPart")
        task.wait(1)
    end)

    print("[Ryzen AI v5.0] All Systems Online!")
end

initialize()
return true