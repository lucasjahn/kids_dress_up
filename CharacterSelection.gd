extends Node2D

signal character_selected

func _on_Characters_character_clicked(characterName):
	emit_signal("character_selected", characterName)
