extends Node



func Vector2_RandomSingle(range: float):
	return Vector2( randf_range(range*-1, range), randf_range(range*-1, range) )

func Vector2_FromString(str_vector: String) -> Vector2:
	# Remove parentheses
	var cleaned = str_vector.trim_prefix("(").trim_suffix(")")
	
	# Split and try to convert
	var components = cleaned.split(",")
	if components.size() != 2:
		push_error("Invalid vector string format")
		return Vector2.ZERO
		
	# Convert to Vector2
	return Vector2(
		float(components[0].strip_edges()),
		float(components[1].strip_edges())
	)
