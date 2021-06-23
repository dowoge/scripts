local call
local add
for i,v in pairs(getgc(true))do
    if type(v)=='table'then
        if rawget(v,'Call')and getinfo(rawget(v,'Call')).source:find('Remote')then
            call=rawget(v,'Call')
        elseif rawget(v,'Add')and getinfo(rawget(v,'Add')).source:find('Command')then
            add=rawget(v,'Add')
        end
    end
end
h=hookfunc(call,function(...)
    local args={...}
    if args[1]=='Chatted' then
        local msg=table.concat(args,' ',2)
        local cmd = msg:find('/') or msg:find('!')
        if not cmd then
            local final=''
            for i in msg:gmatch('.') do
                final=final..i..'<1:'..string.char(math.random(97,122))..'>'
            end
            return h(args[1],string.sub(final,1,#final-5))
        end
    end
    return h(...)
end)
