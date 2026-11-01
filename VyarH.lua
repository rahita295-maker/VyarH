-- ============================================================
-- VYARH v2.0.0 (NEON BLUE EDITION)
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Очистка старых версий
for _, gui in pairs(game.CoreGui:GetChildren()) do
    if gui.Name == "VyarHMenu" then gui:Destroy() end
end

-- Палитра (Неоновый синий)
local Colors = {
    Bg = Color3.fromRGB(12, 12, 14),
    Panel = Color3.fromRGB(20, 20, 25),
    Element = Color3.fromRGB(30, 30, 38),
    Accent = Color3.fromRGB(0, 170, 255), -- Неоновый синий
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(140, 140, 150)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VyarHMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui
ScreenGui.IgnoreGuiInset = true

-- Круг FOV
local FOVCircle = Instance.new("Frame", ScreenGui)
FOVCircle.Size = UDim2.new(0, 300, 0, 300)
FOVCircle.Position = UDim2.new(0.5, -150, 0.5, -150)
FOVCircle.BackgroundTransparency = 1
FOVCircle.BorderSizePixel = 1
FOVCircle.BorderColor3 = Colors.Accent
FOVCircle.Visible = false
Instance.new("UICorner", FOVCircle).CornerRadius = UDim.new(1, 0)

-- Главное окно
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 450)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Colors.Bg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- Неоновая обводка
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Colors.Accent
UIStroke.Thickness = 1
UIStroke.Transparency = 0.3

-- Заголовок
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Colors.Panel
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)
local HeaderFix = Instance.new("Frame", Header)
HeaderFix.Size = UDim2.new(1, 0, 0, 20)
HeaderFix.Position = UDim2.new(0, 0, 1, -20)
HeaderFix.BackgroundColor3 = Colors.Panel
HeaderFix.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Colors.Accent
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.Text = "VyarH | v2.0.0"
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
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

-- Контейнер вкладок (слева)
local TabPanel = Instance.new("Frame", MainFrame)
TabPanel.Size = UDim2.new(0, 110, 1, -60)
TabPanel.Position = UDim2.new(0, 10, 0, 55)
TabPanel.BackgroundColor3 = Colors.Panel
TabPanel.BorderSizePixel = 0
Instance.new("UICorner", TabPanel).CornerRadius = UDim.new(0, 8)

local TabList = Instance.new("UIListLayout", TabPanel)
TabList.Padding = UDim.new(0, 5)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Контейнер контента (справа)
local ContentPanel = Instance.new("Frame", MainFrame)
ContentPanel.Size = UDim2.new(1, -130, 1, -60)
ContentPanel.Position = UDim2.new(0, 120, 0, 55)
ContentPanel.BackgroundTransparency = 1

local Scroll = Instance.new("ScrollingFrame", ContentPanel)
Scroll.Size = UDim2.new(1, 0, 1, 0)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Colors.Accent
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Переменные
local Pages = {Main = {}, Combat = {}, Visuals = {}}
local speedOn, flyOn, noclipOn, infJumpOn, tpOn = false, false, false, false, false
local aimbotOn, godOn, espOn, spinOn = false, false, false, false
local spd, flySpd, aimSmooth, aimFOV = 32, 50, 0.3, 300
local flyV, flyG
local HLs = {}

-- Создание вкладок
local function CreateTab(name)
    local Btn = Instance.new("TextButton", TabPanel)
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.BackgroundColor3 = Colors.Element
    Btn.TextColor3 = Colors.TextDim
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 13
    Btn.Text = name
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    Btn.MouseButton1Click:Connect(function()
        for _, b in pairs(TabPanel:GetChildren()) do
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Element, TextColor3 = Colors.TextDim}):Play()
            end
        end
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent, TextColor3 = Colors.Bg}):Play()
        
        for n, buttons in pairs(Pages) do
            for _, btn in pairs(buttons) do
                btn.Visible = (n == name)
            end
        end
    end)
    
    if name == "Main" then
        Btn.BackgroundColor3 = Colors.Accent
        Btn.TextColor3 = Colors.Bg
    end
    return name
end

