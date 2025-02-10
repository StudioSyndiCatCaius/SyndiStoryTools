return {
	id='onItemGive',
	name="on Item Give",
	tooltip="Input node, run when the owner is given an item.",
	inputs={},
	outputs={{}},
	color={r=0.5,g=0.5,b=1,a=1},
	size={x=100,y=75},
	schema={item='String'},

	GetDisplayText=function (self,data)
		return data.item
	end
}