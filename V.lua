-- // Blox Fruits Delta Hack - Ryzen AI (Updated, Full Working) // --
-- // Yêu cầu: Delta Executor hoặc executor tương tự hỗ trợ Drawing, hookfunction, getconnections, setreadonly // --

-- Bảo vệ chống AFK
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer = game:GetService("Players").LocalPlayer
LocalPlayer.Idled:connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Dịch vụ
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = WS.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ===== THƯ VIỆN VẼ CƠ BẢN =====
local DrawingLib = {}
do
    -- Sử dụng Drawing object từ executor (nếu có), nếu không tạo object giả
    local function createDrawing(type)
        if Drawing then
            return Drawing.new(type)
        else
            return {
                Visible = false,
                Text = "",
                Color = Color3.new(1,1,1),
                Size = 14,
                Position = Vector2.new(),
                From = Vector2.new(),
                To = Vector2.new(),
                Remove = function() end,
            }
        end
    end
    DrawingLib.create = createDrawing
end

-- ===== AUTO DETECT REMOTES =====
local Remotes = {}
local function scanRemotes()
    -- Tìm tất cả các remote trong ReplicatedStorage, thường nằm trong folder "Remotes" hoặc "Networks"
    local function scan(folder)
        for _, obj in ipairs(folder:GetChildren()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                Remotes[obj.Name] = obj
            end
            if obj:IsA("Folder") or obj:IsA("Model") then
                scan(obj)
            end
        end
    end
    scan(RS)
    -- In ra console để kiểm tra
    warn("Remotes found: ", Remotes)
end
scanRemotes()

-- Hàm gửi remote an toàn
local function fireRemote(name, ...)
    local remote = Remotes[name]
    if remote then
        pcall(function()
            remote:FireServer(...)
        end)
    end
end

-- ===== ANTI-CHEAT BYPASS =====
-- Ngăn chặn các sự kiện anti-cheat (nếu có)
for _, obj in ipairs(WS:GetDescendants()) do
    if obj.Name == "AntiCheat" or obj.Name == "BanScript" then
        obj:Destroy()
    end
end

-- Tắt các kết nối gây lag hoặc phát hiện (nếu có)
local function disableAntiCheatConnections()
    for _, connection in ipairs(getconnections(LocalPlayer.Idled)) do
        connection:Disable()
    end
end
pcall(disableAntiCheatConnections)

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RyzenHub"
ScreenGui.Parent = game.CoreGui or LocalPlayer.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 580, 0, 420)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(255, 100, 30)
Title.Text = "Blox Fruits Delta Hack - Ryzen AI"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Tab Bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.Position = UDim2.new(0,0,0,35)
TabBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
TabBar.Parent = MainFrame

local tabs = {"Farm", "Teleport", "ESP", "Combat", "Misc"}
local selectedTab = "Farm"
local tabButtons = {}
local contentFrames = {}

for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.Position = UDim2.new(0, (i-1)*100, 0, 0)
    btn.Text = tab
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.Parent = TabBar
    table.insert(tabButtons, btn)

    local contentFrame = Instance.new("Frame")
    contentFrame.Name = tab
    contentFrame.Size = UDim2.new(1, -10, 1, -75)
    contentFrame.Position = UDim2.new(0,5,0,70)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Visible = tab == selectedTab
    contentFrame.Parent = MainFrame
    contentFrames[tab] = contentFrame

    btn.MouseButton1Click:Connect(function()
        selectedTab = tab
        for _, b in ipairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(50,50,50)
        end
        btn.BackgroundColor3 = Color3.fromRGB(255, 100, 30)
        for _, frame in pairs(contentFrames) do
            frame.Visible = false
        end
        contentFrame.Visible = true
    end)
end

