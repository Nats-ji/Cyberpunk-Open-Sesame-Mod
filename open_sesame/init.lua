registerForEvent("onInit", function()
	HotKey = 0x45 -- Change Hotkey Here. You can find Key Codes at https://docs.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
    drawFakeDoor = false
	drawDoor = false
	drawVehicle = false
	drawNPC = false
	getTime = 0
	print("******************************************************")
    print("* Open Semame Mod Loaded... Press E to open any door *")
	print("******************************************************")
end)

registerForEvent("onUpdate", function()
	if (not ImGui.IsKeyDown(0x10) and ImGui.IsKeyPressed(HotKey, false)) then
		drawFakeDoor = false
		drawDoor = false
		drawVehicle = false
		drawNPC = false
		player = Game.GetPlayer()
		objLook = Game.GetTargetingSystem():GetLookAtObject(player,false,false)
		objType = objLook:ToString()
		if (objType == "Door") then
			objLook:OpenDoor() -- Real Door
			getTime = os:clock()
			drawDoor = true
		elseif (objType == "FakeDoor") then
			getTime = os:clock()
			drawFakeDoor = true -- Fake Door
		elseif (objLook:IsVehicle()) then
			vehDestoryed = objLook:IsDestroyed()
			if (not vehDestoryed) then
				vehName = objLook:GetDisplayName()
				vehPS = objLook:GetVehiclePS()
				vehComp = objLook:GetVehicleComponent()
				vehOcc = not is_empty(vehPS:GetNpcOccupiedSlots())
				vehMass = objLook:GetTotalMass()
				vehBreachInfo = "Vehicle doors has been unlocked."
				if (vehOcc) then -- Vehicle is occupied by npc
					vehComp:DestroyVehicle() -- Eject NPCs
					vehComp:RepairVehicle()
					vehComp:DestroyMappin() -- RepairVehicle() somehow adds mappin
				end
				vehPS:UnlockAllVehDoors()	-- Open Vehicle Doors
				vehComp:HonkAndFlash()
				getTime = os:clock()
				drawVehicle = true
			end
		end
	elseif (ImGui.IsKeyDown(0x10) and ImGui.IsKeyPressed(HotKey, false)) then
		drawFakeDoor = false
		drawDoor = false
		drawVehicle = false
		drawNPC = false
		player = Game.GetPlayer()
		objLook = Game.GetTargetingSystem():GetLookAtObject(player,false,false)
		objType = objLook:ToString()
		if (objType == "NPCPuppet") then
			if (not objLook:IsDead()) then
				npcName = objLook:GetDisplayName()
				objLook:Kill(player, false, false)  -- Kill NPC by player
				getTime = os:clock()
				drawNPC = true
			end
		elseif (objLook:IsVehicle()) then
			vehName = objLook:GetDisplayName()
			vehComp = objLook:GetVehicleComponent()
			vehMass = objLook:GetTotalMass()
			vehDestoryed = objLook:IsDestroyed()
			vehComp:ExplodeVehicle(player)
			vehComp:DestroyVehicle()
			vehBreachInfo = "Vehicle has been blown up."
			if (not vehDestoryed) then
				getTime = os:clock()
				drawVehicle = true
			end
		end
-- Dump object
--	elseif (ImGui.IsKeyDown(0x10) and ImGui.IsKeyPressed(0x52, false)) then
--		objLook = Game.GetTargetingSystem():GetLookAtObject(player,false,false)
--		print(Dump(objLook))
	end
end)

