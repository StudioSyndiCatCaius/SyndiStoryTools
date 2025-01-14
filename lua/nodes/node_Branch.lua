return {
	id='branch',
	name="Branch",
	inputs={{}},
	outputs={{
		color={r=0,g=1,b=0,a=1}
	},{
		color={r=1,g=0,b=0,a=1}
	}},
	color={r=1,g=0.9,b=0.9,a=1},
	size={x=170,y=120},
	schema={Text='Code'},

	GetDisplayText=function (self,data)
		return data.Text
	end
}