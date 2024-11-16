local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Kings Script",
    LoadingTitle = "All Gui Script",
    LoadingSubtitle = "(by King)",
    Theme = "Darker",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "Kings script gui"
    },
    Discord = {
        Enabled = true,
        Invite = "https://discord.gg/DTBaEBp7",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Hello"}
    }
})

-- ESP Variables and Functions
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Visuals = {Players = {}}



-- Drawing Properties - Modified to all white
local DrawingProperties = {
    Square = {
        Thickness = 2,
        Filled = false,
        Color = Color3.fromRGB(255, 255, 255), -- Pure white
        Visible = false,
        Transparency = 1
    }
}

-- ESP Functions
function Visuals:Round(Number, Bracket)
    Bracket = (Bracket or 1)
    if typeof(Number) == "Vector2" then
        return Vector2.new(Visuals:Round(Number.X), Visuals:Round(Number.Y))
    else
        return (Number - Number % (Bracket or 1))
    end
end

function Visuals:GetScreenPosition(Position)
    local Position, Visible = workspace.CurrentCamera:WorldToViewportPoint(Position)
    return Vector2.new(Position.X, Position.Y), Visible, Position
end

function Visuals:CreateDrawing(Type, Custom)
    local Drawing = Drawing.new(Type)
    for Property, Value in pairs(DrawingProperties[Type]) do
        Drawing[Property] = Value
    end
    if Custom then
        for Property, Value in pairs(Custom) do
            Drawing[Property] = Value
        end
    end
    return Drawing
end

-- ESP Player Management
function Visuals.AddPlayer(Player)
    if not Visuals.Players[Player] then
        Visuals.Players[Player] = {
            Boxes = {},
            LastParts = {}
        }
    end
end

function Visuals.RemovePlayer(Player)
    if Visuals.Players[Player] then
        for _, Drawing in pairs(Visuals.Players[Player].Boxes) do
            if Drawing.Main then Drawing.Main:Remove() end
            if Drawing.Outline then Drawing.Outline:Remove() end
        end
        Visuals.Players[Player] = nil
    end
end

-- Player Utility Functions
local PlayerUtilities = {}

function PlayerUtilities:IsPlayerAlive(Player)
    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid")
    return Character and Humanoid and Humanoid.Health > 0
end

-- ESP Toggle State
local ESPEnabled = false

-- Create Tabs
local MainTab = Window:CreateTab("Home", nil)
local MainSection = MainTab:CreateSection("Main")
local MainSection = MainTab:CreateSection("Main")

-- Create Menu Status Label
local MenuStatusLabel = MainTab:CreateLabel("Menu Status: Checking...")

-- Function to check menu components
local function CheckMenuStatus()
    local menuComponents = {
        UserInputService = game:GetService("UserInputService"),
        RunService = game:GetService("RunService"),
        Players = game:GetService("Players"),
        Character = game.Players.LocalPlayer.Character,
    }
    
    -- Check if all components are available
    local allValid = true
    local missingComponents = {}
    
    for name, component in pairs(menuComponents) do
        if not component then
            allValid = false
            table.insert(missingComponents, name)
        end
    end
    
    -- Additional character component checks
    if menuComponents.Character then
        local requiredParts = {"HumanoidRootPart", "Humanoid", "Head"}
        for _, part in ipairs(requiredParts) do
            if not menuComponents.Character:FindFirstChild(part) then
                allValid = false
                table.insert(missingComponents, "Character:" .. part)
            end
        end
    end
    
    -- Update status label with appropriate check mark or X
    if allValid then
        MenuStatusLabel:Set("Menu Status: Working ✅")
        Rayfield:Notify({
            Title = "Menu Status",
            Content = "All menu components are working properly!",
            Duration = 6.5,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Okay!",
                    Callback = function()
                        print("Menu status check completed successfully")
                    end
                },
            },
        })
    else
        MenuStatusLabel:Set("Menu Status: Error ❌")
        local errorMsg = "Missing components: " .. table.concat(missingComponents, ", ")
        Rayfield:Notify({
            Title = "Menu Status Error",
            Content = errorMsg,
            Duration = 6.5,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Got it",
                    Callback = function()
                        print("Menu status check failed: " .. errorMsg)
                    end
                },
            },
        })
    end
