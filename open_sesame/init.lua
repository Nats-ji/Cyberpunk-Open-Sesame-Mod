registerForEvent("onInit", function()
	HotKey = 0x45 -- Change Hotkey Here. You can find Key Codes at https://docs.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
    drawFakeDoor = false
	drawDoor = false
	drawVehicle = false
	getTime = 0
    print("Open Semame Mod Loaded... Press E to open any door")
end)

registerForEvent("onUpdate", function()
		if (ImGui.IsKeyPressed(HotKey, false)) then
			objLook = Game.GetTargetingSystem():GetLookAtObject(Game.GetPlayer(),false,false)
			objType = objLook:ToString()
			if (objType == "Door") then
				objLook:OpenDoor() -- Real Door
				getTime = os:clock()
				drawDoor = true
			elseif (objType == "FakeDoor") then
				getTime = os:clock()
				drawFakeDoor = true -- Fake Door
			elseif (objLook:IsVehicle()) then
				vehName = objLook:GetDisplayName()
				vehPS = objLook:GetVehiclePS()
				vehPS:UnlockAllVehDoors()	-- Open Vehicle Doors
				getTime = os:clock()
				drawVehicle = true
			end
		end
end)

registerForEvent("onDraw", function()
	if (drawFakeDoor) then
		ImGui.BeginTooltip()
			ImGui.Text("This is a fake door...")
		ImGui.EndTooltip()
		if (os:clock() > getTime + 0.8) then
			drawFakeDoor = false
		end
	elseif (drawDoor) then
		ImGui.BeginTooltip()
			ImGui.Text("OPEN SESAME!")
		ImGui.EndTooltip()
		if (os:clock() > getTime + 0.8) then
			drawDoor = false
		end
	elseif (drawVehicle) then
		ImGui.BeginTooltip()
			vehToolTip = vehName.." has been unlocked!"
			ImGui.Text(vehToolTip)
		ImGui.EndTooltip()
		if (os:clock() > getTime + 1) then
			drawVehicle = false
		end
	end
end)
