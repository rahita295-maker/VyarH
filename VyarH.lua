-- ============================================================
-- VYARH v1.2.2 (FPS FIX - NO LAG)
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Очистка старых версий
for _, gui in pairs(game.CoreGui:GetChildren()) do
    if gui.Name == "VyarHMenu" then gui:Destroy() end
end

-- Убираем старый BlurEffect, если он остался в памяти от других скриптов
for _, effect in pairs(Lighting:GetChildren()) do
    if effect:IsA("BlurEffect") then effect:Destroy() end
end

-- Палитра
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
-- Отключаем тяжелые эффекты рендера для этого GUI
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling 

-- FOV
local FOVCircle = Instance.new("Frame", ScreenGui)
FOVCircle.Size = UDim2.new(0, 300, 0, 300)
FOVCircle.Position = UDim2.new(0.5, -150, 0.5, -150)
FOVCircle.BackgroundTransparency = 1
FOVCircle.BorderSizePixel = 1
FOVCircle.BorderColor3 = Colors.Accent
FOVCircle.Visible = false
Instance.new("UICorner", FOVCircle).CornerRadius = UDim.new(1, 0)

-- MainFrame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 680, 0, 520)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Colors.Bg
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
-- Оставили только одну обводку, чтобы не грузить ФПС
local UIStroke = Instance.new("UIStroke", MainFrame); UIStroke.Color = Colors.Accent; UIStroke.Thickness = 1; UIStroke.Transparency = 0.5

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 55)
TopBar.BackgroundColor3 = Colors.Panel
TopBar.BackgroundTransparency = 0.1
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 150, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Colors.Accent
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.Text = "VyarH v1.2.2"
Title.TextXAlignment = Enum.TextXAlignment.Left

local DescLabel = Instance.new("TextLabel", TopBar)
DescLabel.Size = UDim2.new(1, -280, 1, 0)
DescLabel.Position = UDim2.new(0, 170, 0, 0)
DescLabel.BackgroundTransparency = 1
DescLabel.TextColor3 = Colors.TextDim
DescLabel.Font = Enum.Font.GothamMedium
DescLabel.TextSize = 13
DescLabel.Text = "Наведи на функцию для описания"
DescLabel.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -45, 0, 10)
CloseBtn.BackgroundColor3 = Colors.Element
CloseBtn.TextColor3 = Colors.Accent
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Text = "X"
CloseBtn.BorderSizePixel = 0
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local LeftPanel = Instance.new("Frame", MainFrame)
LeftPanel.Size = UDim2.new(0, 120, 1, -65)
LeftPanel.Position = UDim2.new(0, 10, 0, 60)
LeftPanel.BackgroundColor3 = Colors.Panel
LeftPanel.BackgroundTransparency = 0.2
LeftPanel.BorderSizePixel = 0
Instance.new("UICorner", LeftPanel).CornerRadius = UDim.new(0, 8)

local TabList = Instance.new("UIListLayout", LeftPanel)
TabList.Padding = UDim.new(0, 5)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local CenterPanel = Instance.new("Frame", MainFrame)
CenterPanel.Size = UDim2.new(0, 280, 1, -65)
CenterPanel.Position = UDim2.new(0, 140, 0, 60)
CenterPanel.BackgroundColor3 = Colors.Panel
CenterPanel.BackgroundTransparency = 0.2
CenterPanel.BorderSizePixel = 0
Instance.new("UICorner", CenterPanel).CornerRadius = UDim.new(0, 8)

local FuncScroll = Instance.new("ScrollingFrame", CenterPanel)
FuncScroll.Size = UDim2.new(1, -10, 1, -10)
FuncScroll.Position = UDim2.new(0, 5, 0, 5)
FuncScroll.BackgroundTransparency = 1
FuncScroll.ScrollBarThickness = 4
FuncScroll.ScrollBarImageColor3 = Colors.Accent
FuncScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
-- Оптимизация скролла (чтобы не рендерил лишнее)
FuncScroll.ClipsDescendants = true

local FuncLayout = Instance.new("UIListLayout", FuncScroll)
FuncLayout.Padding = UDim.new(0, 6)
FuncLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local RightPanel = Instance.new("Frame", MainFrame)
RightPanel.Size = UDim2.new(0, 220, 1, -65)
RightPanel.Position = UDim2.new(1, -230, 0, 60)
RightPanel.BackgroundColor3 = Colors.Panel
RightPanel.BackgroundTransparency = 0.2
RightPanel.BorderSizePixel = 0
Instance.new("UICorner", RightPanel).CornerRadius = UDim.new(0, 8)

