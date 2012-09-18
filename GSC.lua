
local myname, ns = ...


-- Converts an integer into a colored gold.silver.copper string
--
--   cash - an integer representing a price in copper
--
-- Returns a colored string
function ns.GSC(cash)
	if not cash then return end

	local g, s, c = floor(cash/10000), floor((cash/100)%100), cash%100

	if g > 0 then
		return string.format("|cffffd700%d.|cffc7c7cf%02d.|cffeda55f%02d", g, s, c)
	elseif s > 0 then
		return string.format("|cffc7c7cf%d.|cffeda55f%02d", s, c)
	else
		return string.format("|cffeda55f%d", c)
	end
end


-- Converts an integer into a colored gold.silver string
--
--   cash - an integer representing a price in copper
--
-- Returns a colored string
function ns.GS(cash)
	if not cash then return end

	cash = cash/100
	local s = floor(cash%100)
	local g = floor(cash/100)

	if g > 0 then
		return string.format("|cffffd700%d.|cffc7c7cf%02d", g, s)
	else
		return string.format("|cffc7c7cf%d", s)
	end
end
