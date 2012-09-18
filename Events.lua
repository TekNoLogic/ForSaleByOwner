
local myname, ns = ...


local frame = CreateFrame("Frame")


function ns.RegisterEvent(event, func)
	frame:RegisterEvent(event)
	if func then ns[event] = func end
end


frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, arg1, ...)
	-- Handle special OnLoad code when our addon has loaded, if present
	-- If ns.ADDON_LOADED is defined, the ADDON_LOADED event is not unregistered
	if event == "ADDON_LOADED" and arg1 == myname and ns.OnLoad then
		local disable = ns.OnLoad()
		if not ns.ADDON_LOADED then frame:UnregisterEvent("ADDON_LOADED") end
		ns.OnLoad = nil
	end

	if ns[event] then ns[event](event, arg1, ...) end
end)
