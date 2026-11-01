-- ============================================================
-- VYARH v1.3.0 (CLEAN EDITION - NO 3008, NO LAG)
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Очистка старых версий
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
ScreenGui.IgnoreGuiInset = true

-- Главное окно (без лишних обводок)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 500)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Colors.Bg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Colors.Panel
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Colors.Accent
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.Text = "VyarH v1.3.0"
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 10)
CloseBtn.BackgroundColor3 = Colors.Element
CloseBtn.TextColor3 = Colors.Accent
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Text = "X"
CloseBtn.BorderSizePixel = 0
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 55)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 6
Scroll.ScrollBarImageColor3 = Colors.Accent
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Переменные
local speedOn, flyOn, noclipOn, infJumpOn, tpOn = false, false, false, false, false
local aimbotOn, godOn, espOn, spinOn = false, false, false, false
local spd, flySpd = 32, 50
local flyV, flyG
local HLs = {}

-- Кнопки-переключатели
local function CreateToggle(text, callback)
    local Btn = Instance.new("TextButton", Scroll)
    Btn.Size = UDim2.new(1, -10, 0, 40)
    Btn.BackgroundColor3 = Colors.Element
    Btn.TextColor3 = Colors.TextDim
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 14
    Btn.Text = text
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.TextColor3 = state and Colors.Text or Colors.TextDim
        Btn.BackgroundColor3 = state and Colors.Accent or Colors.Element
        if state then Btn.TextColor3 = Colors.Bg end
        callback(state)
    end)
end

-- Ползунки
local function CreateSlider(text, min, max, def, callback)
    local F = Instance.new("Frame", Scroll)
    F.Size = UDim2.new(1, -10, 0, 50)
    F.BackgroundColor3 = Colors.Element
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -10, 0, 20)
    L.Position = UDim2.new(0, 5, 0, 5)
    L.BackgroundTransparency = 1
    L.TextColor3 = Colors.Text
    L.Text = text .. ": " .. def
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
            L.Text = text .. ": " .. val
            callback(val)
        end
    end)
end

-- ==================== ФУНКЦИИ ====================
CreateToggle("Speed Hack", function(s) speedOn = s end)
CreateSlider("Speed Value", 16, 200, 32, function(v) spd = v end)
CreateToggle("Fly (WASD)", function(s) 
    flyOn = s 
    if s and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
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
CreateToggle("Noclip", function(s) noclipOn = s end)
CreateToggle("Infinite Jump", function(s) infJumpOn = s end)
CreateToggle("Click TP", function(s) tpOn = s end)
CreateToggle("Aimbot (RMB)", function(s) aimbotOn = s end)
CreateToggle("Spinbot", function(s) spinOn = s end)
CreateToggle("God Mode", function(s) godOn = s end)
CreateToggle("Player ESP", function(s) 
    espOn = s 
    if s then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = Instance.new("Highlight", p.Character)
                h.FillColor = Colors.Accent
                HLs[p] = h
            end
        end
    else
        for _, h in pairs(HLs) do h:Destroy() end
        HLs = {}
    end
end)

-- ==================== ЛОГИКА ====================
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
        for _, v in pairs(char:GetDescendants()) do 
            if v:IsA("BasePart") then v.CanCollide = false end 
        end
    end

    if godOn then hum.Health = 100 end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.RenderStepped:Connect(function()
    if flyOn and flyV and flyG and LocalPlayer.Character then
        local md = Vector3.zero
        local cam = workspace.CurrentCamera
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then md = md + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then md = md - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then md = md - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then md = md + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then md = md + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then md = md - Vector3.new(0,1,0) end
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

-- Скрытие меню
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

print("VyarH v1.3.0 (Clean) загружено!")
