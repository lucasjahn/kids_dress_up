extends Node2D

signal color_selected

func _ready():
	for child in $ColorPickerWrapper.get_children():
		child.connect("pressed", self, "_on_buttonPressed", [child.get_name()])
		
		
func _on_buttonPressed(colorName):
	emit_signal("color_selected", colorName.to_lower())