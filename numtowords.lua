const onesMap: { string } = { 
	"one", "two", "three", "four", "five",
	"six", "seven", "eight", "nine", "ten",	
	"eleven", "twelve", "thirteen", "fourteen",
	"fifteen", "sixteen", "seventeen", "eighteen",
	"nineteen"
}

const tensMap: { string } = {
	"twenty", "thirty", "forty", "fifty",
	"sixty", "seventy", "eighty", "ninety"
}

const suffixMap: { string } = { "thousand", "million", "billion" }

local function parse_below_twenty(num: number): string
	return onesMap[num]
end

local function parse_below_hundred(num: number): string
	local tens, ones = (num // 10), (num % 10)
	if ones == 0 then
		return tensMap[tens - 1]
	end
	
	return `{tensMap[tens - 1]}-{parse_below_twenty(ones)}`
end

local function parse_below_thousand(num: number): string
	local hundreds, remainder = (num // 100), (num % 100)
	if remainder == 0 then
		return `{hundreds} hundred`
	end
	
	return `{parse_below_twenty(hundreds)} hundred and {parse_below_hundred(remainder)}`
end

local function parse_num(num: number): string
	if num < 20 then
		return parse_below_twenty(num)
	end
		
	if num < 100 then
		return parse_below_hundred(num)
	end

	return parse_below_thousand(num)
end

local function num_to_words(num: number): string
	if num == 0 then return 'zero' end
	num = math.abs(num)
	
	local result: {string} = {}
	
	local parts: {string} = {}
	while num > 0 do
		table.insert(parts, (num % 1000))
		num = (num // 1000)
	end
	
	local formatString = ""
	for idx = #parts, 1, -1 do
		local digit = parts[idx]
		if digit == 0 then continue end
		
		local parsedNumber = parse_num(digit)
		
		local suffix = suffixMap[idx - 1]
		if suffix then
			parsedNumber = `{parsedNumber} {suffix}`
		end
		
		table.insert(result, parsedNumber)
	end
	
	return table.concat(result, " ")
end
