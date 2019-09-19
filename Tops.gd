extends VBoxContainer

# warning-ignore:unused_class_variable
export var isColored : bool
# warning-ignore:unused_class_variable
export var texturePrefix : String

signal colorSelected

func _ready():
	for child in get_children():
		var button = child.get_children()[0]
		button.connect("pressed", self, "_on_buttonPressed", [self, child.get_name()])
		
		
func _on_buttonPressed(category, itemName):
	emit_signal("colorSelected", category, itemName)
