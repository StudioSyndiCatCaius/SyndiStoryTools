extends wg_PropertyBase

@export var N_ValueEdit: CodeEdit

func _init_value():
	default_value=''
	N_ValueEdit.text=Value_Get()

func _on_code_edit_text_changed():
	Value_Set(N_ValueEdit.text)

var keyworlds=['if','else','function','end','then','return']

func _ready():

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
	
	syntax_highlighter.symbol_color=yellow_color
	
	for i in keyworlds:
		syntax_highlighter.add_member_keyword_color(i,red_color)
	
	# Apply highlighter to CodeEdit
	N_ValueEdit.syntax_highlighter = syntax_highlighter


