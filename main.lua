-- โหลด Fluent UI และ Addons local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))() local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))() local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- สร้างหน้าต่างหลัก ZEN X HUB local Window = Fluent:CreateWindow({ Title = "ZEN X HUB", SubTitle = "Grow A Garden Script by Tanongtuay", TabWidth = 160, Size = UDim2.fromOffset(580, 460), Acrylic = true, Theme = "Dark", MinimizeKey = Enum.KeyCode.LeftControl })

-- แท็บหลัก local Tabs = { Garden = Window:AddTab({ Title = "Main", Icon = "leaf" }), Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }) }

-- ปุ่ม Auto Sell Tabs.Garden:AddToggle("AutoSell", { Title = "Auto Sell", Default = false }):OnChanged(function(state) _G.AutoSell = state end)

-- ปุ่ม Auto Buy Seed Tabs.Garden:AddToggle("AutoBuySeed", { Title = "Auto Buy Seed", Default = false }):OnChanged(function(state) _G.AutoBuySeed = state end)

-- ตั้งค่าระบบ Save/Interface SaveManager:SetLibrary(Fluent) InterfaceManager:SetLibrary(Fluent) SaveManager:IgnoreThemeSettings() SaveManager:SetIgnoreIndexes({}) InterfaceManager:SetFolder("ZenXHub") SaveManager:SetFolder("ZenXHub/GrowAGarden") InterfaceManager:BuildInterfaceSection(Tabs.Settings) SaveManager:BuildConfigSection(Tabs.Settings) Window:SelectTab(1)

-- แจ้งเตือนเมื่อโหลดเสร็จ Fluent:Notify({ Title = "ZEN X HUB", Content = "Script Loaded Successfully", Duration = 6 })

SaveManager:LoadAutoloadConfig()

-- ระบบทำงานหลัก local RunService = game:GetService("RunService") RunService.RenderStepped:Connect(function() if _G.AutoSell then for _, v in pairs(workspace:GetDescendants()) do if v.Name == "SellBox" and v:FindFirstChild("ClickDetector") then fireclickdetector(v.ClickDetector) end end end

if _G.AutoBuySeed then
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "SeedSeller" and v:FindFirstChild("ClickDetector") then
            fireclickdetector(v.ClickDetector)
        end
    end
end

end)

