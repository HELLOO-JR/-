local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

local SETTINGS = {
    AutoFarm = {Enabled = false, Method = "Quest", Distance = 100, AutoStats = false, Stats = "Melee", AutoSkills = false, CollectDrops = false, AutoSell = false, AutoBuy = false, FastMode = false},
    FruitSniper = {Enabled = false, AutoCollect = false, AutoStore = false, StorePercentage = 80, FruitBlacklist = {"Bomb-Bomb", "Spike-Spike", "Spin-Spin", "Spring-Spring", "Kilo-Kilo", "Smoke-Smoke", "Rocket-Rocket", "Falcon-Falcon", "Chop-Chop"}, AutoServerHop = false, ServerHopDelay = 3, AutoNotifier = false, WebhookURL = ""},
    AutoRaid = {Enabled = false, Type = "Flame", AutoNext = false, AutoBuyChip = false, AutoAwaken = false},
    AutoMastery = {Enabled = false, Weapon = "Current"},
    AutoBoss = {Enabled = false, BossList = {"Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral", "Greybeard", "rip_indra", "Tide Keeper", "Beautiful Pirate", "Longma", "Cursed Captain", "Captain Elephant", "Stone", "Island Empress", "Warden", "Chief Warden", "Magma Admiral", "Fishman Lord", "Vice Admiral", "Ice Admiral", "Tank", "Spy", "Hydra Leader"}, AutoNext = false, AutoReward = false},
    AutoSeaEvents = {Enabled = false, SeaBeast = false, ShipRaid = false, AutoReward = false, AutoSummon = false},
    ESP = {Enabled = false, PlayerESP = false, FruitESP = false, EnemyESP = false, ChestESP = false, ESPDistance = 2000, ShowHealth = false, ShowDistance = false, ShowName = false, Tracers = false, BoxESP = false, Chams = false},
    Teleports = {FastTeleport = true, TweenSpeed = 250, AutoAvoidWater = true, WaterTP = true, SafeMode = false},
    Combat = {Godmode = false, InfiniteEnergy = false, NoStun = false, AutoDodge = false, KillAura = false, KillAuraRange = 30, FastAttack = false, AutoBounty = false, AutoKenHaki = false, AutoBusoHaki = false, AutoSoru = false, AutoObservationV2 = false, AutoFlashStep = false, NoClip = false, HitboxExpander = false, HitboxSize = 15, AutoBlock = false, PerfectBlock = false},
    Movement = {SpeedHack = 0, JumpPower = 0, Fly = false, FlySpeed = 50, Noclip = false, Invisible = false, NoFallDamage = false, AutoSwim = false, InfinityJump = false, AutoDash = false, WalkOnWater = false},
    AutoQuest = {Enabled = false, SkipDialog = false, AutoComplete = false, AutoStart = false},
    AutoStats = {Enabled = false, AutoUpgrade = false, UpgradeOrder = {"Melee", "Defense", "Sword", "Gun", "BloxFruit"}, PointsPerUpgrade = 3},
    AntiAFK = {Enabled = false, Interval = 600},
    AutoRejoin = {Enabled = false, Interval = 1800, AutoRejoinOnKick = false},
    Misc = {AutoHaki = false, AutoRaceV4 = false, MirageFinder = false, ChestFarm = false, FPSBoost = false, WhiteScreen = false, NoFog = false},
    Webhook = {Enabled = false, URL = "", NotifyBoss = false, NotifyFruit = false, NotifyRaid = false, NotifySeaEvent = false, NotifyDeath = false, NotifyLevelUp = false, NotifyBounty = false},
    Performance = {FixLag = false, LowGraphics = false, NoParticles = false, NoShadows = false, NoTextures = false, RenderDistance = 500, DisableAudio = false, ClearWorkspace = false, OptimizeMemory = false, FPSUnlocker = false, MaxFPS = 240, LowQualityTerrain = false, DisableDecals = false, NoWaterReflection = false, NoLighting = false, DisableBloom = false, DisableDepthOfField = false, DisableMotionBlur = false, DisableColorCorrection = false, DisableSunRays = false},
    AutoServerHop = {Enabled = false, MinPlayers = 5, MaxPlayers = 30, HopOnBossSpawn = false, HopOnFruitFound = false, SafeServer = false, HopDelay = 10}
}

