extends HBoxContainer

signal pictureClicked

func _ready():
	var counter = 0
	
	for child in get_children():
		child.connect("pressed", self, "_on_buttonPressed", [child, counter])
		counter += 1
		
		
func _on_buttonPressed(node, index):
	emit_signal("pictureClicked", node, index)