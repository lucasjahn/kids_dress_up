extends Control

func _on_Characters_character_clicked(characterName):
	$AnimationPlayer.stop(true)
	Events.emit_signal("character_selected", characterName)