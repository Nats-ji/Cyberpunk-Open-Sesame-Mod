registerForEvent("onInit", function()
	HotKey = 0x45 -- Change Hotkey Here. You can find Key Codes at https://docs.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
	drawPopup = false
	getTime = 0
	print("************************************************")
	print("* Open Semame Mod Loaded...                    *")
	print("* Press E to open any doors and unlock cars    *")
	print("* Press Shift+E to kill NPCs and blow up cars. *")
	print("************************************************")
end)

registerForEvent("onUpdate", function()
	if (not ImGui.IsKeyDown(0x10) and ImGui.IsKeyPressed(HotKey, false)) then
		drawPopup = false
		player = Game.GetPlayer()
		objLook = Game.GetTargetingSystem():GetLookAtObject(player,false,false)
		objType = objLook:ToString()
		
		-- Real door --
		if (objType == "Door") then
			objName = objType
			detailInfo = "Open Sesame..."
			breachInfo = "The door has been opened."
			objLook:OpenDoor()
			getTime = os:clock()
			drawPopup = true
			
		-- Fake door --
		elseif (objType == "FakeDoor") then
			objName = objType
			detailInfo = "This is a fake door..."
			breachInfo = "Failed to breach the door."
			getTime = os:clock()
			drawPopup = true
			
		-- Vehicle door --
		elseif (objLook:IsVehicle()) then
			vehDestoryed = objLook:IsDestroyed()
			if (not vehDestoryed) then
				vehName = objLook:GetDisplayName()
				vehPS = objLook:GetVehiclePS()
				vehComp = objLook:GetVehicleComponent()
				vehOcc = not is_empty(vehPS:GetNpcOccupiedSlots())
				vehMass = objLook:GetTotalMass()
				objName = vehName
				detailInfo = vehName.." weighs "..vehMass.."KG"
				breachInfo = "Vehicle doors has been unlocked."
				if (vehOcc) then -- Vehicle is occupied by npc
					vehComp:DestroyVehicle() -- Eject NPCs
					vehComp:RepairVehicle()
					vehComp:DestroyMappin() -- RepairVehicle() somehow adds mappin
				end
				vehPS:UnlockAllVehDoors()	-- Open Vehicle Doors
				vehComp:HonkAndFlash()
				getTime = os:clock()
				drawPopup = true
			end
		end
	elseif (ImGui.IsKeyDown(0x10) and ImGui.IsKeyPressed(HotKey, false)) then
		drawPopup = false
		player = Game.GetPlayer()
		objLook = Game.GetTargetingSystem():GetLookAtObject(player,false,false)
		objType = objLook:ToString()
		
		-- Kill NPC --
		if (objType == "NPCPuppet") then
			if (not objLook:IsDead()) then
				npcName = objLook:GetDisplayName()
				objName = npcName
				detailInfo = npcName.." is a NPC."
				breachInfo = npcName.." has been killed."
				objLook:Kill(player, false, false)  -- Kill NPC by player
				getTime = os:clock()
				drawPopup = true
			end
			
		-- Explode Vehicle --
		elseif (objLook:IsVehicle()) then
			vehName = objLook:GetDisplayName()
			vehComp = objLook:GetVehicleComponent()
			vehMass = objLook:GetTotalMass()
			vehDestoryed = objLook:IsDestroyed()
			vehComp:ExplodeVehicle(player)
			vehComp:DestroyVehicle()
			objName = vehName
			detailInfo = vehName.." weighs "..vehMass.."KG"
			breachInfo = "Vehicle has been blown up."
			if (not vehDestoryed) then
				getTime = os:clock()
				drawPopup = true
			end
		end
-- Dump object
--	elseif (ImGui.IsKeyDown(0x10) and ImGui.IsKeyPressed(0x52, false)) then
--		objLook = Game.GetTargetingSystem():GetLookAtObject(player,false,false)
--		print(Dump(objLook))
	end
end)

registerForEvent("onDraw", function()
	ImGui.PushStyleColor(ImGuiCol.PopupBg, 0.21, 0.08, 0.08, 0.85)
	ImGui.PushStyleColor(ImGuiCol.Border, 0.4, 0.17, 0.12, 1)
	ImGui.PushStyleColor(ImGuiCol.Separator, 0.4, 0.17, 0.12, 1)
	if (drawPopup) then
		ImGui.BeginTooltip()
		ImGui.SetWindowFontScale(1.6)
			ImGui.Spacing()
			ImGui.TextColored(0.2, 1, 1, 1, "DATA")
			ImGui.Spacing()
			ImGui.Spacing()
			ImGui.Spacing()
			ImGui.TextColored(1, 0.36, 0.35, 1, "SCAN RESULTS")
			ImGui.Spacing()
			ImGui.TextColored(0.98, 0.85, 0.25, 1, objName)
			ImGui.Spacing()
			ImGui.Spacing()
			ImGui.Separator()
			ImGui.Spacing()
			ImGui.Spacing()
			ImGui.TextColored(1, 0.36, 0.35, 1, "DETAILS")
			ImGui.Spacing()
			ImGui.TextColored(0.2, 1, 1, 1, detailInfo)
			ImGui.Spacing()
			ImGui.Spacing()
			ImGui.Spacing()
			ImGui.TextColored(1, 0.36, 0.35, 1, "BREACH RESULT")
			ImGui.Spacing()
			ImGui.TextColored(0.2, 1, 1, 1, breachInfo)
			ImGui.Spacing()
		ImGui.EndTooltip()
		if (os:clock() > getTime + 2) then
			drawPopup = false
		end
	end
	ImGui.PopStyleColor(3)
end)

function is_empty(t)
    for _,_ in pairs(t) do
        return false
    end
    return true
end
