local Config = {
    ESP = {
        Box = true,
        Skeleton = true,
        Line2D = true,
        Glow = true,
        Chams = true,
        Health = true,
        Distance = true,
        Name = true,
        Weapon = true,
        ViewLine = true,
        Item = true,
        Vehicle = true,
        Radar = true,
        Projectile = true
    },
    AutoFarm = false,
    AutoFarmTarget = "Bandit",
    AutoAttackPlayer = false,
    SpeedHack = false,
    SpeedMultiplier = 5,
    LongRange = false,
    RangeDistance = 100
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "RyzenHack"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 230, 0, 400)
MainFrame.Position = UDim2.new(0, 10, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Selectable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
Title.Text = "RYZEN HACK"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BorderSizePixel = 0

local ScrollingFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollingFrame.Size = UDim2.new(1, 0, 1, -30)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 30)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 700)
ScrollingFrame.ScrollBarThickness = 8

local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function createSection(text)
    local section = Instance.new("Frame", ScrollingFrame)
    section.Size = UDim2.new(1, -20, 0, 30)
    section.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    section.BorderSizePixel = 0
    local label = Instance.new("TextLabel", section)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = text
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    return section
end

local function createToggle(text, callback)
    local toggleFrame = Instance.new("Frame", ScrollingFrame)
    toggleFrame.Size = UDim2.new(1, -20, 0, 35)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggleFrame.BorderSizePixel = 0
    local label = Instance.new("TextLabel", toggleFrame)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Text = text
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    local button = Instance.new("TextButton", toggleFrame)
    button.Size = UDim2.new(0, 50, 1, -5)
    button.Position = UDim2.new(1, -55, 0, 2.5)
    button.Text = "OFF"
    button.Font = Enum.Font.SourceSans
    button.TextSize = 14
    button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BorderSizePixel = 0
    local toggled = false
    button.MouseButton1Click:Connect(function()
        toggled = not toggled
        button.Text = toggled and "ON" or "OFF"
        button.BackgroundColor3 = toggled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        callback(toggled)
    end)
    return toggleFrame
end

local function createButton(text, callback)
    local btnFrame = Instance.new("Frame", ScrollingFrame)
    btnFrame.Size = UDim2.new(1, -20, 0, 35)
    btnFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btnFrame.BorderSizePixel = 0
    local button = Instance.new("TextButton", btnFrame)
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = text
    button.Font = Enum.Font.SourceSans
    button.TextSize = 14
    button.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BorderSizePixel = 0
    button.MouseButton1Click:Connect(callback)
    return btnFrame
end

createSection("ESP GLOBAL")
createToggle("Box", function(v) Config.ESP.Box = v end)
createToggle("Skeleton", function(v) Config.ESP.Skeleton = v end)
createToggle("Line 2D", function(v) Config.ESP.Line2D = v end)
createToggle("Glow", function(v) Config.ESP.Glow = v end)
createToggle("Chams", function(v) Config.ESP.Chams = v end)
createToggle("Health", function(v) Config.ESP.Health = v end)
createToggle("Distance", function(v) Config.ESP.Distance = v end)
createToggle("Name", function(v) Config.ESP.Name = v end)
createToggle("Weapon", function(v) Config.ESP.Weapon = v end)
createToggle("View Line", function(v) Config.ESP.ViewLine = v end)
createToggle("Item/Loot", function(v) Config.ESP.Item = v end)
createToggle("Vehicle", function(v) Config.ESP.Vehicle = v end)
createToggle("Radar", function(v) Config.ESP.Radar = v end)
createToggle("Projectile", function(v) Config.ESP.Projectile = v end)

createSection("AUTO FARM")
createToggle("Auto Farm", function(v) Config.AutoFarm = v end)
createSection("AUTO ATTACK PLAYERS")
createToggle("Auto Attack", function(v) Config.AutoAttackPlayer = v end)
createSection("SPEED HACK")
createToggle("Speed Hack", function(v) Config.SpeedHack = v end)
createSection("LONG RANGE")
createToggle("Long Range (100m)", function(v) Config.LongRange = v end)

createButton("Destroy GUI", function() ScreenGui:Destroy() end)

