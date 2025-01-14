extends Node


func GUID_New() -> String:
	var characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	var result = ""
	
	for i in range(12):
		result += characters[randi() % characters.length()]
	
	return result
