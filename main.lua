logChat = true

function logs(var)
    sendVariant({v1="OnConsoleMessage", v2="CP:0_PL:4_OID:_CT:[]_ `b** [`5SveHelper`b]`^ "..var.."``"})
end

function say(var) 
sendPacket(2, "action|input\n|text|`b[`5"..GetLocal().name .."`b]`w ".. var) 
end

function drop(id, count)
    sendPacket(2, [[
action|dialog_return
dialog_name|drop_item
itemID|]]..id..[[|
count|]]..count..[[
]])
end

function packet(type, pkt)
    local count = pkt:match("/w (%d+)")
    if count then
        drop(242, count)
logs("Dropped`w ".. count .. " World Lock")
if logChat then
say("Dropped ".. count .. " World Lock") 
end
        return true
    end
    local count = pkt:match("/d (%d+)")
    if count then
        drop(1796, count)
logs("Dropped`w ".. count .. " Diamond Lock")
if logChat then
say("Dropped ".. count .. " Diamond Lock") 
end
        return true
    end
    local count = pkt:match("/b (%d+)")
    if count then
        drop(7188, count)
logs("Dropped`w ".. count .. " Blue Gem Lock")
if logChat then
say("Dropped ".. count .. " Blue Gem Lock") 
end
        return true
    end
end

AddHook(packet, "OnSendPacket")
