extends VBoxContainer

signal categorySelected

onready var clickSfx = get_tree().get_root().get_node('Main').get_node('Sfx/Click')

func _ready():
	for child in get_children():
		if child.get_name() != 'ButtonColor':
			child.connect("pressed", self, "_on_buttonPressed", [child.get_name()])
		
		
func _on_buttonPressed(nodeName):
	var selectedCategory = nodeName.replace('Button', '')
	
	clickSfx.pitch_scale = 0.7
	clickSfx.play(0)

	emit_signal("categorySelected", selectedCategory)
