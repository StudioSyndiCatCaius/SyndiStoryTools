return {
	id='choice',
	name="Choice",
	inputs={{}},
	outputs={{}},
	color={r=0.4,g=1,b=0.6,a=1},
	size={x=175,y=100},
	schema={Text='String'},

	GetDisplayText=function (self,data)
		return data.Text
	end
}