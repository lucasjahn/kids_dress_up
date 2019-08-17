extends Node2D

signal character_clicked

func _ready():
	for child in get_children():
		child.connect("pressed", self, "_on_buttonPressed", [child.get_name()])
		
		
		
func _on_buttonPressed(nodeName):
	emit_signal("character_clicked", nodeName)