return {
	id='camera',
	name="Camera",
	inputs={{}},
	outputs={{}},
	color={r=0.2,g=1,b=0.5,a=1},
	size={x=175,y=100},
	schema={Camera='String',BlendTime='float'},

	GetDisplayText=function (self,data)
		return [[Camera: ']]..data.Camera..[['
		Overtime: ]]..tostring(data.BlendTime)
	end
}