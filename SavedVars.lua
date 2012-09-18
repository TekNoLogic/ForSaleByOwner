
local myname, ns = ...


function ns.InitDB()
	local char = UnitName("player")
	local server = GetRealmName().." "..UnitFactionGroup("player")

	ForSaleByOwnerDB = ForSaleByOwnerDB or {}
	ForSaleByOwnerDB[server] = ForSaleByOwnerDB[server] or {}
	ForSaleByOwnerDB[server][char] = ForSaleByOwnerDB[server][char] or {}

	ns.realmdb = ForSaleByOwnerDB[server]
	ns.chardb = ns.realmdb[char]
end
