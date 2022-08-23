local plr = game.Players.LocalPlayer
local uis = game:GetService('UserInputService')
function j(old,new)
    if new==Enum.HumanoidStateType.Landed then
        if uis:IsKeyDown(Enum.KeyCode.Space) then
            game:GetService('RunService').RenderStepped:Wait()
            plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end

plr.Character.Humanoid.StateChanged:Connect(j)
plr.CharacterAdded:Connect(function()
    plr.Character:WaitForChild('Humanoid').StateChanged:Connect(j) 
end)
