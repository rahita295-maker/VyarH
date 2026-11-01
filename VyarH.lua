-- ============================================================
-- VYARH v1.0.0 (OFFICIAL RELEASE)
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

-- Палитра цветов
local Colors = {
    Bg = Color3.fromRGB(15, 15, 15),
    Panel = Color3.fromRGB(22, 22, 22),
    Element = Color3.fromRGB(32, 32, 32),
    Accent = Color3.fromRGB(255, 115, 0),
    Green = Color3.fromRGB(0, 255, 100),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(160, 160, 160)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VyarHMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui
ScreenGui.IgnoreGuiInset = true

-- Glassmorphism Blur
local Blur = Instance.new("BlurEffect", Lighting)
Blur.Size = 0
Blur.Enabled = false

-- Круг FOV для аимбота
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
MainFrame.Size = UDim2.new(0, 680, 0, 520)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Colors.Bg
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local UIStroke = Instance.new("UIStroke", MainFrame); UIStroke.Color = Colors.Accent; UIStroke.Thickness = 1.5; UIStroke.Transparency = 0.3

-- Верхняя панель
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 55)
TopBar.BackgroundColor3 = Colors.Panel
TopBar.BackgroundTransparency = 0.1
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 130, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Colors.Accent
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.Text = "VyarH v1.0.0"
Title.TextXAlignment = Enum.TextXAlignment.Left

local DescLabel = Instance.new("TextLabel", TopBar)
DescLabel.Size = UDim2.new(1, -250, 1, 0)
DescLabel.Position = UDim2.new(0, 150, 0, 0)
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
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy(); Blur:Destroy() end)

-- Левая панель (Вкладки)
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

-- Центральная панель (Функции)
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

local FuncLayout = Instance.new("UIListLayout", FuncScroll)
FuncLayout.Padding = UDim.new(0, 6)
FuncLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Правая панель (Настройки)
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

local RightLayout = Instance.new("UIListLayout", RightScroll)
RightLayout.Padding = UDim.new(0, 8)
RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ПЕРЕМЕННЫЕ СОСТОЯНИЙ
local Pages = {Main = {}, Combat = {}, Visuals = {}, Optimize = {}, Settings = {}}
local IsBinding = false
local CurrentBindConfig = nil

local speedEnabled, flyEnabled, noclipEnabled, infJumpEnabled, clickTpEnabled = false, false, false, false, false
local aimbotEnabled, godEnabled, espEnabled, esp3DEnabled = false, false, false, false
local spiderEnabled, spinbotEnabled, hitboxEnabled, tracersEnabled, fovEnabled = false, false, false, false, false
local stealthEnabled, glassEnabled, trailEnabled = false, false, false
local currentCamFov = 70
local baseSpeed, currentFlySpeed, aimbotSmoothness, aimbotFOV = 32, 50, 0.3, 300
local flyBV, flyBG
local highlights = {}
local esp3DGuis = {}
local lastSafePosition = nil
local myTrail = nil

-- UI ЛОГИКА
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