-- Toggle (Переключатель)
local function CreateToggle(name, text, callback)
    local Btn = Instance.new("TextButton", Scroll)
    Btn.Size = UDim2.new(1, -10, 0, 45)
    Btn.BackgroundColor3 = Colors.Element
    Btn.TextColor3 = Colors.TextDim
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 13
    Btn.Text = "  " .. text
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    local Switch = Instance.new("Frame", Btn)
    Switch.Size = UDim2.new(0, 40, 0, 20)
    Switch.Position = UDim2.new(1, -50, 0.5, -10)
    Switch.BackgroundColor3 = Colors.Bg
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Dot = Instance.new("Frame", Switch)
    Dot.Size = UDim2.new(0, 16, 0, 16)
    Dot.Position = UDim2.new(0, 2, 0.5, -8)
    Dot.BackgroundColor3 = Colors.TextDim
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            TweenService:Create(Btn, TweenInfo.new(0.2), {TextColor3 = Colors.Text}):Play()
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = Colors.Bg}):Play()
        else
            TweenService:Create(Btn, TweenInfo.new(0.2), {TextColor3 = Colors.TextDim}):Play()
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Bg}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Colors.TextDim}):Play()
        end
        callback(state)
    end)
    table.insert(Pages[name], Btn)
end

-- Slider (Ползунок)
local function CreateSlider(tab, text, min, max, def, callback)
    local F = Instance.new("Frame", Scroll)
    F.Size = UDim2.new(1, -10, 0, 55)
    F.BackgroundColor3 = Colors.Element
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -10, 0, 20)
    L.Position = UDim2.new(0, 5, 0, 5)
    L.BackgroundTransparency = 1
    L.TextColor3 = Colors.Text
    L.Font = Enum.Font.GothamMedium
    L.TextSize = 12
    L.Text = text .. ": " .. def
    L.TextXAlignment = Enum.TextXAlignment.Left

    local Bar = Instance.new("Frame", F)
    Bar.Size = UDim2.new(1, -20, 0, 5)
    Bar.Position = UDim2.new(0, 10, 0, 35)
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
    table.insert(Pages[tab], F)
end

-- ==================== ФУНКЦИИ ====================
CreateTab("Main")
CreateTab("Combat")
CreateTab("Visuals")

-- Main
CreateToggle("Main", "Speed Hack", function(s) speedOn = s end)
CreateSlider("Main", "Speed Value", 16, 200, 32, function(v) spd = v end)
CreateToggle("Main", "Fly (WASD)", function(s) 
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
CreateSlider("Main", "Fly Speed", 10, 200, 50, function(v) flySpd = v end)
CreateToggle("Main", "Noclip", function(s) noclipOn = s end)
CreateToggle("Main", "Infinite Jump", function(s) infJumpOn = s end)
CreateToggle("Main", "Click TP", function(s) tpOn = s end)

-- Combat
CreateToggle("Combat", "Aimbot (RMB)", function(s) aimbotOn = s end)
CreateSlider("Combat", "Aimbot Smoothness", 1, 100, 30, function(v) aimSmooth = v / 100 end)
CreateSlider("Combat", "Aimbot FOV", 50, 800, 300, function(v) aimFOV = v; FOVCircle.Size = UDim2.new(0, v, 0, v); FOVCircle.Position = UDim2.new(0.5, -v/2, 0.5, -v/2) end)
CreateToggle("Combat", "Spinbot", function(s) spinOn = s end)
CreateToggle("Combat", "God Mode", function(s) godOn = s end)

-- Visuals
CreateToggle("Visuals", "Player ESP", function(s) 
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
        local closest, dist = nil, aimFOV
        local myChar = LocalPlayer.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local d = (p.Character.Head.Position - myChar.HumanoidRootPart.Position).Magnitude
                    if d < dist then dist = d; closest = p.Character.Head end
                end
            end
            if closest then 
                workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(workspace.CurrentCamera.CFrame.Position, closest.Position), aimSmooth) 
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
toggleBtn.Size = UDim2.new(0, 120, 0, 35)
toggleBtn.Position = UDim2.new(0, 20, 1, -55)
toggleBtn.BackgroundColor3 = Colors.Panel
toggleBtn.TextColor3 = Colors.Accent
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.Text = "VYARH | v2.0.0"
toggleBtn.BorderSizePixel = 0
toggleBtn.Visible = false
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
        toggleBtn.Visible = not MainFrame.Visible
    end
end)
toggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; toggleBtn.Visible = false end)

print("VyarH v2.0.0 (Neon Blue) успешно загружено!")
