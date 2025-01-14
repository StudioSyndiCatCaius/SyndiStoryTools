extends wg_PropertyBase

@export var N_ValueEdit: CodeEdit

func _init_value():
	default_value=''
	N_ValueEdit.text=Value_Get()

func _on_code_edit_text_changed():
	Value_Set(N_ValueEdit.text)

var speakers = ["Judith", "Becky", "Alex", "Sarah"] # Add your speaker names here
func _ready():
	speakers=APP._D['Speakers']
	# Set up syntax highlighting
	var syntax_highlighter = CodeHighlighter.new()
	
	# Set default colors to white to prevent interference
	syntax_highlighter.number_color = Color.WHITE
	syntax_highlighter.symbol_color = Color.WHITE
	syntax_highlighter.function_color = Color.WHITE
	syntax_highlighter.member_variable_color = Color.WHITE
	
	# Create color constants
	var blue_color = Color(0.3, 0.5, 1.0)
	var green_color = Color(0.3, 0.8, 0.3)
	var red_color = Color(0.8, 0.3, 0.3)
	var yellow_color = Color(0.8, 0.8, 0.3)
	
	# Set up custom syntax highlighting
	syntax_highlighter.add_color_region("[", "]", blue_color, false)  # false = don't color whitespace
	
	# Add line-based colors (from start character to newline)
	syntax_highlighter.add_color_region("+", " ", green_color, true)
	syntax_highlighter.add_color_region("-", " ", red_color, true)
	syntax_highlighter.add_color_region("#", " ", yellow_color, true)
	
	syntax_highlighter.add_keyword_color("%",Color.AQUA)
	syntax_highlighter.add_member_keyword_color("hugo",Color.BLUE)
	
	# Apply highlighter to CodeEdit
	N_ValueEdit.syntax_highlighter = syntax_highlighter
	
	# Connect signals
	N_ValueEdit.text_changed.connect(_on_text_changed)
	
	# Set up code completion
	N_ValueEdit.code_completion_enabled = true
	N_ValueEdit.code_completion_prefixes = ["["]

func is_LastCodeB(char: String):
	var cursor_line = N_ValueEdit.get_caret_line()
	var cursor_column = N_ValueEdit.get_caret_column()
	var line_text = N_ValueEdit.get_line(cursor_line)
	return  cursor_column > 0 and line_text[cursor_column - 1] == char

func _on_text_changed():
	# Check if we need to show completion
	var cursor_line = N_ValueEdit.get_caret_line()
	var cursor_column = N_ValueEdit.get_caret_column()
	var line_text = N_ValueEdit.get_line(cursor_line)
	
	var is_lastCode=func(char: String):
		return cursor_column > 0 and line_text[cursor_column - 1] == char
	
	if is_lastCode.call("["):
		_show_completion(speakers)

func _show_completion(options):
	# Add each suggestion individually
	for i in options:
		N_ValueEdit.add_code_completion_option(CodeEdit.KIND_CLASS, i, i)
	# Show completion popup
	N_ValueEdit.update_code_completion_options(true)

# Optional: Add method to get currently selected text between brackets
func get_selected_speaker() -> String:
	var cursor_line = N_ValueEdit.get_caret_line()
	var line_text = N_ValueEdit.get_line(cursor_line)
	
	var start_idx = line_text.find("[")
	var end_idx = line_text.find("]", start_idx)
	
	if start_idx != -1 and end_idx != -1:
		return line_text.substr(start_idx + 1, end_idx - start_idx - 1)
	
	return ""
