local SimulationClass,DynamicPartsClass,View,UnpackageControls,MapReplication
for _,t in next, getgc(true) do
    if type(t)=='table' then
        if type(rawget(t,'Constructor'))=='function' and getinfo(rawget(t,'Constructor')).source=='=ReplicatedStorage.Shared.Simulation' then
            SimulationClass=t
        end
        if type(rawget(t,'Constructor'))=='function' and getinfo(rawget(t,'Constructor')).source=='=ReplicatedStorage.Shared.DynamicParts' then
            DynamicPartsClass=t
        end
        if rawget(t,'Mode') and rawget(t,'ModeChanged') then
            View=t
        end
        if rawget(t,'UnpackageControls') then
            UnpackageControls=rawget(t,'UnpackageControls')
        end
        if rawget(t,'MapChanged') then
            MapReplication=t
        end
    end
end

local Cylinder = Instance.new("Part", workspace)
Cylinder.Name = "CustomHitMarker"
Cylinder.Anchored = true
Cylinder.CanCollide = false
Cylinder.BrickColor = BrickColor.new(21)
Cylinder.Size = Vector3.new(5, 2, 2)
Cylinder.Shape = Enum.PartType.Cylinder
Cylinder.TopSurface = Enum.SurfaceType.Smooth
Cylinder.BottomSurface = Enum.SurfaceType.Smooth
Cylinder.Transparency = 1
local Offset = CFrame.new(0, 0, 0, 0, -1, 0, 1, 0, 0, 0, 0, 1)

local Simulation=SimulationClass()

function CollisionStart(a,b)
    if a.GameMechanics:IsTouchable(b.Part) then
        b.Type='TickEnd'
        Simulation.ShouldRun=false
    end
end

MapReplication.MapChanged:Add(function(MapInfo,ProcessedMapInfo)
    Simulation:SetMapInfo(MapInfo)
    Simulation.GameMechanics:AttachDynamicInstance(DynamicPartsClass(ProcessedMapInfo,Simulation.Timer))
    Simulation.Phys.Handlers.CollisionStart:Add(CollisionStart)
end)

Simulation:SetMapInfo(MapReplication.MapInfo)
Simulation.GameMechanics:AttachDynamicInstance(DynamicPartsClass(MapReplication.ProcessedMapInfo,Simulation.Timer))
Simulation.Phys.Handlers.CollisionStart:Add(CollisionStart)

local LastOutput

local MaxTime=2
local TickRate=20

local rs=game:GetService('RunService')
rs:BindToRenderStep('CustomHit',170,function()
    local SimulationPlayback=View.SimulationPlayback
    if SimulationPlayback then
        local Input=SimulationPlayback:GetInput()
        local Output=SimulationPlayback:GetOutput()
        if Input and Output and Output~=LastOutput then
            local Time=Output[1]
            local SimPhys=Simulation.Phys
            SimPhys.Time=Time
            SimPhys:SetPosition(Output[4])
            SimPhys:SetVelocity(Output[5])
            Simulation.Camera:SetAngles(Output[3])
            Simulation.Camera:SetTime(Time)
            Simulation.GameMechanics:SetControls(UnpackageControls(Input[2]))
            Simulation.ShouldRun=true
            local t=0
            local LastPosition=SimPhys.Position
            while Simulation.ShouldRun and SimPhys.Time-Time<MaxTime do
                t=t+1
                print('run '..t)
                if SimPhys:Tick(Time + t / TickRate) then
                    local Position=SimPhys.Position
                    if Position==LastPosition then
                        break
                    end
                else
                    print('CustomHitSimulation failed lol')
                    break
                end
            end
            if Simulation.ShouldRun then
                Cylinder.Transparency=1
            else
                Cylinder.Transparency=0.5
                Cylinder.CFrame=Offset+SimPhys.Position
                LastOutput=Output
            end
        end
    end
end)
