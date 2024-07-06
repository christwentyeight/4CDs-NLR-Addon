if SERVER then
    AddCSLuaFile("cl_death_circle.lua")
    include("sv_death_circle.lua")
else
    include("cl_death_circle.lua")
    include("nlraddon.lua")
end

include("sh_death_circle.lua")