local State = {
    IsFarming = false, IsPickingFruit = false, IsRaiding = false, IsBossFarming = false,
    CurrentTarget = nil, CurrentQuest = nil, CollectedFruits = {}, ESPObjects = {},
    LastAttack = 0, LastServerHop = 0, LastRejoin = tick(),
    PerformanceOptimized = false, GUILoaded = false,
    FlyLoop = nil, NoclipLoop = nil, InvisibleLoop = nil, GodmodeLoop = nil,
    InfiniteEnergyLoop = nil, NoStunLoop = nil, KillAuraLoop = nil, FastAttackLoop = nil,
    KenHakiLoop = nil, BusoHakiLoop = nil, SoruLoop = nil
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
    local bosses = {"Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral", "Greybeard", "rip_indra", "Tide Keeper", "Beautiful Pirate", "Longma", "Cursed Captain", "Captain Elephant", "Stone", "Island Empress", "Warden", "Chief Warden", "Magma Admiral", "Fishman Lord", "Vice Admiral", "Ice Admiral", "Tank", "Spy", "Hydra Leader", "Dough King", "Cake Prince", "Leviathan"}
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

local function getNearestFruit()
    local nearest = nil
    local nearestDist = 500
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled then
            local parent = obj.Parent
            if parent and parent:IsA("BasePart") and parent:IsDescendantOf(Workspace) then
                local dist = (RootPart.Position - parent.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = parent
                end
            end
        end
    end
    if not nearest then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("fruit") and not obj.Name:lower():find("tree") and obj:IsDescendantOf(Workspace) then
                local dist = (RootPart.Position - obj.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = obj
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
    if instant or SETTINGS.Teleports.FastTeleport then
        pcall(function()
            RootPart.CFrame = CFrame.new(targetPosition)
        end)
    else
        pcall(function()
            local tween = TweenService:Create(RootPart, TweenInfo.new((RootPart.Position - targetPosition).Magnitude / SETTINGS.Teleports.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPosition)})
            tween:Play()
            tween.Completed:Wait()
        end)
    end
end

local function attackTarget(target)
    if not target then return end
    if not target:FindFirstChild("Humanoid") or target.Humanoid.Health <= 0 then return end
    local hrp = target:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if (RootPart.Position - hrp.Position).Magnitude > 15 then
        teleportTo(hrp.Position, true)
    end
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, "M", false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, "M", false, game)
    end)
    if SETTINGS.AutoFarm.AutoSkills then
        for i = 1, 4 do
            pcall(function()
                local tool = Backpack:FindFirstChildOfClass("Tool") or Character:FindFirstChildOfClass("Tool")
                if tool then
                    Humanoid:EquipTool(tool)
                    tool:Activate()
                    task.wait(0.2)
                end
            end)
        end
    end
    State.LastAttack = tick()
end

local function getFruitName(fruitPart)
    local name = fruitPart.Name
    local parent = fruitPart.Parent
    if parent and parent:IsA("Tool") then name = parent.Name end
    return name
end

local function isFruitOwned(fruitName)
    for _, item in ipairs(Backpack:GetChildren()) do
        if item:IsA("Tool") and (item.Name == fruitName or item.Name:find(fruitName)) then return true end
    end
    for _, fruit in ipairs(State.CollectedFruits) do
        if fruit == fruitName then return true end
    end
    return false
end

local function isFruitBlacklisted(fruitName)
    for _, blacklisted in ipairs(SETTINGS.FruitSniper.FruitBlacklist) do
        if fruitName:find(blacklisted) then return true end
    end
    return false
end

