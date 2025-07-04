--Lobby
repeat task.wait() until game:IsLoaded()
local Library = loadstring(game:HttpGetAsync("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local options = Library.Options
-- SCRIPT

local client = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

maps = {
    ["Map 1"] = "17387475546";
    ["Map 2"] = "17387482786"
}

-- GUI THINGY

local Window;
if UserInputService.TouchEnabled then
    Window = Library:CreateWindow{
        Title = `FireHubx | Project Slayer`,
        TabWidth = 160,
        Size = UDim2.fromOffset(600, 300);
        Resize = true, -- Resize this ^ Size according to a 1920x1080 screen, good for mobile users but may look weird on some devices
        MinSize = Vector2.new(235, 190),
        Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.RightShift -- Used when theres no MinimizeKeybind
    }
    local ScreenGui = Instance.new("ScreenGui", gethui())
    local Frame = Instance.new("ImageButton", ScreenGui)
    Frame.Size = UDim2.fromOffset(60, 60)
    Frame.Position = UDim2.fromOffset(30, 30)
    Window.Root.Active = true
    Frame.MouseButton1Click:Connect(function()
        Window:Minimize()
    end)
else
    Window = Library:CreateWindow{
        Title = `FireHub | Project Slayer`,
        TabWidth = 160,
        Size = UDim2.fromOffset(830, 525),
        Resize = true, -- Resize this ^ Size according to a 1920x1080 screen, good for mobile users but may look weird on some devices
        MinSize = Vector2.new(470, 380),
        Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.RightShift -- Used when theres no MinimizeKeybind
    }
end

local Tabs = {
    ["Spins"] = Window:AddTab({Title = "Spins", Icon = ""});
    ["Auto Join"] = Window:AddTab({Title = "Auto Join", Icon = ""});
    ["Webhook settings"] = Window:AddTab({Title = "Webhook settings", Icon = ""});
    ["Settings"] = Window:AddTab({Title = "Settings", Icon = "settings"});
}

Tabs["Spins"]:AddButton({
    Title = "Daily Spin";
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("spins_thing_remote"):InvokeServer()
    end
})

Tabs["Spins"]:AddButton({
    Title = "Race Spin";
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("To_Server"):WaitForChild("Handle_Initiate_S_"):InvokeServer("check_can_spin")
        
    end
})

Tabs["Spins"]:AddButton({
    Title = "Unlock Fast Spins";
    Description = "For Clans And Bda Only";
    Callback = function()
        local unlock = Instance.new("Part")
        unlock.Name = "46503236"
        unlock.Parent = client.gamepasses
    end
})

Tabs['Spins']:AddButton({
    Title = 'Spin until u get a Legendary-Supreme Clan';
    Description = 'This will spin until u get ur desired clan or u get out of spins';
    Callback = function()
        local player = game.Players.LocalPlayer
local playerData = game:GetService("ReplicatedStorage"):WaitForChild("Player_Data"):WaitForChild(player.Name)

while true do
    local clan = playerData:WaitForChild("Clan").Value
    if clan == "Kamado" or clan == "Agatsuma" or clan == "Rengoku" or clan == "Uzui" 
    or clan == "Tomioka" or clan == "Hashibira" or clan == "Tokito" or clan == "Soyama"
    or clan == "Kocho" or clan == "Shinazugawa" or clan == "Sabito" or clan == "Tamayo" or clan == "Kuwajima" or clan == "Makamo"then
        break -- Si el clan es cualquiera de estos, se detiene el bucle
    end

    local args = {
        [1] = "check_can_spin"
    }

    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("To_Server"):WaitForChild("Handle_Initiate_S_"):InvokeServer(unpack(args))
    wait(1)
end

print("Clan.. : " .. playerData:WaitForChild("Clan").Value)
})

-- INPUT para que el jugador escriba su clan deseado
Tabs["Spins"]:AddInput("DesiredClan", {
    Title = "Desired Clan",
    Default = "",
    Placeholder = "Write your desired clan here",
    Numeric = false, -- no solo números
    Finished = true -- solo guarda cuando presionás Enter
})

-- BOTÓN para empezar el spin hasta obtener el clan
Tabs["Spins"]:AddButton({
    Title = "Spin Until Desired Clan";
    Description = "Will spin until you get your chosen clan or run out of spins";
    Callback = function()
        local desiredClan = options["DesiredClan"].Value
        if not desiredClan or desiredClan == "" then
            warn("You must write a clan name first.")
            return
        end

        local player = game.Players.LocalPlayer
        local playerData = game:GetService("ReplicatedStorage"):WaitForChild("Player_Data"):WaitForChild(player.Name)

        while true do
            local currentClan = playerData:WaitForChild("Clan").Value
            if currentClan == desiredClan then
                break -- se detiene cuando lo consigue
            end

            local args = {
                [1] = "check_can_spin"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("To_Server"):WaitForChild("Handle_Initiate_S_"):InvokeServer(unpack(args))

            task.wait(1) -- para no saturar el servidor
        end

        print("You got your desired clan: " .. playerData:WaitForChild("Clan").Value)
    end
})


Tabs["Auto Join"]:AddSlider("sSlot", {
    Title = "Slot Chooser",
    Description = "Default is one",
    Default = 1,
    Min = 1,
    Max = 3,
    Rounding = 0,
    Callback = function(Value)
    end
})

Tabs["Auto Join"]:AddInput("iCode", {
    Title = "PSCode",
    Default = nil,
    Placeholder = "Enter private server code",
    Numeric = false, -- Only allows numbers
    Finished = true -- Only calls callback when you press enter
})

Tabs["Auto Join"]:AddDropdown("dMapSelect", {
    Title = "Select Map",
    Values = {"Map 1", "Map 2", "Hub"};
    Default = "Map 2",
    Multi = false,
})

Tabs["Auto Join"]:AddToggle("tAntiJoin", {
    Title = "Anti Join";
    Default = false;
    Description = "Make you not auto join so you can make your configs ",
})

task.spawn(function()
    Window:Dialog({
        Title = "Enable Anti Join",
        Content = "Enable anti join quickly here",
        Buttons = {
            {
                Title = "Confirm",
                Callback = function()
                    options["tAntiJoin"]:SetValue(true)
                end
            },
            {
                Title = "No",
                Callback = function()
                    options["tAntiJoin"]:SetValue(false)
                end
            }
        }
    })
end)

Tabs["Auto Join"]:AddToggle("tAutoJoin", {
    Title = "Auto Join Server";
    Default = false;
    Callback = function(Value)
        task.spawn(function()
            if Value then
                repeat task.wait() until game:IsLoaded()
                workspace.Is_Customization_place:WaitForChild("Slot3")
                print("loaded") 
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Apply_Slot"):InvokeServer(options["sSlot"].Value)
                while task.wait(1) do
                    if not options["tAntiJoin"].Value and options["tAutoJoin"].Value then
                        game:GetService("ReplicatedStorage"):WaitForChild("handle_privateserver"):InvokeServer("join", options["iCode"].Value, tonumber(maps[options["dMapSelect"].Value]))
                    end
                end
            end
        end)
    end
})

SaveManager:SetLibrary(Library)
SaveManager:SetIgnoreIndexes({"tAntiJoin"})
makefolder(`CloudHub/{game.PlaceId}`)
makefolder(`CloudHub/{game.PlaceId}/{client.UserId}`)
SaveManager:SetFolder(`CloudHub/{game.PlaceId}/{client.UserId}`)
SaveManager:BuildConfigSection(Tabs["Settings"])
Tabs["Settings"]:AddToggle("tAutoExec", {
    Title = "Auto Execute Script On Rejoin";
    Default = true;
    Callback = function(Value)
        getgenv().AutoExecCloudy = Value
    end
})
Window:SelectTab(1)

task.wait(3)

SaveManager:LoadAutoloadConfig()
