extends Node


func Split(text: String, delimiter: String, from_end: bool = false) -> Array:
	if from_end:
		var position = text.rfind(delimiter)
		return [text.substr(0, position), text.substr(position + delimiter.length())] if position != -1 else [text]
	else:
		var position = text.find(delimiter)
		return [text.substr(0, position), text.substr(position + delimiter.length())] if position != -1 else [text]
