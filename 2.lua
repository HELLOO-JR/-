
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

-- Bảo vệ chống AFK kick
local function antiAFK()
    local vu = VirtualUser
    LocalPlayer.Idled:connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end
antiAFK()

-- ==================== THƯ VIỆN DRAWING ====================
local Drawing = {}
if type(Drawing) ~= "table" or not Drawing.Fonts then -- nếu drawing library chưa có sẵn
    local function getDrawing()
        return {
            new = function(self, type)
                local obj = {
                    Type = type,
                    Visible = false,
                    Text = "",
                    Color = Color3.new(1,1,1),
                    Size = 14,
                    Position = Vector2.new(0,0),
                    From = Vector2.new(0,0),
                    To = Vector2.new(0,0),
                }
                function obj:Remove()
                    self = nil
                end
                return obj
            end
        }
    end
    Drawing = getDrawing()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaBloxFruits"
ScreenGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
TitleBar.BorderSizePixel = 0
TitleBar.Text = "Blox Fruits Delta Hack - Ryzen AI"
TitleBar.TextColor3 = Color3.new(1,1,1)
TitleBar.Font = Enum.Font.SourceSansBold
TitleBar.TextSize = 18
TitleBar.Parent = MainFrame

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 30)
TabContainer.Position = UDim2.new(0,0,0,40)
TabContainer.BackgroundColor3 = Color3.fromRGB(50,50,50)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local tabs = {"Farm", "Teleport", "ESP", "Combat", "Misc"}
local activeTab = "Farm"
local tabButtons = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.Position = UDim2.new(0, (i-1)*100, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.BorderSizePixel = 0
    btn.Text = tabName
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.Parent = TabContainer
    table.insert(tabButtons, btn)

    btn.MouseButton1Click:Connect(function()
        activeTab = tabName
       
        for _, frame in ipairs(ContentArea:GetChildren()) do
            frame.Visible = false
        end
        if ContentArea:FindFirstChild(tabName) then
            ContentArea[tabName].Visible = true
        end
        
        for _, b in ipairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(70,70,70)
        end
        btn.BackgroundColor3 = Color3.fromRGB(255,100,0)
    end)
end

tabButtons[1].BackgroundColor3 = Color3.fromRGB(255,100,0)

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, 0, 1, -70)
ContentArea.Position = UDim2.new(0,0,0,70)
ContentArea.BackgroundColor3 = Color3.fromRGB(40,40,40)
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainFrame

local FarmFrame = Instance.new("Frame")
FarmFrame.Name = "Farm"
FarmFrame.Size = UDim2.new(1,0,1,0)
FarmFrame.BackgroundTransparency = 1
FarmFrame.Parent = ContentArea
FarmFrame.Visible = true

local autoFarmToggle = Instance.new("TextButton")
autoFarmToggle.Size = UDim2.new(0,200,0,30)
autoFarmToggle.Position = UDim2.new(0,10,0,10)
autoFarmToggle.Text = "Auto Farm Level [OFF]"
autoFarmToggle.BackgroundColor3 = Color3.fromRGB(100,0,0)
autoFarmToggle.TextColor3 = Color3.new(1,1,1)
autoFarmToggle.Font = Enum.Font.SourceSans
autoFarmToggle.Parent = FarmFrame
local autoFarmEnabled = false
autoFarmToggle.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    autoFarmToggle.Text = autoFarmEnabled and "Auto Farm Level [ON]" or "Auto Farm Level [OFF]"
    autoFarmToggle.BackgroundColor3 = autoFarmEnabled and Color3.fromRGB(0,150,0) or Color3.fromRGB(100,0,0)
end)