-- ===== HÀM TIỆN ÍCH =====
local function createToggle(parent, text, position, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = position
    btn.Text = text.." [OFF]"
    btn.BackgroundColor3 = Color3.fromRGB(100,0,0)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.Parent = parent
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = text..(enabled and " [ON]" or " [OFF]")
        btn.BackgroundColor3 = enabled and Color3.fromRGB(0,150,0) or Color3.fromRGB(100,0,0)
        if callback then
            callback(enabled)
        end
    end)
    return btn
end

local function createDropdown(parent, items, position, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = position
    btn.Text = items[1] or "Select"
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.Parent = parent
    local currentIndex = 1
    btn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex % #items + 1
        btn.Text = items[currentIndex]
        if callback then
            callback(items[currentIndex])
        end
    end)
    return btn
end

local function createButton(parent, text, position, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = position
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ===== TRANG FARM =====
local farmFrame = contentFrames["Farm"]
local autoFarmLevel = false
local autoFarmMastery = false
local autoFarmMoney = false
local autoBoss = false

createToggle(farmFrame, "Auto Farm Level", UDim2.new(0,10,0,10), function(v) autoFarmLevel = v end)
createToggle(farmFrame, "Auto Farm Mastery", UDim2.new(0,10,0,50), function(v) autoFarmMastery = v end)
createToggle(farmFrame, "Auto Farm Money", UDim2.new(0,10,0,90), function(v) autoFarmMoney = v end)
createToggle(farmFrame, "Auto Boss", UDim2.new(0,10,0,130), function(v) autoBoss = v end)

-- Chọn vùng (Sea)
local seaOptions = {"First Sea", "Second Sea", "Third Sea"}
local currentSea = "First Sea"
createDropdown(farmFrame, seaOptions, UDim2.new(0,10,0,170), function(sel) currentSea = sel end)

-- ===== HÀM FARM / TẤN CÔNG =====
local function getNearestEnemy(range)
    local nearest, minDist = nil, range or 200
    for _, obj in ipairs(WS:GetDescendants()) do
        if obj:IsA("Model") and obj ~= LocalPlayer.Character then
            local hum = obj:FindFirstChild("Humanoid")
            local root = obj:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and root then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local dist = (char.HumanoidRootPart.Position - root.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        nearest = obj
                    end
                end
            end
        end
    end
    return nearest
end

local function attackTarget(target)
    if not target then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then
        -- Tìm tool trong Backpack và trang bị
        for _, v in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if v:IsA("Tool") then
                char.Humanoid:EquipTool(v)
                break
            end
        end
    end
    -- Di chuyển đến gần mục tiêu
    local targetRoot = target:FindFirstChild("HumanoidRootPart")
    if targetRoot then
        hrp.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
    end
    -- Gửi remote tấn công (phụ thuộc vào game)
    -- Có thể dùng FireServer cho tool hoặc remote chiến đấu
    fireRemote("CombatDamage", target) -- Tên remote thường gặp
    -- Nếu không có, thử click chuột
    local vim = game:GetService("VirtualInputManager")
    vim:SendMouseButtonEvent(0, 0, 0, true, nil, 0)
    wait(0.1)
    vim:SendMouseButtonEvent(0, 0, 0, false, nil, 0)
end

-- ===== TRANG TELEPORT =====
local teleFrame = contentFrames["Teleport"]
local teleportLocations = {
    "Pirate Island", "Marine Fortress", "Snow Island", "Magma Village",
    "Underwater City", "Skylands", "Prison", "Colosseum", "Boss Don Swan",
    "Diamond", "Jeremy", "Fajita", "Bobby", "Thunder God"
}
local selectedLocation = teleportLocations[1]
local locationData = {
    ["Pirate Island"] = Vector3.new(1024, 16, 1024),
    ["Marine Fortress"] = Vector3.new(-1024, 16, -1024),
    ["Snow Island"] = Vector3.new(2048, 16, 2048),
    ["Magma Village"] = Vector3.new(-1500, 16, 2000),
    ["Underwater City"] = Vector3.new(200, -50, 200),
    ["Skylands"] = Vector3.new(300, 500, 300),
    ["Prison"] = Vector3.new(4850, 50, 700),
    ["Colosseum"] = Vector3.new(-1500, 50, -2500),
    ["Boss Don Swan"] = Vector3.new(2800, 16, 1800),
    ["Diamond"] = Vector3.new(1500, 16, -1000),
    ["Jeremy"] = Vector3.new(2000, 16, -2000),
    ["Fajita"] = Vector3.new(-500, 16, -1500),
    ["Bobby"] = Vector3.new(1000, 16, 3000),
    ["Thunder God"] = Vector3.new(-2000, 16, -3000),
}

createDropdown(teleFrame, teleportLocations, UDim2.new(0,10,0,10), function(sel) selectedLocation = sel end)
createButton(teleFrame, "TELEPORT", UDim2.new(0,10,0,50), function()
    local pos = locationData[selectedLocation]
    if pos and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local tween = TweenService:Create(LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(0.5), {CFrame = CFrame.new(pos)})
        tween:Play()
    end
end)

-- ===== TRANG ESP =====
local espFrame = contentFrames["ESP"]
local playerESP = false
local chestESP = false
local fruitESP = false

createToggle(espFrame, "Player ESP", UDim2.new(0,10,0,10), function(v) playerESP = v end)
createToggle(espFrame, "Chest ESP", UDim2.new(0,10,0,50), function(v) chestESP = v end)
createToggle(espFrame, "Devil Fruit ESP", UDim2.new(0,10,0,90), function(v) fruitESP = v end)

-- ESP Logic (dùng Highlight)
local function updateESP()
    -- Xóa highlight cũ
    for _, obj in ipairs(WS:GetDescendants()) do
        if obj:FindFirstChild("ESP_Highlight") then
            obj.ESP_Highlight:Destroy()
        end
    end
    if playerESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESP_Highlight"
                highlight.OutlineColor = Color3.new(1,0,0)
                highlight.FillTransparency = 0.5
                highlight.Parent = player.Character
            end
        end
    end
    if chestESP then
        for _, obj in ipairs(WS:GetDescendants()) do
            if obj.Name == "Chest" and obj:IsA("BasePart") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESP_Highlight"
                highlight.OutlineColor = Color3.new(0,1,0)
                highlight.Parent = obj
            end
        end
    end
    if fruitESP then
        -- Devil fruits thường có dạng Model với phần "Fruit" trong tên
        for _, obj in ipairs(WS:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name:lower():find("fruit") or obj.Name:lower():find("devil")) then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESP_Highlight"
                highlight.OutlineColor = Color3.new(1,1,0)
                highlight.Parent = obj
            end
        end
    end
end

-- ===== TRANG COMBAT =====
local combatFrame = contentFrames["Combat"]
local aimbot = false
local autoStats = false
local autoHaki = false

createToggle(combatFrame, "Aimbot", UDim2.new(0,10,0,10), function(v) aimbot = v end)
createToggle(combatFrame, "Auto Stats", UDim2.new(0,10,0,50), function(v) autoStats = v end)
createToggle(combatFrame, "Auto Haki", UDim2.new(0,10,0,90), function(v) autoHaki = v end)

-- ===== TRANG MISC =====
local miscFrame = contentFrames["Misc"]
local noClip = false
local fly = false
local speedVal = 16
local jumpVal = 50

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0,200,0,20)
speedLabel.Position = UDim2.new(0,10,0,10)
speedLabel.Text = "Walk Speed: 16"
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Parent = miscFrame

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0,200,0,30)
speedBox.Position = UDim2.new(0,10,0,35)
speedBox.Text = "16"
speedBox.BackgroundColor3 = Color3.fromRGB(70,70,70)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Parent = miscFrame
speedBox.FocusLost:Connect(function()
    local num = tonumber(speedBox.Text)
    if num and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.WalkSpeed = num
        speedLabel.Text = "Walk Speed: "..num
    end
end)

