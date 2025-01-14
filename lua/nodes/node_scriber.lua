return {
	id='script',
	name="Script",
	inputs={{}},
	outputs={{}},
	color={r=0.2,g=0.4,b=1,a=1},
	size={x=200,y=200},
	schema={comment='String', script='Script',},

	GetDisplayText=function (self,data)
		return data.script
	end,

	GetScreenplayText=function (self,data)
		return self:GetDisplayText(data)
	end,


}