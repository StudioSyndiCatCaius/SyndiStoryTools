return {
	id='finish',
	name="Finish",
	inputs={{}},
	outputs={},
	color={r=1,g=0,b=0,a=1},
	size={x=100,y=75},
	schema={flag='String'},

	GetDisplayText=function (self,data)
		return data.flag
	end
}