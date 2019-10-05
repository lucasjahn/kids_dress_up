extends Node


onready var mainRoot : MarginContainer = get_tree().get_root().get_node('Main')


# Scenes
onready var character : TextureRect = mainRoot.get_node("MainSceneContainer/CharacterContainer/Character")
onready var characterSelection : Control = mainRoot.get_node("CharacterSelection")
onready var colorPicker : MarginContainer = mainRoot.get_node("ColorPicker")
onready var lookbook : MarginContainer = mainRoot.get_node("Lookbook")
onready var dialogConfirmationDelete : MarginContainer = mainRoot.get_node("DialogConfirmationDelete")
onready var dialogSettings : MarginContainer = mainRoot.get_node("DialogSettings")
onready var timerSettings : MarginContainer = mainRoot.get_node("TimerSettings")
onready var store : MarginContainer = mainRoot.get_node("Store")


# Controls
onready var buttonBack : TextureButton = mainRoot.get_node("MainSceneContainer/ButtonLeftContainer/VBoxContainer/ButtonsTop/ButtonBack")
onready var buttonMute : TextureButton = mainRoot.get_node("MainSceneContainer/ButtonLeftContainer/VBoxContainer/ButtonsTop/ButtonMute")
onready var buttonLookbook : TextureButton = mainRoot.get_node("MainSceneContainer/ButtonLeftContainer/VBoxContainer/ButtonsBottom/ButtonOpenLookbook")
onready var buttonSaveToLookbook : TextureButton = mainRoot.get_node("MainSceneContainer/ButtonLeftContainer/VBoxContainer/ButtonsBottom/ButtonSaveToLookbook")
onready var buttonSettings : TextureButton = mainRoot.get_node("MainSceneContainer/ButtonRightContainer/VBoxContainer/ButtonsTop/ButtonSettings")
onready var buttonDelete : TextureButton = mainRoot.get_node("MainSceneContainer/ButtonRightContainer/VBoxContainer/ButtonsBotton/ButtonDelete")
onready var buttonPickColor : TextureButton = mainRoot.get_node("MainSceneContainer/Wardrobe/OpenWardrobeContainer/OpenWardrobeCols/SidebarContainer/Sidebar/ButtonColor")


# Misc Elements
onready var wardrobe : MarginContainer = mainRoot.get_node("MainSceneContainer/Wardrobe")
onready var wardrobeMenu : MarginContainer = mainRoot.get_node("MainSceneContainer/Wardrobe/WardrobeMenuContainer/WardrobeMenu")
onready var categories : CenterContainer = mainRoot.get_node("MainSceneContainer/Wardrobe/OpenWardrobeContainer/OpenWardrobeCols/OpenWardrobe/CenterContainer/ScrollContainer/MarginContainer/Categories")
onready var animatedPictureFrame : MarginContainer = mainRoot.get_node("PictureFrameWrapper")

# Sfx
onready var sfx : Dictionary = {
	"click": mainRoot.get_node("Sfx/Click")
}