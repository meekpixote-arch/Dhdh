-- Nbc Hub - King Tower Script
-- Criado por Nbc Hub

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Criando a GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NbcHubGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Arredondamento
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "Nbc Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Botão Fechar
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Função para criar botões
local function CreateButton(text, position, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 280, 0, 40)
    Button.Position = UDim2.new(0.5, -140, 0, position)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextScaled = true
    Button.Font = Enum.Font.Gotham
    Button.Parent = MainFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 5)
    ButtonCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(callback)
    return Button
end

-- Variáveis para os toggles
local tpwalk15Enabled = false
local tpwalk3Enabled = false
local floatEnabled = false
local untpwalkEnabled = false
local godModeEnabled = false

-- TPWalk 15
CreateButton("TPWalk 15", 60, function()
    tpwalk15Enabled = not tpwalk15Enabled
    if tpwalk15Enabled then
        tpwalk3Enabled = false
        untpwalkEnabled = false
    end
    print("TPWalk 15: " .. tostring(tpwalk15Enabled))
end)

-- TPWalk 3
CreateButton("TPWalk 3", 120, function()
    tpwalk3Enabled = not tpwalk3Enabled
    if tpwalk3Enabled then
        tpwalk15Enabled = false
        untpwalkEnabled = false
    end
    print("TPWalk 3: " .. tostring(tpwalk3Enabled))
end)

-- Floating
CreateButton("Floating", 180, function()
    floatEnabled = not floatEnabled
    print("Floating: " .. tostring(floatEnabled))
end)

-- UNTPWalk
CreateButton("UNTPWalk", 240, function()
    untpwalkEnabled = not untpwalkEnabled
    if untpwalkEnabled then
        tpwalk15Enabled = false
        tpwalk3Enabled = false
    end
    print("UNTPWalk: " .. tostring(untpwalkEnabled))
end)

-- God Mode
CreateButton("God Mode", 300, function()
    godModeEnabled = not godModeEnabled
    if godModeEnabled then
        LocalPlayer.Character:WaitForChild("Humanoid").Health = math.huge
    else
        LocalPlayer.Character:WaitForChild("Humanoid").Health = 100
    end
    print("God Mode: " .. tostring(godModeEnabled))
end)

-- Loop principal para os efeitos
RunService.Heartbeat:Connect(function()
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    
    -- TPWalk 15
    if tpwalk15Enabled then
        local moveDirection = humanoid.MoveDirection
        if moveDirection.Magnitude > 0 then
            rootPart.Velocity = moveDirection * 15
        end
    end
    
    -- TPWalk 3
    if tpwalk3Enabled then
        local moveDirection = humanoid.MoveDirection
        if moveDirection.Magnitude > 0 then
            rootPart.Velocity = moveDirection * 3
        end
    end
    
    -- Floating
    if floatEnabled then
        rootPart.Velocity = Vector3.new(rootPart.Velocity.X, 0, rootPart.Velocity.Z)
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            rootPart.Velocity = Vector3.new(rootPart.Velocity.X, 20, rootPart.Velocity.Z)
        end
    end
    
    -- UNTPWalk
    if untpwalkEnabled then
        local moveDirection = humanoid.MoveDirection
        if moveDirection.Magnitude > 0 then
            rootPart.Velocity = moveDirection * 50
        end
    end
    
    -- God Mode
    if godModeEnabled then
        humanoid.Health = math.huge
        humanoid.MaxHealth = math.huge
        -- Remove danos de queda
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    else
        humanoid.MaxHealth = 100
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    end
end)

-- Detectar quando o personagem morre
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    if godModeEnabled then
        Humanoid.Health = math.huge
        Humanoid.MaxHealth = math.huge
    end
end)

print("Nbc Hub carregado com sucesso!")
print("Script criado por Nbc Hub")