-- КОНФИГУРАЦИЯ
local FunctionConfig = {
    -- MAIN
    {Name="Stealth Bypass", Tab="Main", Desc="Маскировка от античитов", Type="Toggle", Callback=function(s) stealthEnabled=s end},
    {Name="Click TP", Tab="Main", Desc="Телепорт по клику мыши", Type="Toggle", Callback=function(s) clickTpEnabled=s end},
    {Name="Speed Hack", Tab="Main", Desc="Обход скорости", Type="Toggle", Callback=function(s) speedEnabled=s end, Settings={{"Speed", 16, 200, 32, function(v) baseSpeed=v end}}},
    {Name="Spider", Tab="Main", Desc="Лазать по стенам", Type="Toggle", Callback=function(s) spiderEnabled=s end},
    {Name="Fly (WASD)", Tab="Main", Desc="Полет", Type="Toggle", 
     Callback=function(s) 
        flyEnabled=s 
        if s and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            flyBV = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart); flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            flyBG = Instance.new("BodyGyro", LocalPlayer.Character.HumanoidRootPart); flyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5); flyBG.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        else if flyBV then flyBV:Destroy() end; if flyBG then flyBG:Destroy() end end
     end, Settings={{"Speed", 10, 200, 50, function(v) currentFlySpeed=v end}}},
    {Name="Noclip", Tab="Main", Desc="Проход сквозь стены", Type="Toggle", Callback=function(s) noclipEnabled=s end},
    {Name="Infinite Jump", Tab="Main", Desc="Бесконечный прыжок", Type="Toggle", Callback=function(s) infJumpEnabled=s end},
    
    -- COMBAT
    {Name="Aimbot (RMB)", Tab="Combat", Desc="Наводка на цель", Type="Toggle", Callback=function(s) aimbotEnabled=s; FOVCircle.Visible=s end, Settings={{"Smoothness", 1, 100, 30, function(v) aimbotSmoothness=v/100 end}, {"FOV Radius", 50, 800, 300, function(v) aimbotFOV=v; FOVCircle.Size=UDim2.new(0,v,0,v); FOVCircle.Position=UDim2.new(0.5,-v/2,0.5,-v/2) end}}},
    {Name="Spinbot", Tab="Combat", Desc="Вращение тела", Type="Toggle", Callback=function(s) spinbotEnabled=s end},
    {Name="Hitbox Expander", Tab="Combat", Desc="Большой хитбокс", Type="Toggle", Callback=function(s) hitboxEnabled=s end},
    {Name="God Mode", Tab="Combat", Desc="Локальный бог", Type="Toggle", Callback=function(s) godEnabled=s end},
    
    -- VISUALS
    {Name="Glassmorphism UI", Tab="Visuals", Desc="Размытие фона за меню", Type="Toggle", Callback=function(s) glassEnabled=s; Blur.Enabled=s; Blur.Size = s and 15 or 0 end},
    {Name="Particle Trails", Tab="Visuals", Desc="Шлейф за спиной", Type="Toggle", 
     Callback=function(s) 
        trailEnabled=s 
        if s and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local att0 = Instance.new("Attachment", LocalPlayer.Character.HumanoidRootPart); att0.Position = Vector3.new(0, 1, 0)
            local att1 = Instance.new("Attachment", LocalPlayer.Character.HumanoidRootPart); att1.Position = Vector3.new(0, -1, 0)
            myTrail = Instance.new("Trail", LocalPlayer.Character.HumanoidRootPart)
            myTrail.Attachment0 = att0; myTrail.Attachment1 = att1
            myTrail.LightEmission = 1; myTrail.Color = ColorSequence.new(Colors.Accent); myTrail.Lifetime = 0.5
        else if myTrail then myTrail:Destroy() end end
     end},
    {Name="3D ESP", Tab="Visuals", Desc="Коробки и HP над игроками", Type="Toggle", Callback=function(s) esp3DEnabled=s end},
    {Name="Time Changer (Noon)", Tab="Visuals", Desc="Ставит день (14:00)", Type="Toggle", Callback=function(s) Lighting.ClockTime = s and 14 or 0 end},
    
    -- OPTIMIZE
    {Name="Aggressive FPS Boost", Tab="Optimize", Desc="Удаляет все частицы (Огонь, Дым)", Type="Button", Callback=function() 
        for _,v in pairs(workspace:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then v:Destroy() end end 
    end},
    {Name="Hide Accessories", Tab="Optimize", Desc="Скрывает шапки и волосы у всех", Type="Button", Callback=function() 
        for _,p in pairs(Players:GetPlayers()) do
            if p.Character then
                for _,v in pairs(p.Character:GetChildren()) do
                    if v:IsA("Accessory") then v:Destroy() end
                end
            end
        end
    end},
    {Name="Disable Post-Processing", Tab="Optimize", Desc="Убирает свечение и размытие игры", Type="Button", Callback=function() 
        for _,v in pairs(Lighting:GetChildren()) do if v:IsA("PostEffect") and v ~= Blur then v:Destroy() end end 
    end},
    {Name="Low Graphics", Tab="Optimize", Desc="Режим картошки (Ставит графу на 1)", Type="Button", Callback=function() 
        settings().Rendering.QualityLevel = 1 
    end},
    {Name="Clear Terrain", Tab="Optimize", Desc="Убирает траву и детали ландшафта", Type="Button", Callback=function() 
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.WaterWaveSize = 0; terrain.WaterTransparency = 1
            terrain.Decoration = false
        end
    end},
    
    -- SETTINGS (Убрана смена цвета)
    {Name="Save Config", Tab="Settings", Desc="Сохраняет бинды в файл", Type="Button", Callback=function() SaveConfig() end},
    {Name="Load Config", Tab="Settings", Desc="Загружает бинды", Type="Button", Callback=function() LoadConfig() end},
    {Name="Destroy GUI", Tab="Settings", Desc="Полностью закрывает меню", Type="Button", Callback=function() ScreenGui:Destroy(); Blur:Destroy() end}
}

