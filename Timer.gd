extends Timer





	
func _on_Timer_timeout():
	get_tree().change_scene("res://DialogSettings.gd")
	print("Yes")



func _on_Ten_pressed():
	set_wait_time(3)
	start()
	one_shot = true


func _on_Twenty_pressed():
	pass # Replace with function body.