local function round(num, decimals)
    local mult = 10^(decimals or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function worldToScreen(worldPoint)
    local screenPoint, onScreen = Camera:WorldToScreenPoint(worldPoint)
    return Vector2.new(screenPoint.X, screenPoint.Y), onScreen
end

local function getBoundingBox(character)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return nil end
    local head = character:FindFirstChild("Head")
    if not head then return nil end

    local rootPos = humanoidRootPart.Position
    local min = rootPos - Vector3.new(2, 0, 2)
    local max = rootPos + Vector3.new(2, humanoid.HipHeight + 2, 2)

    local corners = {
        Vector3.new(min.X, min.Y, min.Z),
        Vector3.new(max.X, min.Y, min.Z),
        Vector3.new(max.X, min.Y, max.Z),
        Vector3.new(min.X, min.Y, max.Z),
        Vector3.new(min.X, max.Y, min.Z),
        Vector3.new(max.X, max.Y, min.Z),
        Vector3.new(max.X, max.Y, max.Z),
        Vector3.new(min.X, max.Y, max.Z)
    }
    return corners
end

local function draw3DBox(corners, color)
    local screenPoints = {}
    for _, corner in ipairs(corners) do
        local screen, onScreen = worldToScreen(corner)
        table.insert(screenPoints, {position = screen, visible = onScreen})
    end

    local lines = {
        {1,2},{2,3},{3,4},{4,1},
        {5,6},{6,7},{7,8},{8,5},
        {1,5},{2,6},{3,7},{4,8}
    }
    for _, edge in ipairs(lines) do
        local p1 = screenPoints[edge[1]]
        local p2 = screenPoints[edge[2]]
        if p1.visible and p2.visible then
            local line = Drawing.new("Line")
            line.Visible = true
            line.Color = color
            line.Thickness = 1
            line.From = p1.position
            line.To = p2.position
            task.delay(0.05, function()
                if line then line:Remove() end
            end)
        end
    end
end

local function drawSkeleton(character, color)
    local parts = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"}
    }
    for _, pair in ipairs(parts) do
        local part1 = character:FindFirstChild(pair[1])
        local part2 = character:FindFirstChild(pair[2])
        if part1 and part2 then
            local pos1, on1 = worldToScreen(part1.Position)
            local pos2, on2 = worldToScreen(part2.Position)
            if on1 and on2 then
                local line = Drawing.new("Line")
                line.Visible = true
                line.Color = color
                line.Thickness = 1
                line.From = pos1
                line.To = pos2
                task.delay(0.05, function()
                    if line then line:Remove() end
                end)
            end
        end
    end
end

local function draw2DLine(targetPos, color)
    local screenPos, onScreen = worldToScreen(targetPos)
    if onScreen then
        local line = Drawing.new("Line")
        line.Visible = true
        line.Color = color
        line.Thickness = 1
        line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
        line.To = screenPos
        task.delay(0.05, function()
            if line then line:Remove() end
        end)
    end
end

local GlowCache = {}
local function addGlow(character)
    if not Config.ESP.Glow then return end
    if GlowCache[character] then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPGlow"
    highlight.FillColor = Color3.fromRGB(255,0,0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.new(1,1,1)
    highlight.OutlineTransparency = 0
    highlight.Adornee = character
    highlight.Parent = character
    GlowCache[character] = highlight
end

local function removeGlow(character)
    if GlowCache[character] then
        GlowCache[character]:Destroy()
        GlowCache[character] = nil
    end
end

local ChamsCache = {}
local function addChams(character)
    if not Config.ESP.Chams then return end
    if ChamsCache[character] then return end
    local function processPart(part)
        if part:IsA("BasePart") and not part.Parent:FindFirstChild("Humanoid") then
            pcall(function()
                part.Material = Enum.Material.ForceField
                part.Transparency = 0.4
            end)
        end
    end
    for _, part in ipairs(character:GetDescendants()) do
        processPart(part)
    end
    character.DescendantAdded:Connect(function(part)
        processPart(part)
    end)
    ChamsCache[character] = true
end

local function removeChams(character)
    if ChamsCache[character] then
        ChamsCache[character] = nil
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function()
                    part.Material = Enum.Material.Plastic
                    part.Transparency = 0
                end)
            end
        end
    end
end

