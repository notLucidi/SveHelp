logChat = true

--------------------------------
-- CONFIG
--------------------------------
local ITEMS = {
    w = {id = 242, name = "World Lock"},
    d = {id = 1796, name = "Diamond Lock"},
    b = {id = 7188, name = "Blue Gem Lock"}
}

local MAX_DROP = 200

--------------------------------
-- LOG FUNCTION
--------------------------------
function logs(text)
    sendVariant({
        v1 = "OnConsoleMessage",
        v2 = "CP:0_PL:4_OID:_CT:[]_ `b** [`5SveHelper`b]`^ "..text.."``"
    })
end

--------------------------------
-- CHAT FUNCTION
--------------------------------
function say(text)
    sendPacket(2,
        "action|input\n|text|`b["..GetLocal().name.."`b]`w "..text
    )
end

--------------------------------
-- DROP FUNCTION
--------------------------------
function drop(id, count)

    if not id or not count then
        logs("Invalid drop request")
        return
    end

    if count <= 0 then
        logs("Drop count invalid")
        return
    end

    sendPacket(2,
        "action|dialog_return\n"..
        "dialog_name|drop_item\n"..
        "itemID|"..id.."|\n"..
        "count|"..count
    )

end

--------------------------------
-- SAFE DROP
--------------------------------
function safeDrop(cmd, count)

    local item = ITEMS[cmd]
    if not item then return end

    count = tonumber(count)

    if not count then
        logs("Invalid number")
        return
    end

    if count > MAX_DROP then
        count = MAX_DROP
    end

    local inv = growtopia.checkInventoryCount(item.id)

    if inv <= 0 then
        logs("No "..item.name.." in inventory")
        return
    end

    if count > inv then
        count = inv
    end

    drop(item.id, count)

    logs("Dropped `w"..count.." "..item.name)

    if logChat then
        say("Dropped "..count.." "..item.name)
    end

end

--------------------------------
-- PACKET HOOK
--------------------------------
function packet(type, pkt)

    if type ~= 2 then return end
    if not pkt then return end

    local cmd, count = pkt:match("^action|input\n|text|/(%w)%s*(%d+)")

    if cmd and count then

        cmd = cmd:lower()

        if ITEMS[cmd] then
            safeDrop(cmd, count)
            return true
        end

    end

end

AddHook(packet, "OnSendPacket")