end

-- Create Check Menu Status button
local CheckMenuButton = MainTab:CreateButton({
    Name = "Check Menu Status",
    Callback = function()
        MenuStatusLabel:Set("Menu Status: Checking...")
        task.wait(0.5) -- Short delay for visual feedback
        CheckMenuStatus()
    end
})

-- Run initial check when script loads
task.spawn(function()
    task.wait(1) -- Wait for everything to load
    CheckMenuStatus()
end)



local FriendsOnline = 0

-- Count online friends
for _, friend in pairs(LocalPlayer:GetFriendsOnline()) do
    FriendsOnline = FriendsOnline + 1
end

-- Add this right after your Window creation
local FriendsLabel = MainTab:CreateLabel("Friends Online: " .. FriendsOnline)

-- Auto-update the counter every 5 seconds
coroutine.wrap(function()
    while task.wait(5) do
        local NewCount = 0
        for _, friend in pairs(LocalPlayer:GetFriendsOnline()) do
            NewCount = NewCount + 1
        end
        FriendsOnline = NewCount
        FriendsLabel:Set("Friends Online: " .. FriendsOnline)
    end
end)()

-- Add this to track friends joining
Players.PlayerAdded:Connect(function(player)
    if LocalPlayer:IsFriendsWith(player.UserId) then
        Rayfield:Notify({
            Title = "Friend Joined!",
            Content = player.Name .. " has joined your server!",
            Duration = 6.5,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Cool!",
                    Callback = function()
                        print("Friend joined: " .. player.Name)
                    end
                },
            },
        })
    end
end)

-- Add this to track friends already in server
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and LocalPlayer:IsFriendsWith(player.UserId) then
        Rayfield:Notify({
            Title = "Friend In Server!",
            Content = player.Name .. " is currently in your server!",
            Duration = 6.5,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Nice!",
                    Callback = function()
                        print("Friend in server: " .. player.Name)
                    end
                },
            },
        })
    end
end

local function countFriendsInServer()
    local friendCount = 0
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and LocalPlayer:IsFriendsWith(player.UserId) then
            friendCount = friendCount + 1
        end
    end
    return friendCount
end

local FriendsInServerLabel = MainTab:CreateLabel("Friends in Server: " .. countFriendsInServer())

-- Auto-update the counter
Players.PlayerAdded:Connect(function()
    FriendsInServerLabel:Set("Friends in Server: " .. countFriendsInServer())
end)

Players.PlayerRemoving:Connect(function()
    FriendsInServerLabel:Set("Friends in Server: " .. countFriendsInServer())
end)

local MiscsTab = Window:CreateTab("Miscs", nil)
local MiscsSection = MiscsTab:CreateSection("Movement")
local Toggle = MiscsTab:CreateToggle({
    Name = "Hold Infinite Jump",
    CurrentValue = true,
    Flag = "HoldJump",
    Callback = function(Value)
        _G.holdInfJump = Value
        
        if _G.holdJumpStarted == nil then
            _G.holdJumpStarted = true
            
            -- Setup the hold jump functionality
            game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
                if _G.holdInfJump and input.KeyCode == Enum.KeyCode.Space then
                    while _G.holdInfJump and input.KeyCode == Enum.KeyCode.Space and 
                          game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) do
                        local humanoid = game:GetService('Players').LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
                        if humanoid then
                            humanoid:ChangeState('Jumping')
                        end
                        task.wait()
                    end
                end
            end)
        end
    end,
})
local JumpDistanceSlider = MiscsTab:CreateSlider({
    Name = "Jump Distance",
    Range = {50, 500},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = 50,
    Flag = "JumpDistance",
    Callback = function(Value)
        local player = game:GetService('Players').LocalPlayer
        if player.Character and player.Character:FindFirstChild('Humanoid') then
            player.Character.Humanoid.JumpPower = Value
        end
    end,
})
local FloorButton = MiscsTab:CreateButton({
    Name = "Drop to Floor",
    Callback = function()
        local player = game:GetService('Players').LocalPlayer
        local character = player.Character
        
        task.spawn(function()
            if character then
                local humanoid = character:FindFirstChild('Humanoid')
                local rootPart = character:FindFirstChild('HumanoidRootPart')
                if humanoid and rootPart then
                    rootPart.Velocity = Vector3.new(0, 0, 0)
                    local currentPos = rootPart.Position
                    rootPart.CFrame = CFrame.new(currentPos.X, 0, currentPos.Z)
                    task.wait()
                    rootPart.CFrame = CFrame.new(currentPos.X, 3, currentPos.Z)
                end
            end
        end)
    end
})


