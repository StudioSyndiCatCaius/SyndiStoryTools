return {
	id='scriptCall',
	name="Script Call",
	inputs={{}},
	outputs={{}},
	color={r=0.0,g=0.7,b=1,a=1},
	size={x=200,y=100},
	schema={comment='String', script='Code',},

	GetDisplayText=function (self,data)
		return data.script
	end,

	GetScreenplayText=function (self,data)
		return self:GetDisplayText(data)
	end,


}