local plr=game.Players.LocalPlayer
local char=game.Workspace.Characters:WaitForChild(plr.Name)
game:GetService('RunService').RenderStepped:Connect(function()
    local ray=Ray.new(char.Torso.CFrame.Position,Vector3.new(0,-3.5,0))
    local hit=workspace:FindPartOnRayWithIgnoreList(ray,{char})
    if hit and game:GetService('UserInputService'):IsKeyDown(Enum.KeyCode.Space) then
        mousescroll(1337)
    end
    last=speed
end)
