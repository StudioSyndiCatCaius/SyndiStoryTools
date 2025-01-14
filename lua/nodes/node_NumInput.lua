return {
	id='NumInput',
	name="Number Input",
	inputs={{}},
	outputs={{
		color={r=0,g=1,b=0,a=1}
	},{
		color={r=1,g=0,b=0,a=1}
	}},
	color={r=1,g=0.9,b=0.9,a=1},
	size={x=170,y=100},
	schema={CorrectNumber='int'},

	GetDisplayText=function (self,data)
		return tostring(data.CorrectNumber)
	end
}