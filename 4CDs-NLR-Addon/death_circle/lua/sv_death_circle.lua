util.AddNetworkString("PlayerDeathCircle")
util.AddNetworkString("KillPlayerInCircle")

hook.Add("PlayerDeath", "CreateDeathCircle", function(ply, inflictor, attacker)
    net.Start("PlayerDeathCircle")
    net.WriteVector(ply:GetPos())
    net.Broadcast()
end)

net.Receive("KillPlayerInCircle", function(len, ply)
    if not ply:Alive() then return end
    ply:Kill()
end)