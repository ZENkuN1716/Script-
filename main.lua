local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- สร้างหน้าต่างหลัก
local Window = Fluent:CreateWindow({
    Title = "ZEN X HUB",
    SubTitle = "Script by Tanongtuay",
    TabWidth = 160,
    Size = UDim2.fromOffset(400, 280),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- สร้างแท็บ Main
local Tabs = {
    Main = Window:AddTab({ Title = "Main" }),
}

-- ตัวแปร AIM BOT
local aimBotEnabled = false
local targetPlayerName = nil

-- ฟังก์ชันดึงรายชื่อผู้เล่น ยกเว้นตัวเอง
local function getPlayerNames()
    local names = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(names, plr.Name)
        end
    end
    return names
end

-- Dropdown รายชื่อผู้เล่น
local playerDropdown = Tabs.Main:AddDropdown("PlayerDropdown", {
    Title = "เลือกผู้เล่นล็อกเป้า",
    Values = getPlayerNames(),
    Multi = false,
    Default = 1,
    Callback = function(value)
        targetPlayerName = value
    end,
})

-- ปุ่มรีเฟรชผู้เล่น
Tabs.Main:AddButton({
    Title = "รีเฟรชผู้เล่น",
    Description = "อัปเดตรายชื่อผู้เล่นในเซิร์ฟเวอร์",
    Callback = function()
        playerDropdown:SetValues(getPlayerNames())
        if targetPlayerName and not Players:FindFirstChild(targetPlayerName) then
            targetPlayerName = nil
            playerDropdown:SetValue(nil)
        end
    end
})

Players.PlayerAdded:Connect(function()
    playerDropdown:SetValues(getPlayerNames())
end)
Players.PlayerRemoving:Connect(function()
    playerDropdown:SetValues(getPlayerNames())
    if targetPlayerName and not Players:FindFirstChild(targetPlayerName) then
        targetPlayerName = nil
        playerDropdown:SetValue(nil)
    end
end)

-- Toggle AIMBOT
Tabs.Main:AddToggle("AimBotToggle", {
    Title = "เปิด/ปิด AIM BOT",
    Default = false,
}):OnChanged(function(state)
    aimBotEnabled = state
end)

-- BOOTS FPS Button
Tabs.Main:AddButton({
    Title = "BOOTS FPS",
    Description = "ลดกราฟิก เพิ่มเฟรมเรต",
    Callback = function()
        setfpscap(30)
        sethiddenproperty(game.Lighting, "Technology", 2)
        sethiddenproperty(workspace.Terrain, "Decoration", false)

        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            end
        end

        print("Graphics Optimization Applied!")
    end
})

-- กล้องเล็งผู้เล่น
RunService.RenderStepped:Connect(function()
    if aimBotEnabled and targetPlayerName then
        local targetPlayer = Players:FindFirstChild(targetPlayerName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = targetPlayer.Character.HumanoidRootPart.Position
            local camPos = Camera.CFrame.Position
            local direction = (targetPos - camPos).Unit
            Camera.CFrame = CFrame.new(camPos, camPos + direction)
        end
    end
end)

-- ตั้งค่าระบบ Save/Interface
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("ZenXHub")
SaveManager:SetFolder("ZenXHub/Main")
InterfaceManager:BuildInterfaceSection(Tabs.Main)
SaveManager:BuildConfigSection(Tabs.Main)
Window:SelectTab(1)

Fluent:Notify({
    Title = "ZEN X HUB",
    Content = "พร้อมใช้งานแล้ว",
    Duration = 6
})

SaveManager:LoadAutoloadConfig()

-- ปุ่มเปิด/ปิด UI แบบลากได้
local CoreGui = game:GetService("CoreGui")
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 30, 0, 30)
toggleBtn.Position = UDim2.new(0, 20, 0, 120)
toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggleBtn.Text = "UI"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.ZIndex = 9999
toggleBtn.Parent = CoreGui
local uicorner = Instance.new("UICorner", toggleBtn)
uicorner.CornerRadius = UDim.new(0, 8)

toggleBtn.MouseButton1Click:Connect(function()
    Window.Minimized = not Window.Minimized
end)
