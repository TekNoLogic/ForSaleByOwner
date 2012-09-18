
local myname, ns = ...


function ns.OnLoad()
	ns.InitDB()
	ns.InitDB = nil

	local char = UnitName("player")
	local orig = GameTooltip:GetScript("OnTooltipSetItem")
	GameTooltip:SetScript("OnTooltipSetItem", function(frame, ...)
		assert(frame, "arg 1 is nil, someone isn't hooking correctly")

		local _, link = frame:GetItem()
		local id = link and ns.ids[link]
		if id then
			for toon,items in pairs(ns.realmdb) do
				if toon ~= char and items[id] then
					frame:AddDoubleLine(toon.." is selling:", items[id])
				elseif toon == char and items[id] then
					frame:AddDoubleLine("You are selling:", items[id])
				end
			end
		end

		if orig then return orig(frame, ...) end
	end)
end


ns.RegisterEvent('AUCTION_HOUSE_SHOW', function()
	local textframe = AuctionsCancelAuctionButton:CreateFontString(nil, "OVERLAY")
	textframe:SetPoint("RIGHT", AuctionsCancelAuctionButton, "LEFT", -5, 0)
	textframe:SetFontObject(GameFontNormal)

	local label = AuctionsCancelAuctionButton:CreateFontString(nil, "OVERLAY")
	label:SetPoint("RIGHT", textframe, "LEFT", -5, 0)
	label:SetFontObject(GameFontHighlight)
	label:SetText("Total buyout:")

	local textframe2 = AuctionsCancelAuctionButton:CreateFontString(nil, "OVERLAY")
	textframe2:SetPoint("RIGHT", label, "LEFT", -20, 0)
	textframe2:SetFontObject(GameFontNormal)

	local label2 = AuctionsCancelAuctionButton:CreateFontString(nil, "OVERLAY")
	label2:SetPoint("RIGHT", textframe2, "LEFT", -5, 0)
	label2:SetFontObject(GameFontHighlight)
	label2:SetText("Total sold:")

	ns.AUCTION_HOUSE_SHOW = function()
		local sum, soldsum = 0, 0
		wipe(ns.chardb)
		for i = 1,GetNumAuctionItems("owner") do
			local _, _, _, _, _, _, _, _, _, buyout, bidAmount, _, _, sold, itemID
				= GetAuctionItemInfo("owner", i)

			if sold == 0 then
				ns.chardb[itemID] = (ns.chardb[itemID] or 0) + 1
				sum = sum + buyout
			else
				soldsum = soldsum + bidAmount
			end
		end
		textframe2:SetText(ns.GS(soldsum) or "ERROR")
		textframe:SetText(ns.GS(sum) or "ERROR")
	end
	ns.AUCTION_OWNED_LIST_UPDATE = ns.AUCTION_HOUSE_SHOW
	ns.AUCTION_HOUSE_SHOW()
end)


ns.RegisterEvent('AUCTION_OWNED_LIST_UPDATE', ns.AUCTION_HOUSE_SHOW)
