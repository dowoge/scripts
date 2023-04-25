local call
for i,v in pairs(getgc(true))do
    if type(v)=='table'then
        if rawget(v,'Call')and getinfo(rawget(v,'Call')).source:find('Remote')then
            call=rawget(v,'Call')
            break
        end
    end
end
h=hookfunc(call,function(...)
    local args={...}
    if args[1]=='Chatted' then
        local msg=table.concat(args,' ',2)
        if not (msg:sub(1,1)=='/'or msg:sub(1,1)=='!') then
            local final=''
            for i in msg:gmatch('.') do
                final=final..i..'<mlg:100:11251521:<1:fan>>'
            end
            return h(args[1],string.sub(final,1,#final-24))
        end
    end
    return h(...)
end)
