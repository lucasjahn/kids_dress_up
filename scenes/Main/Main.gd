extends MarginContainer

var activeWardrobeColor : String = 'blue'
var selectedCharacter : String = ''

onready var characterSelection = Elements.characterSelection
onready var wardrobe = Elements.wardrobe
onready var character = Elements.character
onready var clickSfx = Elements.sfx.click
onready var buttonMute = Elements.buttonMute
onready var buttonMuteCharacterSelection = Elements.characterSelection.get_node("MuteButtonWrapper/MuteButton")
onready var lookbook = Elements.lookbook

onready var characterTextures: Dictionary = {
	'CharacterFemale1': preload("res://assets/btn_characterfemale1.png"),
	'CharacterFemale2': preload("res://assets/btn_characterfemale2.png"),
	'CharacterMale1': preload("res://assets/btn_charactermale1.png"),
}

func _ready():
	Events.connect("color_picked", self, "_on_color_picked")
	Events.connect("home_clicked", self, "_on_home_clicked")
	Events.connect("mute_clicked", self, "_on_mute_clicked")
	Events.connect("character_selected", self, "_on_character_selected")
	Events.connect("open_lookbook_clicked", self, "_on_open_lookbook_clicked")
	Events.connect("reset_character_selection", self, "resetCharacter")

	characterSelection.show()


func _on_color_picked(colorName):
	activeWardrobeColor = colorName


func _on_character_selected(characterName):
	selectedCharacter = characterName
	character.texture = characterTextures[selectedCharacter]

	clickSfx.pitch_scale = 0.7
	clickSfx.play(0)

	characterSelection.hide()


func _on_mute_clicked():
	var buttonTextures = {
		"mute": "res://assets/btn_mute.png",
		"unmute": "res://assets/btn_unmute.png"
	}

	if toggleGameSounds():
		buttonMute.texture_normal = load(buttonTextures.mute)
		buttonMuteCharacterSelection.texture_normal = load(buttonTextures.mute)
	else:
		buttonMute.texture_normal = load(buttonTextures.unmute)
		buttonMuteCharacterSelection.texture_normal = load(buttonTextures.unmute)


func resetCharacter():
	characterSelection.show()
	characterSelection.get_node('AnimationPlayer').play()

	selectedCharacter = ''


func toggleGameSounds():
	var masterBus = AudioServer.get_bus_index("Master")

	if not AudioServer.is_bus_mute(masterBus):
		AudioServer.set_bus_mute(masterBus, true)
		return false
	else:
		AudioServer.set_bus_mute(masterBus, false)
		return true


func _on_open_lookbook_clicked():
	clickSfx.pitch_scale = 0.7
	clickSfx.play(0)

	lookbook._ready()
	lookbook.show()


func _on_home_clicked():
	clickSfx.pitch_scale = 1
	clickSfx.play(0)

	lookbook.hide()