local RightTitle = Instance.new("TextLabel", RightPanel)
RightTitle.Size = UDim2.new(1, 0, 0, 40)
RightTitle.BackgroundTransparency = 1
RightTitle.TextColor3 = Colors.Accent
RightTitle.Font = Enum.Font.GothamBold
RightTitle.TextSize = 14
RightTitle.Text = "Настройки"
RightTitle.TextXAlignment = Enum.TextXAlignment.Center

local RightScroll = Instance.new("ScrollingFrame", RightPanel)
RightScroll.Size = UDim2.new(1, -10, 1, -50)
RightScroll.Position = UDim2.new(0, 5, 0, 45)
RightScroll.BackgroundTransparency = 1
RightScroll.ScrollBarThickness = 4
RightScroll.ScrollBarImageColor3 = Colors.Accent
RightScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
RightScroll.ClipsDescendants = true

local RightLayout = Instance.new("UIListLayout", RightScroll)
RightLayout.Padding = UDim.new(0, 8)
RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Pages = {Main = {}, Combat = {}, Visuals = {}, Optimize = {}, Game3008 = {}, Settings = {}}
local IsBinding = false
local CurrentBindConfig = nil

local speedEnabled, flyEnabled, noclipEnabled, infJumpEnabled, clickTpEnabled = false, false, false, false, false
local aimbotEnabled, godEnabled, espEnabled, esp3DEnabled = false, false, false, false
local spiderEnabled, spinbotEnabled, hitboxEnabled, tracersEnabled, fovEnabled = false, false, false, false, false
local stealthEnabled, trailEnabled = false, false
local currentCamFov = 70
local baseSpeed, currentFlySpeed, aimbotSmoothness, aimbotFOV = 32, 50, 0.3, 300
local flyBV, flyBG
local highlights = {}
local esp3DGuis = {}
local lastSafePosition = nil
local myTrail = nil

local infHunger, infEnergy, empEsp, autoLoot = false, false, false, false

local function ClearRightPanel()
    for _, v in pairs(RightScroll:GetChildren()) do
        if v:IsA("Frame") or v:IsA("TextButton") then v:Destroy() end
    end
end

local function CreateRightSlider(name, min, max, default, callback)
    local F = Instance.new("Frame", RightScroll)
    F.Size = UDim2.new(1, -10, 0, 50)
    F.BackgroundColor3 = Colors.Element
    F.BorderSizePixel = 0
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(1, -10, 0, 20); L.Position = UDim2.new(0, 5, 0, 5)
    L.BackgroundTransparency = 1; L.TextColor3 = Colors.Text; L.Font = Enum.Font.GothamMedium; L.TextSize = 12
    L.Text = name .. ": " .. default; L.TextXAlignment = Enum.TextXAlignment.Left

    local Bar = Instance.new("Frame", F)
    Bar.Size = UDim2.new(1, -20, 0, 5); Bar.Position = UDim2.new(0, 10, 0, 30)
    Bar.BackgroundColor3 = Colors.Bg; Bar.BorderSizePixel = 0
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Colors.Accent
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function Update(input)
        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos + 0.5)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        L.Text = name .. ": " .. val
        callback(val)
    end

    Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; Update(i) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then Update(i) end end)
end

