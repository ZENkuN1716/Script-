-- สร้างหน้าโหลด (Loading Screen)
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- GUI หลัก
local loaderGui = Instance.new("ScreenGui", CoreGui)
loaderGui.IgnoreGuiInset = true
loaderGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
loaderGui.Name = "ZenXLoader"

-- พื้นหลัง
local background = Instance.new("Frame", loaderGui)
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(10, 10, 10)

-- วงกลมหมุน
local spinner = Instance.new("ImageLabel", background)
spinner.Size = UDim2.new(0, 80, 0, 80)
spinner.Position = UDim2.new(0.5, -40, 0.4, -40)
spinner.Image = "rbxassetid://11372950109" -- ไอคอนวงกลมหมุน
spinner.BackgroundTransparency = 1

-- Tween หมุน
task.spawn(function()
	while true do
		TweenService:Create(spinner, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Rotation = spinner.Rotation + 360}):Play()
		task.wait(1)
	end
end)

-- แถบโหลด
local barBG = Instance.new("Frame", background)
barBG.Size = UDim2.new(0.5, 0, 0, 16)
barBG.Position = UDim2.new(0.25, 0, 0.6, 0)
barBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
barBG.BorderSizePixel = 0
barBG:ClearAllChildren()
Instance.new("UICorner", barBG).CornerRadius = UDim.new(0, 8)

local barFill = Instance.new("Frame", barBG)
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(90, 160, 255)
barFill.BorderSizePixel = 0
Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 8)

-- แถบเพิ่มทีละนิด
TweenService:Create(barFill, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
task.wait(3.5)
loaderGui:Destroy()

-- โหลด Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- หน้าต่างหลัก
local Window = Fluent:CreateWindow({
	Title = "ZEN X HUB",
	SubTitle = "Blox Fruits Script by Tanongtuay",
	TabWidth = 160,
	Size = UDim2.fromOffset(580, 460),
	Acrylic = true,
	Theme = "Dark",
	MinimizeKey = Enum.KeyCode.LeftControl
})

-- ปุ่มสี่เหลี่ยมเปิด/ปิด UI
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 36, 0, 36)
toggleBtn.Position = UDim2.new(0, 20, 0, 120)
toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggleBtn.Text = "≡"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 20
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.ZIndex = 9999
toggleBtn.Parent = CoreGui
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

toggleBtn.MouseButton1Click:Connect(function()
	Window.Minimized = not Window.Minimized
end)

-- สร้าง Tab
local Tabs = {
	AutoFarm = Window:AddTab({ Title = "⚔️ AutoFarm", Icon = "swords" }),
	Teleport = Window:AddTab({ Title = "🌍 Teleport", Icon = "map" }),
	Misc = Window:AddTab({ Title = "🧰 Misc", Icon = "package" }),
	Settings = Window:AddTab({ Title = "⚙️ Settings", Icon = "settings" })
}

-- Notify ว่าโหลดเสร็จ
Fluent:Notify({ Title = "ZEN X HUB", Content = "โหลดสำเร็จ! พร้อมใช้งานแล้ว", Duration = 6 })

-- AutoFarm
Tabs.AutoFarm:AddButton({
	Title = "เริ่มฟาร์ม LV",
	Description = "ระบบจะเริ่มฟาร์มตามเลเวลอัตโนมัติ",
	Callback = function()
		print("AutoFarm Started")
	end
})

Tabs.AutoFarm:AddDropdown("SelectEnemy", {
	Title = "เลือกศัตรู",
	Values = { "Bandit", "Monkey", "Gorilla" },
	Multi = false,
	Default = 1,
	Callback = function(Value)
		print("Selected Enemy:", Value)
	end
})

Tabs.AutoFarm:AddToggle("AutoQuest", {
	Title = "รับเควสอัตโนมัติ",
	Default = true
}):OnChanged(function()
	print("Auto Quest:", Fluent.Options.AutoQuest.Value)
end)

-- Teleport
Tabs.Teleport:AddButton({
	Title = "วาร์ปไปเกาะต่อไป",
	Description = "ใช้สำหรับเปลี่ยนเกาะฟาร์มเมื่อถึงเลเวลที่กำหนด",
	Callback = function()
		print("Teleporting...")
	end
})

-- Misc
Tabs.Misc:AddParagraph({ Title = "ZEN X HUB", Content = "ระบบยังพัฒนา ขอบคุณที่ใช้งาน!" })

-- Settings
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("ZenXHub")
SaveManager:SetFolder("ZenXHub/BloxFruits")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()
