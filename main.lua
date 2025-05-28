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

-- สร้างแท็บ Aim Bot
local Tabs = {
    AimBot = Window:AddTab({ Title = "Aim Bot" }),
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

-- สร้าง Dropdown รายชื่อผู้เล่นสำหรับ AimBot
local playerDropdown = Tabs.AimBot:AddDropdown("PlayerDropdown", {
    Title = "เลือกผู้เล่นล็อกเป้า",
    Values = getPlayerNames(),
    Multi = false,
    Default = 1,
    Callback = function(value)
        targetPlayerName = value
    end,
})

-- ปุ่มรีเฟรชรายชื่อผู้เล่น
Tabs.AimBot:AddButton({
    Title = "รีเฟรชผู้เล่น",
    Description = "กดเพื่ออัปเดตรายชื่อผู้เล่นในเซิร์ฟเวอร์",
    Callback = function()
        playerDropdown:SetValues(getPlayerNames())
        -- ถ้าผู้เล่นเป้าหมายหายไป ให้เคลียร์ค่า
        if targetPlayerName and not Players:FindFirstChild(targetPlayerName) then
            targetPlayerName = nil
            playerDropdown:SetValue(nil)
        end
    end
})

-- อัปเดตรายชื่อผู้เล่นเมื่อมีคนเข้าหรือออกเซิร์ฟเวอร์อัตโนมัติ
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

-- Toggle เปิด/ปิด AIM BOT
Tabs.AimBot:AddToggle("AimBotToggle", {
    Title = "เปิด/ปิด AIM BOT",
    Default = false,
}):OnChanged(function(state)
    aimBotEnabled = state
end)

-- ฟังก์ชันล็อกกล้องตามเป้าหมาย
RunService.RenderStepped:Connect(function()
    if aimBotEnabled and targetPlayerName then
        local targetPlayer = Players:FindFirstChild(targetPlayerName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = targetPlayer.Character.HumanoidRootPart.Position
            local camPos = Camera.CFrame.Position
            local direction = (targetPos - camPos).Unit
            local newCFrame = CFrame.new(camPos, camPos + direction)
            Camera.CFrame = newCFrame
        end
    end
end)

-- ตั้งค่าระบบ Save/Interface
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("ZenXHub")
SaveManager:SetFolder("ZenXHub/AimBot")
InterfaceManager:BuildInterfaceSection(Tabs.AimBot)
SaveManager:BuildConfigSection(Tabs.AimBot)
Window:SelectTab(1)

Fluent:Notify({
    Title = "ZEN X HUB",
    Content = "Aim Bot พร้อมใช้งาน",
    Duration = 6
})

SaveManager:LoadAutoloadConfig()

-- ปุ่มเปิด/ปิด UI แบบลากได้ สำหรับมือถือ
local CoreGui = game:GetService("CoreGui")
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 30, 0, 30)
toggleBtn.Position = UDim2.new(0, 20, 0, 120)
toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggleBtn.Text = "AB"
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
