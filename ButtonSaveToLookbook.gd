extends TextureButton


func _ready():
	if deleteConfirmationScene:
		deleteConfirmationScene.connect("dialog_confirmed", self, "_on_deleteConfirmation_confirmed")