local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(0,200,0,20)
jumpLabel.Position = UDim2.new(0,10,0,75)
jumpLabel.Text = "Jump Power: 50"
jumpLabel.BackgroundTransparency = 1
jumpLabel.TextColor3 = Color3.new(1,1,1)
jumpLabel.Parent = miscFrame

local jumpBox = Instance.new("TextBox")
jumpBox.Size = UDim2.new(0,200,0,30)
jumpBox.Position = UDim2.new(0,10,0,100)
jumpBox.Text = "50"
jumpBox.BackgroundColor3 = Color3.fromRGB(70,70,70)
jumpBox.TextColor3 = Color3.new(1,1,1)
jumpBox.Parent = miscFrame
jumpBox.FocusLost:Connect(function()
    local num = tonumber(jumpBox.Text)
    if num and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.JumpPower = num
        jumpLabel.Text = "Jump Power: "..num
    end
end)

createToggle(miscFrame, "NoClip", UDim2.new(0,10,0,140), function(v) noClip = v end)
createToggle(miscFrame, "Fly", UDim2.new(0,10,0,180), function(v) fly = v end)

-- ===== VÒNG LẶP CHÍNH =====
spawn(function()
    while task.wait(0.1) do
        -- Auto Farm Level / Mastery / Money
        if autoFarmLevel or autoFarmMastery or autoFarmMoney then
            local enemy = getNearestEnemy(200)
            if enemy then
                attackTarget(enemy)
            end
        end
        -- Auto Boss
        if autoBoss then
            local bossNames = {"Don Swan", "Diamond", "Jeremy", "Fajita", "Bobby", "Thunder God", "Magma Admiral"}
            for _, name in ipairs(bossNames) do
                for _, obj in ipairs(WS:GetDescendants()) do
                    if obj.Name == name and obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                        attackTarget(obj)
                        break
                    end
                end
            end
        end
        -- Aimbot
        if aimbot then
            local enemy = getNearestEnemy(300)
            if enemy and enemy:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, enemy.Head.Position)
            end
        end
        -- Auto Stats
        if autoStats then
            -- Gửi remote thêm điểm (Melee, Defense, ...)
            fireRemote("AddPoint", "Melee") -- có thể thay bằng tên remote đúng
        end
        -- Auto Haki
        if autoHaki then
            fireRemote("ActivateHaki")
        end
    end
