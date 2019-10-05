extends HBoxContainer

signal character_clicked

func _ready():
	for child in get_children():
		var childButton = child.get_children()[0]
		childButton.connect("pressed", self, "_on_buttonPressed", [childButton.get_name()])
		
		
func _on_buttonPressed(nodeName):
	emit_signal("character_clicked", nodeName)