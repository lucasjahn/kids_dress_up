extends Node2D

var activeWardrobeCategory = null
var activeWardrobeColor = 'blue'

func _ready():
	$Wardrobe.connect("changed_color", self, "_on_Wardrobe_changed_color")
	
func _on_Wardrobe_changed_color(colorName):
	activeWardrobeColor = colorName