-- Auto Mastery
local autoMasteryToggle = Instance.new("TextButton")
autoMasteryToggle.Size = UDim2.new(0,200,0,30)
autoMasteryToggle.Position = UDim2.new(0,10,0,50)
autoMasteryToggle.Text = "Auto Farm Mastery [OFF]"
autoMasteryToggle.BackgroundColor3 = Color3.fromRGB(100,0,0)
autoMasteryToggle.TextColor3 = Color3.new(1,1,1)
autoMasteryToggle.Font = Enum.Font.SourceSans
autoMasteryToggle.Parent = FarmFrame
local autoMasteryEnabled = false
autoMasteryToggle.MouseButton1Click:Connect(function()
    autoMasteryEnabled = not autoMasteryEnabled
    autoMasteryToggle.Text = autoMasteryEnabled and "Auto Farm Mastery [ON]" or "Auto Farm Mastery [OFF]"
    autoMasteryToggle.BackgroundColor3 = autoMasteryEnabled and Color3.fromRGB(0,150,0) or Color3.fromRGB(100,0,0)
end)

-- Auto Money
local autoMoneyToggle = Instance.new("TextButton")
autoMoneyToggle.Size = UDim2.new(0,200,0,30)
autoMoneyToggle.Position = UDim2.new(0,10,0,90)
autoMoneyToggle.Text = "Auto Farm Money [OFF]"
autoMoneyToggle.BackgroundColor3 = Color3.fromRGB(100,0,0)
autoMoneyToggle.TextColor3 = Color3.new(1,1,1)
autoMoneyToggle.Font = Enum.Font.SourceSans
autoMoneyToggle.Parent = FarmFrame
local autoMoneyEnabled = false
autoMoneyToggle.MouseButton1Click:Connect(function()
    autoMoneyEnabled = not autoMoneyEnabled
    autoMoneyToggle.Text = autoMoneyEnabled and "Auto Farm Money [ON]" or "Auto Farm Money [OFF]"
    autoMoneyToggle.BackgroundColor3 = autoMoneyEnabled and Color3.fromRGB(0,150,0) or Color3.fromRGB(100,0,0)
end)

-- Teleport to Sea
local seaDropdownLabel = Instance.new("TextLabel")
seaDropdownLabel.Size = UDim2.new(0,200,0,20)
seaDropdownLabel.Position = UDim2.new(0,10,0,140)
seaDropdownLabel.Text = "Select Sea:"
seaDropdownLabel.BackgroundTransparency = 1
seaDropdownLabel.TextColor3 = Color3.new(1,1,1)
seaDropdownLabel.Font = Enum.Font.SourceSans
seaDropdownLabel.Parent = FarmFrame

local seaDropdown = Instance.new("TextButton")
seaDropdown.Size = UDim2.new(0,200,0,30)
seaDropdown.Position = UDim2.new(0,10,0,160)
seaDropdown.Text = "First Sea"
seaDropdown.BackgroundColor3 = Color3.fromRGB(70,70,70)
seaDropdown.TextColor3 = Color3.new(1,1,1)
seaDropdown.Font = Enum.Font.SourceSans
seaDropdown.Parent = FarmFrame
local currentSea = 1
seaDropdown.MouseButton1Click:Connect(function()
    currentSea = currentSea % 3 + 1
    local seaNames = {"First Sea", "Second Sea", "Third Sea"}
    seaDropdown.Text = seaNames[currentSea]
end)

-- Auto Boss
local autoBossToggle = Instance.new("TextButton")
autoBossToggle.Size = UDim2.new(0,200,0,30)
autoBossToggle.Position = UDim2.new(0,10,0,200)
autoBossToggle.Text = "Auto Boss [OFF]"
autoBossToggle.BackgroundColor3 = Color3.fromRGB(100,0,0)
autoBossToggle.TextColor3 = Color3.new(1,1,1)
autoBossToggle.Font = Enum.Font.SourceSans
autoBossToggle.Parent = FarmFrame
local autoBossEnabled = false
autoBossToggle.MouseButton1Click:Connect(function()
    autoBossEnabled = not autoBossEnabled
    autoBossToggle.Text = autoBossEnabled and "Auto Boss [ON]" or "Auto Boss [OFF]"
    autoBossToggle.BackgroundColor3 = autoBossEnabled and Color3.fromRGB(0,150,0) or Color3.fromRGB(100,0,0)
end)

-- TELEPORT TAB
local TeleFrame = Instance.new("Frame")
TeleFrame.Name = "Teleport"
TeleFrame.Size = UDim2.new(1,0,1,0)
TeleFrame.BackgroundTransparency = 1
TeleFrame.Parent = ContentArea
TeleFrame.Visible = false