local function drawTextESP(character, player)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    if not (humanoid and hrp and head) then return end

    local pos2D, onScreen = worldToScreen(head.Position + Vector3.new(0, 1.5, 0))
    if not onScreen then return end

    local texts = {}
    if Config.ESP.Name then
        table.insert(texts, player.Name)
    end
    if Config.ESP.Health then
        table.insert(texts, "HP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth))
    end
    if Config.ESP.Distance then
        local dist = round((LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude) or 0, 1)
        table.insert(texts, "Dist: " .. dist)
    end
    if Config.ESP.Weapon then
        local tool = nil
        for _, child in ipairs(character:GetChildren()) do
            if child:IsA("Tool") then
                tool = child
                break
            end
        end
        if tool then
            table.insert(texts, "W: " .. tool.Name)
        end
    end

    for i, text in ipairs(texts) do
        local textDrawing = Drawing.new("Text")
        textDrawing.Visible = true
        textDrawing.Text = text
        textDrawing.Size = 14
        textDrawing.Color = Color3.fromRGB(255,255,255)
        textDrawing.Outline = true
        textDrawing.OutlineColor = Color3.new(0,0,0)
        textDrawing.Position = pos2D + Vector2.new(0, 15*(i-1))
        textDrawing.Center = true
        task.delay(0.05, function()
            if textDrawing then textDrawing:Remove() end
        end)
    end
end

local function drawViewLine()
    if not Config.ESP.ViewLine then return end
    local origin = Camera.CFrame.Position
    local direction = Camera.CFrame.LookVector * 9999
    local target = origin + direction
    local screenOrigin, on1 = worldToScreen(origin)
    local screenTarget, on2 = worldToScreen(target)
    if on1 and on2 then
        local line = Drawing.new("Line")
        line.Visible = true
        line.Color = Color3.fromRGB(0,255,0)
        line.Thickness = 1
        line.From = screenOrigin
        line.To = screenTarget
        task.delay(0.05, function()
            if line then line:Remove() end
        end)
    end
end

local function getItemList()
    local items = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("fruit") or name:find("chest") or name:find("item") or name:find("scroll") or name:find("gem") or name:find("boss") then
                local primaryPart = obj:IsA("Model") and obj.PrimaryPart or obj
                if primaryPart and primaryPart:IsA("BasePart") then
                    table.insert(items, {object = obj, position = primaryPart.Position, name = obj.Name})
                end
            end
        end
    end
    return items
end

local function drawItemESP(items)
    if not Config.ESP.Item then return end
    for _, item in ipairs(items) do
        local pos2D, onScreen = worldToScreen(item.position)
        if onScreen then
            local text = Drawing.new("Text")
            text.Visible = true
            text.Text = item.name
            text.Size = 14
            text.Color = Color3.fromRGB(255, 215, 0)
            text.Outline = true
            text.OutlineColor = Color3.new(0,0,0)
            text.Position = pos2D
            text.Center = true
            task.delay(0.05, function()
                if text then text:Remove() end
            end)
            local circle = Drawing.new("Circle")
            circle.Visible = true
            circle.Radius = 4
            circle.Color = Color3.fromRGB(255, 215, 0)
            circle.Position = pos2D
            circle.Filled = true
            task.delay(0.05, function()
                if circle then circle:Remove() end
            end)
        end
    end
end

local function getVehicleList()
    local vehicles = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():find("boat") or obj.Name:lower():find("ship") or obj.Name:lower():find("raft")) then
            local primaryPart = obj.PrimaryPart
            if primaryPart then
                table.insert(vehicles, {object = obj, position = primaryPart.Position, name = obj.Name})
            end
        end
    end
    return vehicles
end

local function drawVehicleESP(vehicles)
    if not Config.ESP.Vehicle then return end
    for _, veh in ipairs(vehicles) do
        local pos2D, onScreen = worldToScreen(veh.position)
        if onScreen then
            local text = Drawing.new("Text")
            text.Visible = true
            text.Text = veh.name
            text.Size = 14
            text.Color = Color3.fromRGB(0, 191, 255)
            text.Outline = true
            text.OutlineColor = Color3.new(0,0,0)
            text.Position = pos2D
            text.Center = true
            task.delay(0.05, function()
                if text then text:Remove() end
            end)
        end
    end
end

local function getProjectileList()
    local projectiles = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("projectile") or obj.Name:lower():find("bullet") or obj.Name:lower():find("slash") or obj.Name:lower():find("ball") or obj.Name:lower():find("bomb") or obj.Name:lower():find("rocket")) then
            table.insert(projectiles, {object = obj, position = obj.Position, name = obj.Name})
        end
    end
    return projectiles
end

local function drawProjectileESP(projectiles)
    if not Config.ESP.Projectile then return end
    for _, proj in ipairs(projectiles) do
        local pos2D, onScreen = worldToScreen(proj.position)
        if onScreen then
            local circle = Drawing.new("Circle")
            circle.Visible = true
            circle.Radius = 3
            circle.Color = Color3.fromRGB(255, 69, 0)
            circle.Position = pos2D
            circle.Filled = true
            task.delay(0.05, function()
                if circle then circle:Remove() end
            end)
        end
    end
end

