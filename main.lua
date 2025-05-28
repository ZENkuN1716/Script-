--== Loader UI ==--
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local UICorner = Instance.new("UICorner", Frame)
local UIStroke = Instance.new("UIStroke", Frame)
local UIGradient = Instance.new("UIGradient", Frame)
local Spinner = Instance.new("ImageLabel", Frame)
local ProgressBarBG = Instance.new("Frame", Frame)
local ProgressBar = Instance.new("Frame", ProgressBarBG)
local TextLabel = Instance.new("TextLabel", Frame)

ScreenGui.ResetOnSpawn = false
Frame.Size = UDim2.new(0, 400, 0, 180)
Frame.Position = UDim2.new(0.5, -200, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
}

Spinner.Size = UDim2.new(0, 40, 0, 40)
Spinner.Position = UDim2.new(0.5, -20, 0, 10)
Spinner.BackgroundTransparency = 1
Spinner.Image = "rbxassetid://12820402706"

ProgressBarBG.Size = UDim2.new(0.8, 0, 0, 10)
ProgressBarBG.Position = UDim2.new(0.1, 0, 0.7, 0)
ProgressBarBG.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ProgressBar.Parent = ProgressBarBG

TextLabel.Size = UDim2.new(1, 0, 0, 50)
TextLabel.Position = UDim2.new(0, 0, 1, -50)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "ZEN X HUB กำลังโหลด..."
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.Font = Enum.Font.GothamBold

--== Animation ==--
local TweenService = game:GetService("TweenService")
TweenService:Create(Spinner, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
	Rotation = 360
}):Play()

TweenService:Create(ProgressBar, TweenInfo.new(2), {
	Size = UDim2.new(1, 0, 1, 0)
}):Play()

wait(2.5)
ScreenGui:Destroy()

--== Load Fluent ==--
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
	Title = "ZEN X HUB",
	SubTitle = "Blox Fruits Script by Tanongtuay",
	TabWidth = 160,
	Size = UDim2.fromOffset(580, 460),
	Acrylic = true,
	Theme = "Dark",
	MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
	AutoFarm = Window:AddTab({ Title = "⚔️ AutoFarm", Icon = "swords" }),
	Teleport = Window:AddTab({ Title = "🌍 Teleport", Icon = "map" }),
	Misc = Window:AddTab({ Title = "🧰 Misc", Icon = "package" }),
	Settings = Window:AddTab({ Title = "⚙️ Settings", Icon = "settings" })
}

--== ปุ่ม UI เปิดปิด ==--
local toggleBtn = Instance.new("TextButton", game:GetService("CoreGui"))
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(0, 20, 0, 120)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleBtn.Text = "≡"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 20
toggleBtn.Active = true
toggleBtn.Draggable = true

local corner = Instance.new("UICorner", toggleBtn)
corner.CornerRadius = UDim.new(0, 8)

toggleBtn.MouseButton1Click:Connect(function()
	Window.Minimized = not Window.Minimized
end)

--== เมนูหลัก ==--
Tabs.AutoFarm:AddButton({
	Title = "เริ่มฟาร์ม LV",
	Description = "ระบบจะเริ่มฟาร์มตามเลเวลอัตโนมัติ",
	Callback = function()
		print("AutoFarm Started")
	end
})

Tabs.AutoFarm:AddDropdown("SelectEnemy", {
	Title = "เลือกศัตรู",
	Values = {"Bandit", "Monkey", "Gorilla"},
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
	print("Auto Quest Toggled:", Fluent.Options.AutoQuest.Value)
end)

Tabs.Teleport:AddButton({
	Title = "วาร์ปไปเกาะต่อไป",
	Description = "ใช้สำหรับเปลี่ยนเกาะฟาร์มเมื่อถึงเลเวลที่กำหนด",
	Callback = function()
		print("Teleporting to next island")
	end
})

Tabs.Misc:AddParagraph({
	Title = "ZEN X HUB",
	Content = "ระบบของเรายังอยู่ระหว่างการพัฒนา ขอบคุณที่ใช้งาน!"
})

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("ZenXHub")
SaveManager:SetFolder("ZenXHub/BloxFruits")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
Fluent:Notify({
	Title = "ZEN X HUB",
	Content = "Script ได้โหลดแล้ว พร้อมใช้งาน",
	Duration = 8
})
SaveManager:LoadAutoloadConfig()