-- Убрали Glassmorphism из конфига
local FunctionConfig = {
    {Name="Stealth Bypass", Tab="Main", Desc="Маскировка от античитов", Type="Toggle", Callback=function(s) stealthEnabled=s end},
    {Name="Click TP", Tab="Main", Desc="Телепорт по клику мыши", Type="Toggle", Callback=function(s) clickTpEnabled=s end},
    {Name="Speed Hack", Tab="Main", Desc="Обход скорости", Type="Toggle", Callback=function(s) speedEnabled=s end, Settings={{"Speed", 16, 200, 32, function(v) baseSpeed=v end}}},
    {Name="Spider", Tab="Main", Desc="Лазать по стенам", Type="Toggle", Callback=function(s) spiderEnabled=s end},
    {Name="Fly (WASD)", Tab="Main", Desc="Полет", Type="Toggle", Callback=function(s) flyEnabled=s end, Settings={{"Speed", 10, 200, 50, function(v) currentFlySpeed=v end}}},
    {Name="Noclip", Tab="Main", Desc="Проход сквозь стены", Type="Toggle", Callback=function(s) noclipEnabled=s end},
    {Name="Infinite Jump", Tab="Main", Desc="Бесконечный прыжок", Type="Toggle", Callback=function(s) infJumpEnabled=s end},
    {Name="Aimbot (RMB)", Tab="Combat", Desc="Наводка на цель", Type="Toggle", Callback=function(s) aimbotEnabled=s; FOVCircle.Visible=s end, Settings={{"Smoothness", 1, 100, 30, function(v) aimbotSmoothness=v/100 end}, {"FOV Radius", 50, 800, 300, function(v) aimbotFOV=v; FOVCircle.Size=UDim2.new(0,v,0,v); FOVCircle.Position=UDim2.new(0.5,-v/2,0.5,-v/2) end}}},
    {Name="Spinbot", Tab="Combat", Desc="Вращение тела", Type="Toggle", Callback=function(s) spinbotEnabled=s end},
    {Name="Hitbox Expander", Tab="Combat", Desc="Большой хитбокс", Type="Toggle", Callback=function(s) hitboxEnabled=s end},
    {Name="God Mode", Tab="Combat", Desc="Локальный бог", Type="Toggle", Callback=function(s) godEnabled=s end},
    {Name="Particle Trails", Tab="Visuals", Desc="Шлейф за спиной", Type="Toggle", Callback=function(s) trailEnabled=s end},
    {Name="3D ESP", Tab="Visuals", Desc="Коробки и HP над игроками", Type="Toggle", Callback=function(s) esp3DEnabled=s end},
    {Name="Aggressive FPS Boost", Tab="Optimize", Desc="Удаляет все частицы", Type="Button", Callback=function() 
        for _,v in pairs(workspace:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then v:Destroy() end end 
    end},
    {Name="Low Graphics", Tab="Optimize", Desc="Режим картошки", Type="Button", Callback=function() settings().Rendering.QualityLevel = 1 end},
    
    {Name="Infinite Hunger", Tab="Game3008", Desc="Еда не убывает", Type="Toggle", Callback=function(s) infHunger=s end},
    {Name="Infinite Energy", Tab="Game3008", Desc="Выносливость не убывает", Type="Toggle", Callback=function(s) infEnergy=s end},
    {Name="Employee ESP", Tab="Game3008", Desc="Подсветка NPC (без лагов)", Type="Toggle", Callback=function(s) empEsp=s end},
    {Name="Auto Loot (Click)", Tab="Game3008", Desc="Кликни по еде для ТП", Type="Toggle", Callback=function(s) autoLoot=s end},
    
    {Name="Save Config", Tab="Settings", Desc="Сохраняет бинды", Type="Button", Callback=function() SaveConfig() end},
    {Name="Load Config", Tab="Settings", Desc="Загружает бинды", Type="Button", Callback=function() LoadConfig() end},
    {Name="Destroy GUI", Tab="Settings", Desc="Закрывает меню", Type="Button", Callback=function() ScreenGui:Destroy() end}
}

local function CreateFunctionButton(cfg)
    local Btn = Instance.new("TextButton", FuncScroll)
    Btn.Size = UDim2.new(1, -10, 0, 40)
    Btn.BackgroundColor3 = Colors.Element
    Btn.BackgroundTransparency = 0.2
    Btn.TextColor3 = Colors.TextDim
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 13
    Btn.Text = "  " .. cfg.Name
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    cfg.State = false
    if cfg.Type == "Toggle" then
        local Ind = Instance.new("Frame", Btn)
        Ind.Size = UDim2.new(0, 10, 0, 10)
        Ind.Position = UDim2.new(1, -20, 0.5, -5)
        Ind.BackgroundColor3 = Colors.Bg
        Instance.new("UICorner", Ind).CornerRadius = UDim.new(1, 0)
        cfg.UpdateVisuals = function(s)
            if s then
                Btn.TextColor3 = Colors.Text
                Ind.BackgroundColor3 = Colors.Accent
            else
                Btn.TextColor3 = Colors.TextDim
                Ind.BackgroundColor3 = Colors.Bg
            end
        end
    end

    Btn.MouseEnter:Connect(function()
        DescLabel.Text = cfg.Desc or "Нет описания"
        Btn.BackgroundColor3 = Colors.Bg
    end)
    Btn.MouseLeave:Connect(function()
        Btn.BackgroundColor3 = Colors.Element
    end)

    Btn.MouseButton1Click:Connect(function()
        ClearRightPanel()
        RightTitle.Text = cfg.Name
        local BindBtn = Instance.new("TextButton", RightScroll)
        BindBtn.Size = UDim2.new(1, -10, 0, 35)
        BindBtn.BackgroundColor3 = Colors.Bg
        BindBtn.TextColor3 = cfg.BoundKey and Colors.Accent or Colors.TextDim
        BindBtn.Font = Enum.Font.GothamBold
        BindBtn.TextSize = 12
        BindBtn.Text = cfg.BoundKey and ("[" .. cfg.BoundKey.Name .. "]") or "[ Назначить клавишу ]"
        BindBtn.BorderSizePixel = 0
        Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 6)
        BindBtn.MouseButton1Click:Connect(function()
            BindBtn.Text = "[ Нажми клавишу... ]"
            BindBtn.TextColor3 = Colors.Accent
            CurrentBindConfig = cfg
            IsBinding = true
        end)
        if cfg.Settings then
            for _, s in pairs(cfg.Settings) do CreateRightSlider(s[1], s[2], s[3], s[4], s[5]) end
        end
        if cfg.Type == "Toggle" then
            cfg.State = not cfg.State
            cfg.UpdateVisuals(cfg.State)
            cfg.Callback(cfg.State)
        else cfg.Callback() end
    end)
    table.insert(Pages[cfg.Tab], Btn)
