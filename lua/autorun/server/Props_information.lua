if SERVER then
    hook.Add("PlayerSpawnedProp", "SavePropOwner", function(ply, model, ent)
        if IsValid(ent) and ent:GetClass() == "prop_physics" then
            ent.SpawnedBy = ply
        end
    end)

    hook.Add("PlayerSay", "PropsInformation", function(ply, text, teamChat)
        if string.lower(text) == "!dem" then
            local trace = ply:GetEyeTrace()
            local ent = trace.Entity

            if IsValid(ent) and ent:GetClass() == "prop_physics" then
                local mins, maxs = ent:GetCollisionBounds()
                local width = math.abs(maxs.x - mins.x)
                local height = math.abs(maxs.y - mins.y)
                local depth = math.abs(maxs.z - mins.z)
                local propVector = ent:GetPos()
                local propAngle = ent:GetAngles()
                local propHeight = 0

                if not ent:IsOnGround() then
                    local propBottom = ent:WorldSpaceCenter() + Vector(0, 0, -(height / 2))
                    propHeight = math.abs(propVector.z - propBottom.z)
                end

                local modelName = ent:GetModel()
                local spawnedBy = ent.SpawnedBy

                ply:ChatPrint("Prop Details:")
                ply:ChatPrint("Model: " .. modelName)
                ply:ChatPrint("Width: " .. width)
                ply:ChatPrint("Height: " .. height)
                ply:ChatPrint("Depth: " .. depth)
                ply:ChatPrint("Vector: " .. tostring(propVector))
                ply:ChatPrint("Angle: " .. tostring(propAngle))
                ply:ChatPrint("Airborne Height: " .. propHeight)

                if IsValid(spawnedBy) then
                    ply:ChatPrint("Owner: " .. spawnedBy:Nick())
                else
                    ply:ChatPrint("Owner: Unknown")
                end
            else
                ply:ChatPrint("No prop found.")
            end

            return ""
        end
    end)

    hook.Add("PlayerInitialSpawn", "PropsInformationReminder", function(ply)
        ply:PrintMessage(HUD_PRINTTALK, "To see the information of a prop, you need to look at the prop and write the command !dem")
    end)
end
