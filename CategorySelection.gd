extends Node2D

signal categorySelected
signal resetCharacterSelection
signal showLookbook

func _ready():
	for child in get_children():
		child.connect("pressed", self, "_on_buttonPressed", [child.get_name()])
		
		
func _on_buttonPressed(nodeName):
	var selectedCategory = nodeName.replace('Button', '')
	
	if selectedCategory == 'CharacterSelection':
		emit_signal("resetCharacterSelection")
	elif selectedCategory == 'Lookbook':
		emit_signal("showLookbook")
	else:
		emit_signal("categorySelected", selectedCategory)
