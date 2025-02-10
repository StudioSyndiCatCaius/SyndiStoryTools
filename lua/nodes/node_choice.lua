return {
	id='choice',
	name="Choice",
	inputs={{}},
	outputs={{}},
	color={r=0.4,g=1,b=0.6,a=1},
	size={x=175,y=100},
	schema={text='String',condition="Code",type='Enum',},
	meta={
		type={
			GetOptions=function ()
				return {
					'','question','next','quest','yes','no','exit',
				}
			end
		}
	},

	GetDisplayText=function (self,data)
		return data.text
	end
}