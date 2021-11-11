local Wargroove = require "wargroove/wargroove"
local GrooveVerb = require "wargroove/groove_verb"
local Combat = require "wargroove/combat"
local OldSplashJump = require "verbs/groove_splash_jump"

local SplashJump = GrooveVerb:new()


function SplashJump:init()
    OldSplashJump.execute = SplashJump.execute
end


function SplashJump:execute(unit, targetPos, strParam, path)
    Wargroove.setIsUsingGroove(unit.id, true)
    Wargroove.updateUnit(unit)

    Wargroove.playPositionlessSound("battleStart")
    Wargroove.playGrooveCutscene(unit.id)

    Wargroove.playMapSound("ragna/ragnaGroove", unit.pos)
    Wargroove.waitTime(0.25)
    Wargroove.playUnitAnimation(unit.id, "groove_1")
    Wargroove.waitTime(1.4)
    unit.pos = { x = targetPos.x, y = targetPos.y }
    Wargroove.updateUnit(unit)
    Wargroove.playMapSound("ragna/ragnaGrooveLanding", targetPos)
    Wargroove.playUnitAnimation(unit.id, "groove_2")
    Wargroove.waitTime(0.4)
    Wargroove.playGrooveEffect()
    Wargroove.spawnMapAnimation(unit.pos, 2, "fx/groove/ragna_groove_fx", "idle", "behind_units", { x = 12, y = 12 })
    
    for i, pos in ipairs(Wargroove.getTargetsInRange(targetPos, 2, "unit")) do
        local u = Wargroove.getUnitAt(pos)
        if u and Wargroove.areEnemies(u.playerId, unit.playerId) then
            local damage = Combat:getGrooveAttackerDamage(unit, u, "random", unit.pos, pos, path, nil) * 0.50
            
            u:setHealth(u.health - damage, unit.id)
            Wargroove.updateUnit(u)
            Wargroove.playUnitAnimation(u.id, "hit")
        end
    end

    Wargroove.waitTime(0.5)
end



return SplashJump
