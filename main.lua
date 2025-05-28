local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "ZEN X HUB",
    SubTitle = "Grow A Garden Script",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main" }),
    Settings = Window:AddTab({ Title = "Settings" })
}

local autoSell = false
local autoBuy = false

Tabs.Main:AddToggle("AutoSell", {
    Title = "Auto Sell",
    Default = false
}):OnChanged(function(value)
    autoSell = value
    while autoSell do
        local sell = workspace:FindFirstChild("Sell")
        if sell then
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, sell, 0)
            wait(0.2)
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, sell, 1)
        end
        task.wait(2)
    end
end)

Tabs.Main:AddToggle("AutoBuy", {
    Title = "Auto Buy Seed",
    Default = false
}):OnChanged(function(value)
    autoBuy = value
    while autoBuy do
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BuyItem"):FireServer("Seed")
        task.wait(2)
    end
end)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("ZenXHub")
SaveManager:SetFolder("ZenXHub/GrowAGarden")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
Fluent:Notify({ Title = "ZEN X HUB", Content = "Script Loaded", Duration = 8 })
SaveManager:LoadAutoloadConfig()