local teleportList = {"Pirate Island", "Marine Fortress", "Snow Island", "Magma Village", "Underwater City", "Skylands", "Prison", "Colosseum", "Magma Admiral", "Boss Don Swan", "Diamond", "Jeremy", "Fajita", "Bobby", "Thunder God"}
local teleportDropdown = Instance.new("TextButton")
teleportDropdown.Size = UDim2.new(0,200,0,30)
teleportDropdown.Position = UDim2.new(0,10,0,10)
teleportDropdown.Text = "Select Location"
teleportDropdown.BackgroundColor3 = Color3.fromRGB(70,70,70)
teleportDropdown.TextColor3 = Color3.new(1,1,1)
teleportDropdown.Font = Enum.Font.SourceSans
teleportDropdown.Parent = TeleFrame
local currentTeleportIndex = 1
teleportDropdown.MouseButton1Click:Connect(function()
    currentTeleportIndex = currentTeleportIndex % #teleportList + 1
    teleportDropdown.Text = teleportList[currentTeleportIndex]
end)

local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0,200,0,30)
teleportButton.Position = UDim2.new(0,10,0,50)
teleportButton.Text = "TELEPORT"
teleportButton.BackgroundColor3 = Color3.fromRGB(0,100,255)
teleportButton.TextColor3 = Color3.new(1,1,1)
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.Parent = TeleFrame

-- ESP TAB
local ESPFrame = Instance.new("Frame")
ESPFrame.Name = "ESP"
ESPFrame.Size = UDim2.new(1,0,1,0)
ESPFrame.BackgroundTransparency = 1
ESPFrame.Parent = ContentArea
ESPFrame.Visible = false

local playerESPToggle = Instance.new("TextButton")
playerESPToggle.Size = UDim2.new(0,200,0,30)
playerESPToggle.Position = UDim2.new(0,10,0,10)
playerESPToggle.Text = "Player ESP [OFF]"
playerESPToggle.BackgroundColor3 = Color3.fromRGB(100,0,0)
playerESPToggle.TextColor3 = Color3.new(1,1,1)
playerESPToggle.Font = Enum.Font.SourceSans
playerESPToggle.Parent = ESPFrame
local playerESPEnabled = false
playerESPToggle.MouseButton1Click:Connect(function()
    playerESPEnabled = not playerESPEnabled
    playerESPToggle.Text = playerESPEnabled and "Player ESP [ON]" or "Player ESP [OFF]"
    playerESPToggle.BackgroundColor3 = playerESPEnabled and Color3.fromRGB(0,150,0) or Color3.fromRGB(100,0,0)
end)

local chestESPToggle = Instance.new("TextButton")
chestESPToggle.Size = UDim2.new(0,200,0,30)
chestESPToggle.Position = UDim2.new(0,10,0,50)
chestESPToggle.Text = "Chest ESP [OFF]"
chestESPToggle.BackgroundColor3 = Color3.fromRGB(100,0,0)
chestESPToggle.TextColor3 = Color3.new(1,1,1)
chestESPToggle.Font = Enum.Font.SourceSans
chestESPToggle.Parent = ESPFrame
local chestESPEnabled = false
chestESPToggle.MouseButton1Click:Connect(function()
    chestESPEnabled = not chestESPEnabled
    chestESPToggle.Text = chestESPEnabled and "Chest ESP [ON]" or "Chest ESP [OFF]"
    chestESPToggle.BackgroundColor3 = chestESPEnabled and Color3.fromRGB(0,150,0) or Color3.fromRGB(100,0,0)
end)

