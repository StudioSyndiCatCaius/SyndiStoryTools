return {
	id='finish',
	name="Finish",
	inputs={{}},
	outputs={},
	color={r=0.5,g=0.5,b=0.5,a=1},
	size={x=100,y=75},
	schema={flag='String'},

	GetDisplayText=function (self,data)
		return data.flag
	end
}