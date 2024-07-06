local deathCircles = {}  -- Array to store all death circles
local circleCooldowns = {}  -- Array to store cooldowns for each death circle
local cooldownDuration = 10  -- Cooldown duration in seconds
local maxDeathCount = 3  -- Deaths before "taking action"

local circleColor = Color(255, 0, 0, 150)  -- Colour of the circle
local circleRadius = 200  -- Radius of the circle
local removalDuration = 180  -- Duration after which the circle is removed

local textFont = "Trebuchet24"  -- Font of the text
local textColor = Color(255, 255, 255, 255)  -- Colour of the text
local textScale = 1  -- Scale of text size
local textHeight = 40  -- Height above ground for text


net.Receive("PlayerDeathCircle", function()
    local pos = net.ReadVector()

    local existingCircle = false
    for _, data in ipairs(deathCircles) do
        if pos:DistToSqr(data.pos) < (circleRadius * circleRadius) then
            existingCircle = true
            break
        end
    end

    if not existingCircle then
        local trace = util.TraceLine({
            start = pos,
            endpos = pos - Vector(0, 0, 10000),
            mask = MASK_SOLID
        })

        local groundPos = trace.HitPos
        table.insert(deathCircles, {pos = groundPos, time = CurTime(), deaths = 0})

        circleCooldowns[#deathCircles] = cooldownDuration
    end
end)

local function Draw3DCircle(pos, radius, color, zoneNumber)
    local segments = 64
    local angle = 360 / segments

    render.SetMaterial(Material("cable/redlaser"))
    render.StartBeam(segments + 1)
    for i = 0, segments do
        local theta = math.rad(i * angle)
        local x = pos.x + math.cos(theta) * radius
        local y = pos.y + math.sin(theta) * radius
        local z = pos.z
        render.AddBeam(Vector(x, y, z), 20, i / segments, color)
    end
    render.EndBeam()

    local textPos = pos + Vector(0, 0, textHeight)
    local text = "NLR Zone " .. zoneNumber
    local textWidth, textHeight = surface.GetTextSize(text)
    local textX = textPos:ToScreen().x - textWidth / 2
    local textY = textPos:ToScreen().y - textHeight / 2

    cam.Start3D2D(textPos, Angle(0, LocalPlayer():EyeAngles().y - 90, 90), textScale)
        draw.DrawText(text, textFont, 0, 0, textColor, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end

hook.Add("PostDrawTranslucentRenderables", "DrawDeathCircles", function()
    for i, data in ipairs(deathCircles) do
        if data.time + removalDuration < CurTime() then
            table.remove(deathCircles, i)
            table.remove(circleCooldowns, i)
        else
            Draw3DCircle(data.pos, circleRadius, circleColor, i)
        end
    end
end)

hook.Add("Think", "CheckPlayerInDeathCircle", function()
    local ply = LocalPlayer()
    if not ply:Alive() then return end

    local plyPos = ply:GetPos()

    for i, data in ipairs(deathCircles) do
        if plyPos:DistToSqr(data.pos) < (circleRadius * circleRadius) then
            if circleCooldowns[i] > 0 then
                circleCooldowns[i] = circleCooldowns[i] - FrameTime()
                if circleCooldowns[i] <= 0 then
                    net.Start("KillPlayerInCircle")
                    net.WriteInt(i, 8)
                    net.SendToServer()
                    circleCooldowns[i] = cooldownDuration
                end
            end
            return
        end
    end
end)

hook.Add("HUDPaint", "DrawCountdown", function()
    for i, data in ipairs(deathCircles) do
        local cooldown = circleCooldowns[i]
        local remainingTime = removalDuration - (CurTime() - data.time)
        if cooldown > 0 then
            local text = "NLR Zone " .. i .. ": Time until action " .. math.ceil(cooldown) .. " / 10. | Remaining: " .. math.ceil(remainingTime) .. " / 180."
            draw.SimpleText(text, textFont, ScrW() / 2, 50 + 25 * i, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
end)

net.Receive("PlayerDiedInCircle", function()
    local circleIndex = net.ReadInt(8)
    if circleIndex and deathCircles[circleIndex] then
        deathCircles[circleIndex].deaths = deathCircles[circleIndex].deaths + 1
        if deathCircles[circleIndex].deaths >= maxDeathCount then
            -- Other Shit
        end
    end
end)