-- СОЗДАНИЕ ИНТЕРФЕЙСА
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
                TweenService:Create(Btn, TweenInfo.new(0.2), {TextColor3 = Colors.Text}):Play()
                TweenService:Create(Ind, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent}):Play()
            else
                TweenService:Create(Btn, TweenInfo.new(0.2), {TextColor3 = Colors.TextDim}):Play()
                TweenService:Create(Ind, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Bg}):Play()
            end
        end
    end

    Btn.MouseEnter:Connect(function()
        DescLabel.Text = cfg.Desc or "Нет описания"
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Colors.Bg}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Colors.Element}):Play()
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
            for _, s in pairs(cfg.Settings) do
                CreateRightSlider(s[1], s[2], s[3], s[4], s[5])
            end
        end
        
        if cfg.Type == "Toggle" then
            cfg.State = not cfg.State
            cfg.UpdateVisuals(cfg.State)
            cfg.Callback(cfg.State)
        else
            cfg.Callback()
        end
    end)
    
    table.insert(Pages[cfg.Tab], Btn)
end

local TabsData = {"Main", "Combat", "Visuals", "Optimize", "Settings"}
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
                TweenService:Create(other, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Element, TextColor3 = Colors.TextDim}):Play()
            end
        end
        TweenService:Create(tBtn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent, TextColor3 = Colors.Text}):Play()
        
        for name, buttons in pairs(Pages) do
            for _, btn in pairs(buttons) do
                btn.Visible = (name == tabName)
            end
        end
        ClearRightPanel()
        RightTitle.Text = "Настройки"
    end)
    
    if i == 1 then tBtn.BackgroundColor3 = Colors.Accent; tBtn.TextColor3 = Colors.Text end
end

for _, cfg in pairs(FunctionConfig) do
    CreateFunctionButton(cfg)
end

for name, buttons in pairs(Pages) do
    for _, btn in pairs(buttons) do
        if name ~= "Main" then btn.Visible = false end
    end
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
                else
                    cfg.Callback()
                end
            end
        end
    end
end)

-- ФУНКЦИИ КОНФИГА
function SaveConfig()
    if writefile then
        local data = {}
        for _, cfg in pairs(FunctionConfig) do
            data[cfg.Name] = cfg.BoundKey and cfg.BoundKey.Name or nil
        end
        local success, err = pcall(function()
            writefile("VyarH_Config.json", HttpService:JSONEncode(data))
        end)
        if success then print("VyarH: Конфиг сохранен!") else print("VyarH: Ошибка сохранения: " .. tostring(err)) end
    else
        print("VyarH: Твой инжектор не поддерживает сохранение файлов.")
    end
end

function LoadConfig()
    if isfile and readfile then
        if isfile("VyarH_Config.json") then
            local success, data = pcall(function() return HttpService:JSONDecode(readfile("VyarH_Config.json")) end)
            if success and data then
                for _, cfg in pairs(FunctionConfig) do
                    if data[cfg.Name] then
                        cfg.BoundKey = Enum.KeyCode[data[cfg.Name]]
                    end
                end
                print("VyarH: Конфиг загружен!")
            end
        else
            print("VyarH: Файл конфига не найден.")
        end
    end
end

