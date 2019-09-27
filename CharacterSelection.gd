extends Control

signal character_selected

func _on_Characters_character_clicked(characterName):
	$AnimationPlayer.stop(true)
	emit_signal("character_selected", characterName)