local devilFruitESPToggle = Instance.new("TextButton")
devilFruitESPToggle.Size = UDim2.new(0,200,0,30)
devilFruitESPToggle.Position = UDim2.new(0,10,0,90)
devilFruitESPToggle.Text = "Devil Fruit ESP [OFF]"
devilFruitESPToggle.BackgroundColor3 = Color3.fromRGB(100,0,0)
devilFruitESPToggle.TextColor3 = Color3.new(1,1,1)
devilFruitESPToggle.Font = Enum.Font.SourceSans
devilFruitESPToggle.Parent = ESPFrame
local devilFruitESPEnabled = false
devilFruitESPToggle.MouseButton1Click:Connect(function()
    devilFruitESPEnabled = not devilFruitESPEnabled
    devilFruitESPToggle.Text = devilFruitESPEnabled and "Devil Fruit ESP [ON]" or "Devil Fruit ESP [OFF]"
    devilFruitESPToggle.BackgroundColor3 = devilFruitESPEnabled and Color3.fromRGB(0,150,0) or Color3.fromRGB(100,0,0)
end)

-- COMBAT TAB
local CombatFrame = Instance.new("Frame")
CombatFrame.Name = "Combat"
CombatFrame.Size = UDim2.new(1,0,1,0)
CombatFrame.BackgroundTransparency = 1
CombatFrame.Parent = ContentArea
CombatFrame.Visible = false

local aimbotToggle = Instance.new("TextButton")
aimbotToggle.Size = UDim2.new(0,200,0,30)
aimbotToggle.Position = UDim2.new(0,10,0,10)
aimbotToggle.Text = "Aimbot [OFF]"
aimbotToggle.BackgroundColor3 = Color3.fromRGB(100,0,0)
aimbotToggle.TextColor3 = Color3.new(1,1,1)
aimbotToggle.Font = Enum.Font.SourceSans
aimbotToggle.Parent = CombatFrame
local aimbotEnabled = false
aimbotToggle.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    aimbotToggle.Text = aimbotEnabled and "Aimbot [ON]" or "Aimbot [OFF]"
    aimbotToggle.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0,150,0) or Color3.fromRGB(100,0,0)
end)

local autoStatsToggle = Instance.new("TextButton")
autoStatsToggle.Size = UDim2.new(0,200,0,30)
autoStatsToggle.Position = UDim2.new(0,10,0,50)
autoStatsToggle.Text = "Auto Stats [OFF]"
autoStatsToggle.BackgroundColor3 = Color3.fromRGB(100,0,0)
autoStatsToggle.TextColor3 = Color3.new(1,1,1)
autoStatsToggle.Font = Enum.Font.SourceSans
autoStatsToggle.Parent = CombatFrame
local autoStatsEnabled = false
autoStatsToggle.MouseButton1Click:Connect(function()
    autoStatsEnabled = not autoStatsEnabled
    autoStatsToggle.Text = autoStatsEnabled and "Auto Stats [ON]" or "Auto Stats [OFF]"
    autoStatsToggle.BackgroundColor3 = autoStatsEnabled and Color3.fromRGB(0,150,0) or Color3.fromRGB(100,0,0)
end)

local autoHakiToggle = Instance.new("TextButton")
autoHakiToggle.Size = UDim2.new(0,200,0,30)
autoHakiToggle.Position = UDim2.new(0,10,0,90)
autoHakiToggle.Text = "Auto Haki [OFF]"
autoHakiToggle.BackgroundColor3 = Color3.fromRGB(100,0,0)
autoHakiToggle.TextColor3 = Color3.new(1,1,1)
autoHakiToggle.Font = Enum.Font.SourceSans
autoHakiToggle.Parent = CombatFrame
local autoHakiEnabled = false
autoHakiToggle.MouseButton1Click:Connect(function()
    autoHakiEnabled = not autoHakiEnabled
    autoHakiToggle.Text = autoHakiEnabled and "Auto Haki [ON]" or "Auto Haki [OFF]"
    autoHakiToggle.BackgroundColor3 = autoHakiEnabled and Color3.fromRGB(0,150,0) or Color3.fromRGB(100,0,0)
end)

-- MISC TAB
local MiscFrame = Instance.new("Frame")
MiscFrame.Name = "Misc"
MiscFrame.Size = UDim2.new(1,0,1,0)
MiscFrame.BackgroundTransparency = 1
MiscFrame.Parent = ContentArea
MiscFrame.Visible = false

