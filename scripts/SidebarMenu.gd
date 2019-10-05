extends VBoxContainer

onready var clickSfx = Elements.sfx.click

func _ready():
	for child in get_children():
		child.connect("pressed", self, "_on_buttonPressed", [child.get_name()])
		
		
func _on_buttonPressed(nodeName):
	if nodeName != 'ButtonColor':
		var selectedCategory = nodeName.replace('Button', '')
		
		clickSfx.pitch_scale = 0.7
		clickSfx.play(0)
		
		Events.emit_signal("category_selected", selectedCategory)
	else:
		Events.emit_signal("open_color_picker_clicked")
