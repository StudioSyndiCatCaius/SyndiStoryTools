return {
	id='ToHub',
	name="To HUB",
	inputs={{}},
	outputs={},
	color={r=1,g=1,b=0,a=1},
	size={x=100,y=75},
	schema={hub='String'},

	GetDisplayText=function (self,data) return data.hub end,
}