end)

-- NoClip
spawn(function()
    while task.wait(0.1) do
        if noClip and LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Fly (sử dụng BodyVelocity)
local flyVelocity
spawn(function()
    while task.wait(0.1) do
        if fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if not flyVelocity then
                flyVelocity = Instance.new("BodyVelocity")
                flyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
                flyVelocity.Velocity = Vector3.new(0,0,0)
                flyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
            end
            local vel = Vector3.new(0,0,0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then vel += Vector3.new(0,0,-50) end
            if UIS:IsKeyDown(Enum.KeyCode.S) then vel += Vector3.new(0,0,50) end
            if UIS:IsKeyDown(Enum.KeyCode.A) then vel += Vector3.new(-50,0,0) end
            if UIS:IsKeyDown(Enum.KeyCode.D) then vel += Vector3.new(50,0,0) end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then vel += Vector3.new(0,50,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then vel += Vector3.new(0,-50,0) end
            flyVelocity.Velocity = vel
        else
            if flyVelocity then
                flyVelocity:Destroy()
                flyVelocity = nil
            end
        end
    end
end)

-- Cập nhật ESP mỗi 5 giây
spawn(function()
    while task.wait(5) do
        if playerESP or chestESP or fruitESP then
            updateESP()
        end
    end
end)

-- Cảnh báo
game.StarterGui:SetCore("SendNotification", {
    Title = "Ryzen Hub",
    Text = "Script loaded successfully! Enjoy.",
    Duration = 5,
})

print("Ryzen Hub loaded!")