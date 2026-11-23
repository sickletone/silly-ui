local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/sickletone/silly-ui/refs/heads/main/source/library.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Folders used by the config system
Library.Folders = {
    Directory = "SillyUI",
    Configs = "SillyUI/Configs",
    Assets = "SillyUI/Assets",
}

-- Theme
local Accent = Color3.fromRGB(255, 80, 80)
local Gradient = Color3.fromRGB(120, 20, 20)

Library.Theme.Accent = Accent
Library.Theme.AccentGradient = Gradient
Library:ChangeTheme("Accent", Accent)
Library:ChangeTheme("AccentGradient", Gradient)

-- Default icon provider for icons written without a prefix (https://molto.pages.dev/icons)
Library:SetIconProvider("lucide")

-- Window
local Window = Library:Window({
    Name = "Silly UI",
    SubName = "Full component showcase",
    Logo = "120959262762131", -- Roblox asset id
    MenuKeybind = Enum.KeyCode.Insert,
    AutoResize = true, -- Keeps the window inside the viewport (toggle in Settings too)
})

-- Keybind list and watermark
local KeybindList = Library:KeybindList("Keybinds")

Library:Watermark({
    "Silly UI",
    "by sickletone",
    120959262762131,
})

Library.WatermarkFrame.Instance.Visible = true

task.spawn(function()
    while true do
        local FPS = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())

        Library:Watermark({
            "Silly UI",
            "by sickletone",
            120959262762131,
            "FPS: " .. FPS,
        })

        task.wait(0.5)
    end
end)

Window:Category("Main")

--[[
    Combat page
    This page uses sub tabs. Each sub tab has its own columns and sections.
]]
local CombatPage = Window:Page({
    Name = "Combat",
    Icon = "lucide:crosshair",
})

local AimbotSubTab = CombatPage:SubTab({
    Name = "Aimbot",
    Icon = "lucide:target",
})

local WeaponsSubTab = CombatPage:SubTab({
    Name = "Weapons",
    Icon = "lucide:sword",
})

-- Icons can be changed at any time, including sub tabs
-- AimbotSubTab:SetIcon("phosphor:crosshair")
-- CombatPage:SetIcon("heroicons:fire")

-- Aimbot sub tab
local AimbotSection = AimbotSubTab:Section({
    Name = "Aimbot",
    Description = "Silent aim settings",
    Icon = "lucide:crosshair",
    Side = 1,
})

local AimbotToggle = AimbotSection:Toggle({
    Name = "Enabled",
    Flag = "AimbotEnabled",
    Default = true,
    Callback = function(Value)
        print("Aimbot:", Value)
    end,
})

-- Colorpicker nested inside a toggle
AimbotToggle:Colorpicker({
    Name = "FOV Color",
    Flag = "AimbotColor",
    Default = Color3.fromRGB(255, 80, 80),
    Callback = function(Color, Alpha)
        print("Aimbot color:", Color, Alpha)
    end,
})

AimbotSection:Keybind({
    Name = "Aimbot Key",
    Flag = "AimbotBind",
    Default = Enum.KeyCode.Q,
    Mode = "Hold",
    Callback = function(State)
        print("Aimbot key:", State)
    end,
})

AimbotSection:Slider({
    Name = "FOV Radius",
    Flag = "AimbotFOV",
    Min = 0,
    Max = 360,
    Default = 120,
    Suffix = "°",
    Callback = function(Value)
        print("FOV:", Value)
    end,
})

AimbotSection:Dropdown({
    Name = "Hitbox",
    Flag = "AimbotHitbox",
    Items = {"Head", "Torso", "Arms", "Legs"},
    Default = "Head",
    Multi = false,
    Callback = function(Value)
        print("Hitbox:", Value)
    end,
})

AimbotSection:Button({
    Name = "Reset Aimbot",
    Icon = "lucide:rotate-ccw",
    Callback = function()
        Library:Notification({
            Title = "Aimbot",
            Description = "Settings were reset!",
            Duration = 4,
            Icon = "lucide:bell",
        })
    end,
})

