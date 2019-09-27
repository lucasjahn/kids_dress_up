extends Node2D

var activeWardrobeCategory = null
var activeWardrobeColor = null

func _ready():
	$Wardrobe.connect("color", self, "_on_Wardrobe_changed_color")
	
func _on_Wardrobe_changed_color():
	print('Signlar received')
