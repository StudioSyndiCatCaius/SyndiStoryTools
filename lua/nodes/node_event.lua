return {
	id='event',
	name="Event",
	inputs={{}},
	outputs={{}},
	color={r=0.2,g=0.4,b=1,a=1},
	size={x=200,y=200},
	schema={Events='Events',name='String'},

	GetNodeTitle=function (self,data)
		return "Event: "..data.name
	end,

	GetDisplayText=function (self,data)
		local out=""
		local num=#data.events
		--print('begin parse events: '..num)

		for i = 1, num, 1 do
			local spk=''
			if (data.events[i]['speaker']) then
				spk=data.events[i]['speaker']
			end
			local in_str=spk..[[: "]]..data.events[i]['line']..[["]]
			out=out..in_str..[[ 
			________________
			]]
		end
		
		return out

	end,

	GetScreenplayText=function (self,data)
		local out=""
		local num=#data.events
		--print('begin parse events: '..num)

		for i = 1, num, 1 do
			local spk=''
			if (data.events[i]['speaker']) then
				spk=data.events[i]['speaker']
			end
			local in_str=spk..[[: "]]..data.events[i]['line']..[["]]
			out=out..in_str..[[ 
			________________
			]]
		end
		
		return out

	end,
}