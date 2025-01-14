@tool
extends EditorPlugin

var autoLoads={
	SynMath="res://addons/SynLib/Globals/SynMath.gd",
	SynFile="res://addons/SynLib/Globals/SynFile.gd",
	SynNode="res://addons/SynLib/Globals/SynNode.gd",
	SynType="res://addons/SynLib/Globals/SynType.gd",
	SynGuid="res://addons/SynLib/Globals/SynGuid.gd",
	SynString="res://addons/SynLib/Globals/SynString.gd",
}

func _enter_tree():
	for i in autoLoads.keys():
		add_autoload_singleton(i,autoLoads[i])


func _exit_tree():
	for i in autoLoads.keys():
		remove_autoload_singleton(i)