-- Targeting sub tab section
local TargetingSection = AimbotSubTab:Section({
    Name = "Targeting",
    Description = "Who to aim at",
    Icon = "lucide:users",
    Side = 2,
})

TargetingSection:Dropdown({
    Name = "Target Teams",
    Flag = "TargetTeams",
    Items = {"Enemies", "Neutrals", "Allies"},
    Default = {"Enemies"},
    Multi = true,
    Callback = function(Value)
        print("Teams:", table.concat(Value, ", "))
    end,
})

TargetingSection:Textbox({
    Name = "Priority Name",
    Flag = "TargetName",
    Placeholder = "Player name...",
    Callback = function(Value)
        print("Priority target:", Value)
    end,
})

TargetingSection:Listbox({
    Name = "Target Mode",
    Flag = "TargetMode",
    Items = {"Closest", "Lowest Health", "Most Visible"},
    Default = "Closest",
    Callback = function(Value)
        print("Target mode:", Value)
    end,
})

-- Weapons sub tab
local WeaponSection = WeaponsSubTab:Section({
    Name = "Weapon",
    Icon = "lucide:sword",
    Side = 1,
})

WeaponSection:Slider({
    Name = "Smoothing",
    Flag = "WeaponSmoothing",
    Min = 0,
    Max = 100,
    Default = 35,
    Suffix = "%",
})

WeaponSection:Dropdown({
    Name = "Weapon",
    Flag = "WeaponChoice",
    Items = {"Rifle", "Shotgun", "Sniper", "Pistol"},
    Default = "Rifle",
})

WeaponSection:Keybind({
    Name = "Rapid Fire",
    Flag = "RapidFireBind",
    Default = Enum.KeyCode.E,
    Mode = "Toggle",
})

local WeaponExtras = WeaponsSubTab:Section({
    Name = "Extras",
    Icon = "lucide:sparkles",
    Side = 2,
})

WeaponExtras:Toggle({
    Name = "Auto Reload",
    Flag = "AutoReload",
    Default = true,
})

WeaponExtras:Label("Tracer Color"):Colorpicker({
    Name = "Tracer",
    Flag = "TracerColor",
    Default = Color3.fromRGB(80, 200, 255),
})

WeaponExtras:Button({
    Name = "Print State",
    Icon = "lucide:terminal",
    Callback = function()
        print("Aimbot:", Library.Flags["AimbotEnabled"])
        print("Weapon:", Library.Flags["WeaponChoice"])
    end,
})

--[[
    Visuals page
    A regular page (no sub tabs), showing page-level sections in both columns.
]]
local VisualsPage = Window:Page({
    Name = "Visuals",
    Icon = "lucide:eye",
})

local EspSection = VisualsPage:Section({
    Name = "ESP",
    Description = "Player visuals",
    Icon = "lucide:scan-eye",
    Side = 1,
})

local EspToggle = EspSection:Toggle({
    Name = "Player ESP",
    Flag = "PlayerESP",
    Default = true,
})

EspToggle:Colorpicker({
    Name = "ESP Color",
    Flag = "ESPColor",
    Default = Color3.fromRGB(255, 80, 80),
})

EspSection:Keybind({
    Name = "ESP Toggle",
    Flag = "ESPBind",
    Default = Enum.KeyCode.X,
    Mode = "Toggle",
})

EspSection:Slider({
    Name = "Max Distance",
    Flag = "ESPDistance",
    Min = 0,
    Max = 5000,
    Default = 1000,
    Suffix = " studs",
})

EspSection:Dropdown({
    Name = "Box Style",
    Flag = "ESPBoxStyle",
    Items = {"2D", "3D", "Corner"},
    Default = "Corner",
})

local WorldSection = VisualsPage:Section({
    Name = "World",
    Description = "Environment settings",
    Icon = "lucide:globe",
    Side = 2,
})

WorldSection:Toggle({
    Name = "Fullbright",
    Flag = "Fullbright",
    Default = false,
})

WorldSection:Slider({
    Name = "Field of View",
    Flag = "CameraFOV",
    Min = 70,
    Max = 120,
    Default = 70,
})