local walkSpeedSliderLabel = Instance.new("TextLabel")
walkSpeedSliderLabel.Size = UDim2.new(0,200,0,20)
walkSpeedSliderLabel.Position = UDim2.new(0,10,0,10)
walkSpeedSliderLabel.Text = "Walk Speed: 16"
walkSpeedSliderLabel.BackgroundTransparency = 1
walkSpeedSliderLabel.TextColor3 = Color3.new(1,1,1)
walkSpeedSliderLabel.Font = Enum.Font.SourceSans
walkSpeedSliderLabel.Parent = MiscFrame

local walkSpeedSlider = Instance.new("TextBox")
walkSpeedSlider.Size = UDim2.new(0,200,0,30)
walkSpeedSlider.Position = UDim2.new(0,10,0,35)
walkSpeedSlider.Text = "16"
walkSpeedSlider.BackgroundColor3 = Color3.fromRGB(70,70,70)
walkSpeedSlider.TextColor3 = Color3.new(1,1,1)
walkSpeedSlider.Font = Enum.Font.SourceSans
walkSpeedSlider.Parent = MiscFrame
walkSpeedSlider.FocusLost:Connect(function(enterPressed)
    local num = tonumber(walkSpeedSlider.Text)
    if num then
        LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = num
        walkSpeedSliderLabel.Text = "Walk Speed: "..num
    end
end)

local jumpPowerSliderLabel = Instance.new("TextLabel")
jumpPowerSliderLabel.Size = UDim2.new(0,200,0,20)
jumpPowerSliderLabel.Position = UDim2.new(0,10,0,75)
jumpPowerSliderLabel.Text = "Jump Power: 50"
jumpPowerSliderLabel.BackgroundTransparency = 1
jumpPowerSliderLabel.TextColor3 = Color3.new(1,1,1)
jumpPowerSliderLabel.Font = Enum.Font.SourceSans
jumpPowerSliderLabel.Parent = MiscFrame

local jumpPowerSlider = Instance.new("TextBox")
jumpPowerSlider.Size = UDim2.new(0,200,0,30)
jumpPowerSlider.Position = UDim2.new(0,10,0,100)
jumpPowerSlider.Text = "50"
jumpPowerSlider.BackgroundColor3 = Color3.fromRGB(70,70,70)
jumpPowerSlider.TextColor3 = Color3.new(1,1,1)
jumpPowerSlider.Font = Enum.Font.SourceSans
jumpPowerSlider.Parent = MiscFrame
jumpPowerSlider.FocusLost:Connect(function(enterPressed)
    local num = tonumber(jumpPowerSlider.Text)
    if num then
        LocalPlayer.Character:WaitForChild("Humanoid").JumpPower = num
        jumpPowerSliderLabel.Text = "Jump Power: "..num
    end
end)

local noClipToggle = Instance.new("TextButton")
noClipToggle.Size = UDim2.new(0,200,0,30)
noClipToggle.Position = UDim2.new(0,10,0,140)
noClipToggle.Text = "NoClip [OFF]"
noClipToggle.BackgroundColor3 = Color3.fromRGB(100,0,0)
noClipToggle.TextColor3 = Color3.new(1,1,1)
noClipToggle.Font = Enum.Font.SourceSans
noClipToggle.Parent = MiscFrame
local noClipEnabled = false
noClipToggle.MouseButton1Click:Connect(function()
    noClipEnabled = not noClipEnabled
    noClipToggle.Text = noClipEnabled and "NoClip [ON]" or "NoClip [OFF]"
    noClipToggle.BackgroundColor3 = noClipEnabled and Color3.fromRGB(0,150,0) or Color3.fromRGB(100,0,0)
end)

local flyToggle = Instance.new("TextButton")
flyToggle.Size = UDim2.new(0,200,0,30)
flyToggle.Position = UDim2.new(0,10,0,180)
flyToggle.Text = "Fly [OFF]"
flyToggle.BackgroundColor3 = Color3.fromRGB(100,0,0)
flyToggle.TextColor3 = Color3.new(1,1,1)
flyToggle.Font = Enum.Font.SourceSans
flyToggle.Parent = MiscFrame
local flyEnabled = false
flyToggle.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    flyToggle.Text = flyEnabled and "Fly [ON]" or "Fly [OFF]"
    flyToggle.BackgroundColor3 = flyEnabled and Color3.fromRGB(0,150,0) or Color3.fromRGB(100,0,0)