-- ГЛАВНАЯ ЛОГИКА
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
    
    if noclipEnabled and stealthEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character.HumanoidRootPart.Position.Y < -40 and lastSafePosition then
            LocalPlayer.Character.HumanoidRootPart.CFrame = lastSafePosition
        end
    end

    if spiderEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local char = LocalPlayer.Character
        local hrp = char.HumanoidRootPart
        local hum = char.Humanoid
        if hum.MoveDirection.Magnitude > 0 then
            local ray = Ray.new(hrp.Position, hrp.CFrame.LookVector * 3)
            local part = workspace:FindPartOnRay(ray, char)
            if part and hrp.CFrame.LookVector:Dot(hum.MoveDirection) > 0.1 then
                hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 50, hrp.AssemblyLinearVelocity.Z)
            end
        end
    end
    
    if spinbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(90), 0)
    end

    if godEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then 
        LocalPlayer.Character.Humanoid.Health = 100 
    end

    if hitboxEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then 
                p.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10) 
            end
        end
    end

    -- 3D ESP
    if esp3DEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                if not esp3DGuis[p] then
                    local bg = Instance.new("BillboardGui", p.Character.Head)
                    bg.Name = "VyarH3D"
                    bg.Size = UDim2.new(0, 100, 0, 50)
                    bg.StudsOffset = Vector3.new(0, 2.5, 0)
                    bg.AlwaysOnTop = true
                    
                    local name = Instance.new("TextLabel", bg)
                    name.Size = UDim2.new(1, 0, 0.5, 0)
                    name.BackgroundTransparency = 1
                    name.TextColor3 = Colors.Accent
                    name.TextStrokeTransparency = 0
                    name.Font = Enum.Font.GothamBold
                    name.TextSize = 14
                    name.Text = p.Name
                    
                    local health = Instance.new("Frame", bg)
                    health.Size = UDim2.new(1, 0, 0.15, 0)
                    health.Position = UDim2.new(0, 0, 0.6, 0)
                    health.BackgroundColor3 = Color3.new(0, 255, 0)
                    health.BorderSizePixel = 1
                    health.BorderColor3 = Color3.new(0, 0, 0)
                    
                    esp3DGuis[p] = bg
                end
                local healthBar = esp3DGuis[p]:FindFirstChild("Frame")
                if healthBar and p.Character:FindFirstChild("Humanoid") then
                    healthBar.Size = UDim2.new(p.Character.Humanoid.Health / p.Character.Humanoid.MaxHealth, 0, 0.15, 0)
                end
            end
        end
    else
        for p, gui in pairs(esp3DGuis) do
            gui:Destroy()
            esp3DGuis[p] = nil
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
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
    
    if fovEnabled and workspace.CurrentCamera.FieldOfView ~= currentCamFov then
        workspace.CurrentCamera.FieldOfView = currentCamFov
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
                local smoothFactor = stealthEnabled and math.max(0.1, aimbotSmoothness) or aimbotSmoothness
                if stealthEnabled then
                    targetCFrame = targetCFrame * CFrame.Angles(math.rad(math.random(-2,2)/10), math.rad(math.random(-2,2)/10), 0)
                end
                workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(targetCFrame, smoothFactor) 
            end
        end
    end
end)

local tracerFolder = Instance.new("Folder", workspace)
tracerFolder.Name = "VyarHTracers"
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if clickTpEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mouse = LocalPlayer:GetMouse()
        if mouse.Hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
    
    if tracersEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mouse = LocalPlayer:GetMouse()
        if mouse.Target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local startPos = LocalPlayer.Character.HumanoidRootPart.Position
            local endPos = mouse.Hit.Position
            local tracer = Instance.new("Part", tracerFolder)
            tracer.Anchored = true; tracer.CanCollide = false; tracer.Material = Enum.Material.Neon; tracer.Color = Colors.Accent
            tracer.Size = Vector3.new(0.1, 0.1, (startPos - endPos).Magnitude)
            tracer.CFrame = CFrame.lookAt(startPos, endPos) * CFrame.new(0, 0, -(startPos - endPos).Magnitude/2)
            TweenService:Create(tracer, TweenInfo.new(0.5), {Transparency = 1}):Play()
            task.delay(0.5, function() tracer:Destroy() end)
        end
    end
end)

-- Скрытие меню
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

print("VyarH v1.0.0 Release успешно загружено!")
