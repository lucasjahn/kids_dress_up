extends TextureRect

signal colorSelected

func _ready():
	for child in get_children():
		child.connect("pressed", self, "_on_buttonPressed", [get_parent().get_name(), child.get_name()])
		
		
func _on_buttonPressed(category, itemName):
	emit_signal("colorSelected", category, itemName)