local function serverHop()
    local timeSinceLastHop = tick() - State.LastServerHop
    if timeSinceLastHop < SETTINGS.AutoServerHop.HopDelay then return end
    State.LastServerHop = tick()
    pcall(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
    if syn and syn.teleport then syn.teleport(game.PlaceId) end
    if getgenv().delta_teleport then getgenv().delta_teleport(game.PlaceId) end
end

local function pickFruit(fruitPart)
    if not fruitPart then return false end
    State.IsPickingFruit = true
    local prompt = fruitPart:FindFirstChildOfClass("ProximityPrompt") or (fruitPart.Parent and fruitPart.Parent:FindFirstChildOfClass("ProximityPrompt"))
    if prompt and prompt.Enabled then
        fireproximityprompt(prompt)
        task.wait(0.5)
        State.IsPickingFruit = false
        return true
    else
        pcall(function()
            firetouchinterest(fruitPart, RootPart, 1)
            task.wait(0.1)
            firetouchinterest(fruitPart, RootPart, 0)
        end)
        task.wait(0.5)
        State.IsPickingFruit = false
        return (fruitPart.Parent == nil) or (not fruitPart:IsDescendantOf(Workspace))
    end
end

local function optimizePerformance()
    if not SETTINGS.Performance.FixLag then return end
    if State.PerformanceOptimized then return end
    State.PerformanceOptimized = true
    task.spawn(function()
        pcall(function()
            if SETTINGS.Performance.LowGraphics then
                settings().Rendering.QualityLevel = 1
                settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level1
            end
            if SETTINGS.Performance.FPSUnlocker then
                settings().Rendering.FrameRateManager = Enum.FrameRateManager.Default
                setfpscap(SETTINGS.Performance.MaxFPS)
            end
            if SETTINGS.Performance.DisableAudio then
                SoundService.Volume = 0
            end
            if SETTINGS.Performance.NoShadows then
                Lighting.GlobalShadows = false
                Lighting.ShadowSoftness = 0
            end
            if SETTINGS.Performance.NoLighting then
                Lighting.Brightness = 2
                Lighting.ExposureCompensation = 0
                Lighting.Ambient = Color3.new(1, 1, 1)
                Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            end
            if SETTINGS.Performance.DisableBloom then
                Lighting.Bloom.Intensity = 0
            end
            if SETTINGS.Performance.DisableDepthOfField then
                Lighting.DepthOfField.Enabled = false
            end
            if SETTINGS.Performance.DisableMotionBlur then
                Lighting.MotionBlur.Enabled = false
            end
            if SETTINGS.Performance.DisableColorCorrection then
                Lighting.ColorCorrection.Enabled = false
            end
            if SETTINGS.Performance.DisableSunRays then
                Lighting.SunRays.Enabled = false
            end
            if SETTINGS.Performance.NoWaterReflection then
                pcall(function() game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.Client["WaterReflection"]:Destroy() end)
            end
            if SETTINGS.Performance.LowQualityTerrain then
                Workspace.Terrain.WaterWaveSize = 0
                Workspace.Terrain.WaterWaveSpeed = 0
                Workspace.Terrain.WaterReflectance = 0
                Workspace.Terrain.WaterTransparency = 1
            end
        end)
        task.spawn(function()
            while SETTINGS.Performance.FixLag do
                pcall(function()
                    if SETTINGS.Performance.NoParticles then
                        for _, obj in ipairs(Workspace:GetDescendants()) do
                            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                                obj.Enabled = false
                            end
                        end
                    end
                    if SETTINGS.Performance.NoTextures then
                        for _, obj in ipairs(Workspace:GetDescendants()) do
                            if obj:IsA("Decal") or obj:IsA("Texture") then
                                obj:Destroy()
                            end
                        end
                    end
                    if SETTINGS.Performance.DisableDecals then
                        for _, obj in ipairs(Workspace:GetDescendants()) do
                            if obj:IsA("Decal") then obj:Destroy() end
                        end
                    end
                    if SETTINGS.Performance.ClearWorkspace then
                        for _, obj in ipairs(Workspace:GetDescendants()) do
                            if obj.Name == "Rock" or obj.Name == "Bush" or obj.Name == "Grass" or obj.Name == "Tree" then
                                if obj:IsA("BasePart") and obj.Transparency < 1 then
                                    obj.Transparency = 0.9
                                end
                            end
                        end
                    end
                    if SETTINGS.Performance.RenderDistance > 0 then
                        for _, obj in ipairs(Workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and obj:IsDescendantOf(Workspace) then
                                local dist = (RootPart.Position - obj.Position).Magnitude
                                if dist > SETTINGS.Performance.RenderDistance then
                                    obj.Transparency = 0.95
                                end
                            end
                        end
                    end
                    if SETTINGS.Performance.OptimizeMemory then
                        collectgarbage("collect")
                    end
                end)
                task.wait(30)
            end
        end)
    end)
    notify("Performance Optimizer", "Fix Lag mode activated! FPS boosted.", 5)
end

local function createFuturisticGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RyzenAI_BloxFruits"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(0, 255, 255)
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 0.3
    UIStroke.Parent = MainFrame

    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))}
    Gradient.Rotation = 45
    Gradient.Parent = UIStroke

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 12)
    TopBarCorner.Parent = TopBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.6, 0, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    Title.Text = "⚡ RYZEN AI - BLOX FRUITS"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -40, 0, 7)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Text = "✕"
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    CloseBtn.Parent = TopBar
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 15)
    CloseCorner.Parent = CloseBtn
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Position = UDim2.new(1, -75, 0, 7)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    MinimizeBtn.TextColor3 = Color3.new(1, 1, 1)
    MinimizeBtn.Text = "─"
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 14
    MinimizeBtn.Parent = TopBar
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 15)
    MinCorner.Parent = MinimizeBtn
    local minimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        MainFrame.Size = minimized and UDim2.new(0, 600, 0, 45) or UDim2.new(0, 600, 0, 450)
    end)

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(0, 160, 1, -45)
    TabContainer.Position = UDim2.new(0, 0, 0, 45)
    TabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 2
    TabContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
    TabContainer.Parent = MainFrame
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 12)
    TabCorner.Parent = TabContainer

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 3)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = TabContainer

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, -165, 1, -45)
    ContentFrame.Position = UDim2.new(0, 165, 0, 45)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = MainFrame
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 12)
    ContentCorner.Parent = ContentFrame

    local TabPages = {}
    local TabButtons = {}
    local tabs = {
        {name = "🏠 Home", order = 1},
        {name = "⚔️ Farm", order = 2},
        {name = "🍎 Fruit", order = 3},
        {name = "👹 Raid", order = 4},
        {name = "💀 Combat", order = 5},
        {name = "🏃 Movement", order = 6},
        {name = "👁️ ESP", order = 7},
        {name = "⛵ Sea", order = 8},
        {name = "🎯 Boss", order = 9},
        {name = "🔧 Misc", order = 10},
        {name = "🚀 Performance", order = 11},
        {name = "🌐 Webhook", order = 12},
        {name = "📜 Puzzles", order = 13},
        {name = "🗡️ Swords", order = 14},
        {name = "⚡ Mastery", order = 15},
        {name = "🎪 Events", order = 16},
    }

    for i, tab in ipairs(tabs) do
        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, -10, 1, -10)
        page.Position = UDim2.new(0, 5, 0, 5)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
        page.Visible = (i == 1)
        page.Parent = ContentFrame
        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Padding = UDim.new(0, 4)
        pageLayout.Parent = page
        TabPages[tab.name] = page

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 32)
        btn.Position = UDim2.new(0, 5, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        btn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        btn.Text = tab.name
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = TabContainer
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = Color3.fromRGB(0, 255, 255)
        btnStroke.Thickness = 1
        btnStroke.Transparency = 0.8
        btnStroke.Parent = btn
        TabButtons[tab.name] = btn

        btn.MouseButton1Click:Connect(function()
            for _, p in pairs(TabPages) do p.Visible = false end
            page.Visible = true
            for _, b in pairs(TabButtons) do
                b.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
                b.TextColor3 = Color3.new(0.8, 0.8, 0.8)
                if b:FindFirstChild("UIStroke") then
                    b.UIStroke.Transparency = 0.8
                end
            end
            btn.BackgroundColor3 = Color3.fromRGB(0, 255, 255, 0.1)
            btn.TextColor3 = Color3.fromRGB(0, 255, 255)
            if btn:FindFirstChild("UIStroke") then
                btn.UIStroke.Transparency = 0
            end
        end)
    end

    local function addToggle(parent, text, configTable, configKey, extraCallback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -10, 0, 30)
        container.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
        container.BorderSizePixel = 0
        container.Parent = parent
        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = UDim.new(0, 4)
        containerCorner.Parent = container

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.65, 0, 1, 0)
        label.Position = UDim2.new(0, 8, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(0.85, 0.85, 0.85)
        label.Text = text
        label.Font = Enum.Font.Gotham
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container

        local toggleFrame = Instance.new("TextButton")
        toggleFrame.Size = UDim2.new(0, 44, 0, 20)
        toggleFrame.Position = UDim2.new(1, -54, 0.5, -10)
        toggleFrame.BackgroundColor3 = configTable[configKey] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(50, 50, 50)
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

        local function updateToggle()
            if configTable[configKey] then
                toggleFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
                TweenService:Create(toggleKnob, TweenInfo.new(0.15), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
            else
                toggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                TweenService:Create(toggleKnob, TweenInfo.new(0.15), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
            end
        end

        toggleFrame.MouseButton1Click:Connect(function()
            configTable[configKey] = not configTable[configKey]
            updateToggle()
            if extraCallback then extraCallback(configTable[configKey]) end
        end)
    end

    local function addButton(parent, text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 255, 0.2)
        btn.TextColor3 = Color3.fromRGB(0, 255, 255)
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.Parent = parent
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = btn
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = Color3.fromRGB(0, 255, 255)
        btnStroke.Thickness = 1
        btnStroke.Transparency = 0.5
        btnStroke.Parent = btn
        btn.MouseButton1Click:Connect(function()
            pcall(callback)
        end)
        return btn
    end

    local function addSectionLabel(parent, text)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 0, 22)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(0, 255, 255)
        label.Text = "▸ " .. text
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = parent
    end

    addSectionLabel(TabPages["🏠 Home"], "Welcome to Ryzen AI")
    addSectionLabel(TabPages["🏠 Home"], "All features are OFF by default.")
    addSectionLabel(TabPages["🏠 Home"], "Enable what you need from the tabs.")
    addButton(TabPages["🏠 Home"], "🚀 Optimize Performance", optimizePerformance)
    addButton(TabPages["🏠 Home"], "🔄 Server Hop", serverHop)

    addSectionLabel(TabPages["⚔️ Farm"], "Auto Farm Settings")
    addToggle(TabPages["⚔️ Farm"], "Auto Farm", SETTINGS.AutoFarm, "Enabled")
    addToggle(TabPages["⚔️ Farm"], "Auto Skills", SETTINGS.AutoFarm, "AutoSkills")
    addToggle(TabPages["⚔️ Farm"], "Collect Drops", SETTINGS.AutoFarm, "CollectDrops")
    addToggle(TabPages["⚔️ Farm"], "Auto Stats", SETTINGS.AutoFarm, "AutoStats")
    addToggle(TabPages["⚔️ Farm"], "Fast Mode", SETTINGS.AutoFarm, "FastMode")
    addSectionLabel(TabPages["⚔️ Farm"], "Auto Quest")
    addToggle(TabPages["⚔️ Farm"], "Auto Quest", SETTINGS.AutoQuest, "Enabled")
    addToggle(TabPages["⚔️ Farm"], "Skip Dialog", SETTINGS.AutoQuest, "SkipDialog")

    addSectionLabel(TabPages["🍎 Fruit"], "Fruit Sniper")
    addToggle(TabPages["🍎 Fruit"], "Fruit Sniper", SETTINGS.FruitSniper, "Enabled")
    addToggle(TabPages["🍎 Fruit"], "Auto Collect", SETTINGS.FruitSniper, "AutoCollect")
    addToggle(TabPages["🍎 Fruit"], "Auto Store", SETTINGS.FruitSniper, "AutoStore")
    addToggle(TabPages["🍎 Fruit"], "Auto Server Hop", SETTINGS.FruitSniper, "AutoServerHop")
    addToggle(TabPages["🍎 Fruit"], "Auto Notifier", SETTINGS.FruitSniper, "AutoNotifier")

    addSectionLabel(TabPages["👹 Raid"], "Auto Raid")
    addToggle(TabPages["👹 Raid"], "Auto Raid", SETTINGS.AutoRaid, "Enabled")
    addToggle(TabPages["👹 Raid"], "Auto Next", SETTINGS.AutoRaid, "AutoNext")
    addToggle(TabPages["👹 Raid"], "Auto Buy Chip", SETTINGS.AutoRaid, "AutoBuyChip")
    addToggle(TabPages["👹 Raid"], "Auto Awaken", SETTINGS.AutoRaid, "AutoAwaken")

    addSectionLabel(TabPages["💀 Combat"], "Combat")
    addToggle(TabPages["💀 Combat"], "Godmode", SETTINGS.Combat, "Godmode")
    addToggle(TabPages["💀 Combat"], "Infinite Energy", SETTINGS.Combat, "InfiniteEnergy")
    addToggle(TabPages["💀 Combat"], "No Stun", SETTINGS.Combat, "NoStun")
    addToggle(TabPages["💀 Combat"], "Kill Aura", SETTINGS.Combat, "KillAura")
    addToggle(TabPages["💀 Combat"], "Fast Attack", SETTINGS.Combat, "FastAttack")
    addToggle(TabPages["💀 Combat"], "Auto Block", SETTINGS.Combat, "AutoBlock")
    addToggle(TabPages["💀 Combat"], "Hitbox Expander", SETTINGS.Combat, "HitboxExpander")
    addSectionLabel(TabPages["💀 Combat"], "Haki")
    addToggle(TabPages["💀 Combat"], "Auto Ken Haki", SETTINGS.Combat, "AutoKenHaki")
    addToggle(TabPages["💀 Combat"], "Auto Buso Haki", SETTINGS.Combat, "AutoBusoHaki")
    addToggle(TabPages["💀 Combat"], "Auto Soru", SETTINGS.Combat, "AutoSoru")
    addToggle(TabPages["💀 Combat"], "Auto Observation V2", SETTINGS.Combat, "AutoObservationV2")

    addSectionLabel(TabPages["🏃 Movement"], "Movement")
    addToggle(TabPages["🏃 Movement"], "Fly", SETTINGS.Movement, "Fly")
    addToggle(TabPages["🏃 Movement"], "Noclip", SETTINGS.Movement, "Noclip")
    addToggle(TabPages["🏃 Movement"], "Invisible", SETTINGS.Movement, "Invisible")
    addToggle(TabPages["🏃 Movement"], "No Fall Damage", SETTINGS.Movement, "NoFallDamage")
    addToggle(TabPages["🏃 Movement"], "Infinity Jump", SETTINGS.Movement, "InfinityJump")
    addToggle(TabPages["🏃 Movement"], "Walk On Water", SETTINGS.Movement, "WalkOnWater")

    addSectionLabel(TabPages["👁️ ESP"], "ESP Settings")
    addToggle(TabPages["👁️ ESP"], "ESP Enabled", SETTINGS.ESP, "Enabled")
    addToggle(TabPages["👁️ ESP"], "Player ESP", SETTINGS.ESP, "PlayerESP")
    addToggle(TabPages["👁️ ESP"], "Fruit ESP", SETTINGS.ESP, "FruitESP")
    addToggle(TabPages["👁️ ESP"], "Enemy ESP", SETTINGS.ESP, "EnemyESP")
    addToggle(TabPages["👁️ ESP"], "Chest ESP", SETTINGS.ESP, "ChestESP")
    addToggle(TabPages["👁️ ESP"], "Tracers", SETTINGS.ESP, "Tracers")
    addToggle(TabPages["👁️ ESP"], "Box ESP", SETTINGS.ESP, "BoxESP")

    addSectionLabel(TabPages["⛵ Sea"], "Sea Events")
    addToggle(TabPages["⛵ Sea"], "Auto Sea Events", SETTINGS.AutoSeaEvents, "Enabled")
    addToggle(TabPages["⛵ Sea"], "Sea Beast", SETTINGS.AutoSeaEvents, "SeaBeast")
    addToggle(TabPages["⛵ Sea"], "Ship Raid", SETTINGS.AutoSeaEvents, "ShipRaid")
    addToggle(TabPages["⛵ Sea"], "Auto Reward", SETTINGS.AutoSeaEvents, "AutoReward")

    addSectionLabel(TabPages["🎯 Boss"], "Auto Boss")
    addToggle(TabPages["🎯 Boss"], "Auto Boss", SETTINGS.AutoBoss, "Enabled")
    addToggle(TabPages["🎯 Boss"], "Auto Next", SETTINGS.AutoBoss, "AutoNext")
    addToggle(TabPages["🎯 Boss"], "Auto Reward", SETTINGS.AutoBoss, "AutoReward")

    addSectionLabel(TabPages["🔧 Misc"], "Miscellaneous")
    addToggle(TabPages["🔧 Misc"], "Anti AFK", SETTINGS.AntiAFK, "Enabled")
    addToggle(TabPages["🔧 Misc"], "Auto Rejoin", SETTINGS.AutoRejoin, "Enabled")
    addToggle(TabPages["🔧 Misc"], "Auto Haki", SETTINGS.Misc, "AutoHaki")
    addToggle(TabPages["🔧 Misc"], "FPS Boost", SETTINGS.Misc, "FPSBoost")
    addToggle(TabPages["🔧 Misc"], "No Fog", SETTINGS.Misc, "NoFog")

    addSectionLabel(TabPages["🚀 Performance"], "Fix Lag / FPS Boost")
    addToggle(TabPages["🚀 Performance"], "Fix Lag", SETTINGS.Performance, "FixLag")
    addToggle(TabPages["🚀 Performance"], "Low Graphics", SETTINGS.Performance, "LowGraphics")
    addToggle(TabPages["🚀 Performance"], "No Particles", SETTINGS.Performance, "NoParticles")
    addToggle(TabPages["🚀 Performance"], "No Shadows", SETTINGS.Performance, "NoShadows")
    addToggle(TabPages["🚀 Performance"], "No Textures", SETTINGS.Performance, "NoTextures")
    addToggle(TabPages["🚀 Performance"], "Disable Audio", SETTINGS.Performance, "DisableAudio")
    addToggle(TabPages["🚀 Performance"], "Clear Workspace", SETTINGS.Performance, "ClearWorkspace")
    addToggle(TabPages["🚀 Performance"], "Optimize Memory", SETTINGS.Performance, "OptimizeMemory")
    addToggle(TabPages["🚀 Performance"], "FPS Unlocker", SETTINGS.Performance, "FPSUnlocker")
    addToggle(TabPages["🚀 Performance"], "Low Quality Terrain", SETTINGS.Performance, "LowQualityTerrain")
    addToggle(TabPages["🚀 Performance"], "Disable Decals", SETTINGS.Performance, "DisableDecals")
    addToggle(TabPages["🚀 Performance"], "No Water Reflection", SETTINGS.Performance, "NoWaterReflection")
    addToggle(TabPages["🚀 Performance"], "No Lighting", SETTINGS.Performance, "NoLighting")
    addToggle(TabPages["🚀 Performance"], "Disable Bloom", SETTINGS.Performance, "DisableBloom")
    addToggle(TabPages["🚀 Performance"], "Disable Depth Of Field", SETTINGS.Performance, "DisableDepthOfField")
    addToggle(TabPages["🚀 Performance"], "Disable Motion Blur", SETTINGS.Performance, "DisableMotionBlur")
    addToggle(TabPages["🚀 Performance"], "Disable Color Correction", SETTINGS.Performance, "DisableColorCorrection")
    addToggle(TabPages["🚀 Performance"], "Disable Sun Rays", SETTINGS.Performance, "DisableSunRays")
    addButton(TabPages["🚀 Performance"], "🚀 Apply Fix Lag Now", optimizePerformance)

    addSectionLabel(TabPages["🌐 Webhook"], "Discord Webhook")
    addToggle(TabPages["🌐 Webhook"], "Enable Webhook", SETTINGS.Webhook, "Enabled")
    addToggle(TabPages["🌐 Webhook"], "Notify Boss", SETTINGS.Webhook, "NotifyBoss")
    addToggle(TabPages["🌐 Webhook"], "Notify Fruit", SETTINGS.Webhook, "NotifyFruit")
    addToggle(TabPages["🌐 Webhook"], "Notify Raid", SETTINGS.Webhook, "NotifyRaid")
    addToggle(TabPages["🌐 Webhook"], "Notify Death", SETTINGS.Webhook, "NotifyDeath")

    local firstTab = TabButtons["🏠 Home"]
    if firstTab then
        firstTab.BackgroundColor3 = Color3.fromRGB(0, 255, 255, 0.1)
        firstTab.TextColor3 = Color3.fromRGB(0, 255, 255)
        if firstTab:FindFirstChild("UIStroke") then
            firstTab.UIStroke.Transparency = 0
        end
    end

    State.GUILoaded = true
end

local function autoFarm()
    task.spawn(function()
        while true do
            if not SETTINGS.AutoFarm.Enabled then task.wait(2); continue end
            if not Character or not Character.Parent then
                Character = LocalPlayer.CharacterAdded:Wait()
                Humanoid = Character:WaitForChild("Humanoid")
                RootPart = Character:WaitForChild("HumanoidRootPart")
            end
            if Humanoid.Health <= 0 then task.wait(3); continue end
            local target, _ = getNearestEnemy(SETTINGS.AutoFarm.Distance)
            if target then
                State.IsFarming = true
                State.CurrentTarget = target
                attackTarget(target)
            else
                State.IsFarming = false
                State.CurrentTarget = nil
                task.wait(1)
            end
            if SETTINGS.AutoFarm.FastMode then task.wait(0.1) else task.wait(0.5) end
        end
    end)
end

local function fruitSniper()
    task.spawn(function()
        while true do
            if not SETTINGS.FruitSniper.Enabled then task.wait(3); continue end
            if not Character or not Character.Parent then task.wait(1); continue end
            local fruit, dist = getNearestFruit()
            if fruit and dist <= 500 then
                local fruitName = getFruitName(fruit)
                if isFruitOwned(fruitName) or isFruitBlacklisted(fruitName) then task.wait(1); continue end
                if SETTINGS.FruitSniper.AutoNotifier then notify("Devil Fruit!", fruitName, 3) end
                teleportTo(fruit.Position, true)
                task.wait(0.3)
                if (RootPart.Position - fruit.Position).Magnitude <= 15 then
                    local success = pickFruit(fruit)
                    if success then
                        table.insert(State.CollectedFruits, fruitName)
                        notify("Collected!", fruitName, 2)
                        if SETTINGS.FruitSniper.AutoServerHop then task.wait(SETTINGS.FruitSniper.ServerHopDelay); serverHop(); return end
                    end
                end
            else
                if SETTINGS.FruitSniper.AutoServerHop and tick() - (State.LastFruitFoundTime or 0) > 15 then
                    task.wait(2); serverHop(); return
                end
            end
            task.wait(2)
        end
    end)
end

local function autoBoss()
    task.spawn(function()
        while true do
            if not SETTINGS.AutoBoss.Enabled then task.wait(5); continue end
            local boss, dist = getNearestBoss()
            if boss and dist <= 200 then
                State.IsBossFarming = true
                teleportTo(boss:FindFirstChild("HumanoidRootPart") and boss.HumanoidRootPart.Position)
                task.wait(0.5)
                attackTarget(boss)
            else
                State.IsBossFarming = false
            end
            task.wait(3)
        end
    end)
end

local function combatFeatures()
    task.spawn(function()
        while true do
            if SETTINGS.Combat.Godmode then
                pcall(function() if Humanoid then Humanoid.Health = Humanoid.MaxHealth end end)
            end
            if SETTINGS.Combat.InfiniteEnergy then
                pcall(function() if Character then local e = Character:FindFirstChild("Energy"); if e then e.Value = e.MaxValue end end end)
            end
            if SETTINGS.Combat.NoStun then
                pcall(function() if Humanoid then Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false); Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false) end end)
            end
            if SETTINGS.Combat.KillAura then
                local nearest, dist = getNearestEnemy(SETTINGS.Combat.KillAuraRange)
                if nearest and dist <= SETTINGS.Combat.KillAuraRange then attackTarget(nearest) end
            end
            if SETTINGS.Combat.FastAttack then
                pcall(function() VirtualInputManager:SendKeyEvent(true, "M", false, game); task.wait(0.03); VirtualInputManager:SendKeyEvent(false, "M", false, game) end)
            end
            if SETTINGS.Combat.AutoKenHaki then
                pcall(function() VirtualInputManager:SendKeyEvent(true, "E", false, game); task.wait(0.1); VirtualInputManager:SendKeyEvent(false, "E", false, game) end)
            end
            if SETTINGS.Combat.AutoBusoHaki then
                pcall(function() VirtualInputManager:SendKeyEvent(true, "J", false, game); task.wait(0.1); VirtualInputManager:SendKeyEvent(false, "J", false, game) end)
            end
            if SETTINGS.Combat.AutoSoru then
                pcall(function() VirtualInputManager:SendKeyEvent(true, "Q", false, game); task.wait(0.1); VirtualInputManager:SendKeyEvent(false, "Q", false, game) end)
            end
            task.wait(0.2)
        end
    end)
