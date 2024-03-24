-- CP77 Open Sesame Mod is a mod which gives you abilities to open
-- locked doors and vehicles in Cyberpunk 2077.

-- Copyright (C) 2020-2021 Mingming Cui
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.


registerForEvent("onInit", function()
	drawPopup = false
	wWidth, wHeight = GetDisplayResolution()
	getTime = 0
	print("************************************************")
	print("* Open Sesame Mod Loaded...                    *")
	print("************************************************")
end)

registerHotkey("open_sesame_open", "Open/Unlock Hotkey", function()
	drawPopup = false
	player = Game.GetPlayer()
	objLook = Game.GetTargetingSystem():GetLookAtObject(player,false,false)

  if objLook then
  	objType = objLook:ToString()

  	-- Real door --
  	if (objType == "Door") then
  		objName = objType
  		detailInfo = "Open Sesame..."
  		breachInfo = "The door has been opened."
		local handlePS = objLook:GetDevicePS()
		if handlePS:IsSealed() then handlePS:ToggleSealOnDoor() end
		if handlePS:IsLocked() then
			handlePS:ToggleLockOnDoor()
		end
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

  end
end)

registerHotkey("open_sesame_kill", "Kill/Explode Hotkey", function()
	drawPopup = false
	player = Game.GetPlayer()
	objLook = Game.GetTargetingSystem():GetLookAtObject(player,false,false)
  if objLook then
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

  end
end)

registerForEvent("onDraw", function()
	ImGui.PushStyleColor(ImGuiCol.WindowBg, 0.21, 0.08, 0.08, 0.85)
	ImGui.PushStyleColor(ImGuiCol.Border, 0.4, 0.17, 0.12, 1)
	ImGui.PushStyleColor(ImGuiCol.Separator, 0.4, 0.17, 0.12, 1)
	if (drawPopup) then
		ImGui.Begin("Popup", true, bit32.bor(ImGuiWindowFlags.NoResize, ImGuiWindowFlags.NoMove, ImGuiWindowFlags.NoTitleBar, ImGuiWindowFlags.AlwaysAutoResize, ImGuiWindowFlags.NoNav))
		ImGui.SetWindowPos(wWidth/2, wHeight/2)
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
		ImGui.End()
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