end)

-- ==================== LOGIC CHỨC NĂNG ====================

-- Hàm lấy NPC gần nhất
local function getClosestNPC(range)
    local closest = nil
    local shortestDistance = range or 200
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") and obj ~= LocalPlayer.Character then
            local npcHumanoid = obj.Humanoid
            if npcHumanoid.Health > 0 and obj:FindFirstChild("HumanoidRootPart") then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closest = obj
                end
            end
        end
    end
    return closest
end

-- Hàm tấn công NPC
local function attackNPC(target)
    if target and target:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
        -- Sử dụng vũ khí hoặc kỹ năng, giả sử có tool
        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                LocalPlayer.Character.Humanoid:EquipTool(tool)
                break
            end
        end
        -- Click để tấn công
        local args = {
            [1] = target,
            [2] = target:FindFirstChild("HumanoidRootPart").Position,
        }
        -- Gửi sự kiện tấn công, có thể cần tùy chỉnh theo game
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CombatDamage"):FireServer(unpack(args))
        end)
    end
end

-- Hàm dịch chuyển đến vị trí (teleport)
local function teleportTo(position)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local char = LocalPlayer.Character
        local hrp = char.HumanoidRootPart
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(position)})
        tween:Play()
    end
end

-- Hàm lấy vị trí theo tên địa điểm
local function getLocationPosition(name)
    local locations = {
        ["Pirate Island"] = Vector3.new(1024, 16, 1024),
        ["Marine Fortress"] = Vector3.new(-1024, 16, -1024),
        ["Snow Island"] = Vector3.new(2048, 16, 2048),
        ["Magma Village"] = Vector3.new(-1500, 16, 2000),
        ["Underwater City"] = Vector3.new(200, -50, 200),
        ["Skylands"] = Vector3.new(300, 500, 300),
        ["Prison"] = Vector3.new(4850, 50, 700),
        ["Colosseum"] = Vector3.new(-1500, 50, -2500),
        ["Magma Admiral"] = Vector3.new(-2000, 16, 3000),
        ["Boss Don Swan"] = Vector3.new(2800, 16, 1800),
        ["Diamond"] = Vector3.new(1500, 16, -1000),
        ["Jeremy"] = Vector3.new(2000, 16, -2000),
        ["Fajita"] = Vector3.new(-500, 16, -1500),
        ["Bobby"] = Vector3.new(1000, 16, 3000),
        ["Thunder God"] = Vector3.new(-2000, 16, -3000),
    }
    return locations[name] or Vector3.new(0, 16, 0)
end

teleportButton.MouseButton1Click:Connect(function()
    local pos = getLocationPosition(teleportDropdown.Text)
    teleportTo(pos)
end)

-- ESP Logic
local espConnections = {}
local function updateESP()
    -- Clear old ESP
    for _, conn in ipairs(espConnections) do
        conn:Disconnect()
    end
    espConnections = {}
    if playerESPEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local conn = RunService.RenderStepped:Connect(function()
                    if player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("HumanoidRootPart") then
                        local headPos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
                        if onScreen then
                            -- Sử dụng Drawing để vẽ (đơn giản hóa)
                            -- Thực tế cần thư viện Drawing, nhưng ở đây ta dùng highlight tạm
                            if not player.Character.Head:FindFirstChild("ESPHighlight") then
                                local highlight = Instance.new("Highlight")
                                highlight.Name = "ESPHighlight"
                                highlight.OutlineColor = Color3.new(1,0,0)
                                highlight.FillColor = Color3.new(1,0,0)
                                highlight.FillTransparency = 0.5
                                highlight.Parent = player.Character
                            end
                        end
                    end
                end)
                table.insert(espConnections, conn)
            end
        end
    end
    if chestESPEnabled then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name == "Chest" and obj:IsA("BasePart") then
                local conn = RunService.RenderStepped:Connect(function()
                    local pos, onScreen = Camera:WorldToViewportPoint(obj.Position)
                    if onScreen then
                        -- highlight chest
                        if not obj:FindFirstChild("ESPHighlight") then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "ESPHighlight"
                            highlight.OutlineColor = Color3.new(0,1,0)
                            highlight.Parent = obj
                        end
                    end
                end)
                table.insert(espConnections, conn)
            end
        end
    end
