return {
	id='HUB',
	name="HUB",
	tooltip="A common reroute point you can used for cleaner dialog layout.",
	inputs={},
	outputs={{}},
	color={r=1,g=1,b=0,a=1},
	size={x=100,y=75},
	schema={hub='String'},

	GetDisplayText=function (self,data) return data.hub end,
}