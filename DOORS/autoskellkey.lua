local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local ReSt = game:GetService("ReplicatedStorage")
local PPS = game:GetService("ProximityPromptService")

-- Variables

local Plr = Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")

local SelfModules = {
    Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua"))(),
    DoorReplication = loadstring(game:HttpGet("https://pastebin.com/raw/7i7b10PG"))(),
    Achievements = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Achievements/Source.lua"))(),
}
local Assets = {
    KeyItem = game:GetObjects("rbxassetid://11961521528")[1],
  

}

-- Functions

local function replicateDoor(room)
    local originalDoor = room:FindFirstChild("Door")

    if originalDoor then
        local door = SelfModules.DoorReplication.CreateDoor({
            Locked = room:WaitForChild("Assets"):WaitForChild("KeyObtain", 0.3) ~= nil,
            Sign = true,
            Light = true,
            Barricaded = false,
            CustomKeyNames = {"Skeleton Key"},
            DestroyKey = false,
            GuidingLight = true,
            FastOpen = false,
        })

        door.Model.Name = "FakeDoor"
        door.Model:SetPrimaryPartCFrame(originalDoor.PrimaryPart.CFrame)
        door.Model.Parent = room
        SelfModules.DoorReplication.ReplicateDoor(door)
        originalDoor:Destroy()
        
        door.Debug.OnDoorOpened = function()
            local key = Char:FindFirstChild(Assets.KeyItem.Name) or Char:FindFirstChild("Key")

            if key then
                if key.Name == Assets.KeyItem.Name then
                    local uses = key:GetAttribute("Uses") - 1
    
                    if uses == 69 then
                        key:Destroy()
    
                        SelfModules.Achievements.Get({
                            Title = "Unbolting Hazard",
                            Desc = "Indefinitely cursing yourself.",
                            Reason = "Breaking the Skeleton Key.",
                            Image = "https://media.discordapp.net/attachments/1035320391142477896/1036335501004779632/unknown.png",
                        })
                    else
                        key:SetAttribute("Uses", uses)
                    end
    
                    Hum.Health = math.max(Hum.Health - 10, 0)
                    workspace.Curse:Play()
                else
                    key:Destroy()
                end
            end
        end
    end
end

-- Scripts

if typeof(Assets.KeyItem) ~= "Instance" then
    return
end

Assets.KeyItem.Parent = game.Players.LocalPlayer.Backpack

-- Door replication setup

task.spawn(function()
    for _, v in next, workspace.CurrentRooms:GetChildren() do
        if v:FindFirstChild("Door") and v.Door:FindFirstChild("Lock") then
            replicateDoor(v)
        end
    end
    
    workspace.CurrentRooms.DescendantAdded:Connect(function(des)
        if des.Name == "Lock" and des.Parent.Name == "Door" then
            task.wait(0.3)

            if des.Parent then
                replicateDoor(des.Parent.Parent)
            end
        end
    end)
end)

-- Obtain cursed key

KeyItem.Parent = game.Players.LocalPlayer.Backpack
 firesignal(ReSt.Bricks.Caption.OnClientEvent, "You got Skeleton Key!", true)



-- other chrustmas 

local Player = game.Players.LocalPlayer
local Character = Player.Character

local WrappingTexture = 4516925393

function Wrap(Part, Id)
	if Part.Transparency > .9 then 
		return 
	end
	
	local PartFaces = {
		"Front",
		"Top",
		"Bottom",
		"Back",
		"Left",
		"Right"
	}
	
	local texturecoro = coroutine.create(function()
		for _,v in pairs(PartFaces) do
			local Texture = Instance.new("Texture",Part)
			Texture.Texture = "rbxassetid://"..Id
			Texture.Face = v
		end
	end)
	
	coroutine.resume(texturecoro)
	
	local WrappedTag = Instance.new("BoolValue",Part)
	WrappedTag.Name = "Textured"
end

function christmas_wrap_tool(Tool)
	spawn(function()
		for _,object in pairs(Tool:GetDescendants()) do
			if not object:FindFirstChild("Textured") and object:IsA("BasePart") then
				Wrap(object, WrappingTexture)
			end
		end
	end)
end

local ItemNames = {"Door1","Door2","Knob","Wood","Knobs","Main","Blanket","Mattress","Part","Darker","Lighter","Shelves","Books","End","Cushion","Border","Face","Hour_Hand","Lines","Minute_Hand","Swing","Door","Wall_Strip","Flashlight","Key","Key_Obtain"}
local C_Rooms = workspace.CurrentRooms

function update()
	local Room = C_Rooms[game.ReplicatedStorage.GameData.LatestRoom.Value]
	local Door = Room.Door
	
	
	--Fix the doors
	
	if Door:WaitForChild("Lock",1) then
		local Lock = Door:FindFirstChild("Lock")
		
		spawn(function()
			Wrap(Lock, WrappingTexture)
			Wrap(Lock:WaitForChild("Metal",5), WrappingTexture)
			Wrap(Lock:WaitForChild("Thing",5), WrappingTexture)
		end)
	end
	
	if Room.Assets:WaitForChild("LeverForGate",1) then
		local Lever =  Room.Assets:FindFirstChild("LeverForGate")
		
		spawn(function()
			Wrap(Lever.Main, WrappingTexture)
			Wrap(Lever.Main.ToUnanchor.Handle, WrappingTexture)
		end)
	end
	
	
	
	
	
	
	
	
	
	
	spawn(function()
		Wrap(Door.Door:WaitForChild("Knob"), WrappingTexture)
		Wrap(Door.Door:WaitForChild("Plate"), WrappingTexture)
	end)
	
	--incase items spawn lol
	spawn(function()
		Room.DescendantAdded:Connect(function(newobj)
			task.wait(.3)
			for _,name in pairs(ItemNames) do
				if newobj.Name == name and newobj:IsA("Model") then
					christmas_wrap_tool(newobj)
				end
			end
		end)
	end)
	
	wrapcheck()
end

spawn(function()
	game.ReplicatedStorage.GameData.LatestRoom.Changed:Connect(function()
		update()
	end)
end)
--newobj.Name == name

--string.match(newobj.Name,name)



spawn(function()
	Character.DescendantAdded:Connect(function(newobj)
		if newobj:IsA("Script") and string.match(newobj.Name,"ToolHandlerServer") then
			christmas_wrap_tool(newobj.Parent)
		end
	end)
end)


workspace.DescendantAdded:Connect(function(newobj)
	spawn(function()
		for _,name in pairs(ItemNames) do
			if newobj.Name == name and newobj:IsA("Instance") then
				if newobj:IsA("Model") then
					christmas_wrap_tool(newobj)
				elseif newobj:IsA("BasePart") and newobj.Parent.Name ~= "Bookcase" then
					Wrap(newobj, WrappingTexture)
				end
		
			end
		end
		
	end)
end)


update()