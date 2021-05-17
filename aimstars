getgenv().aimkey = 'f'
getgenv().autoclick = true

local plr = game.Players.LocalPlayer
local mouse2 = plr:GetMouse()
local char = plr.Character
local camera = game.Workspace.CurrentCamera
local rs = game:GetService('RunService')
local uis = game:GetService('UserInputService')
local folder = game.Workspace:FindFirstChild('Bots') or game.Workspace:FindFirstChildOfClass('MeshPart')
local physicalIgnore = game.Workspace.physicalIgnore
local mode

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if method == 'Kick' then
        print('kick attempt', ...)
        return
    end

    return old(self, unpack(args))
end
setreadonly(mt, true)


repeat wait(0.5) print('not found')
    if folder.ClassName == 'Folder' then
        if folder:FindFirstChild('Part') and folder:FindFirstChild('Part'):FindFirstChild('Target') then
            mode = 'part'
            print('mode set to part')
        elseif folder:FindFirstChild('Bot') and folder:FindFirstChild('Bot'):FindFirstChild('Humanoid') then
            mode = 'bot'
            print('mode set to bot')
        elseif folder:FindFirstChild('Sphere') and folder:FindFirstChild('Sphere'):FindFirstChild('Target') then
            mode = 'sphere'
            print('mode set to sphere')
        end
    end
until mode
for i,v in pairs(physicalIgnore:GetChildren()) do
    if v.Name == 'Barrier' then
        v:Destroy()
    end
end
print('ready to load')

wait()

function findtarget()
    if mode == 'bot' then
        for i,v in pairs(folder:GetChildren()) do
            if v:FindFirstChild('Head') then
                local h,isonscreen = camera:WorldToViewportPoint(v:FindFirstChild('Head').Position)
                if isonscreen then
                    return v.Head
                end
            elseif v:FindFirstChild('Torso') then
                local h,isonscreen = camera:WorldToViewportPoint(v:FindFirstChild('Torso').Position)
                if isonscreen and v.Torso then
                    return v.Torso
                end
            end
        end
    elseif mode == 'part' then
        for i,v in pairs(folder:GetChildren()) do
            if v.Name == 'Part' and v.Target.Value == 'Target' and v.Transparency ~= 1 then
                local h,isonscreen = camera:WorldToViewportPoint(v.Position)
                if isonscreen then
                    return v
                end
            end
        end
    elseif mode == 'sphere' then
        for i,v in pairs(folder:GetChildren()) do
            if v.Name == 'Sphere' and v.Target.Value == 'Target' and v.Transparency ~= 1 then
                local h,isonscreen = camera:WorldToViewportPoint(v.Position)
                if isonscreen then
                    return v
                end
            end
        end
    end
end

print('f1 initialized')

function AimAt(instance)
    local v = camera:WorldToViewportPoint(instance.Position)
    local mouse = uis:GetMouseLocation()
    if uis:IsKeyDown(Enum.KeyCode[getgenv().aimkey:upper()]) then
        mousemoverel((v.X - mouse.X), (v.Y - mouse.Y))
    end
end

print('f2 initialized')

rs.RenderStepped:Connect(function()
    local part = findtarget()
    
    pcall(AimAt, part)
    print(mouse2.Target)
    if getgenv().autoclick and (mouse2.Target:IsDescendantOf(folder) or mouse2.Target.Name == 'Head' or mouse2.Target.Name == 'Torso') then 
        mouse1click()
    end
end)

getrenv().print = function() return end

print('loaded')
