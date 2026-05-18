--!strict
--@tinywingedangel
--05/18/26

const ones: { string } = {
	"one", "two", "three", "four", "five",
	"six", "seven", "eight", "nine",
	"ten", "eleven", "twelve", "thirteen",
	"fourteen", "fifteen", "sixteen", "seventeen",
	"eighteen", "nineteen"
}

const tens: { string } = {
	"twenty", "thirty", "fourty", "fifty",
	"sixty", "seventy", "eighty", "ninety"
}

const suffixes: { string } = {
	"thousand", "million", "billion"
}

local function parse_below_twenty(num: number): string
	return ones[num]
end

local function parse_below_hundred(num: number): string
	local tensPlace = (num // 10)
	local onesPlace = (num % 10)

	local tensDigit = tens[tensPlace - 1]
	local onesDigit = ones[onesPlace]
	if onesPlace == 0 then
		return tensDigit
	end

	return `{tensDigit}-{onesDigit}`
end

local function parse_below_thousand(num: number): string
	local hundredsPlace = (num // 100)
	local leftover = (num % 100)

	local hundredsDigit = ones[hundredsPlace]
	if leftover == 0 then
		return `{hundredsDigit} hundred`
	end

	return `{hundredsDigit} hundred and {parse_below_hundred(leftover)}`
end

-- Parse numbers below a thousand (1 - 999)
local function parse_number(num: number): string
	if num < 20 then
		return parse_below_twenty(num)
	end
	
	if num < 100 then
		return parse_below_hundred(num)
	end
	
	if num < 1000 then
		return parse_below_thousand(num)
	end
end

local function num_to_words(num: number): string
	if num == 0 then return "zero" end
	num = math.abs(num)
	
	-- Partition the number into base-1000
	local partitioned: { number } = {}
	while num > 0 do
		table.insert(partitioned, num % 1000)
		num = (num // 1000)
	end
	
	-- Next, go through each of the partitioned
	-- numbers and concatenate them together
	local parts: { string } = {}
	for idx = #partitioned, 1, -1 do
		local num = partitioned[idx]
		local parsed = parse_number(num)
		
		local suffix = suffixes[idx - 1]
		if suffix then
			parsed = `{parsed} {suffix},`
		end
		
		table.insert(parts, parsed)
	end
	
	return table.concat(parts, " ")
end

--[[
	Output:
		one million, 
		two hundred and thirty-four thousand, 
		four hundred and fifty-six
]]

num_to_words(1_234_456)
