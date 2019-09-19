extends MarginContainer

const assetRootPath = 'res://assets/'
# warning-ignore:unused_class_variable
var activeWardrobeCategory = null
var activeWardrobeColor = 'blue'
var selectedCharacter = null
var characterTextures = {}

onready var mainSceneContainer = $MainSceneContainer
onready var characterSelection = $CharacterSelection
onready var wardrobe = mainSceneContainer.get_node('Wardrobe')
onready var character = mainSceneContainer.get_node('CharacterContainer/Character')
onready var clickSfx = $Sfx/Click
onready var buttonMute = mainSceneContainer.get_node('ButtonLeftContainer/VBoxContainer/ButtonsTop/ButtonMute')
onready var lookbook = $Lookbook

func _ready():
	characterTextures = {
		'CharacterFemale1': preload("res://assets/characterfemale1.png"),
		'CharacterFemale2': preload("res://assets/characterfemale2.png"),
		'CharacterMale1': preload("res://assets/charactermale1.png"),
	}
	
	wardrobe.connect("changed_color", self, "_on_Wardrobe_changed_color")
	
	lookbook.connect("backToHome", self, "_on_backToHome")
	
	characterSelection.connect("character_selected", self, "_on_CharacterSelection_character_selected")
	
	characterSelection.show()
	
	
func _on_Wardrobe_changed_color(colorName):
	activeWardrobeColor = colorName

func _on_CharacterSelection_character_selected(characterName):
	selectedCharacter = characterName
	character.texture = characterTextures[selectedCharacter]
	
	clickSfx.pitch_scale = 0.7
	clickSfx.play(0)
	
	characterSelection.hide()
	
	
func resetCharacter():
	characterSelection.show()
	characterSelection.get_node('AnimationPlayer').play()
	
	selectedCharacter = null
	
	
func toggleGameSounds():
	var masterBus = AudioServer.get_bus_index("Master")
	
	if not AudioServer.is_bus_mute(masterBus): 
		AudioServer.set_bus_mute(masterBus, true)
		return false
	else: 
		AudioServer.set_bus_mute(masterBus, false)
		return true


func _on_ButtonMute_pressed():
	var buttonTextures = {
		"mute": "res://assets/btn_mute.png",
		"unmute": "res://assets/btn_unmute.png"
	}
	
	if toggleGameSounds():
		buttonMute.texture_normal = load(buttonTextures.mute)
	else:
		buttonMute.texture_normal = load(buttonTextures.unmute)


func _on_ButtonLookbook_pressed():
	clickSfx.pitch_scale = 0.7
	clickSfx.play(0)
	
	lookbook._ready()
	lookbook.show()
	
func _on_backToHome(): 
	clickSfx.pitch_scale = 1
	clickSfx.play(0)
	
	lookbook.hide()
