local addonVersion = "1.0"

concommand.Add("nlrver", function(ply)
    if IsValid(ply) then
        ply:ChatPrint("4CD's NLR Addon: Version " .. addonVersion)
    end
end)

hook.Add("OnPlayerChat", "HandleNlrVerCommand", function(ply, text)
    if string.lower(text) == "!nlrver" then
        ply:ConCommand("nlrver")
        return true
    end
end)
