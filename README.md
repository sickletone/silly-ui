# 💎 "Like Neverlose" UI Library for Roblox

A modern, highly customizable, and optimized UI Library for Roblox scripts. Featuring a clean aesthetic inspired by Neverlose V2, smooth animations, a robust configuration system, and advanced features like DPI scaling and a draggable event logger.

![Lua](https://img.shields.io/badge/Language-Lua-blue) ![Platform](https://img.shields.io/badge/Platform-Roblox-red) ![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Features

*   **Modern Design:** Clean dark theme with customizable accents and gradients.
*   **Smooth Animations:** All interactions are tweened for a premium feel.
*   **DPI Scaling:** Built-in "Menu Scale" support (0.5x to 1.5x) for 4K monitors or small screens.
*   **Advanced Logger:**
    *   Draggable log container with "Smart Snapping" to the center of the screen.
    *   Auto-sizing logs based on text length.
    *   Stacking animations.
*   **Nested Elements:** Support for placing Colorpickers and Keybinds *inside* Toggles.
*   **Sub Tabs:** Pages can contain a sub tab bar, each with its own columns and sections.
*   **Config Manager:** Create, load, overwrite, delete, refresh, auto-load, and import/export configs through the clipboard.
*   **Window Resizing:** Drag any edge or the bottom-right corner grip, with an optional Auto Resize mode.
*   **Molto Icons:** Use icons from Lucide, Tabler, Heroicons, Phosphor, Fluent, Solar and Material for tabs and sections.
*   **Editable Sliders:** Double-click a slider value to type an exact number.
*   **Config System:** Built-in Save/Load system using `writefile`/`readfile`.
*   **Element Features:**
    *   Multi-select Dropdowns with search.
    *   Colorpickers with Alpha (transparency) support.
    *   Keybinds with Toggle/Hold/Always modes.

## 🚀 Getting Started

### Installation
Load the library into your script using `loadstring`.

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/sickletone/silly-ui/refs/heads/main/source/library.lua"))()
```

### Basic Setup
Here is a quick example of how to set up a window, a tab, and a section. See [example.lua](example.lua) for a full showcase of every component.

```lua
local Window = Library:Window({
    Name = "Cheat Name",
    SubName = "Best script ever",
    Logo = "123456789", -- Roblox Asset ID
    MenuKeybind = Enum.KeyCode.End
})

local Page = Window:Page({Name = "Ragebot", Icon = "lucide:crosshair"})
local Section = Page:Section({Name = "Main Settings", Icon = "lucide:settings", Side = 1}) -- Side 1 (Left) or 2 (Right)
```

---

## 📚 Documentation & API

### 1. Toggles
Toggles are the core of the library. They support sub-options (nesting).

```lua
local MyToggle = Section:Toggle({
    Name = "Silent Aim",
    Flag = "SilentAim", -- Unique identifier for Configs
    Default = false,
    Callback = function(Value)
        print("Silent Aim is now:", Value)
    end
})
```

#### Nested Elements (Sub-Options)
You can add elements *inside* a toggle. They will appear when the toggle is expanded.

```lua
-- Add a Slider inside the Toggle
MyToggle:Slider({
    Name = "FOV Radius",
    Min = 0, Max = 360, Default = 180
})

-- Add a Dropdown inside the Toggle
MyToggle:Dropdown({
    Name = "Hitbox",
    Items = {"Head", "Torso"},
    Default = "Head"
})
```

### 2. Sliders
Sliders allow selecting a number within a range.

```lua
local MySlider = Section:Slider({
    Name = "Walkspeed",
    Flag = "WS_Slider",
    Min = 16,
    Max = 200,
    Default = 16,
    Decimals = 1, -- 0 for integers, 1 for 0.5, etc.
    Suffix = " studs",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})
```

**Tip:** Double-click (or double-tap) the value on the right side of a slider to type an exact value instead of dragging.

### 3. Dropdowns
Dropdowns support single and multi-selection, as well as searching.

```lua
local MyDropdown = Section:Dropdown({
    Name = "Target Selection",
    Flag = "Target_Drop",
    Items = {"Player", "NPC", "Boss", "Ally"},
    Default = "Player", -- Use {"Player", "NPC"} for Multi
    Multi = false, -- Set to true for multiple selection
    Callback = function(Value)
        print("Selected:", Value)
    end
})
```

#### Updating Dropdowns
You can update the list of items or the selected value dynamically.

```lua
-- Refresh the list
MyDropdown:Refresh({"New Item 1", "New Item 2"}, "New Item 1")

-- Set a specific value programmatically
MyDropdown:Set("New Item 2")
```

### 4. Colorpickers & Keybinds
These can be added as standalone sections or attached to other elements.

```lua
-- Standalone
Section:Colorpicker({
    Name = "ESP Color",
    Flag = "ESP_Color",
    Default = Color3.fromRGB(255, 0, 0),
    Alpha = 1, -- Transparency (0-1)
    Callback = function(Color, Alpha) ... end
})

Section:Keybind({
    Name = "Triggerbot Key",
    Flag = "Trigger_Bind",
    Default = Enum.KeyCode.E,
    Mode = "Hold", -- "Toggle", "Hold", or "Always"
    Callback = function(State) ... end
})

-- Attached to a Toggle
MyToggle:Colorpicker({ Default = Color3.new(1,1,1) })
MyToggle:Keybind({ Default = Enum.KeyCode.X })
```

### 5. Icons
Tabs (pages), sections and buttons accept icons from the [Molto icon registry](https://molto.pages.dev/icons). Use `"provider:name"`, an icon table, or a normal Roblox asset id.

```lua
Library:SetIconProvider("lucide") -- Default provider for icons without a prefix

local Combat = Window:Page({Name = "Combat", Icon = "lucide:crosshair"})
local Aimbot = Combat:Section({Name = "Aimbot", Icon = "phosphor:gear"})

-- Every provider works:
-- lucide | tabler | heroicons | phosphor | fluent | solar | material
local Visuals = Window:Page({
    Name = "Visuals",
    Icon = { Provider = "tabler", Name = "eye" }
})

-- You can change an icon at any time:
Combat:SetIcon("heroicons:fire")
Aimbot:SetIcon("material:swords")

-- Roblox asset ids are still supported
Window:Page({Name = "Legacy", Icon = "1234567890"})
```

Icons are loaded lazily through [Molto](https://github.com/notpoiu/Molto), so the first icon of each provider is downloaded on demand. If the executor cannot load Molto, numeric asset ids keep working as before.

### 6. Sub Tabs
Sub tabs render in a bar at the top of a page and keep their own columns and sections. Create one with `Page:SubTab(...)` and add sections through it.

```lua
local Combat = Window:Page({Name = "Combat", Icon = "lucide:crosshair"})

local AimbotTab = Combat:SubTab({Name = "Aimbot", Icon = "lucide:target"})
local WeaponsTab = Combat:SubTab({Name = "Weapons", Icon = "lucide:sword"})

-- Each sub tab has its own left/right columns
AimbotTab:Section({Name = "Aimbot", Icon = "lucide:crosshair", Side = 1})
WeaponsTab:Section({Name = "Weapons", Icon = "lucide:sword", Side = 2})

-- Sub tab icons can be changed at any time
AimbotTab:SetIcon("phosphor:crosshair")
```

If a page has sub tabs, `Page:Section(...)` automatically creates the section on the currently selected sub tab.

---

## 🖥️ Event Logger

The library includes a built-in event logger that appears on the screen. It features a draggable bar that snaps to the center of the screen.

**How to enable:**
You must enable the logger in your script before sending logs.

```lua
Library.LogsEnabled = true -- Required to show the panel
```

**Sending Logs:**
```lua
-- Library:Log(Text, Duration, Color)
Library:Log("Config Loaded", 5, Color3.fromRGB(0, 255, 0))
Library:Log("Target missed", 3, Color3.fromRGB(255, 0, 0))
```

---

## ⚙️ Settings & Configs

To add the built-in Settings page (which includes the config manager, watermark toggle, keybind list toggle and auto resize toggle), simply call:

```lua
Library:CreateSettingsPage(Window)
```

### Config Manager
The Settings page ships with a full config manager:

*   **Name** field for the config file.
*   **Create**, **Load**, **Overwrite**, **Delete** and **Refresh List**.
*   **Set Auto Load** / **Remove Auto Load** — the chosen config is loaded automatically when the Settings page is created.
*   **Export to Clipboard** / **Import from Clipboard** — copies the config JSON out and writes a pasted config back.

Configs are plain JSON files in `Library.Folders.Configs`. The same actions are available from code:

```lua
Library:GetConfig()                     -- JSON string of every flag
Library:LoadConfig(ReadFile(path))      -- load JSON
Library:DeleteConfig("myconfig.json")
Library:RefreshConfigsList(dropdown)

Library:SetAutoLoadConfig("myconfig.json")
Library:GetAutoLoadConfig()
Library:ClearAutoLoadConfig()
Library:LoadAutoLoadConfig()            -- also called at the end of CreateSettingsPage

Library:SetClipboard(Library:GetConfig())
Library:GetClipboard()
```

### Menu Scale
The library supports DPI scaling. Users can change this in the Settings page, or you can set it programmatically:

```lua
-- Values: 0.5, 0.75, 1, 1.25, 1.5
Library.CurrentScale = 1.25 
-- You must trigger a refresh on objects if setting manually, 
-- so it is recommended to use the built-in Settings Page dropdown.
```

---

## 🪟 Window Resizing & Auto Resize

Drag any edge of the window, or the three-line **corner grip** in the bottom-right corner, to resize it. The grip follows the mouse/touch instantly and stops at the minimum size.

```lua
-- Double-click the corner grip to restore the default 677x644 size.
Window:SetSize(800, 600)      -- Resize programmatically (tweened)
Window:GetSize()              -- Current size as a Vector2
Window:SetAutoResize(false)   -- Stop the window from fitting itself to the screen
Window:FitToViewport()        -- Shrink/re-center the window inside the current screen
```

Auto Resize is enabled by default: when the game window or device orientation changes, the window is shrunk (never below the minimum size) so it stays on screen. Disable it per window with `AutoResize = false`, or from the Settings page toggle.

---

## 🔄 Updating Values Programmatically

If you need to change the state of a UI element from your script (not by user click), use the `:Set()` method on the object returned when you created the element.

**Toggle:**
```lua
local Toggle = Section:Toggle(...)
Toggle:Set(true) -- Turns it on
```

**Slider:**
```lua
local Slider = Section:Slider(...)
Slider:Set(50) -- Sets value to 50
```

**Dropdown:**
```lua
local Dropdown = Section:Dropdown(...)
Dropdown:Set("Option 1") -- Selects Option 1
```

---

## 🛡️ Unloading

To safely unload the UI (hide it and stop connections) without triggering anti-cheats (by avoiding `Destroy` on CoreGui), use:

```lua
Library:Unload()
```

---

## 📝 Full Example Script

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/sickletone/silly-ui/refs/heads/main/source/library.lua"))()

-- Enable Logs
Library.LogsEnabled = true

local Window = Library:Window({
    Name = "Project Nova",
    SubName = "Release Build",
    Logo = "123456789",
    MenuKeybind = Enum.KeyCode.RightShift
})

local MainTab = Window:Page({Name = "Combat", Icon = "lucide:crosshair"})
local MainSection = MainTab:Section({Name = "Aimbot", Icon = "lucide:sword", Side = 1})

-- Icons can be swapped at any time; see https://molto.pages.dev/icons
MainTab:SetIcon("phosphor:crosshair")
MainSection:SetIcon("tabler:sword")

local AimToggle = MainSection:Toggle({
    Name = "Enabled",
    Flag = "AimEnabled",
    Default = false,
    Callback = function(v)
        if v then 
            Library:Log("Aimbot Enabled", 3)
        end
    end
})

-- Nested Slider
AimToggle:Slider({
    Name = "FOV",
    Min = 0, Max = 180, Default = 90
})

-- Nested Dropdown
AimToggle:Dropdown({
    Name = "Hitbox",
    Items = {"Head", "Torso", "Legs"},
    Default = "Head"
})

-- Create Settings Page (Configs, Scale, etc.)
Library:CreateSettingsPage(Window)
```