-- Walkspeed Slider
local Slider = MiscsTab:CreateSlider({
   Name = "Walkspeed Slider",
   Range = {0, 500},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "example",
   Callback = function(Value)
      if Value == 0 then
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
      else
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

-- Players Tab with ESP Toggle
local Tab = Window:CreateTab("Players", nil)
local Section = Tab:CreateSection("Self")


local Toggle = Tab:CreateToggle({
    Name = "Toggle Spin",
    CurrentValue = false,
    Flag = "SpinEnabled",
    Callback = function(Value)
        local character = game.Players.LocalPlayer.Character
        if character then
            if Value then
                local spinForce = Instance.new("BodyAngularVelocity")
                spinForce.Name = "SpinForce"
                spinForce.AngularVelocity = Vector3.new(0, 50, 0)
                spinForce.MaxTorque = Vector3.new(0, math.huge, 0)
                spinForce.Parent = character.HumanoidRootPart
            else
                local spinForce = character.HumanoidRootPart:FindFirstChild("SpinForce")
                if spinForce then spinForce:Destroy() end
            end
        end
    end
})

local Slider = Tab:CreateSlider({
    Name = "Spin Speed",
    Range = {1, 1000},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 50,
    Flag = "SpinSpeed",
    Callback = function(Value)
        local character = game.Players.LocalPlayer.Character
        if character then
            local spinForce = character.HumanoidRootPart:FindFirstChild("SpinForce")
            if spinForce then
                spinForce.AngularVelocity = Vector3.new(0, Value, 0)
            end
        end
    end,
})


local Toggle = Tab:CreateToggle({
    Name = "Ragdoll",
    CurrentValue = false,
    Flag = "LooseJoints",
    Callback = function(Value)
        local character = game.Players.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if Value then
                -- Disable walking and movement
                humanoid.PlatformStand = true
                humanoid.AutoRotate = false
                
                -- Force character to fall
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CFrame = rootPart.CFrame * CFrame.new(0, 0.5, 0) -- Slight lift
                    rootPart.Velocity = Vector3.new(math.random(-10, 10), 5, math.random(-10, 10)) -- Random fall direction
                end
                
                -- Make joints loose
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("Motor6D") and part.Name ~= "Root" and part.Name ~= "Neck" then
                        local constraint = Instance.new("BallSocketConstraint")
                        local a1 = Instance.new("Attachment")
                        local a2 = Instance.new("Attachment")
                        
                        a1.Parent = part.Part0
                        a2.Parent = part.Part1
                        a1.CFrame = part.C0
                        a2.CFrame = part.C1
                        
                        constraint.Parent = part.Part0
                        constraint.Attachment0 = a1
                        constraint.Attachment1 = a2
                        constraint.LimitsEnabled = true
                        constraint.TwistLimitsEnabled = true
                        constraint.UpperAngle = 90
                        
                        part.Enabled = false
                    end
                end
            else
                -- Reset everything
                humanoid.PlatformStand = false
                humanoid.AutoRotate = true
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("Motor6D") then
                        part.Enabled = true
                    end
                    if part:IsA("BallSocketConstraint") or part:IsA("Attachment") then
                        part:Destroy()
                    end
                end
            end
        end
    end
})

--
local Section = Tab:CreateSection("View")
local Toggle = Tab:CreateToggle({
   Name = "ESP",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
      ESPEnabled = Value
   end,
})

-- Initialize ESP
for _, Player in pairs(Players:GetPlayers()) do
    if Player ~= LocalPlayer then
        Visuals.AddPlayer(Player)
    end
end

Players.PlayerAdded:Connect(function(Player)
    Visuals.AddPlayer(Player)
end)

Players.PlayerRemoving:Connect(function(Player)
    Visuals.RemovePlayer(Player)
end)

-- ESP Update Loop
RunService.RenderStepped:Connect(function()
    for _, Player in pairs(Players:GetPlayers()) do
        if Player == LocalPlayer then continue end
        
        local Objects = Visuals.Players[Player]
        if not Objects then continue end

        if ESPEnabled and PlayerUtilities:IsPlayerAlive(Player) then
            local Character = Player.Character
            if not Character then continue end
            
            -- Get all BaseParts in the character
            local CurrentParts = {}
            for _, Part in ipairs(Character:GetDescendants()) do
                if Part:IsA("BasePart") then
                    CurrentParts[Part] = true
                    
                    -- Create box if it doesn't exist - Modified to all white
                    if not Objects.Boxes[Part] then
                        Objects.Boxes[Part] = {
                            Main = Visuals:CreateDrawing("Square", {
                                Color = Color3.fromRGB(255, 255, 255), -- Pure white for main box
                                Thickness = 1
                            }),
                            Outline = Visuals:CreateDrawing("Square", {
                                Color = Color3.fromRGB(255, 255, 255), -- Changed to white outline
                                Thickness = 2 -- Increased thickness for better visibility
                            })
                        }
                    end
                    
                    local ScreenPosition, OnScreen = Visuals:GetScreenPosition(Part.Position)
                    
                    if OnScreen then
                        local PartSize = Part.Size
                        local Height = (workspace.CurrentCamera.CFrame - workspace.CurrentCamera.CFrame.Position) * Vector3.new(0, PartSize.Y/2, 0)
                        Height = math.abs(workspace.CurrentCamera:WorldToScreenPoint(Part.Position + Height).Y - workspace.CurrentCamera:WorldToScreenPoint(Part.Position - Height).Y)
                        local Width = Height * (PartSize.X/PartSize.Y)
                        
                        local Size = Visuals:Round(Vector2.new(Width, Height))
                        local Position = Visuals:Round(Vector2.new(ScreenPosition.X, ScreenPosition.Y) - (Size / 2))

                        -- Set properties for both the outline and main box
                        Objects.Boxes[Part].Outline.Size = Size
                        Objects.Boxes[Part].Outline.Position = Position
                        Objects.Boxes[Part].Outline.Visible = true

                        Objects.Boxes[Part].Main.Size = Size
                        Objects.Boxes[Part].Main.Position = Position
                        Objects.Boxes[Part].Main.Visible = true
                    else
                        Objects.Boxes[Part].Main.Visible = false
                        Objects.Boxes[Part].Outline.Visible = false
                    end
                end
            end
            
            -- Remove boxes for parts that no longer exist
            for Part, Box in pairs(Objects.Boxes) do
                if not CurrentParts[Part] then
                    Box.Main:Remove()
                    Box.Outline:Remove()
                    Objects.Boxes[Part] = nil
                end
            end
        else
            -- Hide all boxes when ESP is disabled
            for _, Box in pairs(Objects.Boxes) do
                Box.Main.Visible = false
                Box.Outline.Visible = false
            end
        end
    end
end)
-- Variables to store states
local aimbotEnabled = false
local FOVring = nil
local reticle = nil
local sensitivity = 2  -- Adjust this value for easier "look away"

-- Function to reset all features (like aimbot)
local function ResetAllFeatures()
    -- Disable aimbot
    aimbotEnabled = false
    if FOVring then FOVring.Visible = false end  -- Hide the FOV ring if it exists
    if reticle then reticle.Visible = false end  -- Hide the reticle if it exists
end

-- Function to toggle the aimbot
local function ToggleAimBot()
    aimbotEnabled = not aimbotEnabled  -- Toggle aimbot state

    if aimbotEnabled then
        -- Enable the aimbot and create drawing elements like FOV ring and reticle
        print("Aimbot Enabled")

        local fov = 150
        local RunService = game:GetService("RunService")
        
        -- Create FOV ring if not already created
        if not FOVring then
            FOVring = Drawing.new("Circle")
            FOVring.Visible = true
            FOVring.Thickness = 1.5
            FOVring.Radius = fov
            FOVring.Transparency = 1
            FOVring.Position = workspace.CurrentCamera.ViewportSize / 2
        end
        FOVring.Visible = true

        -- Create reticle if not already created
        if not reticle then
            reticle = Drawing.new("Circle")
            reticle.Visible = true
            reticle.Radius = 30  -- Adjust size if needed
            reticle.Transparency = 1
            reticle.Position = workspace.CurrentCamera.ViewportSize / 2
            reticle.Color = Color3.fromRGB(57, 255, 20)  -- Neon Green color for the reticle
        end
        reticle.Visible = true

        -- Aimbot logic here (simplified)
        local function getClosest(cframe)
            local ray = Ray.new(cframe.Position, cframe.LookVector).Unit
            local target = nil
            local mag = math.huge

            for i, v in pairs(game.Players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v ~= game.Players.LocalPlayer then
                    local magBuf = (v.Character.Head.Position - ray:ClosestPoint(v.Character.Head.Position)).Magnitude
                    if magBuf < mag then
                        mag = magBuf
                        target = v
                    end
                end
            end
            return target
        end

        -- RGB effect for the FOV ring (slowed down color change)
        local function updateRGBColor()
            local time = tick() * 0.5  -- Slow down the RGB transition by multiplying by a smaller factor
            -- Cycle colors through RGB using sine functions for smooth transitions
            local r = math.abs(math.sin(time * 2)) * 255
            local g = math.abs(math.sin(time * 2 + math.pi / 2)) * 255
            local b = math.abs(math.sin(time * 2 + math.pi)) * 255
            FOVring.Color = Color3.fromRGB(r, g, b)  -- Set the FOV ring color to the calculated RGB value
        end

        -- Render loop for aimbot (as before)
        RunService.RenderStepped:Connect(function()
            if not aimbotEnabled then
                return  -- Exit the loop if aimbot is disabled
            end

            -- Update the FOV ring color to create the RGB effect
            updateRGBColor()

            local cam = workspace.CurrentCamera
            local zz = cam.ViewportSize / 2
            local curTar = getClosest(cam.CFrame)
            if curTar then
                local ssHeadPoint = cam:WorldToScreenPoint(curTar.Character.Head.Position)
                ssHeadPoint = Vector2.new(ssHeadPoint.X, ssHeadPoint.Y)
                
                -- Adjust the threshold for snapping
                local distance = (ssHeadPoint - zz).Magnitude
                local snapThreshold = FOVring.Radius / sensitivity  -- Adjust sensitivity for easier "look away"
                
                if distance < snapThreshold then
                    -- **Hard snap to the target**: Directly set the camera's CFrame to the target's position
                    cam.CFrame = CFrame.new(cam.CFrame.Position, curTar.Character.Head.Position)
                end
            end
        end)
        
    else
        -- Disable the aimbot
        print("Aimbot Disabled")
        if FOVring then FOVring.Visible = false end
        if reticle then reticle.Visible = false end
    end
end

-- Create a toggle button for the aimbot
local aimbotToggle = Tab:CreateToggle({
    Name = "Toggle Aimbot",  -- Name of the toggle
    Default = false,  -- Default state of the toggle (off by default)
    Callback = function(state)
        -- Call the toggle function when the state changes (on/off)
        if state then
            ToggleAimBot()  -- Enable aimbot
        else
            ToggleAimBot()  -- Disable aimbot
        end
    end
})

-- Server Info Tab
local ServerInfoTab = Window:CreateTab("Server Info", nil)

-- Time In Server
local startTime = tick()
local serverUptimeLabel = ServerInfoTab:CreateLabel("Time In Server: 0 seconds")

-- Update Time In Server every second
local function updateServerUptime()
   while true do
       local uptime = tick() - startTime
       serverUptimeLabel:Set("Time In Server: " .. math.floor(uptime) .. " seconds")
       wait(1)
   end
end
task.spawn(updateServerUptime)

-- Player Count
local playerCount = #game.Players:GetPlayers()
local maxPlayerCount = game.Players.MaxPlayers
local playerLabel = ServerInfoTab:CreateLabel("Players: " .. playerCount .. "/" .. maxPlayerCount)

-- Server FPS
local serverFPS = nil
local fpsLabel = ServerInfoTab:CreateLabel("Server FPS: Calculating...")

-- Update server FPS every second
local function updateServerFPS()
   local startTime = os.clock()
   local frameCount = 0
   
   while true do
       game:GetService("RunService").RenderStepped:Wait()
       frameCount = frameCount + 1
       
       if os.clock() - startTime >= 1 then
           serverFPS = frameCount
           fpsLabel:Set("Server FPS: " .. tostring(serverFPS))
           startTime = os.clock()
           frameCount = 0
       end
   end
end
task.spawn(updateServerFPS)

-- Server Hop and Rejoin
local rejoinButton = ServerInfoTab:CreateButton({
   Name = "Rejoin Server",
   Callback = function()
       local ts = game:GetService("TeleportService")
       local p = game:GetService("Players").LocalPlayer
       ts:Teleport(game.PlaceId, p)
   end
})

local serverHopButton = ServerInfoTab:CreateButton({
   Name = "Server Hop",
   Callback = function()
       local ts = game:GetService("TeleportService")
       local p = game:GetService("Players").LocalPlayer
       ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, p)
   end
})

-- Create the time label
local TimeLabel = MainTab:CreateLabel("Time: 00:00:00 AM")

-- Auto-update time every second
coroutine.wrap(function()
    while task.wait(1) do
        local hour = os.date("%I")  -- 12-hour format
        local min = os.date("%M")
        local sec = os.date("%S")
        local ampm = os.date("%p")  -- AM/PM indicator
        local current_time = string.format("%s:%s:%s %s", hour, min, sec, ampm)
        TimeLabel:Set("Time: " .. current_time)
    end
end)()

local Tab = Window:CreateTab("LoadStrings", nil) -- Title, Image
local Button = Tab:CreateButton({
   Name = "Therapy Game GUI",
   Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Synergy-Networks/products/main/SynergyHub/loader.lua",true))()
   end,
})

-- Add these variables at the top of your script, after the Window creation
local LastDeathPosition = nil
local TeleportToDeathEnabled = false
local HasAntiTeleport = nil -- Will store if server has anti-teleport

-- Function to test for anti-teleport
local function CheckForAntiTeleport()
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local originalPosition = humanoidRootPart.Position
    local testDistance = 100 -- Distance to test teleport
    
    -- Try a small teleport
    local success = pcall(function()
        humanoidRootPart.CFrame = CFrame.new(originalPosition + Vector3.new(testDistance, 0, 0))
    end)
    
    -- Wait a tiny bit and check position
    task.wait(0.1)
    local newPosition = humanoidRootPart.Position
    local teleported = (newPosition - originalPosition).Magnitude > testDistance/2
    
    -- Return to original position
    humanoidRootPart.CFrame = CFrame.new(originalPosition)
    
    -- Check if we were able to teleport
    if not success or not teleported then
        HasAntiTeleport = true
        Rayfield:Notify({
            Title = "Anti-Teleport Detected",
            Content = "This server has anti-teleport measures enabled!",
            Duration = 6.5,
            Image = 4483362458,
        })
    else
        HasAntiTeleport = false
        Rayfield:Notify({
            Title = "Teleport Check",
            Content = "No anti-teleport detected. Teleporting is allowed!",
            Duration = 6.5,
            Image = 4483362458,
        })
    end
end

-- Add to your existing Main section
local TPLabel = MainTab:CreateLabel("Anti-Teleport Status: Not Checked")

-- Button to check for anti-teleport
local CheckTPButton = MainTab:CreateButton({
    Name = "Check Anti-Teleport",
    Callback = function()
        TPLabel:Set("Anti-Teleport Status: Checking...")
        CheckForAntiTeleport()
        task.wait(0.5)
        TPLabel:Set("Anti-Teleport Status: " .. (HasAntiTeleport and "Enabled ❌" or "Disabled ✅"))
    end
})

-- Toggle for Auto Teleport to Death
local AutoDeathToggle = MainTab:CreateToggle({
    Name = "Auto Teleport to Death",
    CurrentValue = false,
    Flag = "AutoDeathTP",
    Callback = function(Value)
        TeleportToDeathEnabled = Value
        
        if Value then
            if HasAntiTeleport then
                Rayfield:Notify({
                    Title = "Warning",
                    Content = "Anti-teleport is enabled on this server. Teleporting might not work!",
                    Duration = 6.5,
                    Image = 4483362458,
                })
            end
            
            -- Connect death detection
            local function onCharacterDied()
                local character = game.Players.LocalPlayer.Character
                if character then
                    LastDeathPosition = character:WaitForChild("HumanoidRootPart").Position
                    
                    -- Wait for respawn
                    character:WaitForChild("Humanoid").Died:Connect(function()
                        if TeleportToDeathEnabled then
                            task.wait(game.Players.RespawnTime + 0.5) -- Wait for respawn
                            local newCharacter = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                            local humanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
                            
                            -- Teleport to death position
                            if not HasAntiTeleport then
                                humanoidRootPart.CFrame = CFrame.new(LastDeathPosition)
                            end
                        end
                    end)
                end
            end
            
            -- Connect to current and future characters
            if game.Players.LocalPlayer.Character then
                onCharacterDied()
            end
            game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterDied)
        end
    end
})

-- Button to Teleport to Last Death Position
local LastDeathButton = MainTab:CreateButton({
    Name = "Teleport to Last Death",
    Callback = function()
        if HasAntiTeleport then
            Rayfield:Notify({
                Title = "Warning",
                Content = "Anti-teleport is enabled. Teleport might not work!",
                Duration = 3,
            })
        end
        
        if LastDeathPosition then
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = CFrame.new(LastDeathPosition)
            end
        else
            Rayfield:Notify({
                Title = "No Death Position",
                Content = "You haven't died yet!",
                Duration = 3,
            })
        end
    end
})

-- Create a universal teleport handler
local function SafeTeleport(position)
    if not HasAntiTeleport then
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local originalPos = character.HumanoidRootPart.Position
            
            -- Try teleporting
            character.HumanoidRootPart.CFrame = CFrame.new(position)
            
            -- Check if teleport was successful
            task.wait(0.1)
            local newPos = character.HumanoidRootPart.Position
            if (newPos - originalPos).Magnitude < 5 then
                -- Teleport failed, update anti-teleport status
                HasAntiTeleport = true
                TPLabel:Set("Anti-Teleport Status: Enabled ❌")
                Rayfield:Notify({
                    Title = "Anti-Teleport Detected",
                    Content = "Teleport failed! Server has anti-teleport.",
                    Duration = 3,
                })
            end
        end
    else
        Rayfield:Notify({
            Title = "Warning",
            Content = "Anti-teleport is enabled on this server!",
            Duration = 3,
        })
    end
end

-- Track death position for all characters
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid").Died:Connect(function()
        LastDeathPosition = character:WaitForChild("HumanoidRootPart").Position
    end)
