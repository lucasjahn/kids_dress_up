extends VBoxContainer


onready var clickSfx = Elements.sfx.click
onready var deleteButton = Elements.buttonDelete
onready var addToLookbookButton = Elements.buttonSaveToLookbook


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
		Events.emit_signal("reset_character_selection")

		deleteButton.hide()
		addToLookbookButton.hide()
	elif selectedCategory == 'Lookbook':
		Events.emit_signal("open_lookbook_clicked")
	else:
		Events.emit_signal("category_selected", selectedCategory)
