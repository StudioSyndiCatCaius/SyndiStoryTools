extends Control


@onready var N_Vbox=$VBoxContainer



# Called when the node enters the scene tree for the first time.
func _ready():

	for file in SynFile.FILES_ListInDirectory(APP.Project_GetSubDir('dlg'),"dlg",true):
		var file_data=SynFile.FILE_LoadAsJson(file)
		for event in file_data.get('nodes',[]):
			var node_data=APP.GraphNode_Types[event.type]
			if node_data.has('GetScreenplayText'):
				var txt=node_data.GetScreenplayText.call(node_data,event.data)
				if txt is String:
					var new_block=Label.new()
					new_block.text=txt
					N_Vbox.add_child(new_block)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