local function drawRadar()
    if not Config.ESP.Radar then return end
    local radarSize = 200
    local radarPos = Vector2.new(100, 100)
    local radarCenter = radarPos + Vector2.new(radarSize/2, radarSize/2)
    local radarRange = 500

    local bg = Drawing.new("Square")
    bg.Visible = true
    bg.Color = Color3.fromRGB(0,0,0)
    bg.Transparency = 0.7
    bg.Size = Vector2.new(radarSize, radarSize)
    bg.Position = radarPos
    bg.Filled = true
    task.delay(0.05, function()
        if bg then bg:Remove() end
    end)

    local function drawDot(worldPos, color, size)
        local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not localRoot then return end
        local relative = worldPos - localRoot.Position
        local x = relative.X / radarRange * (radarSize/2)
        local y = relative.Z / radarRange * (radarSize/2)
        local dotPos = Vector2.new(radarCenter.X + x, radarCenter.Y + y)
        if math.abs(x) < radarSize/2 and math.abs(y) < radarSize/2 then
            local dot = Drawing.new("Circle")
            dot.Visible = true
            dot.Color = color
            dot.Radius = size
            dot.Position = dotPos
            dot.Filled = true
            task.delay(0.05, function()
                if dot then dot:Remove() end
            end)
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local color = (player.Team and player.Team == LocalPlayer.Team) and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
                drawDot(hrp.Position, color, 4)
            end
        end
    end

    local localPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
    if localPos then
        drawDot(localPos, Color3.fromRGB(255,255,0), 5)
    end
end

local function cleanup()
    for _, highlight in pairs(GlowCache) do
        pcall(function() highlight:Destroy() end)
    end
    GlowCache = {}
    ChamsCache = {}
end

LocalPlayer.CharacterAdded:Connect(function(character)
    cleanup()
end)

local function getCombatRemote()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if remotes then
        local combat = remotes:FindFirstChild("CombatEvent") or remotes:FindFirstChild("DamageEvent") or remotes:FindFirstChild("DealDamage")
        if combat then return combat end
    end
    return nil
end

local function attackTarget(targetCharacter)
    local remote = getCombatRemote()
    if not remote then return end
    local hum = targetCharacter:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    pcall(function()
        remote:FireServer(targetCharacter)
    end)
end

local function getClosestNPC(namePattern)
    local closest = nil
    local minDist = 99999
    local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return nil end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                if not Players:GetPlayerFromCharacter(obj) then
                    if string.find(obj.Name:lower(), namePattern:lower()) then
                        local dist = (localRoot.Position - hrp.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            closest = obj
                        end
                    end
                end
            end
        end
    end
    return closest
end

local function getClosestPlayer()
    local closest = nil
    local minDist = 99999
    local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return nil end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then
                    local dist = (localRoot.Position - hrp.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        closest = char
                    end
                end
            end
        end
    end
    return closest
end

local function teleportTargetToMe(target)
    if not Config.LongRange then return end
    local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot or not target then return end
    local targetRoot = target:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    local originalCFrame = targetRoot.CFrame
    targetRoot.CFrame = localRoot.CFrame * CFrame.new(0, 0, -3)
    task.delay(0.05, function()
        if targetRoot and targetRoot.Parent then
            targetRoot.CFrame = originalCFrame
        end
    end)
end

local function autoFarm()
    if not Config.AutoFarm then return end
    local target = getClosestNPC(Config.AutoFarmTarget)
    if target then
        if Config.LongRange then
            teleportTargetToMe(target)
        end
        local remote = getCombatRemote()
        if remote then
            pcall(function() remote:FireServer(target) end)
        end
    end
end

local function autoAttackPlayer()
    if not Config.AutoAttackPlayer then return end
    local target = getClosestPlayer()
    if target then
        if Config.LongRange then
            teleportTargetToMe(target)
        end
        local remote = getCombatRemote()
        if remote then
            pcall(function() remote:FireServer(target) end)
        end
    end
end

local lastAttackTick = 0
local attackCooldown = 0.1

RunService.RenderStepped:Connect(function(deltaTime)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

    local items = getItemList()
    drawItemESP(items)
    local vehicles = getVehicleList()
    drawVehicleESP(vehicles)
    local projectiles = getProjectileList()
    drawProjectileESP(projectiles)
    if Config.ESP.ViewLine then drawViewLine() end
    if Config.ESP.Radar then drawRadar() end

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local character = player.Character
        if not character then continue end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        local teamCheck = (LocalPlayer.Team and player.Team == LocalPlayer.Team)
        local color = teamCheck and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)

        if Config.ESP.Glow then addGlow(character) else removeGlow(character) end
        if Config.ESP.Chams then addChams(character) else removeChams(character) end

        if Config.ESP.Box then
            local corners = getBoundingBox(character)
            if corners then draw3DBox(corners, color) end
        end
        if Config.ESP.Skeleton then drawSkeleton(character, color) end
        if Config.ESP.Line2D then draw2DLine(hrp.Position, color) end
        drawTextESP(character, player)
    end

    if Config.SpeedHack then
        local now = tick()
        if now - lastAttackTick < (attackCooldown / Config.SpeedMultiplier) then return end
        lastAttackTick = now
    end

    if Config.AutoFarm then autoFarm() end
    if Config.AutoAttackPlayer then autoAttackPlayer() end
end)

cleanup()