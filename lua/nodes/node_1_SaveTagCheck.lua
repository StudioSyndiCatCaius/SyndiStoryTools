

local function readCSVColumn(filename, columnName)
    local data = {}
    print('attempting to read path: '..filename)
    local file = io.open(filename, "r")
    -- Read headers
    local headers = {}
    local headerLine = file:read()
    print("File path read result.."..tostring(headerLine))
    for header in headerLine:gmatch("([^,]+)") do
        headers[#headers + 1] = header:gsub("^%s*(.-)%s*$", "%1") -- trim whitespace
    end
    
    -- Find target column index
    local columnIndex
    for i, header in ipairs(headers) do
        if header == columnName then
            columnIndex = i
            break
        end
    end
    
    -- Read column values
    while true do
        local line = file:read()
        if not line then break end
        
        local currentColumn = 1
        for value in line:gmatch("([^,]+)") do
            if currentColumn == columnIndex then
                data[#data + 1] = value:gsub("^%s*(.-)%s*$", "%1")
                break
            end
            currentColumn = currentColumn + 1
        end
    end
    
    file:close()
    return data
end


local a={
	id='SaveHasTag',
	name="Save Has Tag",
	inputs={{}},
	outputs={{
		color={r=0,g=1,b=0,a=1}
	},{
		color={r=1,g=0,b=0,a=1}
	}},
	color={r=1,g=0.9,b=0.9,a=1},
	size={x=170,y=120},
	schema={tag='Enum',},
	meta={
		tag={
			GetOptions=function ()
                local out=readCSVColumn("../../misc_data/DT_StoryTags.csv",'Tag')
				return out
			end
		}
	},

	GetDisplayText=function (self,data)
		return data.text
	end,
}



return a