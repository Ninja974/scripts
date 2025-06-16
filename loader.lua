-- Loader
local executor = identifyexecutor()
local client = game.Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")

GuiService.ErrorMessageChanged:Connect(function()
    TeleportService:Teleport(5956785391, client)
end)

local fixeable = {
    "Solara",
    "Xeno"
}

if table.find(fixeable, executor) then
    local Library = loadstring(game:HttpGetAsync("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    local modules = "https://raw.githubusercontent.com/cloudman4416/GamesModules/refs/heads/main/Project_Slayer/"
    Library:Notify({
        Title = "Attention",
        Content = `Enabling {executor} Support (Script Might Take Longer Than Usual To Load)`,
        Duration = 5
    })
    getgenv().require = function(obj: LocalScript | ModuleScript)
        local succ, ret = pcall(function()
            return loadstring(decompile(obj))()
        end)
        if succ then
            return ret
        else
            local url = string.gsub(`{modules}{obj:GetFullName()}.lua`, " ", "%%20")
            return loadstring(game:HttpGet(url))()
        end
    end
end

local baseUrl = "https://raw.githubusercontent.com/Ninja974/scripts/refs/heads/main/" .. game.PlaceId .. ".lua"
local base64url = "https://api.github.com/repos/Ninja974/scripts/contents/" .. game.PlaceId .. ".lua?ref=main"

if base64 and base64.decode then
    local succ, err = pcall(function()
        local response = game:HttpGet(base64url)
        local data = HttpService:JSONDecode(response)
        local base64decoded = base64.decode(data.content:gsub("\n", ""))
        loadstring(base64decoded)()
    end)
    if not succ then
        print(err)
        pcall(function()
            loadstring(game:HttpGet(baseUrl))()
        end)
    end
else
    local succ, err = pcall(function()
        loadstring(game:HttpGet(baseUrl))()
    end)
    if not succ then
        print(err)
    end
end
