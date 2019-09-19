extends VBoxContainer

signal categorySelected
signal resetCharacterSelection
signal showLookbook

onready var clickSfx = get_tree().get_root().get_node('Main/Sfx/Click')

func _ready():
	for child in get_children():
		var buttons = child.get_children()
		
		for button in buttons:
			button.connect("pressed", self, "_on_buttonPressed", [button.get_name()])
		
		
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
