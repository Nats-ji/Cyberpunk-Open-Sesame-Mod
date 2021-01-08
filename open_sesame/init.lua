registerForEvent("onInit", function()
	HotKey = 0x45 -- Change Hotkey Here. You can find Key Codes at https://docs.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
	ts=Game.GetTimeSystem()
    drawFakeDoor = false
    trapInput = false
	gameTime = 0
    print("Open Semame Mod Loaded... Press E to open any door")
end)

registerForEvent("onUpdate", function()
		if (ImGui.IsKeyPressed(HotKey, false)) then
			objLook = Game.GetTargetingSystem():GetLookAtObject(Game.GetPlayer(),false,false)
			dsname = objLook:GetDisplayName()
			if (dsname == "LocKey#69") or (dsname == "LocKey#74") or (dsname == "Gameplay-Devices-DisplayNames-DoorLift") or (dsname == "Gameplay-Devices-DisplayNames-Door") then
				if (objLook.OpenDoor) then
					objLook:OpenDoor() -- Real Door
				else
					gameTime = ts:GetGameTimeStamp()
					print(gameTime)
					drawFakeDoor = true -- Fake Door
				end
			end
		end
end)

registerForEvent("onDraw", function()
	if (drawFakeDoor) then
	ImGui.BeginTooltip()
		ImGui.Text("This is a fake door...")
	ImGui.EndTooltip()
	end
	if (ts:GetGameTimeStamp() > gameTime + 8) then
		drawFakeDoor = false
	end
end)
