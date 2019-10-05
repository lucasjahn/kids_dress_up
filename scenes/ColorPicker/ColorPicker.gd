extends MarginContainer

signal color_selected

func _ready():
	for child in $CenterContainer/ColorPickerWrapper.get_children():
		child.connect("pressed", self, "_on_buttonPressed", [child.get_name()])


func _on_buttonPressed(colorName):
	Events.emit_signal("color_picked", colorName.to_lower())