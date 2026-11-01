-- ============================================================
-- VYARH v1.2.3 (ULTRA LIGHTWEIGHT)
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

for _, gui in pairs(game.CoreGui:GetChildren()) do
    if gui.Name == "VyarHMenu" then gui:Destroy() end
end

local Colors = {
    Bg = Color3.fromRGB(15, 15, 15),
    Panel = Color3.fromRGB(22, 22, 22),
    Element = Color3.fromRGB(32, 32, 32),
    Accent = Color3.fromRGB(255, 115, 0),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(160, 160, 160)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VyarHMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 500)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Colors.Bg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Colors.Panel
Title.TextColor3 = Colors.Accent
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.Text = "VyarH v1.2.3"
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

local Close = Instance.new("TextButton", MainFrame)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -40, 0, 10)
Close.BackgroundColor3 = Colors.Element
Close.TextColor3 = Colors.Accent
Close.Font = Enum.Font.GothamBold
Close.TextSize = 18
Close.Text = "X"
Close.BorderSizePixel = 0
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -70)
Scroll.Position = UDim2.new(0, 10, 0, 60)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 6
Scroll.ScrollBarImageColor3 = Colors.Accent
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ПЕРЕМЕННЫЕ
local speedOn, flyOn, noclipOn, infJumpOn, tpOn = false, false, false, false, false
local aimbotOn, godOn, espOn, spinOn, hitboxOn = false, false, false, false, false
local h3008, e3008, esp3008, loot3008 = false, false, false, false
local fovOn, trailOn = false, false

local spd, flySpd = 32, 50
local flyV, flyG
local HLs = {}

local function CreateToggle(name, text, callback)
    local Btn = Instance.new("TextButton", Scroll)
    Btn.Size = UDim2.new(1, -10, 0, 40)
    Btn.BackgroundColor3 = Colors.Element
    Btn.TextColor3 = Colors.TextDim
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 13
    Btn.Text = " " .. text
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIPadding", Btn).PaddingLeft = UDim.new(0, 10)

    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.TextColor3 = state and Colors.Text or Colors.TextDim
        Btn.BackgroundColor3 = state and Colors.Accent or Colors.Element
        if state then Btn.TextColor3 = Colors.Bg end
        callback(state)
    end)
end