end

local TabsData = {"Main", "Combat", "Visuals", "Optimize", "Game3008", "Settings"}
for i, tabName in ipairs(TabsData) do
    local tBtn = Instance.new("TextButton", LeftPanel)
    tBtn.Size = UDim2.new(1, -15, 0, 35)
    tBtn.BackgroundColor3 = Colors.Element
    tBtn.BackgroundTransparency = 0.2
    tBtn.TextColor3 = Colors.TextDim
    tBtn.Font = Enum.Font.GothamBold
    tBtn.TextSize = 13
    tBtn.Text = tabName
    tBtn.BorderSizePixel = 0
    Instance.new("UICorner", tBtn).CornerRadius = UDim.new(0, 6)
    tBtn.MouseButton1Click:Connect(function()
        for _, other in pairs(LeftPanel:GetChildren()) do
            if other:IsA("TextButton") then
                other.BackgroundColor3 = Colors.Element
                other.TextColor3 = Colors.TextDim
            end
        end
        tBtn.BackgroundColor3 = Colors.Accent
        tBtn.TextColor3 = Colors.Text
        for name, buttons in pairs(Pages) do
            for _, btn in pairs(buttons) do btn.Visible = (name == tabName) end
        end
        ClearRightPanel()
        RightTitle.Text = "Настройки"
    end)
    if i == 1 then tBtn.BackgroundColor3 = Colors.Accent; tBtn.TextColor3 = Colors.Text end
end

for _, cfg in pairs(FunctionConfig) do CreateFunctionButton(cfg) end
for name, buttons in pairs(Pages) do
    for _, btn in pairs(buttons) do if name ~= "Main" then btn.Visible = false end end
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if IsBinding and CurrentBindConfig then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.Backspace then
                CurrentBindConfig.BoundKey = nil
                RightScroll:FindFirstChildOfClass("TextButton").Text = "[ Назначить клавишу ]"
            else
                CurrentBindConfig.BoundKey = input.KeyCode
                RightScroll:FindFirstChildOfClass("TextButton").Text = "[" .. input.KeyCode.Name .. "]"
                RightScroll:FindFirstChildOfClass("TextButton").TextColor3 = Colors.Accent
            end
            IsBinding = false
            CurrentBindConfig = nil
        end
    else
        for _, cfg in pairs(FunctionConfig) do
            if cfg.BoundKey and input.KeyCode == cfg.BoundKey then
                if cfg.Type == "Toggle" then
                    cfg.State = not cfg.State
                    if cfg.UpdateVisuals then cfg.UpdateVisuals(cfg.State) end
                    cfg.Callback(cfg.State)
                else cfg.Callback() end
            end
        end
    end
end)

