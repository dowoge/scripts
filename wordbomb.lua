loadstring(game:HttpGet('https://raw.githubusercontent.com/angeld23/raw-text-host/master/condensed_english_words'))()
local plrgui,uis=game.Players.LocalPlayer.PlayerGui,game:GetService('UserInputService')
local textframe,used_words=plrgui:FindFirstChild('TextFrame',true),{}
function canType()
    return tostring(uis:GetFocusedTextBox())=='Typebox' and true or false
end
function getCurrentLetters()
    local current_letters=''
    for i,v in pairs(textframe:GetChildren()) do
        if v.ClassName=='Frame' then
            for i2,v2 in pairs(v.Letter:GetChildren()) do
                if v2.ClassName=='TextLabel' then
                    if v2.Text~='Q' and v2.Text~='X' then
                        current_letters..=v2.Text
                    end
                end
            end
        end
    end
    return current_letters
end
function getCurrentWord(letters)
    for i,v in next,ENGLISH_WORDS do
        if v:find(letters:lower()) and not used_words[v] then
            used_words[v]=true
            return v
        end
    end
end
function Type()
    if canType() then
        local word=getCurrentWord(getCurrentLetters())
        for i,letter in next,word:split('') do
            keypress(string.byte(letter:upper()))
            task.wait(math.random(5,25)/100)
        end
        task.wait(1/4)
        keypress(0x0D)
    end
end

uis.TextBoxFocused:Connect(function(t)
    if tostring(t)=='Typebox' then
        textframe=plrgui:FindFirstChild('TextFrame',true)
        wait(1/5)
        Type()
    end
end)