registerForEvent("onDraw", function()
	ImGui.PushStyleColor(ImGuiCol.PopupBg, 0.21, 0.08, 0.08, 1)
	ImGui.PushStyleColor(ImGuiCol.Border, 0.4, 0.17, 0.12, 1)
	if (drawFakeDoor) then
		ImGui.BeginTooltip()
		ImGui.SetWindowFontScale(1.6)
			ImGui.PushStyleColor(ImGuiCol.Text, 0.2, 1, 1, 1)
			ImGui.Text("DATA")
			ImGui.Spacing()
			ImGui.PopStyleColor(1)
			ImGui.PushStyleColor(ImGuiCol.Text, 1, 0.36, 0.35, 1)
			ImGui.Text("SCAN RESULTS")
			ImGui.PopStyleColor(1)
			ImGui.PushStyleColor(ImGuiCol.Text, 0.98, 0.85, 0.25, 1)
			ImGui.Text(objType)
			ImGui.PopStyleColor(1)
			ImGui.Spacing()
			ImGui.Separator()
			ImGui.Spacing()
			ImGui.PushStyleColor(ImGuiCol.Text, 1, 0.36, 0.35, 1)
			ImGui.Text("DETAILS")
			ImGui.PopStyleColor(1)
			ImGui.PushStyleColor(ImGuiCol.Text, 0.2, 1, 1, 1)
			ImGui.Text("This is a fake door...")
			ImGui.PopStyleColor(1)
			ImGui.PushStyleColor(ImGuiCol.Text, 1, 0.36, 0.35, 1)
			ImGui.Spacing()
			ImGui.Text("BREACH RESULT")
			ImGui.PopStyleColor(1)
			ImGui.PushStyleColor(ImGuiCol.Text, 0.2, 1, 1, 1)
			ImGui.Text("Breaching Failed")
			ImGui.PopStyleColor(1)
		ImGui.EndTooltip()
		if (os:clock() > getTime + 2) then
			drawFakeDoor = false
		end
	elseif (drawDoor) then
		ImGui.BeginTooltip()
		ImGui.SetWindowFontScale(1.6)
			ImGui.PushStyleColor(ImGuiCol.Text, 0.2, 1, 1, 1)
			ImGui.Text("DATA")
			ImGui.Spacing()
			ImGui.PopStyleColor(1)
			ImGui.PushStyleColor(ImGuiCol.Text, 1, 0.36, 0.35, 1)
			ImGui.Text("SCAN RESULTS")
			ImGui.PopStyleColor(1)
			ImGui.PushStyleColor(ImGuiCol.Text, 0.98, 0.85, 0.25, 1)
			ImGui.Text(objType)
			ImGui.PopStyleColor(1)
			ImGui.Spacing()
			ImGui.Separator()
			ImGui.Spacing()
			ImGui.PushStyleColor(ImGuiCol.Text, 1, 0.36, 0.35, 1)
			ImGui.Text("DETAILS")
			ImGui.PopStyleColor(1)
			ImGui.PushStyleColor(ImGuiCol.Text, 0.2, 1, 1, 1)
			ImGui.Text("Open Sesame...")
			ImGui.PopStyleColor(1)
			ImGui.PushStyleColor(ImGuiCol.Text, 1, 0.36, 0.35, 1)
			ImGui.Spacing()
			ImGui.Text("BREACH RESULT")
			ImGui.PopStyleColor(1)
			ImGui.PushStyleColor(ImGuiCol.Text, 0.2, 1, 1, 1)
			ImGui.Text("The door has been opened.")
			ImGui.PopStyleColor(1)
		ImGui.EndTooltip()
		if (os:clock() > getTime + 2) then
			drawDoor = false
		end
	elseif (drawVehicle) then
		ImGui.BeginTooltip()
		ImGui.SetWindowFontScale(1.6)
			ImGui.PushStyleColor(ImGuiCol.Text, 0.2, 1, 1, 1)
			ImGui.Text("DATA")
			ImGui.Spacing()
			ImGui.PopStyleColor(1)
			ImGui.PushStyleColor(ImGuiCol.Text, 1, 0.36, 0.35, 1)
			ImGui.Text("SCAN RESULTS")
			ImGui.PopStyleColor(1)
			ImGui.PushStyleColor(ImGuiCol.Text, 0.98, 0.85, 0.25, 1)
			ImGui.Text(vehName)
			ImGui.PopStyleColor(1)
			ImGui.Spacing()
			ImGui.Separator()
			ImGui.Spacing()
			ImGui.PushStyleColor(ImGuiCol.Text, 1, 0.36, 0.35, 1)
			ImGui.Text("DETAILS")
			ImGui.PopStyleColor(1)
			ImGui.PushStyleColor(ImGuiCol.Text, 0.2, 1, 1, 1)
			ImGui.Text(vehName.." weighs "..vehMass.."Kg.")
			ImGui.PopStyleColor(1)
			ImGui.PushStyleColor(ImGuiCol.Text, 1, 0.36, 0.35, 1)
			ImGui.Spacing()
			ImGui.Text("BREACH RESULT")
			ImGui.PopStyleColor(1)
			ImGui.PushStyleColor(ImGuiCol.Text, 0.2, 1, 1, 1)
			ImGui.Text(vehBreachInfo)
			ImGui.PopStyleColor(1)
		ImGui.EndTooltip()
		if (os:clock() > getTime + 2) then
			drawVehicle = false
		end
		elseif (drawNPC) then
		ImGui.BeginTooltip()
		ImGui.SetWindowFontScale(1.6)
			ImGui.PushStyleColor(ImGuiCol.Text, 0.2, 1, 1, 1)
			ImGui.Text("DATA")
			ImGui.Spacing()
			ImGui.PopStyleColor(1)
			ImGui.PushStyleColor(ImGuiCol.Text, 1, 0.36, 0.35, 1)
			ImGui.Text("SCAN RESULTS")
			ImGui.PopStyleColor(1)
			ImGui.PushStyleColor(ImGuiCol.Text, 0.98, 0.85, 0.25, 1)
			ImGui.Text(npcName)
			ImGui.PopStyleColor(1)
			ImGui.Spacing()
			ImGui.Separator()
			ImGui.Spacing()
			ImGui.PushStyleColor(ImGuiCol.Text, 1, 0.36, 0.35, 1)
			ImGui.Text("DETAILS")
			ImGui.PopStyleColor(1)
			ImGui.PushStyleColor(ImGuiCol.Text, 0.2, 1, 1, 1)
			ImGui.Text(npcName.." is a NPC.")
			ImGui.PopStyleColor(1)
			ImGui.PushStyleColor(ImGuiCol.Text, 1, 0.36, 0.35, 1)
			ImGui.Spacing()
			ImGui.Text("BREACH RESULT")
			ImGui.PopStyleColor(1)
			ImGui.PushStyleColor(ImGuiCol.Text, 0.2, 1, 1, 1)
			ImGui.Text(npcName.." has been killed.")
			ImGui.PopStyleColor(1)
		ImGui.EndTooltip()
		if (os:clock() > getTime + 2) then
			drawNPC = false
		end
	end
	ImGui.PopStyleColor(2)
end)

function is_empty(t)
    for _,_ in pairs(t) do
        return false
    end
    return true
end
