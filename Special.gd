extends GridContainer

# warning-ignore:unused_class_variable
export var isColored : bool
# warning-ignore:unused_class_variable
export var texturePrefix : String
export var scaleFactor : float = 0.6

signal colorSelected

func _ready():
	for child in get_children():
		var button = child.get_children()[0]
		button.connect("pressed", self, "_on_buttonPressed", [self, child.get_name()])
		_set_min_size(button)
		
		
func _on_buttonPressed(category, itemName):
	emit_signal("colorSelected", category, itemName)

func _set_min_size(node): 
	node.set_custom_minimum_size(Vector2(node.rect_size.x*scaleFactor, node.rect_size.y*scaleFactor))
	node.expand = true