end

local function movementFeatures()
    task.spawn(function()
        while true do
            if SETTINGS.Movement.SpeedHack > 0 then Humanoid.WalkSpeed = SETTINGS.Movement.SpeedHack end
            if SETTINGS.Movement.JumpPower > 0 then Humanoid.JumpPower = SETTINGS.Movement.JumpPower end
            if SETTINGS.Movement.Fly then
                pcall(function()
                    Humanoid.PlatformStand = true
                    local dir = Vector3.new()
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
                    RootPart.Velocity = dir * SETTINGS.Movement.FlySpeed
                end)
            end
            if SETTINGS.Movement.Noclip then
                pcall(function() for _, p in ipairs(Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end)
            end
            if SETTINGS.Movement.Invisible then
                pcall(function() for _, p in ipairs(Character:GetDescendants()) do if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Transparency = 1 end end end)
            end
            if SETTINGS.Movement.NoFallDamage then
                pcall(function() Humanoid.FallSpeed = 0 end)
            end
            if SETTINGS.Movement.InfinityJump then
                pcall(function() VirtualInputManager:SendKeyEvent(true, "Space", false, game); task.wait(0.05); VirtualInputManager:SendKeyEvent(false, "Space", false, game) end)
            end
            task.wait(0.1)
        end
    end)
end

local function espSystem()
    local function createESP(target, color, name)
        if not target then return end
        local part = target
        if target:IsA("Model") then part = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Head") end
        if not part or not part:IsA("BasePart") then return end
        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = part
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = part
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        frame.Parent = billboard
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0.6, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = color
        label.TextStrokeTransparency = 0
        label.Text = name or target.Name
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.Parent = frame
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, 0, 0.4, 0)
        distLabel.Position = UDim2.new(0, 0, 0.6, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.TextColor3 = Color3.new(1, 1, 1)
        distLabel.TextStrokeTransparency = 0
        distLabel.Text = ""
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextSize = 10
        distLabel.Parent = frame
        table.insert(State.ESPObjects, billboard)
        return billboard, distLabel
    end

    task.spawn(function()
        while true do
            for _, esp in ipairs(State.ESPObjects) do pcall(function() esp:Destroy() end) end
            State.ESPObjects = {}
            if not SETTINGS.ESP.Enabled then task.wait(1); continue end
            if SETTINGS.ESP.PlayerESP then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (RootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if dist <= SETTINGS.ESP.ESPDistance then
                            local info = player.Name .. " [" .. math.floor(dist) .. "m]"
                            if SETTINGS.ESP.ShowHealth and player.Character:FindFirstChild("Humanoid") then info = info .. " | HP: " .. math.floor(player.Character.Humanoid.Health) end
                            createESP(player.Character, Color3.fromRGB(255, 50, 50), info)
                        end
                    end
                end
            end
            if SETTINGS.ESP.FruitESP then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.Enabled and obj.Parent and obj.Parent:IsA("BasePart") then
                        local dist = (RootPart.Position - obj.Parent.Position).Magnitude
                        if dist <= SETTINGS.ESP.ESPDistance then createESP(obj.Parent, Color3.fromRGB(255, 165, 0), "FRUIT [" .. math.floor(dist) .. "m]") end
                    end
                end
            end
            if SETTINGS.ESP.EnemyESP then
                for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        local hrp = enemy:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local dist = (RootPart.Position - hrp.Position).Magnitude
                            if dist <= SETTINGS.ESP.ESPDistance then createESP(enemy, Color3.fromRGB(255, 255, 0), enemy.Name .. " [" .. math.floor(dist) .. "m]") end
                        end
                    end
                end
            end
            if SETTINGS.ESP.ChestESP then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj.Name:lower():find("chest") and obj:IsA("BasePart") then
                        local dist = (RootPart.Position - obj.Position).Magnitude
                        if dist <= SETTINGS.ESP.ESPDistance then createESP(obj, Color3.fromRGB(0, 255, 0), "CHEST [" .. math.floor(dist) .. "m]") end
                    end
                end
            end
            task.wait(1)
        end
    end)
end

local function antiAFK()
    task.spawn(function()
        while true do
            if SETTINGS.AntiAFK.Enabled then
                pcall(function() VirtualInputManager:SendKeyEvent(true, "RightShift", false, game); task.wait(0.1); VirtualInputManager:SendKeyEvent(false, "RightShift", false, game) end)
            end
            task.wait(SETTINGS.AntiAFK.Enabled and SETTINGS.AntiAFK.Interval or 10)
        end
    end)
end

local function autoStats()
    task.spawn(function()
        while true do
            if SETTINGS.AutoStats.Enabled and SETTINGS.AutoStats.AutoUpgrade then
                pcall(function()
                    local args = {[1] = "AddPoint", [2] = SETTINGS.AutoFarm.Stats, [3] = SETTINGS.AutoStats.PointsPerUpgrade}
                    ReplicatedStorage.Remotes.Stat:FireServer(unpack(args))
                end)
            end
            task.wait(2)
        end
    end)
end

local function autoRejoin()
    task.spawn(function()
        while true do
            if SETTINGS.AutoRejoin.Enabled and tick() - State.LastRejoin >= SETTINGS.AutoRejoin.Interval then
                State.LastRejoin = tick()
                pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
            end
            task.wait(60)
        end
    end)
end

local function miscFeatures()
    if SETTINGS.Misc.FPSBoost then
        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9999
            settings().Rendering.QualityLevel = 1
        end)
    end
    if SETTINGS.Misc.NoFog then
        pcall(function()
            Lighting.FogEnd = 99999
            Lighting.FogStart = 99999
        end)
    end
    if SETTINGS.Misc.WhiteScreen then
        pcall(function()
            local screen = Instance.new("ScreenGui"); screen.Name = "WhiteScreen"; screen.Parent = CoreGui
            local frame = Instance.new("Frame"); frame.Size = UDim2.new(1,0,1,0); frame.BackgroundColor3 = Color3.new(1,1,1); frame.Parent = screen
        end)
    end
end

local function initialize()
    print("[Ryzen AI] Blox Fruits Ultimate Script Loading...")
    notify("Ryzen AI", "Blox Fruits Script Loaded! All features OFF.", 5)
    createFuturisticGUI()
    autoFarm()
    fruitSniper()
    autoBoss()
    combatFeatures()
    movementFeatures()
    espSystem()
    antiAFK()
    autoStats()
    autoRejoin()
    miscFeatures()
    LocalPlayer.CharacterAdded:Connect(function(newCharacter)
        Character = newCharacter
        Humanoid = Character:WaitForChild("Humanoid")
        RootPart = Character:WaitForChild("HumanoidRootPart")
        task.wait(1)
    end)
    print("[Ryzen AI] All systems online!")
end

initialize()
return true