local function CreateSlider(name, min, max, def, callback)
    local F = Instance.new("Frame", Scroll)
    F.Size = UDim2.new(1, -10, 0, 50)
    F.BackgroundColor3 = Colors.Element
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -10, 0, 20)
    L.Position = UDim2.new(0, 5, 0, 5)
    L.BackgroundTransparency = 1
    L.TextColor3 = Colors.Text
    L.Text = name .. ": " .. def
    L.TextXAlignment = Enum.TextXAlignment.Left

    local Bar = Instance.new("Frame", F)
    Bar.Size = UDim2.new(1, -20, 0, 5)
    Bar.Position = UDim2.new(0, 10, 0, 30)
    Bar.BackgroundColor3 = Colors.Bg
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((def - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Colors.Accent
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local dragging = false
    Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(i) 
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((i.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * pos + 0.5)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            L.Text = name .. ": " .. val
            callback(val)
        end
    end)
end

-- MAIN
CreateToggle("", "Stealth Bypass", function(s) end)
CreateToggle("", "Click TP", function(s) tpOn = s end)
CreateToggle("", "Speed Hack", function(s) speedOn = s end)
CreateSlider("Speed Value", 16, 200, 32, function(v) spd = v end)
CreateToggle("", "Fly (WASD)", function(s) 
    flyOn = s 
    if s then
        flyV = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
        flyV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyG = Instance.new("BodyGyro", LocalPlayer.Character.HumanoidRootPart)
        flyG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    else
        if flyV then flyV:Destroy() end
        if flyG then flyG:Destroy() end
    end
end)
CreateSlider("Fly Speed", 10, 200, 50, function(v) flySpd = v end)
CreateToggle("", "Noclip", function(s) noclipOn = s end)
CreateToggle("", "Infinite Jump", function(s) infJumpOn = s end)

-- COMBAT
CreateToggle("", "Aimbot (RMB)", function(s) aimbotOn = s end)
CreateToggle("", "Spinbot", function(s) spinOn = s end)
CreateToggle("", "Hitbox Expander", function(s) hitboxOn = s end)
CreateToggle("", "God Mode", function(s) godOn = s end)

-- VISUALS
CreateToggle("", "Particle Trails", function(s) trailOn = s end)

-- 3008
CreateToggle("", "3008: Infinite Hunger", function(s) h3008 = s end)
CreateToggle("", "3008: Infinite Energy", function(s) e3008 = s end)
CreateToggle("", "3008: Employee ESP", function(s) esp3008 = s end)
CreateToggle("", "3008: Auto Loot", function(s) loot3008 = s end)

-- ЛОГИКА
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    if speedOn then
        hum.WalkSpeed = spd
        if hum.MoveDirection.Magnitude > 0 then
            hrp.AssemblyLinearVelocity = Vector3.new(hum.MoveDirection.X * spd, hrp.AssemblyLinearVelocity.Y, hum.MoveDirection.Z * spd)
        end
    end

    if noclipOn then
        for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end

    if godOn then hum.Health = 100 end

    if hitboxOn then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(10,10,10)
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.RenderStepped:Connect(function()
    if flyOn and flyV and flyG then
        local md = Vector3.zero
        local cam = workspace.CurrentCamera
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then md = md + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then md = md - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then md = md - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then md = md + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then md = md + Vector3.new(0,1,0) end
        flyV.Velocity = md * flySpd
        flyG.CFrame = cam.CFrame
    end
    
    if spinOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(90), 0)
    end

    if aimbotOn and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local closest, dist = nil, 300
        local myChar = LocalPlayer.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local d = (p.Character.Head.Position - myChar.HumanoidRootPart.Position).Magnitude
                    if d < dist then dist = d; closest = p.Character.Head end
                end
            end
            if closest then 
                workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(workspace.CurrentCamera.CFrame.Position, closest.Position), 0.3) 
            end
        end
    end
end)

UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if tpOn and i.UserInputType == Enum.UserInputType.MouseButton1 then
        local m = LocalPlayer:GetMouse()
        if m.Hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(m.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)

-- 3008 Logic
task.spawn(function()
    while task.wait(2) do
        if h3008 or e3008 then
            local char = LocalPlayer.Character
            if char then
                for _, obj in pairs(char:GetDescendants()) do
                    if h3008 and (obj.Name:lower():find("hunger") or obj.Name:lower():find("food")) and obj:IsA("NumberValue") then obj.Value = 100 end
                    if e3008 and (obj.Name:lower():find("energy") or obj.Name:lower():find("stamina")) and obj:IsA("NumberValue") then obj.Value = 100 end
                end
            end
        end
        if esp3008 then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= LocalPlayer.Character then
                    if not Players:GetPlayerFromCharacter(v) and not v:FindFirstChild("VyarHEmp") then
                        local h = Instance.new("Highlight", v)
                        h.Name = "VyarHEmp"
                        h.FillColor = Color3.fromRGB(255, 0, 0)
                    end
                end
            end
        else
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") then local h = v:FindFirstChild("VyarHEmp"); if h then h:Destroy() end end
            end
        end
    end
end)

local toggleBtn = Instance.new("TextButton", ScreenGui)
toggleBtn.Size = UDim2.new(0, 100, 0, 30)
toggleBtn.Position = UDim2.new(0, 20, 1, -50)
toggleBtn.BackgroundColor3 = Colors.Panel
toggleBtn.TextColor3 = Colors.Accent
toggleBtn.Text = "VYARH"
toggleBtn.Visible = false
toggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; toggleBtn.Visible = false end)

UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
        toggleBtn.Visible = not MainFrame.Visible
    end
end)

print("VyarH v1.2.3 (Lightweight) Загружен!")