end

-- Auto farm loop
spawn(function()
    while wait(1) do
        if autoFarmEnabled then
            local target = getClosestNPC(100)
            if target then
                attackNPC(target)
            end
        end
        if autoMasteryEnabled then
            -- Tương tự như auto farm nhưng có thể ưu tiên quái theo vùng
            local target = getClosestNPC(100)
            if target then
                attackNPC(target)
            end
        end
        if autoMoneyEnabled then
            -- Giả sử farm money bằng cách đánh boss hoặc quái đặc biệt
            local target = getClosestNPC(200) -- tìm boss
            if target then
                attackNPC(target)
            end
        end
        if autoBossEnabled then
            -- Tìm boss gần nhất, có thể xác định bằng tên
            local bosses = {"Don Swan", "Diamond", "Jeremy", "Fajita", "Bobby", "Thunder God", "Magma Admiral"}
            for _, bossName in ipairs(bosses) do
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj.Name == bossName and obj:FindFirstChild("HumanoidRootPart") then
                        attackNPC(obj)
                        break
                    end
                end
            end
        end
        if aimbotEnabled then
            -- Aimbot đơn giản: tự động khóa mục tiêu gần nhất
            local target = getClosestNPC(300)
            if target then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Head.Position)
            end
        end
        if autoStatsEnabled then
            -- Tự động phân phối điểm (Melee, Defense, Sword, Gun, Devil Fruit)
            -- Gửi remote để tăng stats
            pcall(function()
                local statsRemote = ReplicatedStorage.Remotes:FindFirstChild("AddPoint")
                if statsRemote then
                    statsRemote:FireServer("Melee") -- hoặc lựa chọn ngẫu nhiên
                end
            end)
        end
        if autoHakiEnabled then
            -- Kích hoạt Haki (Busoshoku)
            pcall(function()
                local hakiRemote = ReplicatedStorage.Remotes:FindFirstChild("ActivateHaki")
                if hakiRemote then
                    hakiRemote:FireServer()
                end
            end)
        end
    end
end)

-- NoClip và Fly xử lý
local noClipConnection
RunService.Stepped:Connect(function()
    if noClipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

local flyKeys = {}
local function flyControl(input, processed)
    if not flyEnabled then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        flyKeys[input.KeyCode] = input.UserInputState == Enum.UserInputState.Begin
    end
end
UserInputService.InputBegan:Connect(flyControl)
UserInputService.InputEnded:Connect(function(input)
    flyKeys[input.KeyCode] = false
end)

RunService.RenderStepped:Connect(function()
    if flyEnabled and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local speed = 50
            local move = Vector3.new(0,0,0)
            if flyKeys[Enum.KeyCode.W] then move = move + Vector3.new(0,0,-1) end
            if flyKeys[Enum.KeyCode.S] then move = move + Vector3.new(0,0,1) end
            if flyKeys[Enum.KeyCode.A] then move = move + Vector3.new(-1,0,0) end
            if flyKeys[Enum.KeyCode.D] then move = move + Vector3.new(1,0,0) end
            if flyKeys[Enum.KeyCode.Space] then move = move + Vector3.new(0,1,0) end
            if flyKeys[Enum.KeyCode.LeftControl] then move = move + Vector3.new(0,-1,0) end
            if move.Magnitude > 0 then
                hrp.Velocity = move.Unit * speed
            else
                hrp.Velocity = Vector3.new(0,0,0)
            end
        end
    end
end)

-- Cập nhật ESP định kỳ
spawn(function()
    while wait(5) do
        updateESP()
    end
end)

-- Thông báo đã load
StarterGui:SetCore("SendNotification", {
    Title = "Blox Fruits Delta Hack",
    Text = "Script loaded! Made by Ryzen AI.",
    Duration = 5,
})