extends Node2D

const assetRootPath = 'res://assets/'
var activeWardrobeCategory = null
var activeWardrobeColor = 'blue'
var selectedCharacter = null
var characterTextures = {}

onready var characterSelection = $CharacterSelection
onready var homeScreen = $Wardrobe/Home
onready var wardrobe = $Wardrobe
onready var character = $Figur

func _ready():
	characterTextures = {
		'CharacterFemale1': preload("res://assets/characterfemale1.png"),
		'CharacterFemale2': preload("res://assets/characterfemale2.png"),
		'CharacterMale1': preload("res://assets/charactermale1.png"),
	}
	
	wardrobe.connect("changed_color", self, "_on_Wardrobe_changed_color")
	characterSelection.connect("character_selected", self, "_on_CharacterSelection_character_selected")
	homeScreen.connect("resetCharacterSelection", self, "resetCharacter")
	
	characterSelection.show()
	
	
func _on_Wardrobe_changed_color(colorName):
	activeWardrobeColor = colorName


func _on_CharacterSelection_character_selected(characterName):
	selectedCharacter = characterName
	character.texture = characterTextures[selectedCharacter]
	characterSelection.hide()
	
	
func resetCharacter():
	characterSelection.show()
	selectedCharacter = null
	
