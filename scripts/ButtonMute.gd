extends TextureButton

func _ready():
	connect("pressed", self, "_on_ButtonMute_pressed")
	
func _on_ButtonMute_pressed():
	Events.emit_signal("mute_clicked")