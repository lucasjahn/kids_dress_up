extends Node2D

signal categorySelected
signal resetCharacterSelection
signal showLookbook

onready var clickSfx = get_parent().get_node('Click')

func _ready():
	for child in get_children():
		child.connect("pressed", self, "_on_buttonPressed", [child.get_name()])
		
		
func _on_buttonPressed(nodeName):
	var selectedCategory = nodeName.replace('Button', '')
	
	clickSfx.pitch_scale = 0.7
	clickSfx.play(0)
	
	if selectedCategory == 'CharacterSelection':
		emit_signal("resetCharacterSelection")
	elif selectedCategory == 'Lookbook':
		emit_signal("showLookbook")
	else:
		emit_signal("categorySelected", selectedCategory)
