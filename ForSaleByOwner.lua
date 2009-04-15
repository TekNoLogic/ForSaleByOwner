
local char, server = UnitName("player"), GetRealmName().." "..UnitFactionGroup("player")
local realmdb, chardb

local function GS(cash)
	if not cash then return end
	cash = cash/100
	local s = floor(cash%100)
	local g = floor(cash/100)
	if g > 0 then return string.format("|cffffd700%d.|cffc7c7cf%02d", g, s)
	else return string.format("|cffc7c7cf%d", s) end
end


local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addon)
	if addon ~= "ForSaleByOwner" then return end

	ForSaleByOwnerDB = ForSaleByOwnerDB or {}
	ForSaleByOwnerDB[server] = ForSaleByOwnerDB[server] or {}
	ForSaleByOwnerDB[server][char] = ForSaleByOwnerDB[server][char] or {}
	realmdb, chardb = ForSaleByOwnerDB[server], ForSaleByOwnerDB[server][char]

	self:UnregisterEvent("ADDON_LOADED")

	self:RegisterEvent("AUCTION_HOUSE_SHOW")
	self:RegisterEvent("AUCTION_OWNED_LIST_UPDATE")
	self:SetScript("OnEvent", function(self)
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

		local function OnEvent()
			local sum, soldsum = 0, 0
			for i in pairs(chardb) do chardb[i] = nil end
			for i = 1,GetNumAuctionItems("owner") do
				local name, _, _, _, _, _, _, _, buyout, bidAmount, _, _, sold = GetAuctionItemInfo("owner", i)
				if sold == 0 then
					chardb[name] = (chardb[name] or 0) + 1
					sum = sum + buyout
				else
					soldsum = soldsum + bidAmount
				end
			end
			textframe2:SetText(GS(soldsum) or "ERROR")
			textframe:SetText(GS(sum) or "ERROR")
		end

		self:SetScript("OnEvent", OnEvent)
		OnEvent()
	end)

	local orig = GameTooltip:GetScript("OnTooltipSetItem")
	GameTooltip:SetScript("OnTooltipSetItem", function(frame, ...)
		assert(frame, "arg 1 is nil, someone isn't hooking correctly")

		local _, link = frame:GetItem()
		local name = link and GetItemInfo(link)
		if name then
			for toon,items in pairs(realmdb) do
				if toon ~= char and items[name] then
					frame:AddDoubleLine(toon.." is selling:", items[name])
				elseif toon == char and items[name] then
					frame:AddDoubleLine("You are selling:", items[name])
				end
			end
		end

		if orig then return orig(frame, ...) end
	end)
end)
