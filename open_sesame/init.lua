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
	ImGui.PushStyleColor(ImGuiCol.PopupBg, 0.21, 0.08, 0.08, 0.80)
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
			ImGui.Text("Breaching Success")
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
			ImGui.Text(vehName.." weighs "..objLook:GetTotalMass().."Kg.")
			ImGui.PopStyleColor(1)
			ImGui.PushStyleColor(ImGuiCol.Text, 1, 0.36, 0.35, 1)
			ImGui.Spacing()
			ImGui.Text("BREACH RESULT")
			ImGui.PopStyleColor(1)
			ImGui.PushStyleColor(ImGuiCol.Text, 0.2, 1, 1, 1)
			ImGui.Text("Vehicle Doors Unlocked")
			ImGui.PopStyleColor(1)
		ImGui.EndTooltip()
		if (os:clock() > getTime + 2) then
			drawVehicle = false
		end
	end
	ImGui.PopStyleColor(2)
end)
