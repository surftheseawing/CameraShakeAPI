--[[
Camera Shake API
Author: SyntaxScales
Contributor: psq95
Version: 1.0.0
]]--
--[[
This library enables players to shake their own camera, and the camera of other players who also have this library.
Example:
local cameraShake = require('CameraShake')
function shakeCamera(duration, intensity)
    cameraShake.update(duration, intensity)
    log(string.format("shakeCamera(%d, %d)",
        cameraShake.duration(), cameraShake.intensity()))
end
]]--

---@class SyntaxScales.cameraShake
local cameraShake = {}

-- state
local cameraShakeDuration = 0
local cameraShakeMaxDuration = 0
local cameraShakeIntensity = 0
local cameraShakeUpdateTicker = 0
local cameraShakeReceivers = {}

-- config
local cameraDefault = vec(0, 0, 0)

--- Set default position of camera when not shaking
---@param cameraVec Vector3 Position
function cameraShake.setDefaultPos(cameraVec)
    cameraDefault = cameraVec
end

--- Get duration of current camera shake
---@return integer
function cameraShake.getDuration()
    return cameraShakeDuration
end

--- Get maximum duration of current camera shake
---@return integer
function cameraShake.getMaxDuration()
    return cameraShakeMaxDuration
end

--- Get intensity of current camera shake
---@return integer
function cameraShake.getIntensity()
    return cameraShakeIntensity
end

function cameraShake.update(duration, intensity)
    cameraShakeDuration = duration
    cameraShakeMaxDuration = duration
    cameraShakeIntensity = intensity
    cameraShakeUpdateTicker = cameraShakeUpdateTicker + 1

    -- Store so receivers can have their screen shaken
    avatar:store("cameraShakeDuration", cameraShakeDuration)
    avatar:store("cameraShakeMaxDuration", cameraShakeMaxDuration)
    avatar:store("cameraShakeIntensity", cameraShakeIntensity)
    avatar:store("cameraShakeUpdateTicker", cameraShakeUpdateTicker)
end

function events.render(delta, context)
    -- Shake the camera
    if (cameraShakeDuration > 0) then
        cameraShakeDuration = cameraShakeDuration - delta
        if (cameraShakeDuration < 0) then
            cameraShakeDuration = 0
        end
        local percent = cameraShakeDuration / cameraShakeMaxDuration
        local cameraRandom = vec(
            math.random() * cameraShakeIntensity * percent,
            math.random() * cameraShakeIntensity * percent,
            math.random() * cameraShakeIntensity * percent)
        renderer:setOffsetCameraPivot(cameraDefault + cameraRandom)
    else
        -- Reset the camera when not shaking any more
        renderer:setOffsetCameraPivot(cameraDefault)
    end
end

function events.tick()
    -- First, iterate through every player in the world, stored in the variable v
    for _, v in pairs(world:getPlayers()) do
        -- Then, check to ensure the user is not receiving their own camera shake.
        if (not (v:getUUID() == avatar:getUUID())) then
            -- Get camera shake information from the avatar's stored variables
            local shakeDuration = v:getVariable("cameraShakeDuration")
            local shakeMaxDuration = v:getVariable("cameraShakeMaxDuration")
            local shakeIntensity = v:getVariable("cameraShakeIntensity")

            --[[
            The shake intensity or shake duration is not updated every frame.  
            Therefore, a separate variable is needed to detect when a change
            to the camera shake state has occured. This value is compared with
            the value stored in cameraShakeReceivers using the player's 
            UUID. If the values don't match, that means a new camera shake
            occured. Then, after that is checked, it updates the table to
            contain the new value.
            ]]--
            local shakeUpdateTicker = v:getVariable("cameraShakeUpdateTicker")

            -- Make sure that the camera shake information was actually found.
            if (shakeDuration ~= nil and
                shakeMaxDuration ~= nil and
                shakeIntensity ~= nil and
                shakeUpdateTicker ~= nil)
            then
                -- If the viewer is too far away, don't shake
                if ((player:getPos() - v:getPos()):length() <= shakeIntensity * 1200) then
                    -- If there has been an update (meaning a new screen shake was sent)
                    if (shakeUpdateTicker ~= cameraShakeReceivers[v:getUUID()]) then
                        cameraShakeDuration = shakeDuration
                        cameraShakeMaxDuration = shakeMaxDuration
                        cameraShakeIntensity = shakeIntensity
                    end
                end

                cameraShakeReceivers[v:getUUID()] = shakeUpdateTicker
            end
        end
    end
end

return cameraShake