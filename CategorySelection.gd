extends Node2D

signal categorySelected

func _ready():
	for child in get_children():
		child.connect("pressed", self, "_on_buttonPressed", [child.get_name()])
		
		
		
func _on_buttonPressed(nodeName):
	var selectedCategory = nodeName.replace('Button', '')
	emit_signal("categorySelected", selectedCategory)
