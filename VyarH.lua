-- ============================================================
-- VYARH v3.0.0 (UNIVERSAL BASIC MENU)
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

-- Главное окно
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 450)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Colors.Bg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Заголовок
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Colors.Panel
Title.TextColor3 = Colors.Accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Text = "VyarH | Universal"
Title.BorderSizePixel = 0
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

local Close = Instance.new("TextButton", Title)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 7)
Close.BackgroundColor3 = Colors.Element
Close.TextColor3 = Colors.Accent
Close.Font = Enum.Font.GothamBold
Close.TextSize = 16
Close.Text = "X"
Close.BorderSizePixel = 0
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Скролл для кнопок
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Colors.Accent
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Переменные
local speedOn, flyOn, noclipOn, infJumpOn, clickTpOn = false, false, false, false, false
local espOn, godOn = false, false
local speedValue = 32
local flyV, flyG

-- Создание кнопок
local function AddToggle(name, callback)
    local Btn = Instance.new("TextButton", Scroll)
    Btn.Size = UDim2.new(1, -10, 0, 40)
    Btn.BackgroundColor3 = Colors.Element
    Btn.TextColor3 = Colors.TextDim
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 14
    Btn.Text = "  " .. name
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

-- Базовые функции (без ползунков, просто фиксированные значения)
AddToggle("Speed Hack (32)", function(s) 
    speedOn = s 
    if not s and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

AddToggle("Fly (WASD)", function(s)
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

AddToggle("Noclip", function(s) noclipOn = s end)
AddToggle("Infinite Jump", function(s) infJumpOn = s end)
AddToggle("Click TP", function(s) clickTpOn = s end)
AddToggle("God Mode (Local)", function(s) godOn = s end)

AddToggle("Player ESP", function(s)
    espOn = s
    if s then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = Instance.new("Highlight", p.Character)
                h.FillColor = Colors.Accent
                h.OutlineColor = Colors.Text
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                local h = p.Character:FindFirstChildOfClass("Highlight")
                if h then h:Destroy() end
            end
        end
    end
end)

-- Логика
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    if speedOn then
        hum.WalkSpeed = 32
        if hum.MoveDirection.Magnitude > 0 then
            hrp.AssemblyLinearVelocity = Vector3.new(hum.MoveDirection.X * 32, hrp.AssemblyLinearVelocity.Y, hum.MoveDirection.Z * 32)
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
        flyV.Velocity = md * 50
        flyG.CFrame = cam.CFrame
    end
end)

UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if clickTpOn and i.UserInputType == Enum.UserInputType.MouseButton1 then
        local m = LocalPlayer:GetMouse()
        if m.Hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(m.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)

-- Кнопка скрытия меню
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 100, 0, 35)
ToggleBtn.Position = UDim2.new(0, 20, 1, -55)
ToggleBtn.BackgroundColor3 = Colors.Panel
ToggleBtn.TextColor3 = Colors.Accent
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.Text = "VYARH"
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Visible = false
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
        ToggleBtn.Visible = not MainFrame.Visible
    end
end)
ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; ToggleBtn.Visible = false end)

print("VyarH v3.0.0 (Universal) загружено!")
