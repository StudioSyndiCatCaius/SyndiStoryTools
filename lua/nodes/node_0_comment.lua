return {
	id='comment',
	name="Comment",
	inputs={},
	outputs={},
	color={r=0.8,g=1,b=.8,a=0.7},
	size={x=200,y=200},
    --direct_edit=true,
    resize=true,
	schema={comment='String'},
	meta={
		comment={size=100}
	},

	GetDisplayText=function (self,data)
		return data.comment
	end,

	OnDirectEdit=function (self,text)
		self.data['comment']=text
	end,
}