WorldSection:Label("Sky Tint"):Colorpicker({
    Name = "Sky",
    Flag = "SkyColor",
    Default = Color3.fromRGB(45, 100, 200),
})

WorldSection:Keybind({
    Name = "Freecam",
    Flag = "FreecamBind",
    Default = Enum.KeyCode.F,
    Mode = "Toggle",
})

--[[
    Misc page
    Textbox, listbox, buttons, labels and notifications.
]]
local MiscPage = Window:Page({
    Name = "Misc",
    Icon = "lucide:wrench",
})

local UtilitySection = MiscPage:Section({
    Name = "Utility",
    Icon = "lucide:settings-2",
    Side = 1,
})

UtilitySection:Textbox({
    Name = "Custom Text",
    Flag = "CustomText",
    Placeholder = "Type something...",
    Callback = function(Value)
        print("Textbox:", Value)
    end,
})

UtilitySection:Listbox({
    Name = "Preset",
    Flag = "MiscPreset",
    Items = {"Default", "Aggressive", "Stealth"},
    Default = "Default",
})

UtilitySection:Button({
    Name = "Send Notification",
    Icon = "lucide:bell",
    Callback = function()
        Library:Notification({
            Title = "Silly UI",
            Description = "This is a notification component.",
            Duration = 5,
            Icon = "lucide:bell",
        })
    end,
})

UtilitySection:Button({
    Name = "Toggle ESP From Code",
    Icon = "lucide:code",
    Callback = function()
        local Current = Library.Flags["PlayerESP"]
        Library.SetFlags["PlayerESP"](not Current)
    end,
})

local InfoSection = MiscPage:Section({
    Name = "Info",
    Description = "Everything is customizable",
    Icon = "lucide:info",
    Side = 2,
})

InfoSection:Label("Label component")

InfoSection:Toggle({
    Name = "Streamer Mode",
    Flag = "StreamerMode",
    Default = false,
    Callback = function(Value)
        print("Streamer mode:", Value)
    end,
})

InfoSection:Dropdown({
    Name = "Language",
    Flag = "Language",
    Items = {"English", "Spanish", "German", "French"},
    Default = "English",
})

InfoSection:Keybind({
    Name = "Panic Key",
    Flag = "PanicBind",
    Default = Enum.KeyCode.Delete,
    Mode = "Always",
    Callback = function(State)
        print("Panic:", State)
    end,
})

--[[
    Chat page
    Shows the global chat component on the left and chat controls on the right.
]]
local ChatPage = Window:Page({
    Name = "Chat",
    Icon = "lucide:message-circle",
})

local Chat = ChatPage:GlobalChat(1)

local ChatAvatar = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=48&h=48"

Chat:SendMessage(ChatAvatar, LocalPlayer.DisplayName, "Welcome to the silly chat!", true)

local ChatSection = ChatPage:Section({
    Name = "Chat Controls",
    Icon = "lucide:send",
    Side = 2,
})

ChatSection:Textbox({
    Name = "Message",
    Flag = "ChatMessage",
    Placeholder = "Type a message...",
})

ChatSection:Button({
    Name = "Send Local Message",
    Icon = "lucide:send",
    Callback = function()
        local Message = Library.Flags["ChatMessage"]

        if Message and Message ~= "" then
            Chat:SendMessage(ChatAvatar, LocalPlayer.DisplayName, Message, true)
        end
    end,
})

ChatSection:Button({
    Name = "Set Status Text",
    Icon = "lucide:activity",
    Callback = function()
        Chat:SetStatusText("Online")
    end,
})

-- Settings page: configs, auto load, import/export and UI toggles
Window:Category("Settings")
local SettingsPage = Library:CreateSettingsPage(Window, KeybindList)

Window:Init()

--[[
    Window resizing API
    Window:SetSize(900, 650)
    Window:GetSize()
    Window:SetAutoResize(false)
    Window:FitToViewport()

    Config API
    Library:GetAutoLoadConfig()
    Library:SetAutoLoadConfig("myconfig.json")
    Library:ClearAutoLoadConfig()
    Library:LoadAutoLoadConfig()

    Clipboard API
    Library:SetClipboard("text")
    Library:GetClipboard()
]]