end)

-- Run initial anti-teleport check when the script loads
task.spawn(function()
    task.wait(1) -- Wait for character to load
    CheckForAntiTeleport()
    TPLabel:Set("Anti-Teleport Status: " .. (HasAntiTeleport and "Enabled ❌" or "Disabled ✅"))
end)

-- Add this code right after your Window creation and before any tabs

local function ShowLoadingSuccess()
    Rayfield:Notify({
        Title = "Script Loaded Successfully ✅",
        Content = "All features are ready to use!",
        Duration = 6.5,
        Image = 4483362458,
        Actions = {
            Acknowledge = {
                Name = "Okay!",
                Callback = function()
                    print("User acknowledged successful load")
                end
            },
        },
    })
end

local function ShowLoadingError(errorMessage)
    Rayfield:Notify({
        Title = "Loading Error ❌",
        Content = "Error: " .. errorMessage,
        Duration = 10,
        Image = 4483362458,
        Actions = {
            Acknowledge = {
                Name = "Got it",
                Callback = function()
                    print("User acknowledged error: " .. errorMessage)
                end
            },
        },
    })
end

local Tab = Window:CreateTab("GUI", nil) -- Title, Image


local CloseButton = Tab:CreateButton({
    Name = "Close GUI",
    Callback = function()
        Rayfield:Destroy() -- This will completely remove the GUI
    end
})

local RefreshButton = Tab:CreateButton({
    Name = "Refresh GUI",
    Callback = function()
        -- First notify user
        Rayfield:Notify({
            Title = "Refreshing GUI",
            Content = "Please wait...",
            Duration = 2
        })
        
        -- Destroy current GUI
        Rayfield:Destroy()
        
        -- Wait for cleanup
        task.wait(1)
        
        -- Re-execute your original script
        loadstring(game:HttpGet('YOUR_ORIGINAL_SCRIPT_URL_HERE'))()
    end
})



