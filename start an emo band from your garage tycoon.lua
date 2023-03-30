local rs = game:GetService('ReplicatedStorage')
local plr = game:GetService('Players').LocalPlayer
local hrp = plr.Character.HumanoidRootPart

local events = rs:WaitForChild('Events')

local tourComplete = events:WaitForChild('TourComplete')
local ShowPromptConfirm = events:WaitForChild('ShowPromptConfirm')
local SendToStage = events:WaitForChild('SendToStage')

local stages = workspace:WaitForChild('ConcertAreas')
local currentSong = plr.PlayerGui.SongLines.CurrentSong

local songLines = plr.PlayerGui:WaitForChild('SongLines')
local currentSong = songLines:WaitForChild('CurrentSong')
local createNoteEvent = songLines:WaitForChild('CreateNote')

local data = plr:WaitForChild('Data')
local tourLocation = data:WaitForChild('TourLocationLevel')

function findTycoon()
    for _,tycoon in next,workspace:FindFirstChild('Tycoons'):GetChildren() do
        local claim = tycoon:FindFirstChildOfClass('Model')
        if claim then
            local textLabel = claim:FindFirstChild('ItemName',true)
            if textLabel then
                if textLabel.Text and textLabel.Text:find(plr.Name) then
                    return tycoon
                end
            end
        end
    end
end

local tycoon = findTycoon()

local staticItems = tycoon:FindFirstChild('StaticItems')

local storages = {
    staticItems:FindFirstChild('Storage'),
    staticItems:FindFirstChild('Storage2'),
    staticItems:FindFirstChild('Storage3')
}

for _, storage in next,storages do
    local textLabel = storage:FindFirstChild('Cost',true)
    local prompt = storage:FindFirstChild('ProximityPrompt')
    task.spawn(function()
        local cf = hrp.CFrame
        hrp.CFrame = storage.CFrame
        repeat
            wait(.5)
            fireproximityprompt(prompt)
        until
            not textLabel.Text:find('⚠️')
        hrp.CFrame=cf
    end)
    if textLabel then
        textLabel:GetPropertyChangedSignal('Text'):Connect(function()
            if textLabel.Text:find('⚠️') then
                local cf = hrp.CFrame
                hrp.CFrame = storage.CFrame
                repeat
                    wait(.5)
                    fireproximityprompt(prompt)
                until
                    not textLabel.Text:find('⚠️')
                hrp.CFrame=cf
            end
        end)
    end
end

local mt = getrawmetatable(game)
local ocall=mt.__namecall

setreadonly(mt,false)

mt.__namecall=function(o,i,...)
    if o==currentSong then
        return
    end
    return ocall(o,i,...)
end

game:GetService('UserInputService').InputBegan:Connect(function(input,gpi)
    if gpi then return end
    if input.KeyCode == Enum.KeyCode.E then
        ShowPromptConfirm:FireServer()
    end
end)    
