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
local autoHarvest = false
local selectedSeed = "Carrot"

Tabs.Main:AddToggle("AutoSell", {
    Title = "Auto Sell",
    Default = false
}):OnChanged(function(value)
    autoSell = value
    while autoSell do
        local sell = workspace:FindFirstChild("Sell")
        if sell and game.Players.LocalPlayer.Character then
            firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"), sell, 0)
            task.wait(0.1)
            firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"), sell, 1)
        end
        task.wait(2)
    end
end)

Tabs.Main:AddToggle("AutoHarvest", {
    Title = "Auto Harvest",
    Default = false
}):OnChanged(function(value)
    autoHarvest = value
    while autoHarvest do
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "ClickDetector" and v.Parent and v.Parent.Name == "Plant" then
                fireclickdetector(v)
            end
        end
        task.wait(2)
    end
end)

Tabs.Main:AddDropdown("SeedList", {
    Title = "Auto Buy Seed",
    Values = {"Carrot", "Corn", "Tomato", "Pumpkin"},
    Multi = false,
    Default = 1,
    Callback = function(val)
        selectedSeed = val
    end
})

Tabs.Main:AddToggle("AutoBuySeed", {
    Title = "Auto Buy Selected Seed",
    Default = false
}):OnChanged(function(val)
    while val do
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BuyItem"):FireServer(selectedSeed)
        task.wait(2)
    end
end)

Tabs.Main:AddButton({
    Title = "Boost FPS",
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