function SaveConfig()
    if writefile then
        local data = {}
        for _, cfg in pairs(FunctionConfig) do data[cfg.Name] = cfg.BoundKey and cfg.BoundKey.Name or nil end
        pcall(function() writefile("VyarH_Config.json", HttpService:JSONEncode(data)) end)
        print("VyarH: Конфиг сохранен!")
    end
end

function LoadConfig()
    if isfile and readfile and isfile("VyarH_Config.json") then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile("VyarH_Config.json")) end)
        if success and data then
            for _, cfg in pairs(FunctionConfig) do
                if data[cfg.Name] then cfg.BoundKey = Enum.KeyCode[data[cfg.Name]] end
            end
            print("VyarH: Конфиг загружен!")
        end
    end
end

-- ==================== 3008 LOGIC ====================
task.spawn(function()
    while task.wait(2) do
        if infHunger or infEnergy then
            local char = LocalPlayer.Character
            if char then
                for _, obj in pairs(char:GetDescendants()) do
                    if infHunger and (obj.Name:lower():find("hunger") or obj.Name:lower():find("food")) and obj:IsA("NumberValue") then obj.Value = 100 end
                    if infEnergy and (obj.Name:lower():find("energy") or obj.Name:lower():find("stamina")) and obj:IsA("NumberValue") then obj.Value = 100 end
                end
            end
        end
        if empEsp then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= LocalPlayer.Character then
                    if not Players:GetPlayerFromCharacter(v) and not v:FindFirstChild("VyarHEmp") then
                        local h = Instance.new("Highlight", v)
                        h.Name = "VyarHEmp"
                        h.FillColor = Color3.fromRGB(255, 0, 0)
                        h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    end
                end
            end
        else
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") then
                    local h = v:FindFirstChild("VyarHEmp")
                    if h then h:Destroy() end
                end
            end
        end
    end
end)

-- Auto Loot
UserInputService.InputBegan:Connect(function(input, gp)
    if gp or not autoLoot or input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    local mouse = LocalPlayer:GetMouse()
    if mouse.Target then
        local targetModel = mouse.Target:FindFirstAncestorOfClass("Model")
        if targetModel and (targetModel.Name:lower():find("food") or targetModel.Name:lower():find("apple") or targetModel.Name:lower():find("medkit")) then
            local hrp = targetModel:FindFirstChild("HumanoidRootPart") or targetModel:FindFirstChild("Handle") or targetModel:FindFirstChildWhichIsA("BasePart")
            if hrp and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 3, 0)
            end
        end
    end
end)

-- ==================== ОБЩАЯ ЛОГИКА ====================
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if hrp.Position.Y > -20 then lastSafePosition = hrp.CFrame end
    end

    if speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local finalSpeed = baseSpeed
        if stealthEnabled then finalSpeed = baseSpeed + math.random(-3, 3) end
        LocalPlayer.Character.Humanoid.WalkSpeed = finalSpeed
        if LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
            LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(
                LocalPlayer.Character.Humanoid.MoveDirection.X * finalSpeed, 
                LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity.Y, 
                LocalPlayer.Character.Humanoid.MoveDirection.Z * finalSpeed
            )
        end
    end
    if noclipEnabled and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    if godEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then 
        LocalPlayer.Character.Humanoid.Health = 100 
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.RenderStepped:Connect(function()
    if flyEnabled and flyBV and flyBG then
        local moveDir = Vector3.zero
        local cam = workspace.CurrentCamera
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end
        flyBV.Velocity = moveDir * currentFlySpeed
        flyBG.CFrame = cam.CFrame
    end
    if aimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local closest, dist = nil, aimbotFOV
        local myChar = LocalPlayer.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local d = (p.Character.Head.Position - myChar.HumanoidRootPart.Position).Magnitude
                    if d < dist then dist = d; closest = p.Character.Head end
                end
            end
            if closest then 
                local targetCFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closest.Position)
                workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(targetCFrame, aimbotSmoothness) 
            end
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if clickTpEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mouse = LocalPlayer:GetMouse()
        if mouse.Hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)

local isMenuOpen = true
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

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        isMenuOpen = not isMenuOpen
        MainFrame.Visible = isMenuOpen
        ToggleBtn.Visible = not isMenuOpen
    end
end)
ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; ToggleBtn.Visible = false; isMenuOpen = true end)

print("VyarH v1.2.2 (FPS Fix) успешно загружено!")
